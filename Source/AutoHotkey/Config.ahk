#Requires AutoHotkey v2.0

class Config
{
    static MidiPort := "WizDeck"

    static Debug := false

    static ModifierKey := "LAlt"
    static InputDelay := 5

    static MouseDeadZone := 2
    static MouseSensitivity := 1.0

    ; Toggle WizDeck
    static ToggleKey := "\"

    ; Deck 1
    static PlayDeck1 := "Q"
    static CueDeck1  := "W"
    static SyncDeck1 := "E"
    static LoopDeck1 := "R"

    ; Deck 2
    static PlayDeck2 := "A"
    static CueDeck2  := "S"
    static SyncDeck2 := "D"
    static LoopDeck2 := "F"

    static MidiChannel := 1
}
