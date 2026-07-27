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

    static Step := 0.25

    static Start()
    {
    }

    static Clamp(value)
    {
        if (value > 127)
            return 127

        if (value < 0)
            return 0

        return Round(value)
    }

    static AdjustLowDeck1(dx, dy)
    {
        EQ.Low1 := EQ.Clamp(EQ.Low1 + (dy * EQ.Step))

        MIDI.ControlChange(Mapping.LowEQ1, EQ.Low1)

        ToolTip "LOW D1: " EQ.Low1
    }
}