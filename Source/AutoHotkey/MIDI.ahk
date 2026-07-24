#Requires AutoHotkey v2.0

class MIDI
{
    static Port := 0

    static Start()
    {
        if Config.Debug
            MsgBox "MIDI initialized."
    }

    static NoteOn(note, velocity := 127)
    {
        MIDI.Send(0x90, note, velocity)
    }

    static NoteOff(note)
    {
        MIDI.Send(0x80, note, 0)
    }

    static Send(status, data1, data2)
    {
        if Config.Debug
        {
            MsgBox Format(
                "Status : 0x{:X}`nData1 : {}`nData2 : {}",
                status,
                data1,
                data2
            )
        }
    }
}