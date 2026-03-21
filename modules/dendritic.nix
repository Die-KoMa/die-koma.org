{ inputs, ... }:
{

  imports = [
    (inputs.flake-file.flakeModules.dendritic or { })
  ];

  flake-file.inputs.systems.url = "github:nix-systems/default";
  systems = import inputs.systems;

  flake-file.inputs.nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

}
