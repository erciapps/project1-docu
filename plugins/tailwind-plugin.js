module.exports = function tailwindPlugin(context, options) {
  return {
    name: "tailwind-plugin",
    configurePostCss(postcssOptions) {
      // Agrega Tailwind CSS como plugin de PostCSS
      postcssOptions.plugins.push(
        require("@tailwindcss/postcss") // Plugin oficial Tailwind para PostCSS (Tailwind v4):contentReference[oaicite:10]{index=10}
      );
      return postcssOptions;
    },
  };
};
