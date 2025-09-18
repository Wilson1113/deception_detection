import React from 'react';

const TestComponent = () => {
  return (
    <div className="flex flex-col items-center justify-center min-h-screen bg-gradient-to-br from-blue-100 to-blue-300">
      <h1 className="text-4xl font-bold text-blue-800 mb-4">🚀 Tailwind is Working!</h1>
      <button className="px-6 py-3 bg-blue-600 text-white rounded-lg shadow hover:bg-blue-700 transition">
        Click Me
      </button>
    </div>
  );
};

export default TestComponent;
