#Requires AutoHotkey v2.0

class Input
{
    static Enabled := true

    static Start()
    {
        ; Toggle WizDeck (always available)
        HotIf
        Hotkey Config.ToggleKey, Input.Toggle

        ; Transport controls only when Ready() is true
        HotIf Input.Ready

        ;=========================
        ; Deck 1
        ;=========================

        Hotkey Config.PlayDeck1, Input.PlayDeck1
        Hotkey Config.CueDeck1,  Input.CueDeck1
        Hotkey Config.SyncDeck1, Input.SyncDeck1
        Hotkey Config.LoopDeck1, Input.LoopDeck1

        ;=========================
        ; Deck 2
        ;=========================

        Hotkey Config.PlayDeck2, Input.PlayDeck2
        Hotkey Config.CueDeck2,  Input.CueDeck2
        Hotkey Config.SyncDeck2, Input.SyncDeck2
        Hotkey Config.LoopDeck2, Input.LoopDeck2

        ; End conditional hotkeys
        HotIf

        ; TEMP TEST — hold Z to drive EQ via Analog
        if Config.Debug
        {
            Hotkey "z", Input.AnalogTestDown
            Hotkey "z Up", Input.AnalogTestUp
        }
    }

    static Ready(*)
    {
        return Input.Enabled && WinActive("ahk_exe mixxx.exe")
    }

    static Toggle(*)
    {
        Input.Enabled := !Input.Enabled

        ToolTip(Input.Enabled
            ? "🟢 WizDeck ENABLED"
            : "🔴 WizDeck DISABLED")

        SetTimer () => ToolTip(), -1200
    }

    ;=========================
    ; Deck 1
    ;=========================

    static PlayDeck1(*)
    {
        Transport.PlayDeck1()
    }

    static CueDeck1(*)
    {
        Transport.CueDeck1()
    }

    static SyncDeck1(*)
    {
        Transport.SyncDeck1()
    }

    static LoopDeck1(*)
    {
        Transport.LoopDeck1()
    }

    ;=========================
    ; Deck 2
    ;=========================

    static PlayDeck2(*)
    {
        Transport.PlayDeck2()
    }

    static CueDeck2(*)
    {
        Transport.CueDeck2()
    }

    static SyncDeck2(*)
    {
        Transport.SyncDeck2()
    }

    static LoopDeck2(*)
    {
        Transport.LoopDeck2()
    }

    ;=========================
    ; TEMP TEST — Analog
    ;=========================

    static AnalogTestDown(*)
    {
        Analog.Begin(ObjBindMethod(EQ, "SetLowDeck1"), {
            Min: 0,
            Max: 127,
            InitialValue: EQ.Low1,
            Step: 0.25,
            Axis: "Y",
            Invert: true,
            Sensitivity: Config.MouseSensitivity,
            DeadZone: Config.MouseDeadZone
        })
    }

    static AnalogTestUp(*)
    {
        Analog.End()
    }
}
