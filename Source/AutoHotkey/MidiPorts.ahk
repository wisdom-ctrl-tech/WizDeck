#Requires AutoHotkey v2.0
#Include ..\..\Libraries\MIDIv2\MIDIv2.ahk

MIDI := MidiV2()

ports := MIDI.GetMidiOutDevices()

portId := -1

for index, port in ports
{
    if (port = "WizDeck")
    {
        portId := index - 1
        break
    }
}

if (portId = -1)
{
    MsgBox "WizDeck MIDI port not found."
    ExitApp
}

MIDI.OpenMidiOut(portId)

MsgBox "Connected to WizDeck (Port " portId ")."

MIDI.CloseMidiOut()

ExitApp