import { defineConfig } from 'astro/config'

import compress from 'astro-compress'
import mdx from '@astrojs/mdx'
import tailwind from '@astrojs/tailwind'
import { twMerge } from 'tailwind-merge'
import rehypeExternalLinks from 'rehype-external-links'

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
        'after:ml-1 after:mask-externalLink after:[mask-position:center] after:[mask-repeat:no-repeat] after:size-[1em] after:align-text-top after:inline-block after:bg-current',
      ),
    }),
  })
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
})
