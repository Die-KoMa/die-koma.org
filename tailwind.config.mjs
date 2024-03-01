/** @type {import('tailwindcss').Config} */

import plugin from 'tailwindcss/plugin'

const tailwindPlugin = plugin(({ theme, matchUtilities, addComponents }) => {
  matchUtilities(
    {
      mask: (value) => ({
        maskImage: value,
      }),
    },
    {
      values: {
        ...theme('backgroundImage'),
        none: 'none',
      },
    },
  )
  addComponents({
    '.external-link': {
      '--size': '1em',
      mask: theme('backgroundImage.externalLink'),
      maskSize: 'contain',
      maskRepeat: 'no-repeat',
      maskPosition: 'center',
      backgroundColor: 'currentcolor',
      height: 'var(--size)',
      width: 'var(--size)',
      display: 'inline-block',
      verticalAlign: 'baseline',
      marginBottom: 'calc(-.15 * var(--size))',
    },
  })
})

export default {
  content: ['./astro.config.*', './src/**/*.{astro,html,js,jsx,md,mdx,svelte,ts,tsx,vue}'],
  theme: {
    extend: {
      backgroundImage: {
        externalLink:
          "url(\"data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' fill='none' viewBox='0 0 24 24' stroke-width='1.5' stroke='currentColor' class='w-6 h-6'%3E%3Cpath stroke-linecap='round' stroke-linejoin='round' d='M13.5 6H5.25A2.25 2.25 0 0 0 3 8.25v10.5A2.25 2.25 0 0 0 5.25 21h10.5A2.25 2.25 0 0 0 18 18.75V10.5m-10.5 6L21 3m0 0h-5.25M21 3v5.25' /%3E%3C/svg%3E\")",
      },
    },
  },
  darkMode: ['variant', ['@media(prefers-color-scheme: dark) {.no-theme &}', '.dark &']],
  plugins: [require('@tailwindcss/typography'), tailwindPlugin],
}
