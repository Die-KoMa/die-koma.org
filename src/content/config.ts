import { z, defineCollection } from 'astro:content'

const liederbuchCollection = defineCollection({
  type: 'content',
  schema: z.object({
    title: z.string(),
  }),
})

const resoCollection = defineCollection({
  type: 'content',
  schema: z.object({
    title: z.string(),
  }),
})

export const collections = {
  liederbuch: liederbuchCollection,
  resos: resoCollection,
}
