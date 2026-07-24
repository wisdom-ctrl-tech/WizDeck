#Requires AutoHotkey v2.0
#Include ..\..\Libraries\MIDIv2\MIDIv2.ahk

class MIDI
{
    static Device := ""

    static Start()
    {
        MIDI.Device := MidiV2()

        ports := MIDI.Device.GetMidiOutDevices()

        portId := -1

        for index, port in ports
        {
            if (port = Config.MidiPort)
            {
                portId := index - 1
                break
            }
        }

        if (portId = -1)
        {
            MsgBox "MIDI port '" Config.MidiPort "' not found."
            ExitApp
        }

        MIDI.Device.OpenMidiOut(portId)
        MIDI.Device.OutputChannel := Config.MidiChannel

        if Config.Debug
            MsgBox "Connected to " Config.MidiPort
    }

    static NoteOn(note, velocity := 127)
    {
        MIDI.Device.SendNoteOn(note, velocity)
    }

    static NoteOff(note)
    {
        MIDI.Device.SendNoteOff(note)
    }
}