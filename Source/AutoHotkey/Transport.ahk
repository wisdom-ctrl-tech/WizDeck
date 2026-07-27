#Requires AutoHotkey v2.0

class Transport
{
    static Start()
    {
    }

    static SendButton(note)
    {
        MIDI.NoteOn(note)

        Sleep 10

        MIDI.NoteOff(note)
    }

    static PlayDeck1()
    {
        Transport.SendButton(Mapping.PlayDeck1)
    }

    static CueDeck1()
    {
        Transport.SendButton(Mapping.CueDeck1)
    }

    static SyncDeck1()
    {
        Transport.SendButton(Mapping.SyncDeck1)
    }

    static LoopDeck1()
    {
        Transport.SendButton(Mapping.LoopDeck1)
    }

    static PlayDeck2()
    {
        Transport.SendButton(Mapping.PlayDeck2)
    }

    static CueDeck2()
    {
        Transport.SendButton(Mapping.CueDeck2)
    }

    static SyncDeck2()
    {
        Transport.SendButton(Mapping.SyncDeck2)
    }

    static LoopDeck2()
    {
        Transport.SendButton(Mapping.LoopDeck2)
    }
}