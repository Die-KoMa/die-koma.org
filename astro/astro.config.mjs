import { defineConfig } from 'astro/config'

import compress from 'astro-compress'
import mdx from '@astrojs/mdx'
import tailwind from '@astrojs/tailwind'

function setDefaultLayout() {
  return function (_, file) {
    const { frontmatter } = file.data.astro
    if (!frontmatter.layout) frontmatter.layout = '@layouts/BaseLayout.astro'
  }
}

// https://astro.build/config
export default defineConfig({
  integrations: [mdx(), tailwind(), compress()],
  markdown: {
    remarkPlugins: [setDefaultLayout],
  },
})
