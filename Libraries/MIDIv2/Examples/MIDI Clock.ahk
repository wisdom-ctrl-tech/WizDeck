/*

MIDI Clock
Receive SRT Timing Clock messages
and display them in the style of
a 16 step sequencer.

*/

#Requires AutoHotkey v2.0
#SingleInstance force
Persistent
#include <MIDIv2>

MIDI := MIDIv2()

MyInputDevice := GetInputDeviceByName("MIDI In")	;Change this to the name of your MIDI In port
MIDI.OpenMidiIn(MyInputDevice)
MIDI.SRT_Enabled := True

MainGui := Gui()
P1 := MainGui.AddProgress("w20 h20 x10 y10 border cRed vP1", 0)
P2 := MainGui.AddProgress("w20 h20 x40 y10 border cGreen vP2", 0)
P3 := MainGui.AddProgress("w20 h20 x70 y10 border cGreen vP3", 0)
P4 := MainGui.AddProgress("w20 h20 x100 y10 border cGreen vP4", 0)
P5 := MainGui.AddProgress("w20 h20 x130 y10 border cRed vP5", 0)
P6 := MainGui.AddProgress("w20 h20 x160 y10 border cGreen vP6", 0)
P7 := MainGui.AddProgress("w20 h20 x190 y10 border cGreen vP7", 0)
P8 := MainGui.AddProgress("w20 h20 x220 y10 border cGreen vP8", 0)
P9 := MainGui.AddProgress("w20 h20 x250 y10 border cRed vP9", 0)
P10 := MainGui.AddProgress("w20 h20 x280 y10 border cGreen vP10", 0)
P11 := MainGui.AddProgress("w20 h20 x310 y10 border cGreen vP11", 0)
P12 := MainGui.AddProgress("w20 h20 x340 y10 border cGreen vP12", 0)
P13 := MainGui.AddProgress("w20 h20 x370 y10 border cRed vP13", 0)
P14 := MainGui.AddProgress("w20 h20 x400 y10 border cGreen vP14", 0)
P15 := MainGui.AddProgress("w20 h20 x430 y10 border cGreen vP15", 0)
P16 := MainGui.AddProgress("w20 h20 x460 y10 border cGreen vP16", 0)

MainGui.Show("w490 h40")

ppqn := 1
Sixteenth := 0
MidiInSRT_TimingClock() {
	Global ppqn, Sixteenth
	if Mod(ppqn, 6) = 1 {
		Sixteenth := (Sixteenth = 16) ? 1 : Sixteenth += 1
		Previous := (Sixteenth = 1) ? 16 : Sixteenth - 1
		MainGui["P" Previous].Value := 0
		MainGui["P" Sixteenth].Value := 100
	}
	ppqn := (ppqn = 96) ? 1 : ppqn += 1
}

GetInputDeviceByName(name) {
	inputDevices := MIDI.GetMidiInDevices()
	Loop inputDevices.Length
		if inputDevices[A_Index] = name
			return A_Index - 1
	MsgBox("Input device: " name " is not available.")
	ExitApp
}