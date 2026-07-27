#Requires AutoHotkey v2.0

#Include Config.ahk
#Include MIDI.ahk
#Include Mapping.ahk
#Include EQ.ahk
#Include MouseAxis.ahk
#Include Analog.ahk
#Include Input.ahk
#Include Transport.ahk

MIDI.Start()
EQ.Start()
MouseAxis.Start()
Transport.Start()
Input.Start()

if Config.Debug
    MsgBox "WizDeck Heartbeat started."
