#Requires AutoHotkey v2.0

class Analog
{
    static Active := false
    static Callback := 0

    static Value := 0
    static Min := 0
    static Max := 127
    static Step := 1
    static Sensitivity := 1.0
    static Axis := "Y"
    static Invert := false
    static Clamp := true
    static DeadZone := 2

    static Begin(callback, options := 0)
    {
        if Analog.Active
            return

        if !(IsObject(callback) && HasMethod(callback, "Call"))
            throw ValueError("Analog.Begin requires a callable callback")

        Analog.Callback := callback
        Analog.ResetOptions()

        ; Resolve a profile name or profile object before applying options.
        resolved := Analog.ResolveProfile(options)
        Analog.ApplyOptions(resolved)

        Analog.Active := true
        MouseAxis.Begin(Analog.OnMouseMove)
    }

    static End()
    {
        if !Analog.Active
            return

        Analog.Active := false
        Analog.Callback := 0
        MouseAxis.End()
    }

    static SetValue(value)
    {
        Analog.Value := Analog.ClampEnabled() ? Analog.ClampValue(value) : value
    }

    static GetValue()
    {
        return Analog.Value
    }

    static ResetOptions()
    {
        Analog.Min := 0
        Analog.Max := 127
        Analog.Step := 1
        Analog.Sensitivity := Config.MouseSensitivity
        Analog.Axis := "Y"
        Analog.Invert := false
        Analog.Clamp := true
        Analog.DeadZone := Config.MouseDeadZone
        Analog.Value := 64
    }

    static ApplyOptions(options)
    {
        if !IsObject(options)
            return

        Analog.Min := Analog.ReadOption(options, "Min", Analog.Min)
        Analog.Max := Analog.ReadOption(options, "Max", Analog.Max)
        Analog.Step := Analog.ReadOption(options, "Step", Analog.Step)
        Analog.Sensitivity := Analog.ReadOption(options, "Sensitivity", Analog.Sensitivity)
        Analog.Axis := Analog.ReadOption(options, "Axis", Analog.Axis)
        Analog.Invert := Analog.ReadOption(options, "Invert", Analog.Invert)
        Analog.Clamp := Analog.ReadOption(options, "Clamp", Analog.Clamp)
        Analog.DeadZone := Analog.ReadOption(options, "DeadZone", Analog.DeadZone)

        initial := Analog.ReadOption(options, "InitialValue", (Analog.Min + Analog.Max) / 2)
        Analog.SetValue(initial)
    }

    static ReadOption(options, name, default)
    {
        if options is Map
            return options.Has(name) ? options[name] : default

        if options.HasProp(name)
            return options.%name%

        return default
    }

    ; ResolveProfile accepts:
    ; - a profile name string (e.g. "EQ") and attempts to look up ControlProfiles.<Name>
    ; - a profile object (Map or plain object) which is copied and returned
    ; - any other value is returned unchanged (preserves backward compatibility)
    static ResolveProfile(options)
    {
        if !options
            return options

        if IsObject(options)
            return Analog.CopyOptions(options)

        if (options is String)
        {
            try
            {
                ; Attempt to resolve a named profile from ControlProfiles without creating a hard dependency
                profile := ControlProfiles.%options%
                if IsObject(profile)
                    return Analog.CopyOptions(profile)
            }
            catch
            {
                ; If ControlProfiles is not present or property doesn't exist, fall through
            }
        }

        return options
    }

    ; Shallow-copy a simple options object (Map or plain object) so callers receive
    ; an independent instance and cannot mutate shared ControlProfiles definitions.
    static CopyOptions(src)
    {
        new := {}
        for k, v in src
            new[k] := v
        return new
    }

    static OnMouseMove(dx, dy)
    {
        if !Analog.Active || !(IsObject(Analog.Callback) && HasMethod(Analog.Callback, "Call"))
            return

        delta := (Analog.Axis = "X") ? dx : dy

        if (Abs(delta) < Analog.DeadZone)
            return

        delta *= Analog.Sensitivity

        if (Analog.Invert)
            delta := -delta

        Analog.Value += delta * Analog.Step

        if (Analog.ClampEnabled())
            Analog.Value := Analog.ClampValue(Analog.Value)

        if (Config.Debug)
            ToolTip "Value: " Analog.Value

        Analog.Callback.Call(Analog.Value)
    }

    static ClampEnabled()
    {
        return Analog.Clamp
    }

    static ClampValue(value)
    {
        if (value > Analog.Max)
            return Analog.Max

        if (value < Analog.Min)
            return Analog.Min

        return Round(value)
    }
}
