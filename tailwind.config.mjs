/** @type {import('tailwindcss').Config} */

export default {
  darkMode: ['variant', ['@media(prefers-color-scheme: dark) {.no-theme &}', '.dark &']],
}
