#Requires AutoHotkey v2.0

class Transport
{
    static Start()
    {
        if Config.Debug
            MsgBox "Transport module loaded."
    }

    static Play()
    {
        if Config.Debug
            MsgBox "Play requested."
    }
}