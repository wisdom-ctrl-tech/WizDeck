/*

Gui Controllers
Send and receive MIDI using standard Windows controls

*/

#SingleInstance force
#Requires AutoHotkey >=2.0
#Include <MIDIv2>

MIDI := MidiV2()	; Create an instance of the MidiV2 class

; Create a menu with all MIDI input devices
MidiInputs := MIDI.getMidiInDevices()
inputMenu := Menu()
for _, port in MidiInputs {
	inputMenu.Add(A_Index - 1 . " - " . port, setInputPort)
}

; Create a menu with all MIDI output devices
MidiOutputs := MIDI.getMidiOutDevices()
outputMenu := Menu()
for _, port in MidiOutputs {
	outputMenu.Add(A_Index - 1 . " - " . port, setOutputPort)
}

; Create a menu for MIDI input channel filter
chInMenu := Menu()
chInMenu.Add("All", setInputChannel)
Loop 16 {
	chInMenu.Add(A_Index, setInputChannel)
}
chInMenu.Check("All")

; Create a menu with MIDI output channels
chOutMenu := Menu()
Loop 16 {
	chOutMenu.Add(A_Index, setOutputChannel)
}
chOutMenu.Check("1")

; Add previously created menu items to one menu object
midiMenu := Menu()
midiMenu.Add("Input Port", inputMenu)
midiMenu.Add("Input Channel", chInMenu)
midiMenu.Add()
midiMenu.Add("Output Port", outputMenu)
midiMenu.Add("Output Channel", chOutMenu)

; Create a File menu
fileMenu := Menu()
fileMenu.Add("&Exit", Gui_Close)	; Add Exit to the File menu

guiMenu := MenuBar()	; Create a menu bar
guiMenu.Add("&File", FileMenu)	; Add the File menu to the menu bar
guiMenu.Add("&MIDI", midiMenu)	; Add the MIDI Port menu to the menu bar

mainGui := Gui(, "MIDI Custom Gui")	; Create the GUI
mainGui.MenuBar := guiMenu	; Add the menu bar

; Create Slider 1 (Vertical)
mainGui.AddText("x10 y10 w41 Center", "CC #1")	; Text Label
Slider1 := mainGui.AddSlider("vSlider1 x10 y24 h220 Center Vertical Range0-127 Invert AltSubmit", 0)
Slider1.Lbl := mainGui.AddText("w41 Center Border", "0")
Slider1.OnEvent("Change", Slider_Change)

; Create Slider 2 (Vertical)
mainGui.AddText("x60 y10 w41 Center", "CC #9")	; Text Label
Slider2 := mainGui.AddSlider("vSlider2 x60 y24 h220 Center Vertical Range0-127 AltSubmit", 127)
Slider2.Lbl := mainGui.AddText("w41 Center Border", "127")
Slider2.OnEvent("Change", Slider_Change)

; Create Slider 3 (Horizontal)
mainGui.AddText("x10 y284 w41 Center", "CC #7")	; Text Label
Slider3 := mainGui.AddSlider("vSlider3 x10 y300 w220 Center Range0-127 AltSubmit", 0)
Slider3.Lbl := mainGui.AddText("w41 Center Border", "0")
Slider3.OnEvent("Change", Slider_Change)

; Create Program Change buttons
; Create a text label showing the current Program number
mainGui.AddText("x130 y10", "Program: ")	; Text Label
TextPGNumber := mainGui.AddText("x180 y10 w28 Center Border", "0")	; Program Number
ButtonPCPrev := mainGui.AddButton("x130 y30 w80", "Prev`nProgram")
ButtonPCPrev.OnEvent("Click", PC_Prev)
ButtonPCNext := mainGui.AddButton("x130 y70 w80", "Next`nProgram")
ButtonPCNext.OnEvent("Click", PC_Next)

