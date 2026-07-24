/*

MMC
Send and receive MMC commands and MIDI Time Code
(Double click the Time Code to set)

*/

#SingleInstance force
#Requires AutoHotkey >=2.0
#Include <MIDIv2>

MIDI := MIDIv2()	; Create an instance of the MidiV2 class
MIDI.TC_Enabled := True
MIDI.MMC_Enabled := True

; Open a MIDI In and a MIDI Out port
myInputName := "MIDI In"		; Change this to the name of your MIDI In port
myOutputName := "MIDI Out"		; Change this to the name of your MIDI Out port
myInputID := GetInputDeviceByName(myInputName)
myOutputID := GetOutputDeviceByName(myOutputName)
MIDI.openMidiIn(myInputID)
MIDI.OpenMidiOut(myOutputID)

; Create GUI
MMCGui := Gui()

; Create transport buttons
MMCGui.SetFont("S14", "Consolas")	; Set font for subsequent text objects
btnRew := MMCGui.AddButton("w30 h30 x10 y80 Border", "◄◄")

btnStop := MMCGui.AddButton("w30 h30 x+5 y80 Border", "■")
btnStop.OnEvent("Click", Stop_Click)

MMCGui.SetFont("S20", "Consolas")
btnPlay := MMCGui.AddButton("w30 h30 x+5 y80 Border", "►")
btnPlay.OnEvent("Click", Play_Click)

btnRec := MMCGui.AddButton("w30 h30 x+5 y80 Border", "●")
btnRec.OnEvent("Click", Rec_Click)

MMCGui.SetFont("S14", "Consolas")
btnFF := MMCGui.AddButton("w30 h30 x+5 y80 Border", "►►")

; Create a text object to show the Time Code
TC := MMCGui.AddText("Center Border w130 x30 y30" , "00:00:00:00")
TC.OnEvent("DoubleClick", TC_SetTime)	; Double click to set a new Time Code value. See "TC_SetTime" method further down.

; Create TC input GUI as a separate window
TCGui := Gui()
MMCGui.SetFont("S14", "Consolas")
TChh := TCGui.AddEdit("w26 r1 x10 y10 Limit2 Center")
TCGui.AddText("x+2.5 y10", ":")
TCmm := TCGui.AddEdit("w26 r1 x+2.5 y10 Limit2 Number Center")
TCGui.AddText("x+2.5 y10", ":")
TCss := TCGui.AddEdit("w26 r1 x+2.5 y10 Limit2 Number Center")
TCGui.AddText("x+2.5 y10", ":")
TCff := TCGui.AddEdit("w26 r1 x+2.5 y10 Limit2 Number Center")
TCSet := TCGui.AddButton("x15 y40 w50", "Set")
TCSet.OnEvent("Click", TCSet_Click)
TCCancel := TCGui.AddButton("x80 y40 w50", "Cancel")
TCCancel.OnEvent("Click", TCCancel_Click)

; Show the GUI
MMCGui.Show("w190")
TC.Focus()

MIDI.MMC_enabled := True	; Enable support for MMC
MIDI.MMC_requestTimeCode()	; Request the current Time Code

; Event handlers for left mouse button
; These are used for the Rew and FF buttons
; to allow them to be held down
OnMessage(0x201, HandleEvent)  ; WM_LBUTTONDOWN
OnMessage(0x202, HandleEvent)  ; WM_LBUTTONUP
HandleEvent(wParam, lParam, msg, hwnd) {
   global btnRew, btnFF
	
   if (msg = 0x201 or msg = 0x202) {		
      if hwnd = btnRew.hwnd {
         state := CheckState(hwnd)
			if state
				MIDI.MMC_Rewind()
			else {
				MIDI.MMC_Stop()
				TC.Focus()
			}
      }
		else if hwnd = btnFF.hwnd {
         state := CheckState(hwnd)
			if state
				MIDI.MMC_FF()
			else {
				MIDI.MMC_Stop()
				TC.Focus()
			}
      }
   }   
}

; Helper function to check if mouse button is pressed or released
CheckState(hwnd) {
   state := DllCall("SendMessage", "Ptr", hwnd, "UInt", 0xF2, "Ptr", 0, "Ptr", 0)
	return !(state & 0x20) > 0
}

; Play button
Play_Click(o, i) {
	TC.Focus()
	MIDI.MMC_Play()
}

; Stop button
Stop_Click(o, i) {
	TC.Focus()
	MIDI.MMC_Stop()
}

; Rec button
Rec_Click(o, i) {
	TC.Focus()
	MIDI.MMC_Record()	
}

; Populate the Time Code to the Edit controls
TC_SetTime(o, i) {
	TChh.Text := SubStr(TC.Text, 1, 2)
	TCmm.Text := SubStr(TC.Text, 4, 2)
	TCss.Text := SubStr(TC.Text, 7, 2)
	TCff.Text := SubStr(TC.Text, 10, 2)
	TCGui.Show()
}

; Send new Time Code
TCSet_Click(o, i) {
	timeCode := TChh.Text . ":" . TCmm.Text . ":" . TCss.Text . ":" . TCff.Text
	MIDI.MMC_Locate(timeCode)
	TCGui.Hide()
}

; Cancel button
TCCancel_Click(o, i) {
	TCGui.Hide()
}

; MIDI Input callbacks --------------------------
MidiInMCR_Stop() {
	TC.Focus()
	btnPlay.Opt("+BackgroundDefault")
	btnRec.Opt("+BackgroundDefault")
	btnPlay.Redraw()
	btnRec.Redraw()
}

MidiInMCR_Play() {
	TC.Focus()
	btnPlay.Opt("+Background00FF00")
	btnPlay.Redraw()
}

MidiInMCR_RecordOn() {
	TC.Focus()
	btnRec.Opt("+BackgroundFF0000")
	btnRec.Redraw()
}

MidiInMCR_RecordOff() {
	TC.Focus()
	btnRec.Opt("+BackgroundDefault")
	btnRec.Redraw()
}

MidiInTC_RunningFull(e) {
	h := Format("{:02i}", e.hours)
	m := Format("{:02i}", e.minutes)
	s := Format("{:02i}", e.seconds)
	f := Format("{:02i}", e.frames)
	Global FrameRateCode := e.frameRateCode
	TC.Text := h . ":" . m . ":" . s . ":" . f
}

MidiInTC_Full(e) {
	h := Format("{:02i}", e.hours)
	m := Format("{:02i}", e.minutes)
	s := Format("{:02i}", e.seconds)
	f := Format("{:02i}", e.frames)
	Global FrameRateCode := e.frameRateCode
	TC.Text := h . ":" . m . ":" . s . ":" . f
}

GetInputDeviceByName(name) {
	devices := MIDI.GetMidiInDevices()
	Loop devices.Length
		if devices[A_Index] = name
			return A_Index - 1
	MsgBox("Input device: " name " is not available.")
	ExitApp
}

GetOutputDeviceByName(name) {
	devices := MIDI.GetMidiOutDevices()
	Loop devices.Length
		if devices[A_Index] = name
			return A_Index - 1
	MsgBox("Output device: " name " is not available.")
	ExitApp
}