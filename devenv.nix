{pkgs, ...}: {
  claude.code.enable = true;

  packages = with pkgs; [
    # Development
    just
    keymap-drawer

    # Formatters
    alejandra
    prettier
    shfmt
    treefmt
  ];
}
