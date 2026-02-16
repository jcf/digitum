{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    zmk-nix = {
      url = "github:lilyinstarlight/zmk-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    zmk-nix,
  }: let
    forAllSystems = nixpkgs.lib.genAttrs (nixpkgs.lib.attrNames zmk-nix.packages);
  in {
    packages = forAllSystems (system: rec {
      default = firmware;

      firmware = zmk-nix.legacyPackages.${system}.buildSplitKeyboard {
        name = "firmware";

        src = nixpkgs.lib.sourceFilesBySuffices self [
          ".board"
          ".cmake"
          ".conf"
          ".defconfig"
          ".dts"
          ".dtsi"
          ".json"
          ".keymap"
          ".overlay"
          ".shield"
          ".yml"
          "_defconfig"
        ];

        board = "glove80_%PART%";
        parts = ["lh" "rh"];
        shield = null;

        zephyrDepsHash = "sha256-gdUvNWWIND4bpd5UXcT6a8xhXnICgJNazUXlsjcuL+U=";

        meta = {
          description = "Digitum";
          license = nixpkgs.lib.licenses.agpl3Only;
          platforms = nixpkgs.lib.platforms.all;
        };
      };

      flash = zmk-nix.packages.${system}.flash.override {inherit firmware;};
      update = zmk-nix.packages.${system}.update;
    });

    devShells = forAllSystems (system: {
      default = zmk-nix.devShells.${system}.default;
    });
  };
}
