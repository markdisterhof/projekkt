{
  description = "Nix flake for a Tauri app with Svelte";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
      in
      {
        devShells.default = pkgs.mkShell {
          buildInputs = [
            pkgs.curl
            pkgs.wget
            pkgs.webkitgtk
            pkgs.pkg-config
            pkgs.gcc
            pkgs.openssl
            pkgs.gtk3
            pkgs.libayatana-appindicator
            pkgs.librsvg
            pkgs.nodejs
            pkgs.cargo
            pkgs.rustc
            pkgs.rustup
          ];

          shellHook = ''
            # Install Rust
            if ! command -v rustc &> /dev/null; then
              rustup-init -y
              source $HOME/.cargo/env
            fi

            # Check Rust installation
            if ! rustc --version &> /dev/null; then
              echo "Rust installation failed"
              exit 1
            fi

            # Install Node.js (LTS version)
            if ! command -v node &> /dev/null; then
              export NVM_DIR="$HOME/.nvm"
              [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm
              nvm install --lts
            fi

            # Check Node.js installation
            if ! node --version &> /dev/null; then
              echo "Node.js installation failed"
              exit 1
            fi
          '';
        };
      });
}
