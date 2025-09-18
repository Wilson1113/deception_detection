# === Imports ===
import os
import torch
import torch.nn as nn
from sklearn.model_selection import train_test_split
from torch.utils.data import Dataset, DataLoader
import numpy as np

# === Multimodal Attention LSTM Model ===
class MultimodalAttentionLSTMClassifier(nn.Module):
    def __init__(self, video_dim, audio_dim, text_dim, hidden_dim=64, num_layers=1, num_heads=4):
        super().__init__()
        self.video_lstm = nn.LSTM(video_dim, hidden_dim, num_layers=num_layers, batch_first=True, bidirectional=True)
        self.audio_lstm = nn.LSTM(audio_dim, hidden_dim, num_layers=num_layers, batch_first=True, bidirectional=True)
        self.text_lstm  = nn.LSTM(text_dim,  hidden_dim, num_layers=num_layers, batch_first=True, bidirectional=True)
        self.video_attn = nn.MultiheadAttention(embed_dim=hidden_dim*2, num_heads=num_heads, batch_first=True)
        self.audio_attn = nn.MultiheadAttention(embed_dim=hidden_dim*2, num_heads=num_heads, batch_first=True)
        self.text_attn  = nn.MultiheadAttention(embed_dim=hidden_dim*2, num_heads=num_heads, batch_first=True)
        self.cross_attn = nn.MultiheadAttention(embed_dim=hidden_dim*6, num_heads=num_heads, batch_first=True)
        self.fc = nn.Sequential(
            nn.Linear(hidden_dim*6, 128),
            nn.BatchNorm1d(128),
            nn.ReLU(),
            nn.Dropout(0.3),
            nn.Linear(128,1)
        )
    def forward(self, v, a, t):
        v_out,_ = self.video_lstm(v)
        a_out,_ = self.audio_lstm(a)
        t_out,_ = self.text_lstm(t)
        v_att,_ = self.video_attn(v_out, v_out, v_out)
        a_att,_ = self.audio_attn(a_out, a_out, a_out)
        t_att,_ = self.text_attn(t_out, t_out, t_out)
        combined = torch.cat([v_att, a_att, t_att], dim=2)
        cross_out,_ = self.cross_attn(combined, combined, combined)
        context = cross_out.mean(dim=1)
        return self.fc(context)


# === Custom Dataset ===
class DeceptionDataset(Dataset):
    def __init__(self, seqs, labels):
        self.seqs = seqs
        self.labels = labels
    def __len__(self):
        return len(self.seqs)
    def __getitem__(self, idx):
        seq = self.seqs[idx]
        v_dim, a_dim, t_dim = self.video_dim, self.audio_dim, self.text_dim
        v = seq[:,:v_dim]
        a = seq[:,v_dim:v_dim+a_dim]
        t = seq[:,v_dim+a_dim:]
        y = self.labels[idx]
        return torch.tensor(v, dtype=torch.float32), \
               torch.tensor(a, dtype=torch.float32), \
               torch.tensor(t, dtype=torch.float32), \
               torch.tensor(y, dtype=torch.float32)


# === Training Function ===
def start_train():
    VIDEO_DIR = "../../../Videos/Videos/"
    MODEL_PATH = "../../../face_landmarker.task"
    BATCH_SIZE = 4
    EPOCHS = 50
    TEST_SPLIT = 0.2
    CODE2LABEL = {"PT":0, "NL":0, "PL":1, "NT":1}

    fusion = FusionExtractor(model_path=MODEL_PATH)
    all_seqs, all_labels = [], []
    for fn in sorted(os.listdir(VIDEO_DIR)):
        if not fn.lower().endswith(".wmv"): continue
        base = os.path.splitext(fn)[0]
        fusion.extract(video_path=os.path.join(VIDEO_DIR, fn), save_path=base)
        fused = fusion.get_results()
        v = np.array([item['video'] for item in fused])
        a = np.array([item['audio'] for item in fused])
        t = np.array([item['text']  for item in fused])
        seq = np.concatenate([v, a, t], axis=1)
        all_seqs.append(seq)
        all_labels.append(CODE2LABEL.get(base[-2:].upper(), -1))

    max_t = max(s.shape[0] for s in all_seqs)
    def pad(s): return np.vstack([s, np.zeros((max_t-s.shape[0], s.shape[1]))]) if s.shape[0]<max_t else s
    all_seqs = np.array([pad(s) for s in all_seqs])
    all_labels = np.array(all_labels)

    v_dim = fused[0]['video'].__len__(); a_dim = fused[0]['audio'].__len__(); t_dim = fused[0]['text'].__len__()
    X_train, X_test, y_train, y_test = train_test_split(all_seqs, all_labels, test_size=TEST_SPLIT, random_state=42)

    train_set = DeceptionDataset(X_train, y_train)
    test_set  = DeceptionDataset(X_test, y_test)
    for ds in (train_set, test_set): ds.video_dim, ds.audio_dim, ds.text_dim = v_dim, a_dim, t_dim

    train_loader = DataLoader(train_set, batch_size=BATCH_SIZE, shuffle=True)
    test_loader  = DataLoader(test_set, batch_size=BATCH_SIZE)

    model = MultimodalAttentionLSTMClassifier(v_dim, a_dim, t_dim)
    criterion = nn.BCEWithLogitsLoss()
    optimizer = torch.optim.Adam(model.parameters(), lr=1e-4)
    scheduler = torch.optim.lr_scheduler.StepLR(optimizer, step_size=5, gamma=0.5)

    for epoch in range(EPOCHS):
        model.train()
        train_loss, correct, total = 0, 0, 0
        for v,a,t,y in train_loader:
            optimizer.zero_grad()
            preds = model(v,a,t)
            loss = criterion(preds, y.unsqueeze(1))
            loss.backward(); optimizer.step()
            train_loss += loss.item()
            pred = (torch.sigmoid(preds)>0.5).float()
            correct += (pred.squeeze()==y).sum().item(); total += y.size(0)
        avg_train_loss = train_loss/len(train_loader)
        train_acc = correct/total

        model.eval(); val_loss, correct, total = 0, 0, 0
        with torch.no_grad():
            for v,a,t,y in test_loader:
                preds = model(v,a,t)
                loss = criterion(preds, y.unsqueeze(1))
                val_loss += loss.item()
                pred = (torch.sigmoid(preds)>0.5).float()
                correct += (pred.squeeze()==y).sum().item(); total += y.size(0)
        avg_val_loss = val_loss/len(test_loader)
        val_acc = correct/total

        scheduler.step()
        print(f"Epoch {epoch+1}: Train Loss={avg_train_loss:.4f}, Train Acc={train_acc:.4f}, Val Loss={avg_val_loss:.4f}, Val Acc={val_acc:.4f}")

    torch.save(model.state_dict(), "deception_model.pth")

if __name__=='__main__':
    start_train()
