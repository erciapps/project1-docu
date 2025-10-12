import { useState } from "react";
import { motion, AnimatePresence } from "framer-motion";

export default function Accordion() {
  const [isOpen, setIsOpen] = useState(false);

  return (
    <div className="flex items-center justify-center min-h-screen from-teal-100 via-teal-300 to-teal-500 bg-gradient-to-br p-4">
      <div className="w-full max-w-lg px-10 py-8 mx-auto bg-white rounded-lg shadow-xl">
        <div className="max-w-md mx-auto space-y-6">
          <img
            src="https://tailwindcomponents.com/svg/logo-color.svg"
            alt="Logo"
            className="h-8"
          />

          <div
            onClick={() => setIsOpen(!isOpen)}
            className="flex items-center text-gray-600 w-full border-b cursor-pointer mb-5 transition-all"
          >
            <div
              className={`w-10 border-r px-2 transform transition duration-300 ease-in-out ${
                isOpen ? "rotate-90" : ""
              }`}
            >
              <svg
                xmlns="http://www.w3.org/2000/svg"
                fill="none"
                viewBox="0 0 24 24"
                strokeWidth="1.5"
                stroke="currentColor"
                className="w-6 h-6"
              >
                <path
                  strokeLinecap="round"
                  strokeLinejoin="round"
                  d="M19.5 8.25l-7.5 7.5-7.5-7.5"
                />
              </svg>
            </div>
            <div className="flex items-center px-2 py-3">
              <button className="hover:underline text-gray-700">
                This is where you click to open
              </button>
            </div>
          </div>

          <AnimatePresence initial={false}>
            {isOpen && (
              <motion.div
                key="content"
                initial={{ opacity: 0, height: 0 }}
                animate={{ opacity: 1, height: "auto" }}
                exit={{ opacity: 0, height: 0 }}
                transition={{ duration: 0.5, ease: "easeInOut" }}
                className="flex p-5 w-full border-b pb-6 text-gray-700 bg-gray-50 rounded-lg shadow-inner"
              >
                This is a very simple dropdown/accordion/collapse (whatever you
                call it) using <strong>React</strong> and{" "}
                <strong>TailwindCSS</strong>, with smooth transitions powered by{" "}
                <strong>framer-motion</strong>.
              </motion.div>
            )}
          </AnimatePresence>
        </div>
      </div>
    </div>
  );
}
