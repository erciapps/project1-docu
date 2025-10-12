import React, { useState } from "react";

export default function TerminalBox({ command = "apt-get hire me" }) {
  const [copied, setCopied] = useState(false);

  const handleCopy = () => {
    navigator.clipboard.writeText(command);
    setCopied(true);
    setTimeout(() => setCopied(false), 2000);
  };

  return (
    <div className="w-full max-w-4xl mx-auto my-8 px-4">
      <div className="relative px-6 pt-4 pb-6 shadow-lg text-gray-100 text-base font-mono 
                      bg-gray-800 rounded-xl leading-normal overflow-hidden border border-gray-700">

        {/* Botón copiar */}
        <button
          onClick={handleCopy}
          className="absolute top-3 right-4 text-gray-400 hover:text-white text-sm transition-colors"
          title="Copiar comando"
        >
          {copied ? "Copiado" : "Copiar"}
        </button>

        {/* Barra superior */}
        <div className="mb-4 flex space-x-2">
          <div className="h-3 w-3 bg-red-500 rounded-full"></div>
          <div className="h-3 w-3 bg-yellow-400 rounded-full"></div>
          <div className="h-3 w-3 bg-green-500 rounded-full"></div>
        </div>

        {/* Línea de comando */}
        <div className="mt-2 flex">
          <span className="text-green-400">ercipc:~$</span>
          <p className="flex-1 pl-3 typing text-white">{command}</p>
        </div>
      </div>
    </div>
  );
}
