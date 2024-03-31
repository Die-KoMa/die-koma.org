#!/usr/bin/env nix-shell
#! nix-shell -i python -p python3

import json

from datetime import date
from urllib.request import urlopen, Request


QUERY = f"""
https://de.komapedia.org/api.php?origin=*&action=ask&format=json&query=[[Category:KoMa]][[ende::%3E{date.today().isoformat()}]]|sort=KoMaNr|order=asc|limit=5|?Ort|?Beginn|?Ende|?Anmeldung|?Infoseite
"""
LINKS = ["Anmeldung", "Infoseite"]
IGNORED_STATUS_CODES = [401]


def get_next_komata():
    results = json.loads(urlopen(QUERY).read().decode())
    return results["query"]["results"]


def verify_url(url):
    try:
        response = urlopen(Request(url, method="HEAD"))
    except:
        return False
    else:
        return response.status in [200] + IGNORED_STATUS_CODES


def clean_and_verify_printounts(printouts):
    result = printouts

    for key, value in printouts.items():
        if key in LINKS:
            result[key] = []

            for url in value:
                if verify_url(url):
                    result[key].append(url)

    return result


def clean_and_verify_koma(koma):
    result = koma

    for key, value in koma.items():
        if key == "printouts":
            result[key] = clean_and_verify_printounts(value)

    return result


def clean_and_verify(komata):
    verified = {}

    for koma in komata:
        verified[koma] = clean_and_verify_koma(komata[koma])

    return json.dumps(verified, indent=2, sort_keys=True)


def main():
    next_komata = get_next_komata()
    cleaned_and_verified = clean_and_verify(next_komata)

    with open("next-koma.json", mode="w") as file:
        file.write(cleaned_and_verified)


if __name__ == "__main__":
    main()
