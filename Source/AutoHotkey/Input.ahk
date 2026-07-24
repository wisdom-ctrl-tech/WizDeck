#Requires AutoHotkey v2.0

class Input
{
    static Start()
    {
        Hotkey Config.PlayKey, Input.Play
    }

    static Play(*)
    {
        Transport.Play()
    }
}