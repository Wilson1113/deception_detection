import React, { useEffect, useState } from 'react';
import Layout from './Layout';
import supabase from '../helper/supabaseClient';

function Dashboard() {
  const [userId, setUserId] = useState(null);
  const [records, setRecords] = useState([]);

  useEffect(() => {
    const fetchUserAndData = async () => {
      const session = await supabase.auth.getSession();
      const uid = session.data?.session?.user?.id;
      setUserId(uid);
    
      const { data, error: subjectError } = await supabase
        .from('analyzed_subject')
        .select('*')
        .eq('user_id', uid);
        
      if (subjectError) {
        console.error(subjectError);
      } else {
        setRecords(data);
      }
    };    

    fetchUserAndData();
  }, []);

  return (
    <Layout>
      <div className="flex-1 overflow-y-auto space-y-6">
        {/* Summary Section */}
        <section className="grid grid-cols-1 md:grid-cols-3 gap-4">
          <div className="bg-white p-4 rounded-xl shadow">
            <h3 className="text-sm text-gray-500">Total Analyses</h3>
            <p className="text-2xl font-bold text-blue-700">{records.length}</p>
          </div>
          <div className="bg-white p-4 rounded-xl shadow">
            <h3 className="text-sm text-gray-500">Detected Deceptions</h3>
            <p className="text-2xl font-bold text-red-500">
              {records.filter((r) => r.final_label === false).length}
            </p>
          </div>
          <div className="bg-white p-4 rounded-xl shadow">
            <h3 className="text-sm text-gray-500">Truth Detected</h3>
            <p className="text-2xl font-bold text-green-600">
              {records.filter((r) => r.final_label === true).length}
            </p>
          </div>
        </section>

        {/* Analysis Results */}
        <section className="bg-white p-6 rounded-xl shadow">
          <h2 className="text-xl font-semibold text-gray-800 mb-4">Past Analyses</h2>
          <div className="overflow-x-auto">
            <table className="min-w-full text-sm">
              <thead className="text-left bg-gray-200">
                <tr>
                  <th className="p-2">Date</th>
                  <th className="p-2">Name</th>
                  <th className="p-2">Identification No.</th>
                  <th className="p-2">Result</th>
                </tr>
              </thead>
              <tbody>
                {records.map((rec) => (
                  <tr key={rec.id} className="border-b">
                    <td className="p-2">{new Date(rec.created_at).toLocaleDateString()}</td>
                    <td className="p-2">{rec.name}</td>
                    <td className="p-2">{rec.identification_no}</td>
                    <td className={`p-2 font-bold ${rec.final_label === false ? 'text-red-500' : 'text-green-600'}`}>
                      {rec.final_label === false ? 'Deceptive' : 'Truthful'}
                    </td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
        </section>
      </div>
    </Layout>
  );
}

export default Dashboard;
