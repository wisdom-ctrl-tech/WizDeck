#Requires AutoHotkey v2.0

class MouseAxis
{
    static WM_INPUT := 0x00FF
    static RID_INPUT := 0x10000003
    static RIM_TYPEMOUSE := 0
    static MOUSE_MOVE_RELATIVE := 0

    static HID_USAGE_PAGE_GENERIC := 0x01
    static HID_USAGE_GENERIC_MOUSE := 0x02
    static RIDEV_INPUTSINK := 0x00000100

    static Active := false
    static Callback := 0

    static Start()
    {
        OnMessage(MouseAxis.WM_INPUT, MouseAxis.OnInput)
        MouseAxis.Register()
    }

    static Register()
    {
        ; RAWINPUTDEVICE (x64, 16 bytes)
        rid := Buffer(8 + A_PtrSize, 0)
        NumPut("UShort", MouseAxis.HID_USAGE_PAGE_GENERIC, rid, 0)   ; +0: usUsagePage
        NumPut("UShort", MouseAxis.HID_USAGE_GENERIC_MOUSE, rid, 2)  ; +2: usUsage
        NumPut("UInt", MouseAxis.RIDEV_INPUTSINK, rid, 4)            ; +4: dwFlags
        NumPut("Ptr", A_ScriptHwnd, rid, 8)                           ; +8: hwndTarget

        if !DllCall("RegisterRawInputDevices", "Ptr", rid, "UInt", 1, "UInt", rid.Size)
            throw Error("RegisterRawInputDevices failed")
    }

    static Begin(callback)
    {
        if MouseAxis.Active
            return

        if !(IsObject(callback) && HasMethod(callback, "Call"))
            throw ValueError("MouseAxis.Begin requires a callable callback")

        MouseAxis.Callback := callback
        MouseAxis.Active := true
    }

    static End()
    {
        if !MouseAxis.Active
            return

        MouseAxis.Active := false
        MouseAxis.Callback := 0
        ToolTip
    }

    static CallbackReady()
    {
        return MouseAxis.Active
            && IsObject(MouseAxis.Callback)
            && HasMethod(MouseAxis.Callback, "Call")
    }

    static OnInput(wParam, lParam, msg, hwnd)
    {
        if !MouseAxis.CallbackReady()
            return

        ; RAWINPUTHEADER (x64, 24 bytes = 8 + 2*A_PtrSize)
        ;   +0: dwType   (DWORD)
        ;   +4: dwSize   (DWORD)
        ;   +8: hDevice  (HANDLE)
        ;  +16: wParam   (WPARAM)
        headerSize := 8 + 2 * A_PtrSize

        size := 0
        if (DllCall("GetRawInputData"
                , "Ptr", lParam
                , "UInt", MouseAxis.RID_INPUT
                , "Ptr", 0
                , "UInt*", &size
                , "UInt", headerSize
                , "UInt") = 0xFFFFFFFF)
            return

        if (size <= 0)
            return

        buf := Buffer(size, 0)

        if (DllCall("GetRawInputData"
                , "Ptr", lParam
                , "UInt", MouseAxis.RID_INPUT
                , "Ptr", buf
                , "UInt*", &size
                , "UInt", headerSize
                , "UInt") = 0xFFFFFFFF)
            return

        ; RAWINPUT.header.dwType at +0
        if (NumGet(buf, 0, "UInt") != MouseAxis.RIM_TYPEMOUSE)
            return

        ; RAWINPUT.data.mouse (RAWMOUSE) begins at +24 on x64
        ;   +0: usFlags             (USHORT)
        ;   +2: usButtonFlags       (USHORT)
        ;   +4: usButtonData        (USHORT)
        ;   +6: padding             (USHORT, alignment)
        ;   +8: ulRawButtons        (ULONG)
        ;  +12: lLastX              (LONG)
        ;  +16: lLastY              (LONG)
        ;  +20: ulExtraInformation  (ULONG)
        mouseOffset := headerSize

        ; RAWMOUSE.usFlags at mouse +0
        if (NumGet(buf, mouseOffset, "UShort") != MouseAxis.MOUSE_MOVE_RELATIVE)
            return

        ; RAWMOUSE.lLastX at mouse +12
        dx := NumGet(buf, mouseOffset + 12, "Int")
        ; RAWMOUSE.lLastY at mouse +16
        dy := NumGet(buf, mouseOffset + 16, "Int")

        if (!dx && !dy)
            return

        MouseAxis.Callback.Call(dx, dy)
    }
}
