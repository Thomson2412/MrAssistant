{
  description = "ESPHome pip-based dev env";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };

        pythonEnv = pkgs.python3.withPackages (ps: with ps; [
          pip
          setuptools
          wheel
        ]);
      in {
        devShell = pkgs.mkShell {
          name = "esphome-dev";

          buildInputs = [ pythonEnv ];

          shellHook = ''
            if [ ! -d .venv ]; then
              echo "Creating virtualenv in .venv..."
              python3 -m venv .venv
              source .venv/bin/activate
              pip install --upgrade pip
              pip install esphome
            else
              source .venv/bin/activate
            fi

            echo "ESPHome ready. Run with: esphome run your-config.yaml"
          '';
        };
      });
}