#Requires AutoHotkey v2.0

class Input
{
    static Start()
    {
        Hotkey "F9", Input.Play
    }

    static Play(*)
    {
        Transport.Play()
    }
}