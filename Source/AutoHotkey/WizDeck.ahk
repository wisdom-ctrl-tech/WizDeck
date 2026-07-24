#Requires AutoHotkey v2.0

#Include Config.ahk
#Include Input.ahk
#Include Transport.ahk

Input.Start()
Transport.Start()

if Config.Debug
    MsgBox "WizDeck Heartbeat started."