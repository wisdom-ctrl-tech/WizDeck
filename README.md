# WizDeck

**A laptop-first DJ controller for [Mixxx](https://mixxx.org/).**

Version 0.1 — "Heartbeat" · Motto: *Create Intuition.*

WizDeck turns a Windows laptop's keyboard and mouse into a DJ controller. Instead of copying the layout of physical hardware, it uses the things a laptop is already good at: keys for fast, decisive actions and the mouse for smooth, continuous control.

The result is a lightweight way to practise, prepare sets, or play a casual gig without unpacking a controller.

## How it works

WizDeck is an AutoHotkey v2 application that runs alongside Mixxx. It listens for keyboard and mouse input, converts that input into standard MIDI messages, and sends them to Mixxx through a virtual MIDI port.

```
 Keyboard ──► Input ──────────────┐
                                  ├──► MIDI ──► loopMIDI ──► Mixxx
 Mouse ─────► MouseAxis ──► Analog┘
                                │
                                └──► EQ / Filter / Gain / FX
```

- **Input** registers hotkeys and only activates them while Mixxx is the focused window.
- **MouseAxis** captures raw mouse movement through Windows Raw Input (`WM_INPUT`), so movement is read directly instead of through cursor position.
- **Analog** turns relative movement into a bounded value (0–127 by default) with configurable step size, sensitivity, inversion, clamping, and a dead zone.
- **MIDI** sends note and control-change messages over the MIDIv2 library to a virtual port named `WizDeck`.
- **Mixxx** receives those messages exactly as it would from a hardware controller.

## Features

- Two-deck keyboard transport (play, cue, sync, loop).
- Global enable/disable toggle that stays available at all times.
- Mixxx-aware controls — hotkeys are ignored when another window is focused.
- Raw mouse input for continuous controls.
- Analog engine with min/max, step, sensitivity, invert, clamp, and dead-zone settings.
- Reusable control profiles for EQ, filter, gain, tempo, pitch, and library browsing.
- Config-driven key bindings, MIDI channel, MIDI port, and mouse behaviour.
- Modular AutoHotkey classes with a small, readable codebase.

## Requirements

- Windows 10 or 11
- [AutoHotkey v2.0](https://www.autohotkey.com/)
- [Mixxx](https://mixxx.org/)
- [loopMIDI](https://www.tobias-erichsen.de/software/loopmidi.html) with a virtual port named **WizDeck**
- MIDIv2 — included in `Libraries/MIDIv2`

## Getting started

1. **Install loopMIDI** and create a virtual MIDI port named `WizDeck`.
   The name must match `Config.MidiPort`, or WizDeck will exit on startup.
2. **Install AutoHotkey v2.0** and Mixxx.
3. **Clone the repository.**

   ```bash
   git clone https://github.com/wisdom-ctrl-tech/WizDeck.git
   ```

4. **Run the script** by double-clicking `Source/AutoHotkey/WizDeck.ahk`.
5. **Start Mixxx** and enable the `WizDeck` MIDI input under *Preferences → Controllers*.
6. **Focus the Mixxx window** and use the keyboard controls below.

> The default keys are plain letter keys, so they only fire while Mixxx is the active window. Press `\` at any time to turn WizDeck on or off.

## Default controls

| Key | Action |
|---|---|
| `\` | Enable / disable WizDeck |
| `Q` | Deck 1 — Play |
| `W` | Deck 1 — Cue |
| `E` | Deck 1 — Sync |
| `R` | Deck 1 — Loop |
| `A` | Deck 2 — Play |
| `S` | Deck 2 — Cue |
| `D` | Deck 2 — Sync |
| `F` | Deck 2 — Loop |

Bindings live in `Source/AutoHotkey/Config.ahk`.

## MIDI mapping

### Notes

| Function | Note |
|---|---:|
| Play Deck 1 | 60 |
| Cue Deck 1 | 61 |
| Sync Deck 1 | 62 |
| Loop Deck 1 | 63 |
| Play Deck 2 | 64 |
| Cue Deck 2 | 65 |
| Sync Deck 2 | 66 |
| Loop Deck 2 | 67 |
| FX 1 | 68 |
| FX 2 | 69 |
| FX 3 | 70 |
| FX 4 | 71 |

### Control change

| Function | CC |
|---|---:|
| Low EQ 1 | 20 |
| Mid EQ 1 | 21 |
| High EQ 1 | 22 |
| Filter 1 | 23 |
| Gain 1 | 24 |
| Low EQ 2 | 25 |
| Mid EQ 2 | 26 |
| High EQ 2 | 27 |
| Filter 2 | 28 |
| Gain 2 | 29 |

The full mapping is defined in `Source/AutoHotkey/Mapping.ahk` and documented in [`Docs/MIDI Mapping.md`](Docs/MIDI%20Mapping.md).

## Project structure

```
Source/
  AutoHotkey/
    WizDeck.ahk           entry point
    Config.ahk            keys, MIDI port/channel, mouse settings
    Input.ahk             hotkeys and Mixxx-window guard
    MouseAxis.ahk         raw mouse input via WM_INPUT
    Analog.ahk            relative movement → bounded value
    ControlProfiles.ahk   presets for EQ, filter, gain, tempo, pitch, browser
    MIDI.ahk              MIDIv2 wrapper and port connection
    Mapping.ahk           MIDI notes and CC numbers
    Transport.ahk         play, cue, sync, loop messages
    EQ.ahk                EQ control state and output
  Mixxx/
    WizDeck.js            Mixxx controller script (placeholder)
    WizDeck.xml           Mixxx mapping (placeholder)
Libraries/
  MIDIv2/                 vendored MIDI library
Docs/
  Architecture.md         layer overview and data flow
  MIDI Mapping.md         note and CC reference
  Roadmap.md              planned work
  Ideas.md  Journal.md    project notes
```

## Architecture

| Layer | Files | Responsibility |
|---|---|---|
| Core | `WizDeck.ahk`, `Config.ahk` | Boot the app and hold configuration |
| Input | `Input.ahk`, `MouseAxis.ahk` | Keyboard hotkeys and raw mouse movement |
| Control | `Analog.ahk`, `ControlProfiles.ahk` | Turn movement into stable control values |
| Mixer | `Transport.ahk`, `EQ.ahk` | Deck actions and mixer parameters |
| MIDI | `MIDI.ahk`, `Mapping.ahk` | Encode and send MIDI messages |

See [`Docs/Architecture.md`](Docs/Architecture.md) for the longer explanation.

## Status and roadmap

WizDeck is at **v0.1 "Heartbeat"** — the foundation is in place, but it is not a finished controller yet.

**Working now**

- [x] Virtual MIDI output to Mixxx
- [x] Two-deck keyboard transport
- [x] Mixxx-focused input handling
- [x] Raw mouse input and analog value engine
- [x] Control profiles and configuration system

**Next**

- [ ] Finish EQ, filter, and gain bindings for both decks
- [ ] FX slots and parameter control
- [ ] Library browsing, track loading, and search
- [ ] Mixxx mapping script and XML preset
- [ ] On-screen HUD and notifications
- [ ] Settings UI
- [ ] v1.0 release

The roadmap is tracked in [`Docs/Roadmap.md`](Docs/Roadmap.md).

### A note on the Mixxx mapping

The AutoHotkey side already sends valid MIDI notes and CC messages. The matching Mixxx controller mapping in `Source/Mixxx/` is still a placeholder, so until it is added you will need to MIDI-learn the controls in Mixxx manually.

## Documentation

- [Architecture](Docs/Architecture.md)
- [MIDI Mapping](Docs/MIDI%20Mapping.md)
- [Roadmap](Docs/Roadmap.md)
- [Ideas](Docs/Ideas.md)
- [Journal](Docs/Journal.md)
- [Changelog](CHANGELOG.md)

## Contributing

WizDeck is a personal project, but feedback, ideas, and bug reports are welcome. Open an issue or start a discussion if something could feel more natural.

## Credits

- [MIDIv2](https://github.com/emliberace/MIDIv2.ahk) by emliberace — vendored under `Libraries/MIDIv2` (GPL-3.0).
- [Mixxx](https://mixxx.org/) — the DJ software WizDeck is built for.
- [loopMIDI](https://www.tobias-erichsen.de/software/loopmidi.html) — virtual MIDI ports on Windows.
- [AutoHotkey](https://www.autohotkey.com/) — automation and input handling.

## Author

Built by [Wisdom](https://github.com/wisdom-ctrl-tech).
