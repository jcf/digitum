# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Digitum is a ZMK firmware for the Glove80 split keyboard featuring:
- **Engrammer** layout (Arno's Engram for programmers)
- **Home row mods** with per-finger timing and bilateral enforcement
- **Combos** for common shortcuts
- Built with [zmk-nix](https://github.com/lilyinstarlight/zmk-nix) using MoErgo's ZMK fork for RGB_STATUS

## Commands

```sh
just build    # Build firmware (produces result/zmk_lh.uf2 and zmk_rh.uf2)
just flash    # Copy firmware to connected controllers
just fmt      # Format all project files
```

## Architecture

### Build System
- `flake.nix` - Nix flake using `zmk-nix.buildSplitKeyboard`
- `config/west.yml` - West manifest pinning MoErgo's ZMK fork
- Board: `glove80_%PART%` with parts `["lh" "rh"]`

### Keymap Structure (`config/glove80.keymap`)
The keymap is organized with all configuration at the top for easy customization:

1. **Modifier combinations** - HYPER, MEH definitions
2. **Layer indices** - BASE, NAV, SYM, MAGIC
3. **Home row mods** - Per-finger modifier assignments
4. **Top row mods** - Above home row modifier assignments
5. **Thumb clusters** - Key and layer assignments
6. **Timing constants** - TAPPING_TERM, per-finger times, COMBO_TIMEOUT
7. **Key position indices** - For combos and positional hold-tap

### Key Behaviors
- `hml_i/m/r`, `hmr_i/m/r` - Per-finger home row mods (index/middle/ring)
- `ltl`, `ltr` - Layer-tap for thumb keys
- `parang_left/right` - Mod-morph for `()`/`<>` with shift
- `caps_word` - Auto-disabling caps lock

## Updating Dependencies

When updating ZMK or Zephyr versions:
1. Edit `config/west.yml` with new revisions
2. Set `zephyrDepsHash` to a dummy value (e.g., `"sha256-AAAA..."`)
3. Run `just build` - the error shows the correct hash
4. Update `flake.nix` with the correct hash

Note: `just update` may clear revision values when using non-upstream forks.
