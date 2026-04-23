import { defineCollection } from 'astro:content';
import { z } from 'astro/zod';
import { glob } from "astro/loaders";


const liederbuchCollection = defineCollection({
  loader: glob({ pattern: '**/[^_]*.md', base: "./src/content/liederbuch" }),
  schema: z.object({
    title: z.string(),
    category: z.string(),
  }),
})

const resoCollection = defineCollection({
  loader: glob({ pattern: '**/[^_]*.md', base: "./src/content/resos" }),
  schema: z.object({
    title: z.string(),
  }),
})

export const collections = {
  liederbuch: liederbuchCollection,
  resos: resoCollection,
}
