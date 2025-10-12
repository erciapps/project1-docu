import React from "react";
import { Copy } from "lucide-react";

export default function Terminal({ commands = [] }) {
  const allCommands = Array.isArray(commands) ? commands : [commands];

  const copyAll = () => {
    navigator.clipboard.writeText(allCommands.join("\n"));
  };

  return (
    <div className="w-full max-w-3xl mx-auto my-8">
      <div className="relative shadow-lg text-gray-100 font-mono bg-gray-800 rounded-lg overflow-hidden border border-gray-700">
        {/* Barra superior estilo macOS */}
        <div className="flex items-center px-4 py-2 bg-gray-900 border-b border-gray-700">
          <div className="h-3 w-3 bg-red-500 rounded-full"></div>
          <div className="ml-2 h-3 w-3 bg-orange-300 rounded-full"></div>
          <div className="ml-2 h-3 w-3 bg-green-500 rounded-full"></div>
          <button
            className="absolute right-4 text-gray-400 hover:text-white transition"
            onClick={copyAll}
            title="Copiar comandos"
          >
            <Copy size={18} />
          </button>
        </div>

        {/* Área de comandos */}
        <div className="p-5 text-sm leading-relaxed">
          {allCommands.map((cmd, i) => (
            <div key={i} className="flex">
              <span className="text-green-400 mr-2">computer:~$</span>
              <p className="text-gray-100">{cmd}</p>
            </div>
          ))}
        </div>
      </div>
    </div>
  );
}