; Create Note On/Off buttons
ButtonNoteOn60 := mainGui.AddButton("x130 y150 w80", "Note 60`nOn")
ButtonNoteOn60.OnEvent("Click", NoteOn60)
ButtonNoteOff60 := mainGui.AddButton("x130 y190 w80", "Note 60`nOff")
ButtonNoteOff60.OnEvent("Click", NoteOff60)

mainGUI.OnEvent("Close", Gui_Close)	; Event when the main Gui window closes
mainGUI.Show("w240 h380")	; Show the Gui window

; Callback for the sliders Change events
Slider_Change(obj, info) {
	; Send MIDI CC
	Switch obj.Name {
		Case "Slider1":
			MIDI.SendControlChange(1, obj.Value)
		Case "Slider2":
			MIDI.SendControlChange(9, obj.Value)
		Case "Slider3":
			MIDI.SendControlChange(7, obj.Value)
	}
	; Update text label
	obj.Lbl.Text := obj.Value
}

ProgramNumber := 0	; Global variable
PC_Prev(obj, info) {
	Global ProgramNumber	; Reference the global variable
	ProgramNumber := Min(Max(--ProgramNumber, 0), 127)	; Make sure the value stays within the 0-127 range
	MIDI.SendProgramChange(ProgramNumber)	; Send a Program Change message on the open MIDI Out port (default MIDI Channel)
	TextPGNumber.Text := ProgramNumber	; Update the text label
}

PC_Next(obj, info) {
	Global ProgramNumber
	ProgramNumber := Min(Max(++ProgramNumber, 0), 127)
	MIDI.SendProgramChange(ProgramNumber)
	TextPGNumber.Text := ProgramNumber
}

NoteOn60(obj, info) {
	MIDI.SendNoteOn(60)	; Send MIDI Note On 60 on the default MIDI Channel
	ButtonNoteOn60.Opt("+BackgroundF00000 +CF00000")	; Update the button background color (frame)
	ButtonNoteOn60.Redraw()	; Force a re-draw of the button
}

NoteOff60(obj, info) {
	MIDI.SendNoteOff(60)
	ButtonNoteOn60.Opt("-Background +CDefault")
	ButtonNoteOn60.Redraw()
}

; GUI Menu methods --------------------------
Gui_Close(*) {
	MIDI.closeMidiIn
	MIDI.closeMidiOut
	ExitApp
}

; Open a MIDI In port
setInputPort(port, pos, obj) {
	Loop midiInputs.Length
		inputMenu.Uncheck(A_Index "&")
	inputMenu.Check(port)
	MIDI.closeMidiIn()
	MIDI.openMidiIn(pos - 1)
}

; Open a MIDI Out port
setOutputPort(port, pos, obj) {
	Loop midiOutputs.Length
		outputMenu.Uncheck(A_Index "&")
	outputMenu.Check(port)
	MIDI.closeMidiOut()
	MIDI.openMidiOut(pos - 1)
}

; Set a MIDI Input channel filter
setInputChannel(ch, pos, obj) {
	Loop 17
		chInMenu.Uncheck(A_Index "&")
	chInMenu.Check(ch)
	MIDI.inputChannel := pos - 1
}

; Set the default MIDI Output channel
setOutputChannel(ch, pos, obj) {
	Loop 16
		chOutMenu.Uncheck(A_Index "&")
	chOutMenu.Check(ch)
	MIDI.outputChannel := pos
}

; MIDI Input callbacks
MidiInControlChange1(event) {
	Slider1.Value := event.Value
	Slider1.Lbl.Text := event.Value
}

MidiInControlChange9(event) {
	Slider2.Value := event.Value
	Slider2.Lbl.Text := event.Value
}

MidiInControlChange7(event) {
	Slider3.Value := event.Value
	Slider3.Lbl.Text := event.Value
}

MidiInNoteOn60(event) {
	ButtonNoteOn60.Opt("+BackgroundF00000 +CF00000")
	ButtonNoteOn60.Redraw()
}

MidiInNoteOff60(event) {
	ButtonNoteOn60.Opt("-Background +CDefault")
	ButtonNoteOn60.Redraw()
}