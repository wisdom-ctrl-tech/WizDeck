#Requires AutoHotkey v2.0

class Transport
{
    static Start()
    {
        if Config.Debug
            MsgBox "Transport module loaded."
    }

    static Play()
    {
        MIDI.Send(0x90, 60, 127)
    }
}