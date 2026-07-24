/*

Mouse Wheel to MIDI CC
Use Ctrl + Win + 1 to toggle MIDI CC send mode On/Off
When send mode is On, use the mouse scroll wheel to send MIDI CC

*/

#SingleInstance force
#Requires AutoHotkey >=2.0
#Include <MIDIv2>
Persistent

; Create an instance of the MidiV2 class
MIDI := MidiV2()

; Get the MIDI Out device ID from helper function
myOutputName := "MIDI Out"		; Change this to the name of your MIDI Out port
myOutputID := GetOutputDeviceByName(myOutputName)
; Open the MIDI Out port
MIDI.OpenMidiOut(myOutputID)

sendModeOn := False	; Send MIDI CC mode flag
cc7Value := 0			; MIDI CC value to send

; Ctrl + Win + 1
^#1::
{
	Global sendModeOn
	sendModeOn := !sendModeOn	; Toggle the send mode flag On/Off
	if sendModeOn {
		; Show a tool tip to indicate we are sending MIDI CC with the mouse wheel
		MouseGetPos(&mouseX, &mouseY)
		ToolTip("MouseWheel:`nMIDI CC #7", mouseX, mouseY)
	} else {
		; Hide the tool tip
		ToolTip()
	}
}

; Mouse wheel Up
WheelUp::
{
	if sendModeOn {
		Global cc7Value
		cc7Value++	; Increment the MIDI CC value
		MIDI.SendControlChange(7, cc7Value)	; Send MIDI CC#7 on default MIDI Channel
	} else {
		; If send mode is "off", use the mouse wheel as normal
		MouseClick("WheelUp")
	}
}

; Mouse wheel Down
WheelDown::
{
	if sendModeOn {
		Global cc7Value
		cc7Value--	; Decrement the MIDI CC value
		MIDI.SendControlChange(7, cc7Value)
	} else {
		MouseClick("WheelDown")
	}
}

GetOutputDeviceByName(name) {
	outputDevices := MIDI.GetMidiOutDevices()
	Loop outputDevices.Length
		if outputDevices[A_Index] = name
			return A_Index - 1
	MsgBox("Output device: " name " is not available.")
	ExitApp
}