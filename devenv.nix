{pkgs, ...}: {
  claude.code.enable = true;

  packages = with pkgs; [
    # Development
    babashka
    just
    keymap-drawer

    # Formatters
    alejandra
    prettier
    shfmt
    treefmt
  ];
}
