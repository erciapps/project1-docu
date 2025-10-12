import React, { useState } from "react";

export default function RetroTerminal({ title = "ERCI-CODE", content = [] }) {
  const [copied, setCopied] = useState(false);

  const handleCopy = () => {
    navigator.clipboard.writeText(
      content.map(line => line.text).join("\n")
    );
    setCopied(true);
    setTimeout(() => setCopied(false), 1500);
  };

  return (
    <div className="bg-[#2b2b2b] text-[#e0e0e0] rounded-2xl shadow-2xl p-6 font-mono text-base relative max-w-2xl mx-auto border-4 border-[#ff6600]">
      {/* Header */}
      <div className="flex justify-between items-center mb-4">
        <h2 className="text-[#ff6600] tracking-widest font-extrabold text-lg">
          {title}
        </h2>
        <button
          onClick={handleCopy}
          className="text-xs text-yellow-400 border border-yellow-400 px-2 py-1 rounded hover:bg-yellow-400 hover:text-black transition"
        >
          {copied ? "COPIADO ✔" : "COPIAR"}
        </button>
      </div>

      {/* Body */}
      <div className="bg-[#1c1c1c] rounded-xl p-4 space-y-2 border-2 border-[#444]">
        {content.map((line, i) => (
          <div key={i}>
            {line.type === "command" && (
              <span className="text-[#00ff99]">$ </span>
            )}
            <span
              className={`${
                line.type === "highlight"
                  ? "text-[#ff6600] font-bold"
                  : line.type === "system"
                  ? "text-[#ffd700]"
                  : "text-[#d4d4d4]"
              }`}
            >
              {line.text}
            </span>
          </div>
        ))}
      </div>

      {/* Footer estilo retro */}
      <div className="mt-4 text-center text-[#888] text-sm tracking-wider">
        ▓▓▓ <span className="text-[#ff6600]">ERCI-LAB</span> ▓▓▓
      </div>
    </div>
  );
}
