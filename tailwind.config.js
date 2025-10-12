/** @type {import('tailwindcss').Config} */
module.exports = {
  content: [
    "./src/**/*.{js,jsx,ts,tsx,md,mdx}",
    "./docs/**/*.{md,mdx}"
  ],
  theme: { extend: {} },
  plugins: [],
  darkMode: ["class", '[data-theme="dark"]'], // Soporta el atributo data-theme="dark"
  corePlugins: { preflight: false },         // Desactiva resets globales de Tailwind (no rompe estilos de Docusaurus):contentReference[oaicite:6]{index=6}:contentReference[oaicite:7]{index=7}
  blocklist: ["container"],                 // Evita la clase Tailwind "container" para no interferir:contentReference[oaicite:8]{index=8}
};
