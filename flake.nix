{
  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs }: 
    let
      pkgs = import nixpkgs { system = "x86_64-linux"; config.allowUnfree = true; };
      fhs = pkgs.buildFHSUserEnv {
        name = "fhs-shell";
        targetPkgs = pkgs: with pkgs; [
          gcc
          pkg-config
          libclang.lib
          gnumake
          cmake
          ninja

          git
          wget

          rustup
          cargo-generate
          jetbrains.rust-rover

          espflash
          python3
          python3Packages.pip
          python3Packages.virtualenv
          ldproxy

          openssl        # Add OpenSSL package
          openssl.dev    # Add OpenSSL development headers
        ];

        runScript = ''
        # Source the environment file
        # Requires : cargo install espup
        # Requires : espup install
        if [ -f "$HOME/export-esp.sh" ]; then
          . $HOME/export-esp.sh
        else
          echo "export-esp.sh not found. Please ensure it's installed."
        fi

        # Optional: You can also add any build or run commands here
        # For example, you could start a build process:
        # cargo build

        # Start the bash shell (default behavior)
        bash
        '';
      };
    in {
      devShells.${pkgs.system}.default = fhs.env;
    };
}
