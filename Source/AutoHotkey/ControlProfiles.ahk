#Requires AutoHotkey v2.0

; ControlProfiles.ahk
; Centralized, read-only configuration objects for Analog consumers.
; Profiles contain configuration only (no logic) and are intended to be treated as immutable.

class ControlProfiles
{
    static EQ := { Axis: "Y", Min: 0, Max: 127, InitialValue: 64, Step: 1, Sensitivity: 1.0, Invert: false, Clamp: true, DeadZone: 2 }
    static Filter := { Axis: "Y", Min: 0, Max: 127, InitialValue: 64, Step: 1, Sensitivity: 1.0, Invert: false, Clamp: true, DeadZone: 2 }
    static Gain := { Axis: "Y", Min: 0, Max: 100, InitialValue: 50, Step: 1, Sensitivity: 1.0, Invert: false, Clamp: true, DeadZone: 2 }
    static Tempo := { Axis: "Y", Min: -20, Max: 20, InitialValue: 0, Step: 0.01, Sensitivity: 0.1, Invert: false, Clamp: true, DeadZone: 0.01 }
    static Pitch := { Axis: "Y", Min: -12, Max: 12, InitialValue: 0, Step: 0.01, Sensitivity: 0.1, Invert: false, Clamp: true, DeadZone: 0.01 }
    static Browser := { Axis: "Y", Min: -100, Max: 100, InitialValue: 0, Step: 1, Sensitivity: 1.0, Invert: false, Clamp: true, DeadZone: 2 }
}
