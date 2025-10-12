module.exports = function tailwindLoader() {
  return {
    name: 'docusaurus-tailwind-loader',
    configurePostCss(postcssOptions) {
      // Añade Tailwind y Autoprefixer manualmente al pipeline de Docusaurus
      postcssOptions.plugins.push(require('@tailwindcss/postcss'));
      postcssOptions.plugins.push(require('autoprefixer'));
      return postcssOptions;
    },
  };
};
