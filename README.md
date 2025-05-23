# die-koma.org
Astro Code of the KoMa website.

[Astro](https://astro.build/) is a static site generator that takes
these [Markdown](https://commonmark.org/help/) templates and produces static HTML files.

# How to contribute

Fork this repository, make your changes, and open a pull request. Once
the pull request is merged, the changes will be deployed
automatically.

# Installation
Short: Use [Astro](https://astro.build/).

Long: You will need a working Javascript runtime (e.g., `nodejs`) and
a package manager such as `npm`. Then install the dependencies and run
`npm run dev`.

## Nix (best support)
```sh
# nix packet manager works in almost any linux distribution, mac and wsl1/2
# https://nixos.org/download.html

# with flake-support enabled (https://nixos.wiki/wiki/Flakes)

# building:
nix build -L .

# install dependencies:
nix run .#install

# development server:
nix run
```

## Debian/Ubuntu, MacOS, Windows

First install `npm`:

- Debian/Ubuntu or WSL: `sudo apt install nodejs npm`
- MacOS: `brew install npm`
- Windows: `winget install -e --id OpenJS.NodeJS && echo you lost the game`

And then:

```sh
cd "die-koma.org"
git pull     # make sure to be on main, pull latest version :)
npm install  # install dependencies
npm run dev  # start development server
```