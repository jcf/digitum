# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Digitum is a ZMK firmware configuration for the Glove80 split ergonomic keyboard, built using [zmk-nix](https://github.com/lilyinstarlight/zmk-nix) for reproducible builds via Nix flakes.

## Commands

```sh
just build    # Build firmware (produces .uf2 files)
just flash    # Copy firmware to connected controllers
just update   # Update West dependencies and bump zephyrDepsHash
just fmt      # Format all project files with treefmt
```

## Architecture

The firmware build is defined entirely in `flake.nix` using `zmk-nix.legacyPackages.buildSplitKeyboard`. Key configuration:

- **Board**: `glove80_%PART%` with parts `["lh" "rh"]` (Glove80 is an integrated board, not a shield)
- **ZMK fork**: Uses MoErgo's fork (`moergo-sc/zmk`) for `RGB_STATUS` support
- **Dependencies hash**: `zephyrDepsHash` in flake.nix must be updated when West dependencies change

### Key Files

- `config/glove80.keymap` - Keymap definition using ZMK devicetree syntax
- `config/glove80.conf` - Keyboard configuration options
- `config/west.yml` - West manifest pinning ZMK and Zephyr versions

### Keymap Layers

The keymap defines four layers:
- `DEFAULT` (0) - Standard QWERTY with magic key for layer access
- `LOWER` (1) - Media controls, numpad, navigation
- `MAGIC` (2) - Bluetooth profiles, RGB controls, bootloader
- `FACTORY_TEST` (3) - Hardware testing

The `layer_td` tap-dance behavior allows single tap for momentary layer or double tap for toggle.

## Updating Dependencies

When updating ZMK or Zephyr versions:
1. Edit `config/west.yml` with new revisions
2. Set `zephyrDepsHash` to a dummy value (e.g., `"sha256-AAAA..."`)
3. Run `just build` - the error will show the correct hash
4. Update `flake.nix` with the correct hash

Note: `just update` modifies `west.yml` and may clear revision values when using non-upstream forks. Prefer manual hash updates when using MoErgo's fork.
