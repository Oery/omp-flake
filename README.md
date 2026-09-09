# OMP Nix flake

Nix package for the [OMP coding agent](https://github.com/can1357/oh-my-pi),
using its official Linux release binaries.

## Run

```console
nix run github:Oery/omp-flake
```

From a local checkout:

```console
nix run .
```

## Install on NixOS or Home Manager

Add this flake as an input:

```nix
{
  inputs.omp.url = "github:Oery/omp-flake";
}
```

Then add the package to either `environment.systemPackages` or
`home.packages`:

```nix
{ inputs, pkgs, ... }:
{
  environment.systemPackages = [ inputs.omp.packages.${pkgs.system}.default ];
}
```

The flake also exports an overlay as `overlays.default`, where the package is
available as `pkgs.omp`.

Supported systems are `x86_64-linux` and `aarch64-linux`.
