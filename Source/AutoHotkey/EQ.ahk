#Requires AutoHotkey v2.0

class EQ
{
    static Low1 := 64
    static Mid1 := 64
    static High1 := 64
    static Filter1 := 64

    static Low2 := 64
    static Mid2 := 64
    static High2 := 64
    static Filter2 := 64

    static Start()
    {
    }

    static SetLowDeck1(value)
    {
        EQ.Low1 := value
        MIDI.ControlChange(Mapping.LowEQ1, EQ.Low1)

        if Config.Debug
            ToolTip "LOW D1: " EQ.Low1
    }
}
