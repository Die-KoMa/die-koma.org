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

## Nix (with flakes) + direnv (best support)
```sh
# If you already know nix and direnv, this is quite easy:
# allow this directory's .envrc once:
direnv allow

# building:
nix -L build .

# install dependencies:
npm install

# development server:
nix run
```

## Nix (without direnv)
```sh
# nix package manager works in almost any linux distribution, mac and wsl1/2
# https://nixos.org/download.html

# with flake-support enabled (https://nixos.wiki/wiki/Flakes)

# building:
nix build -L .

# npm must be called in nix shell, e.g. install dependencies like this:
nix develop -c npm install

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

# Deployment

Deployments are automated via a GitHub workflow:

- Every change merged into the `main` branch is built automatically.
- The build output is then written to the `release` branch of this wiki/repository.
- The `release` branch also contains a Nix flake so the content can be consumed through a Nix interface.
- The website host fetches updates from that branch every couple of minutes and refreshes what is served.

The host configuration is defined in the [`die-KoMa/nix` repository](https://github.com/die-KoMa/nix).
