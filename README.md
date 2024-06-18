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


## Debian/Ubuntu
```sh
# ruby installation stuff:
sudo apt install nodejs npm
cd "die-koma.org"
git pull  # make sure to be on main, pull latest version :)
npm install  # install dependencies
npm run dev  # start development server
```

## MacOS
Likely the same as above, but use `homebrew` instead of `apt`?


## Windows
You've lost the game anyways, perhaps try WSL2 with nix?

## Windows with WSL Ubuntu
### Cloning and Installation (run once)
```sh
# clone "die-koma.org" to a directory without any spaces!
cd die-koma.org

# start wsl in the directory
# install nodejs
sudo apt install nodejs

# depending on your distribution add npm (not necessary on noble)
# sudo apt install npm
```

### Running the Website
```sh
cd "die-koma.org"
# start wsl in the directory

git pull  # make sure to be on main, pull latest version :)
npm install  # install dependencies
npm run dev  # start development server
# open http://localhost:4321/ in a browser (either host or within wsl)
```
