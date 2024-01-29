import { useState, useEffect } from 'react'

const [isoDate] = new Date().toISOString().split('T')
const url = `https://de.komapedia.org/api.php?origin=*&action=ask&format=json&query=[[Category:KoMa]][[ende::%3E${isoDate}]]|sort=KoMaNr|order=asc|limit=2|?Ort|?Beginn|?Ende`

type KoMa = {
  name: string
  url: string
  title: string
  location: string
  start: Date
  end: Date
}

type Query = {
  query: {
    results: {
      [key: string]: {
        fulltext: string
        fullurl: string
        displaytitle: string
        printouts: {
          Ort: [string]
          Beginn: [{ timestamp: string }]
          Ende: [{ timestamp: string }]
        }
      }
    }
  }
}

async function fetchKoMata(url: string): Promise<Array<KoMa>> {
  const response = await fetch(url)
  const json: Query = await response.json()
  return Object.values(json.query.results).map((koma) => {
    return {
      name: koma.fulltext,
      url: koma.fullurl,
      title: koma.displaytitle,
      location: koma.printouts.Ort[0],
      start: new Date(Number(koma.printouts.Beginn[0].timestamp) * 1000),
      end: new Date(Number(koma.printouts.Ende[0].timestamp) * 1000),
    }
  })
}

export default function NextKoMa() {
  const [komata, setKomata] = useState<Array<KoMa>>([])
  useEffect(() => {
    let ignore = false

    fetchKoMata(url).then((result) => {
      if (!ignore) {
        setKomata(result)
      }
    })

    return () => {
      ignore = true
    }
  }, [])

  function formatDateRange(start: Date, end: Date) {
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

  return (
    <div className="not-prose float-right size-fit p-2 pr-0">
      <div className="h-44 w-60 rounded-md bg-orange-50 p-3 pb-6 pt-5 leading-5 text-zinc-600 shadow-md md:w-64 md:px-4 md:pb-6">
        <h1 className="px-2 pb-1 text-sm font-bold uppercase tracking-wide text-zinc-500">
          Termine
        </h1>
        <div className="relative z-10 h-4 w-full bg-gradient-to-b from-orange-50 print:invisible"></div>
        <ul className="relative -top-4 h-full overflow-y-auto px-2 pb-2">
          <noscript>
            <div className="pt-4">
              <span>Ohne Javascript gibt es Termine im </span>
              <a className="underline" href="https://de.komapedia.org/">
                Wiki
              </a>
            </div>
          </noscript>
          {komata.map((koma) => {
            const { name, url, location, start, end } = koma
            return (
              <li key={name} className="pb-2">
                <a href={url}>
                  <span className="block pb-1 pt-3 text-xs font-bold tracking-wider text-zinc-500">
                    {formatDateRange(start, end)}
                  </span>
                  <span> {name} in </span>
                  <span className="font-semibold text-zinc-500">{location}</span>
                </a>
              </li>
            )
          })}
        </ul>
        <div className="relative -top-10 z-10 h-6 w-full bg-gradient-to-t from-orange-50 print:invisible"></div>
      </div>
    </div>
  )
}
