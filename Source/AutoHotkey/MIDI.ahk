#Requires AutoHotkey v2.0

class MIDI
{
    static Start()
    {
        if Config.Debug
            MsgBox "MIDI module loaded."
    }

    static Send(status, data1, data2)
    {
        if Config.Debug
            MsgBox Format(
                "MIDI`nStatus: {1}`nData1: {2}`nData2: {3}",
                status,
                data1,
                data2
            )
    }
}