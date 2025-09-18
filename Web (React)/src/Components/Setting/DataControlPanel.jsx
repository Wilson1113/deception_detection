import React, { useEffect, useState } from 'react';
import supabase from '../../helper/supabaseClient';

const DataControlPanel = () => {
  const [improveModel, setImproveModel] = useState(false);
  const [userId, setUserId] = useState(null);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    const fetchPreference = async () => {
      const { data: sessionData } = await supabase.auth.getSession();
      const uid = sessionData?.session?.user?.id;
      setUserId(uid);

      if (uid) {
        const { data, error } = await supabase
          .from('user')
          .select('improve_model')
          .eq('id', uid)
          .single();

        if (error) {
          console.error('Error fetching preference:', error);
        } else {
          setImproveModel(data?.improve_model ?? false);
        }
      }

      setLoading(false);
    };

    fetchPreference();
  }, []);

  const toggleImproveModel = async () => {
    const newValue = !improveModel;
    setImproveModel(newValue);
  
    if (userId) {
      const { error } = await supabase
        .from('user')
        .update({ improve_model: newValue })
        .eq('id', userId); 
  
      if (error) {
        console.error('Error updating preference:', error);
      }
    }
  };
  

  if (loading) return <div>Loading...</div>;

  return (
    <div className="bg-white rounded-xl shadow-md m-4 p-4 space-y-6">
      <div className="flex items-center justify-between">
        <h2 className="text-gray-900 font-medium text-base">Improve the model for everyone</h2>
        <button
          onClick={toggleImproveModel}
          className={`w-12 h-6 flex items-center rounded-full p-1 transition-colors duration-300 ${
            improveModel ? 'bg-blue-600' : 'bg-gray-300'
          }`}
        >
          <div
            className={`bg-white w-4 h-4 rounded-full shadow-md transform transition-transform duration-300 ${
              improveModel ? 'translate-x-6' : 'translate-x-0'
            }`}
          ></div>
        </button>
      </div>

      <p className="text-sm text-gray-500 leading-relaxed">
        Allow your content to be used to train our models, which makes DecepTrack better for you and everyone 
        who uses it. We take steps to protect your privacy.
      </p>
    </div>
  );
};

export default DataControlPanel;