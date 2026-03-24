{ lib
, rustPlatform
}:

rustPlatform.buildRustPackage rec {
  pname = "project-jump";
  version = "0.1";

  src = lib.cleanSource ./.;

  cargoLock.lockFile = ./Cargo.lock;

  meta = {
    description = "A project manager tool";
    license = lib.licenses.mit;
    maintainers = [ ];
    mainProgram = "project-jump";
  };
}
