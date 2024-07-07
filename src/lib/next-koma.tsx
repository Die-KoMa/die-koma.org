import json from 'next-koma.json'

export type KoMa = {
  name: string
  url: string
  title: string
  location: string
  start: Date
  end: Date
  info?: string
  signup?: string
}

export const komata: KoMa[] = Object.values(json).map((koma) => {
  return {
    name: koma.fulltext,
    url: koma.fullurl,
    title: koma.displaytitle,
    location: koma.printouts.Ort[0],
    start: new Date(Number(koma.printouts.Beginn[0].timestamp) * 1000),
    end: new Date(Number(koma.printouts.Ende[0].timestamp) * 1000),
    info: (koma.printouts.Anmeldung ?? [null])[0],
    signup: (koma.printouts.Infoseite ?? [null])[0],
  }
})

export function formatDateRange(start: Date, end: Date) {
  const start_day = Intl.DateTimeFormat('de', { day: 'numeric' }).format(start)
  const start_month = Intl.DateTimeFormat('de', { month: 'long' }).format(start)
  const start_year = Intl.DateTimeFormat('de', { year: 'numeric' }).format(start)
  const end_day = Intl.DateTimeFormat('de', { day: 'numeric' }).format(end)
  const end_month = Intl.DateTimeFormat('de', { month: 'long' }).format(end)
  const end_year = Intl.DateTimeFormat('de', { year: 'numeric' }).format(end)
  if (start_year !== end_year) {
    return `${start_day}. ${start_month} ${start_year} - ${end_day}. ${end_month} ${end_year}`
  }
  if (start_month !== end_month) {
    return `${start_day}. ${start_month} - ${end_day}. ${end_month} ${end_year}`
  }
  if (start_day !== end_day) {
    return `${start_day}.-${end_day}. ${end_month} ${end_year}`
  }
  return `${end_day}. ${end_month} ${end_year}`
}
