import { defineConfig } from 'astro/config'

import { favicons } from 'favicons'
import { twMerge } from 'tailwind-merge'
import compress from 'astro-compress'
import mdx from '@astrojs/mdx'
import rehypeExternalLinks from 'rehype-external-links'
import tailwind from '@astrojs/tailwind'

import type { FaviconOptions } from 'favicons'

function setDefaultLayout() {
  return function (_: any, file: any) {
    const { frontmatter } = file.data.astro
    if (!frontmatter.layout) frontmatter.layout = '@layouts/BaseLayout.astro'
  }
}

function rehypeExternalLinksPlugin() {
  return rehypeExternalLinks({
    target: '_blank',
    rel: ['noopener', 'noreferrer'],
    properties: (element) => ({
      className: twMerge(
        element.properties.className?.toString(),
        'after:external-link after:ml-1',
      ),
    }),
  })
}

async function faviconPlugin(options: FaviconOptions = {}) {
  const icons = await favicons('./src/favicon.svg', options)
  return {
    name: 'vite-plugin-favicons',
    order: 'pre',
    sequential: true,
    transform(src: string, id: string) {
      if (id.endsWith('src/layouts/BaseLayout.astro')) {
        src = src.replace('</head>', icons.html.join('') + '</head>')
      }
      return src
    },
    configureServer(server: any) {
      for (const icon of icons.images) {
        server.middlewares.use(`/${icon.name}`, (req: any, res: any) => {
          res.end(icon.contents)
        })
      }
    },
    generateBundle(options: any, bundle: any) {
      for (const icon of icons.images) {
        bundle[icon.name] = {
          type: 'asset',
          fileName: icon.name,
          source: icon.contents,
        }
      }
    },
  }
}

// https://astro.build/config
export default defineConfig({
  prefetch: {
    prefetchAll: true,
  },
  integrations: [mdx(), tailwind(), compress()],
  markdown: {
    remarkPlugins: [setDefaultLayout],
    rehypePlugins: [rehypeExternalLinksPlugin],
  },
  vite: {
    plugins: [
      faviconPlugin({
        background: '#134e4a',
        icons: {
          favicons: [
            'favicon.svg',
            'favicon.ico',
            'favicon-16x16.png',
            'favicon-32x32.png',
            'favicon-48x48.png',
          ],
          android: false,
          appleIcon: true,
          appleStartup: false,
          windows: false,
          yandex: false,
        },
      }),
    ],
  },
})
