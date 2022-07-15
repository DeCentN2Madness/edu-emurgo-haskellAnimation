let
 pkgs = import <nixpkgs> { };
in
 pkgs.haskellPackages.callPackage ./animate.nix { }
