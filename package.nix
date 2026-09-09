{
  lib,
  stdenv,
  fetchurl,
  autoPatchelfHook,
}:

let
  version = "18.1.13";
  sources = {
    aarch64-linux = {
      asset = "omp-linux-arm64";
      hash = "sha256-BvxyGDygxbOt19HcwaMAXhe5tntnnwS1xkawi/52PLY=";
    };
    x86_64-linux = {
      asset = "omp-linux-x64";
      hash = "sha256-O+WjCMyR5va7oUgXX75lHTWD/20yriIcuTHcCKZOHzk=";
    };
  };
  source = sources.${stdenv.hostPlatform.system};
in
stdenv.mkDerivation {
  pname = "omp";
  inherit version;

  src = fetchurl {
    url = "https://github.com/can1357/oh-my-pi/releases/download/v${version}/${source.asset}";
    inherit (source) hash;
  };

  dontUnpack = true;
  # Bun standalone executables store the bundled application in an appended
  # payload. Stripping the ELF removes that payload and leaves a plain Bun CLI.
  dontStrip = true;
  strictDeps = true;

  nativeBuildInputs = [ autoPatchelfHook ];

  installPhase = ''
    runHook preInstall

    install -Dm755 "$src" "$out/bin/omp"

    runHook postInstall
  '';

  doInstallCheck = stdenv.buildPlatform.canExecute stdenv.hostPlatform;
  installCheckPhase = ''
    runHook preInstallCheck
    versionOutput=$("$out/bin/omp" --version)
    if [ "$versionOutput" != "omp/$version" ]; then
      echo "Expected omp/$version, got: $versionOutput" >&2
      exit 1
    fi
    runHook postInstallCheck
  '';

  meta = {
    description = "Personal AI coding agent for the terminal";
    homepage = "https://github.com/can1357/oh-my-pi";
    license = lib.licenses.mit;
    mainProgram = "omp";
    platforms = builtins.attrNames sources;
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
  };
}
