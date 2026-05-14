// @ts-check
import { themes as prismThemes } from 'prism-react-renderer';
import autoprefixer from 'autoprefixer';
import tailwindcss from '@tailwindcss/postcss';

/** @type {import('@docusaurus/types').Config} */
const config = {
  title: 'ErciApps',
  tagline: 'Ercilla are cool',
  favicon: 'img/favicon.ico',

  //future: { v4: true },

  url: 'https://project1-erciapps.sytes.net',
  baseUrl: '/',

  organizationName: 'erciapps',
  projectName: 'project1-docu',
  trailingSlash: false,
  onBrokenLinks: 'throw',

  markdown: {
    hooks: {
      onBrokenMarkdownLinks: 'warn',
      onBrokenMarkdownImages: 'warn',
    },
  },

  i18n: {
    defaultLocale: 'en',
    locales: ['en'],
  },

  // 🔌 Plugins
  plugins: [
    '@docusaurus/plugin-ideal-image',
    'docusaurus-plugin-image-zoom',

    // ⚙️ React Player en modo lazy
    function aliasReactPlayer() {
      return {
        name: 'alias-react-player-lazy',
        configureWebpack() {
          return {
            resolve: {
              alias: {
                'react-player': require.resolve('react-player/lazy'),
              },
            },
          };
        },
      };
    },

    // ⚙️ Integración de Tailwind + Autoprefixer
    function tailwindPlugin() {
      return {
        name: 'docusaurus-tailwindcss',
        configurePostCss(postcssOptions) {
          postcssOptions.plugins.push(tailwindcss);
          postcssOptions.plugins.push(autoprefixer);
          return postcssOptions;
        },
      };
    },
  ],

  // ⚙️ Preset clásico + integración CSS personalizada
  presets: [
    [
      'classic',
      /** @type {import('@docusaurus/preset-classic').Options} */
      ({
        docs: {
          sidebarPath: './sidebars.js',
        },
        blog: {
          showReadingTime: true,
          feedOptions: { type: ['rss', 'atom'], xslt: true },
          onInlineTags: 'warn',
          onInlineAuthors: 'warn',
          onUntruncatedBlogPosts: 'warn',
        },
        theme: {
          customCss: require.resolve('./src/css/custom.css'),
        },
      }),
    ],
  ],

  // 🎨 Configuración del tema
  themeConfig:
    /** @type {import('@docusaurus/preset-classic').ThemeConfig} */
    ({
      image: 'img/docusaurus-social-card.jpg',

      // 📚 Sidebar
      docs: {
        sidebar: {
          hideable: false,
          autoCollapseCategories: false,
        },
      },

      // 🧭 Tabla de contenidos
      tableOfContents: {
        minHeadingLevel: 2,
        maxHeadingLevel: 4,
      },

      navbar: {
        title: '',
        logo: {
          alt: 'ErciApps',
          src: 'img/ercilogo.png',
          href: 'https://erciapps.sytes.net',
          target: '_self',
          height: 40,
          width: 40,
        },
        items: [
          { to: '/', label: 'Inicio', position: 'left' },
          { to: '/docs/category/gitgithub', label: 'Git&GitHub', position: 'left' },
          { to: '/docs/category/markdown', label: 'Markdown', position: 'left' },
        ],
      },

      footer: {
        style: 'dark',
        copyright: `Copyright © ${new Date().getFullYear()} ErciApps`,
      },

      prism: {
        theme: prismThemes.github,
        darkTheme: prismThemes.dracula,
        additionalLanguages: ['java', 'csharp', 'bash', 'json', 'python'],
      },

      zoom: {
        selector: '.markdown img, .markdown picture img',
        background: {
          light: 'rgb(255, 255, 255)',
          dark: 'rgb(50, 50, 50)',
        },
      },
    }),

  // 🖋️ Fuente moderna
  stylesheets: [
    'https://fonts.googleapis.com/css2?family=Inter:wght@400;600;700&display=swap',
  ],
};

export default config;
