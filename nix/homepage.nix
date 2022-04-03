{ runCommandNoCC
, jekyll
}:

runCommandNoCC "die-koma.org" {} ''
  cp -r --reflink=auto --no-preserve=mode ${../.}/* ./
  rm -rf Dockerfile env-vars flake.lock flake.nix Makefile nix README.md
  ${jekyll}/bin/jekyll build --destination=$out
''
