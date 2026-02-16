_default:
    @just --list

# ------------------------------------------------------------------------------
# Dev

# Format project files
[group('dev')]
fmt:
    treefmt

# Update West dependencies and bump `zephyrDepsHash`
[group('dev')]
update:
    nix run '.#update'

# ------------------------------------------------------------------------------
# Dev

# Build firmware
[group('deploy')]
build:
    nix build '.#firmware'

# Copy `uf2` firmware files to controllers
[group('deploy')]
flash:
    nix run '.#flash'
