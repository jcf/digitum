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
# Deploy

# Build firmware
[group('deploy')]
build:
    nix build '.#firmware'

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
