{pkgs, ...}: {
  claude.code.enable = true;

  packages = with pkgs; [
    # Development
    just

    # Formatters
    alejandra
    prettier
    shfmt
    treefmt
  ];
}
