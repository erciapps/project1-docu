import React, { useState } from "react";

export default function CodeWindow({ language = "html", code }) {
  const [copied, setCopied] = useState(false);

  const handleCopy = async () => {
    await navigator.clipboard.writeText(code);
    setCopied(true);
    setTimeout(() => setCopied(false), 1500);
  };

  return (
    <div className="rounded-2xl overflow-hidden shadow-2xl my-8 bg-[#1e1e1e] border border-[#333]">
      {/* Header tipo macOS */}
      <div className="flex items-center justify-between bg-[#2a2a2a] px-4 py-2 border-b border-[#444]">
        <div className="flex space-x-2">
          <span className="w-3 h-3 bg-[#ff5f56] rounded-full"></span>
          <span className="w-3 h-3 bg-[#ffbd2e] rounded-full"></span>
          <span className="w-3 h-3 bg-[#27c93f] rounded-full"></span>
        </div>
        <button
          onClick={handleCopy}
          className="text-xs text-gray-400 hover:text-white transition"
        >
          {copied ? "✅ Copiado" : "📋 Copiar"}
        </button>
      </div>

      {/* Contenedor de código */}
      <pre className={`language-${language} p-5 text-sm overflow-x-auto`}>
        <code className="text-gray-200 font-mono">{code}</code>
      </pre>
    </div>
  );
}
