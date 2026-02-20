_default:
    @just --list

# ------------------------------------------------------------------------------
# Dev

# Format project files
[group('dev')]
fmt:
    treefmt

# Generate keymap visualization
[group('dev')]
draw:
    keymap parse -c 10 -z config/glove80.keymap | keymap draw - > doc/keymap.svg
    @echo "{{ BOLD }}{{ BLUE }}==>{{ NORMAL }} {{ BOLD }}Generated doc/keymap.svg.{{ NORMAL }}"

# Print key position indices
[group('dev')]
keypos:
    @bin/keypos

# Update West dependencies and bump `zephyrDepsHash`
[group('dev')]
update:
    nix run '.#update'

# ------------------------------------------------------------------------------
# Deploy

# Build firmware
[group('deploy')]
build:
    nix build '.#firmware'
    @just draw

# Copy firmware to mounted bootloader volume
[group('deploy')]
[no-exit-message]
flash:
    #!/usr/bin/env zsh
    set -e

    flashing() {
        local side="$1"
        echo >&2 "{{ BOLD }}{{ BLUE }}==>{{ NORMAL }} {{ BOLD }}Flashing $side hand...{{ NORMAL }}"
    }

    success() {
        echo >&2 "{{ BOLD }}{{ GREEN }}==>{{ NORMAL }} {{ BOLD }}Done. Happy hacking!{{ NORMAL }}"
    }

    err() {
        echo >&2 "{{ BOLD }}{{ RED }}==>{{ NORMAL }} {{ BOLD }}$@{{ NORMAL }}"
    }

    if [[ -d /Volumes/GLV80LHBOOT ]]; then
        flashing "left"
        cp -L result/zmk_lh.uf2 /Volumes/GLV80LHBOOT/
        success
    elif [[ -d /Volumes/GLV80RHBOOT ]]; then
        flashing "right"
        cp -L result/zmk_rh.uf2 /Volumes/GLV80RHBOOT/
        success
    else
        err "No Glove80 found. Are you in bootloader mode?"
        exit 1
    fi
