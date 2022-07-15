{ mkDerivation, base, lib }:
mkDerivation {
  pname = "animate";
  version = "0.1.0.0";
  src = ./.;
  isLibrary = true;
  isExecutable = true;
  libraryHaskellDepends = [ base ];
  executableHaskellDepends = [ base ];
  description = "A small Haskell cli animation for educational purposes";
  license = lib.licenses.unlicense;
}
