import React, { useState, useEffect } from "react";

export default function CookiePopup() {
  const [open, setOpen] = useState(false);

  useEffect(() => {
    const timer = setTimeout(() => setOpen(true), 500);
    return () => clearTimeout(timer);
  }, []);

  if (!open) return null;

  return (
    <div className="fixed bottom-16 inset-x-6 md:inset-x-10 z-50">
      <div
        className="max-w-screen-lg mx-auto bg-white text-gray-900 p-5 rounded-lg shadow-2xl
                   flex flex-col md:flex-row items-center justify-between gap-4
                   transition-all duration-300 ease-in-out border border-gray-200"
      >
        <p className="flex-1 text-center md:text-left text-sm md:text-base">
          Este sitio web utiliza cookies para mejorar tu experiencia.{" "}
          <a
            href="#"
            className="text-indigo-600 font-medium hover:underline ml-1"
          >
            Saber más
          </a>
        </p>

        <div className="flex gap-3">
          <button
            onClick={() => setOpen(false)}
            className="text-indigo-600 text-sm font-medium hover:underline focus:outline-none"
          >
            Rechazar
          </button>
          <button
            onClick={() => setOpen(false)}
            className="bg-indigo-500 hover:bg-indigo-600 text-white text-sm font-medium
                       px-5 py-2 rounded-md focus:outline-none transition"
          >
            Aceptar cookies
          </button>
        </div>
      </div>
    </div>
  );
}
