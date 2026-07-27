\# WizDeck Architecture



\## Core



\- WizDeck.ahk

\- Config.ahk



\## Input Layer



\- Input.ahk

\- MouseAxis.ahk



\## MIDI Layer



\- MIDI.ahk

\- Mapping.ahk



\## Mixer Layer



\- Transport.ahk

\- EQ.ahk

\- Filter.ahk (planned)

\- Gain.ahk (planned)

\- FX.ahk (planned)



\## Libraries



\- MIDIv2

\- LoopMIDI



\## Data Flow



Keyboard

↓

Input

↓

MouseAxis

↓

EQ / Filter / FX / Gain

↓

MIDI

↓

LoopMIDI

↓

Mixxx

