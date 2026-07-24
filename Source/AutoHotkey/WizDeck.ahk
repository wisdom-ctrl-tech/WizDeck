#Requires AutoHotkey v2.0

#Include Config.ahk
#Include MIDI.ahk
#Include Input.ahk
#Include Transport.ahk

MIDI.Start()
Input.Start()
Transport.Start()

if Config.Debug
    MsgBox "WizDeck Heartbeat started."