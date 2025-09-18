import React, { useState } from 'react';
import Layout from '../Layout';
import ProfilePanel from './ProfilePanel';
import DataControlPanel from './DataControlPanel';

const Settings = ({ session }) => {
  const [selectedTab, setSelectedTab] = useState('profile');

  return (
    <Layout>
      {/* Settings box (with spacing already handled by Layout) */}
      <div className="bg-white shadow-xl rounded-2xl overflow-hidden flex flex-col md:flex-row min-h-[500px]">
        {/* Sidebar */}
        <aside className="w-full md:w-60 bg-white border-r border-gray-200">
          <nav className="flex flex-col py-6 px-4 space-y-4">
            <button
              className={`text-left px-4 py-2 rounded-md text-sm font-medium ${
                selectedTab === 'profile' ? 'bg-blue-100 text-blue-800' : 'hover:bg-gray-100'
              }`}
              onClick={() => setSelectedTab('profile')}
            >
              Profile
            </button>
            <button
              className={`text-left px-4 py-2 rounded-md text-sm font-medium ${
                selectedTab === 'data' ? 'bg-blue-100 text-blue-800' : 'hover:bg-gray-100'
              }`}
              onClick={() => setSelectedTab('data')}
            >
              Data Control
            </button>
          </nav>
        </aside>

        {/* Content */}
        <main className="flex-1 bg-gray-50">
          {selectedTab === 'profile' ? (
            <ProfilePanel session={session} />
          ) : (
            <DataControlPanel />
          )}
        </main>
      </div>
    </Layout>
  );
};

export default Settings;
