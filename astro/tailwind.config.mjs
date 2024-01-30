/** @type {import('tailwindcss').Config} */
export default {
  content: ['./src/**/*.{astro,html,js,jsx,md,mdx,svelte,ts,tsx,vue}'],
  theme: {
    extend: {},
  },
  darkMode: ['variant', ['@media(prefers-color-scheme: dark) {.no-theme &}', '.dark &']],
  plugins: [require('@tailwindcss/typography')],
}
