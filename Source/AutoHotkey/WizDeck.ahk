#Requires AutoHotkey v2.0

#Include Config.ahk
#Include Transport.ahk

Transport.Start()

if Config.Debug
    MsgBox "WizDeck Heartbeat started."