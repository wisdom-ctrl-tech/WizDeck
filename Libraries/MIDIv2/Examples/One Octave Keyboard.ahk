/*

One Octave Keyboard
Use the computer keyboard to send Note On/Off messages
Use the +/- keys to change octave

  w e   t y u
 a s d f g h j k

*/

#SingleInstance force
#Requires AutoHotkey >=2.0
#Include <MIDIv2>

; Create an instance of the MidiV2 class
MIDI := MidiV2()

; Get the MIDI Out device ID from helper function
myOutputName := "MIDI Out"		; Change this to the name of your MIDI Out port
myOutputID := GetOutputDeviceByName(myOutputName)
; Open the MIDI Out port
MIDI.OpenMidiOut(myOutputID)

; Set default output MIDI channel to 2
MIDI.OutputChannel := 2

NOTES_IN_OCTAVE := 12
octave := 4

; Note On ----------------------------------------
q::
{
    Hotkey "q", "Off"    ; Prevent key repeat
    ; Send a Note On message with default velocity
    ; on the default MIDI Output channel
    MIDI.SendNoteOn(0 + octave * NOTES_IN_OCTAVE)
}
2::
{
    Hotkey "2", "Off"
    MIDI.SendNoteOn(1 + octave * NOTES_IN_OCTAVE)
}
w::
{
    Hotkey "w", "Off"
    MIDI.SendNoteOn(2 + octave * NOTES_IN_OCTAVE)
}
3::
{
    Hotkey "3", "Off"
    MIDI.SendNoteOn(3 + octave * NOTES_IN_OCTAVE)
}
e::
{
    Hotkey "e", "Off"
    MIDI.SendNoteOn(4 + octave * NOTES_IN_OCTAVE)
}
r::
{
    Hotkey "r", "Off"
    MIDI.SendNoteOn(5 + octave * NOTES_IN_OCTAVE)
}
5::
{
    Hotkey "5", "Off"
    MIDI.SendNoteOn(6 + octave * NOTES_IN_OCTAVE)
}
t::
{
    Hotkey "t", "Off"
    MIDI.SendNoteOn(7 + octave * NOTES_IN_OCTAVE)
}
6::
{
    Hotkey "6", "Off"
    MIDI.SendNoteOn(8 + octave * NOTES_IN_OCTAVE)
}
y::
{
    Hotkey "y", "Off"
    MIDI.SendNoteOn(9 + octave * NOTES_IN_OCTAVE)
}
7::
{
    Hotkey "7", "Off"
    MIDI.SendNoteOn(10 + octave * NOTES_IN_OCTAVE)
}
u::
{
    Hotkey "u", "Off"
    MIDI.SendNoteOn(11 + octave * NOTES_IN_OCTAVE)
}
i::
{
    Hotkey "i", "Off"
    MIDI.SendNoteOn(12 + octave * NOTES_IN_OCTAVE)
}

; Note Off ---------------------------------------
q Up::
{
    Hotkey "q", "On"
    MIDI.SendNoteOff(0 + octave * NOTES_IN_OCTAVE)
}
2 Up::
{
    Hotkey "2", "On"
    MIDI.SendNoteOff(1 + octave * NOTES_IN_OCTAVE)
}
w Up::
{
    Hotkey "w", "On"
    MIDI.SendNoteOff(2 + octave * NOTES_IN_OCTAVE)
}
3 Up::
{
    Hotkey "3", "On"
    MIDI.SendNoteOff(3 + octave * NOTES_IN_OCTAVE)
}
e Up::
{
    Hotkey "e", "On"
    MIDI.SendNoteOff(4 + octave * NOTES_IN_OCTAVE)
}
r Up::
{
    Hotkey "r", "On"
    MIDI.SendNoteOff(5 + octave * NOTES_IN_OCTAVE)
}
5 Up::
{
    Hotkey "5", "On"
    MIDI.SendNoteOff(6 + octave * NOTES_IN_OCTAVE)
}
t Up::
{
    Hotkey "t", "On"
    MIDI.SendNoteOff(7 + octave * NOTES_IN_OCTAVE)
}
6 Up::
{
    Hotkey "6", "On"
    MIDI.SendNoteOff(8 + octave * NOTES_IN_OCTAVE)
}
y Up::
{
    Hotkey "y", "On"
    MIDI.SendNoteOff(9 + octave * NOTES_IN_OCTAVE)
}
7 Up::
{
    Hotkey "7", "On"
    MIDI.SendNoteOff(10 + octave * NOTES_IN_OCTAVE)
}
u Up::
{
    Hotkey "u", "On"
    MIDI.SendNoteOff(11 + octave * NOTES_IN_OCTAVE)
}
i Up::
{
    Hotkey "i", "On"
    MIDI.SendNoteOff(12 + octave * NOTES_IN_OCTAVE)
}

; Change octave ----------------------------------
+::
{
    Global octave
    octave++
}
-::
{
    Global octave
    octave--
}

GetOutputDeviceByName(name) {
	outputDevices := MIDI.GetMidiOutDevices()
	Loop outputDevices.Length
		if outputDevices[A_Index] = name
			return A_Index - 1
	MsgBox("Output device: " name " is not available.")
	ExitApp
}