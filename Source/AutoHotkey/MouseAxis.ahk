#Requires AutoHotkey v2.0

class MouseAxis
{
    static Active := false

    static Callback := 0

    static LockX := 0
    static LockY := 0

    static OriginalX := 0
    static OriginalY := 0

    static DeadZone := 2
    static Sensitivity := 1.0

    static Start()
    {
        SetTimer(MouseAxis.Update.Bind(MouseAxis), 10)
    }

    static Begin(callback)
    {
        if MouseAxis.Active
            return

        MouseGetPos(&x, &y)

        MouseAxis.OriginalX := x
        MouseAxis.OriginalY := y

        MouseAxis.LockX := x
        MouseAxis.LockY := y

        MouseAxis.Callback := callback
        MouseAxis.Active := true
    }

    static End()
    {
        if !MouseAxis.Active
            return

        MouseAxis.Active := false
        MouseAxis.Callback := 0

        DllCall("SetCursorPos"
            , "Int", MouseAxis.OriginalX
            , "Int", MouseAxis.OriginalY)

        ToolTip
    }

    static Update(*)
    {
        if !MouseAxis.Active
            return

        MouseGetPos(&x, &y)

        dx := x - MouseAxis.LockX
        dy := MouseAxis.LockY - y

        if (Abs(dx) < MouseAxis.DeadZone)
            dx := 0

        if (Abs(dy) < MouseAxis.DeadZone)
            dy := 0

        if (!dx && !dy)
            return

        dx *= MouseAxis.Sensitivity
        dy *= MouseAxis.Sensitivity

        DllCall("SetCursorPos"
            , "Int", MouseAxis.LockX
            , "Int", MouseAxis.LockY)

        if (MouseAxis.Callback)
            MouseAxis.Callback.Call(dx, dy)
    }
}

; --------------------------------------------------
; TEMP TEST
; --------------------------------------------------

z::
{
    MouseAxis.Begin(ObjBindMethod(EQ, "AdjustLowDeck1"))
}

z Up::
{
    MouseAxis.End()
}