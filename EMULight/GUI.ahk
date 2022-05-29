;=============================================================================== GUI functions =============================================================================

; Draws TEXT at X, Y in the WINDOW using the s9 white Tahoma before chaning it back to s9 Black Verdana for Gui Edits 
addText(xCoor,yCoor,text, Window :=""){
	gui, %Window%font, % dpi("s9 cWhite"), Tahoma
	gui, %Window%add, text, % dpi(xCoor . " " . yCoor), %text%
	Gui, %Window%font, % dpi("s9 cBlack"), verdana
}

	; =========================================== REBINDS ===================================================
DrawRebinds(){
	global
	Gui, Rebinds:new,, Rebinds
	Gui, Rebinds:-DPIScale
	Gui, Rebinds:Color, 0x404040
	gui, Rebinds:font, % dpi("s7 cWhite"), Tahoma
	gui, Rebinds:add, text, % dpi("x338 y42"), Visible to ER
	gui, Rebinds:font, % dpi("s20 cWhite"), Tahoma
	gui, Rebinds:add, text, % dpi("x30 y20"), Rebinds:
	Loop 9 {
		addText("x30","yp40",%A_Index% . "Rebind", "Rebinds:")
		Gui, Rebinds:Add, Edit, % dpi("x+20 yp0 w100 h20 vreSource" . A_Index), 
		addText("x+20","yp0","as", "Rebinds:")
		Gui, Rebinds:Add, Edit, % dpi("x+20 yp0 w100 h20 vreTarget" . A_Index), 
		Gui, Rebinds:Add, checkbox, % dpi("x+20 yp0 w200 h20 vreSentSourceToGame" . A_Index),
	}
	gui, Rebinds:font, % dpi("s20 cWhite"), Tahoma
	gui, Rebinds:add, text, % dpi("x30 y+20"), Toggles:
	Loop 3 {
		addText("x30","yp40",%A_Index% . "Toggle", "Rebinds:")
		Gui, Rebinds:Add, Edit, % dpi("x+20 yp0 w100 h20 vreToggled" . A_Index), 
		addText("x+20","yp0","with", "Rebinds:")
		Gui, Rebinds:Add, Edit, % dpi("x+20 yp0 w100 h20 vreToggler" . A_Index), 
	}
	Gui, Rebinds:Add,Button, % dpi("x175 y+25 w100 h30 Default gSubmitGUI"), OK
}

	; =========================================== ADVANCED SETTINGS ===================================================
DrawAdvancedSettings(){
	global
	Gui, ADVSET:new,, ADVSET
	Gui, ADVSET:-DPIScale
	Gui, ADVSET:Color, 0x100f0b
	gui, ADVSET:font, % dpi("s16 cWhite"), Tahoma
	gui, ADVSET:add, text, % dpi("x30 y30"), ADVANCED SETTINGS:
	gui, ADVSET:font, % dpi("s12 cWhite"), Tahoma
	gui, ADVSET:add, text, % dpi("x30 y+20"), Controls: 
	addText("x30","yp27","Enable backstep on sprint button press", "ADVSET:")
	Gui, ADVSET:Add, checkbox, % dpi("x470 yp0 w20 h20 vADVSETbackstep"),  									;Allow backstep on sprint
	addText("x30","yp27","Track menus to prevent changing spells/items (hold escape to reset)", "ADVSET:")
	Gui, ADVSET:Add, checkbox, % dpi("x470 yp0 w20 h20 vADVSETenableMenu"),  									;Enable menu tracking
	
	; backgroung image
	Gui, Add, Picture, % dpi("x20 y+1 w537 h137 HwndAttackPic") 
	Imagen("_images\EMUlight_attackcooldown.png", "Background100f0b ahk_id" . AttackPic . " Upscale")
	Gui, font, % dpi("s9"), verdana
	Gui, ADVSET:Add, checkbox, % dpi("x20 yp18 w13 h13 vADVSETenableAttackCooldown gToggleGUIElements"), 
	Gui, ADVSET:Add, Edit, % dpi("x160 yp-2 w100 h19 vADVSETAttackCooldown Lowercase -Wrap -VScroll "), 300 				;Attack cooldown
	Gui, ADVSET:Add, checkbox, % dpi("x38 yp34 w13 h13 vADVSETenableR1Cooldown gToggleGUIElements"), 1
	Gui, ADVSET:Add, checkbox, % dpi("x38 yp28 w13 h13 vADVSETenableL1Cooldown gToggleGUIElements"), 0
	
	gui, ADVSET:font, % dpi("s12 cWhite"), Tahoma
	gui, ADVSET:add, text, % dpi("x30 y+50"), Backup:
	addText("x30","y+5","How many save backups should be saved", "ADVSET:")
	Gui, ADVSET:Add, Edit, % dpi("x470 yp0 w100 h20 vADVSETmaxbackups"), 8									;Maximum number of backups
	addText("x30","y+5","Directory in which save backups are stored", "ADVSET:")
	Gui, ADVSET:Add, Edit, % dpi("x470 yp0 w100 h20 vADVSETtargetbackup"), 									;Overwrite Save backup directory
	addText("x30","y+5","Create a hotkey for manual save backup", "ADVSET:")
	Gui, ADVSET:Add, Edit, % dpi("x470 yp0 w100 h20 vADVSEThotkeybackup"),  									;Backup hotkey
	addText("x30","y+5","Specify name convention for backups", "ADVSET:")
	Gui, ADVSET:Add, Edit, % dpi("x470 yp0 w100 h20 vADVSETnamebackups"), yyyy-MM-dd							;Backup naming convention
	gui, ADVSET:font, % dpi("s12 cWhite"), Tahoma
	gui, ADVSET:add, text, % dpi("x30 y+20"), Launch Options:
	gui, ADVSET:font, % dpi("s9 cWhite"), Tahoma
	addText("x30","y+5","Enable EMUL to work with all open windows", "ADVSET:")
	Gui, ADVSET:Add, checkbox, % dpi("x470 yp0 w20 h20 vADVSETWindowEnable"), 								;Enable EMUL to work in all open window
	addText("x30","y+5","Scale EMU Light GUI factor (Save and restart)", "ADVSET:")
	Gui, ADVSET:Add, Edit, % dpi("x470 yp0 w100 h20 vADVSETWindowScale"),  1.0								;EMU Light scalling factor
	Gui, ADVSET:Add,Button, % dpi("x250 y+25 w100 h30 Default gSubmitGUI"), OK

}

; =========================================== PAUSED ===================================================

createPausedGUI(){
	Gui, paused:New, -Caption -Border -DPIScale +AlwaysOnTop
	Gui, paused:Color, 0f1010
	Gui, paused:Add, Picture, % dpi("x0 y0 w600 h200 HwndpausePic")
	Imagen("_images\EMULight4ER_paused.jpg", "Background0f1010 Fadein000ms ahk_id" . pausePic . " Upscale")
}

showPausedGUI(showGUI){
	if (showGUI)
		Gui, paused:Show, % dpi("w600 h200 NoActivate")
	else
		Gui, paused:Hide
}

; =========================================== VERSION CHECK ===================================================

DrawVersionCheck(){
	global EMUversion,OnlineVersion
	if (OnlineVersion && (EMUVersion < OnlineVersion)) {
		Gui, Add, Picture, % dpi("x880 y0 w95 h103 gShowDownloadPage HwndupdatePic") 
		Imagen("_images\EMULight_update_available.png", "Upscale ahk_id" . updatePic)
	}
}

ShowDownloadPage(){
	run, https://www.nexusmods.com/eldenring/mods/31?tab=files
}

; =========================================================== Draw GUI ================================================================================

; Draw one Controller button's edits and their borders
addControllerEdits(x1,y1,x2,y2,name,basicAction,eventAction,switchAction,switchEventAction){
	global
	; Creates the edits
	Gui, Add, Edit, % dpi(x1 . " " . 	y1 " 	w55 	h20 	vZGUI" . name . " 				-VScroll Lowercase -Wrap"), %basicAction%	
	Gui, Add, Edit, % dpi("xp58 		yp0 	w30 	h20 	vZGUI" . name . "Event 			-VScroll Lowercase -Wrap"), %eventAction%	
	Gui, Add, Edit, % dpi(x2 . " " .	y2 " 	w55 	h20 	vZGUI" . name . "Switch 		-VScroll Lowercase -Wrap"), %switchAction%					
	Gui, Add, Edit, % dpi("xp58 		yp0 	w30 	h20 	vZGUI" . name . "EventSwitch 	-VScroll Lowercase -Wrap"), %switchEventAction%

	; Moves and draws borders 
	local editsToParse := "Event,Switch,EventSwitch"
	Loop, parse, editsToParse, `,
	{
		local coords := getEditCoordinates("ZGUI" . name . A_LoopField, 5, 5)
		local imgName := "img" . name . "" . A_LoopField
		GuiControl, Move, % %imgName%, % coords	
		Imagen("_images\controller" . A_LoopField . "EditBG.png", "Zoom ahk_id" . %imgName%)
	}
}

; Returns absolute x y coordinations of gui element with specified border 
getEditCoordinates(name, leftBorder, topBorder){
	local
	GuiControlGet, %name% , Pos
	return "x" . %name%X - leftBorder . " y" . %name%Y - topBorder 
}

; Predraws empty borders for all controller edits outside of the GUI
AddControlEditsBGs(){
	global
	Loop, 16 {
		Gui, Add, Picture, % dpi("x-300 y-300 w40 h30 hwndimgController" . A_Index . "Event") 
		Gui, Add, Picture, % dpi("x-300 y-300 w65 h30 hwndimgController" . A_Index . "Switch") 
		Gui, Add, Picture, % dpi("x-300 y-300 w40 h30 hwndimgController" . A_Index . "EventSwitch")
	}
	Gui, Add, Picture, % dpi("x-300 y-300 w61 h35 hwndimgControllerEventBG") 
	Gui, Add, Picture, % dpi("x-300 y-300 w61 h35 hwndimgControllerSwitchBG") 
	
}

; Predraws all the GUI windows and displays the main window. If resolution is under 900p, the EMUL logo is omitted. 
DrawGUI(){
	global
	DrawRebinds()
	DrawAdvancedSettings()	
	createPausedGUI()

	; =========================================== EMU GUI ===================================================
	;OnMessage(0x112, "WM_SYSCOMMAND")
	Gui, EMU:new,, EMU
	Gui, -DPIScale ;+resize
	Menu, Tray, Icon, %A_ScriptDir%\_images\icons\emu.ico,,  									;tray icon/menu
	; Top menu
	Menu, Profilemenu, Add, &Open`tCtrl+O, OpenHotkeys 
	Menu, Profilemenu, Add, &Save`tCtrl+S, SaveHotkeys 
	Menu, Profilemenu, Add, &Save as, SaveAsHotkeys 
	Menu, RebindsMenu, add, &Rebinds/Toggles, getRebinds
	Menu, Advancedsettings, add, &Advanced Settings, getADVSET
	Menu, HelpMenu, add, &Help, helpme
	Menu, HelpMenu, add, &Version, getVersion
	Menu, MyMenuBar, Add, &Profiles, :Profilemenu  													;Attach the two sub-menus that were created above.
	Menu, MyMenuBar, Add, &Advanced Settings, :Advancedsettings
	Menu, MyMenuBar, Add, &Rebinds/Toggles, :RebindsMenu
	Menu, MyMenuBar, Add, &Help, :HelpMenu
	Gui, Menu, MyMenuBar
	Gui, Add, StatusBar,, Ready. 																		; Status bar

	; =========================================== MAIN WINDOW ===================================================

	; Window constants
	GUI_MAIN_WINDOW_WIDTH:= 1395																	;The main window witdh
	GUI_MAIN_WINDOW_HEIGHT := 739
	GUI_MAIN_BUTTON_Y:=GUI_MAIN_WINDOW_HEIGHT - 33
	GUI_MAIN_RESTART_BUTTON_X:=GUI_MAIN_WINDOW_WIDTH - 120
	; backgroung image
	Gui, Add, Picture, % dpi("x0 y0 w" . GUI_MAIN_WINDOW_WIDTH . " h" . GUI_MAIN_WINDOW_HEIGHT . " HwndhPic") 
	Imagen("_images\EMUlight_background.jpg", "ahk_id" . hPic . " Upscale")
	DrawVersionCheck()
	; =========================================== LEFT SIDE ===================================================
	Gui, Color, 0xc7c7c7
	Gui, font, % dpi("s9"), verdana
	; Roll And Sprint
	Gui, Add, Picture, 	% dpi("x19 y177 w162 h56 vdisableSprint HwndTPic") 
	Imagen("_images\EMUlight_disableSprint.jpg", "ahk_id" . TPic . " Upscale")
	GuiControl, Move, disableSprint, y-300
	Gui, Add, Picture, 	% dpi("x1079 y155 w126 h75 vAutoHideBG HwndCPic") 
	Imagen("_images\EMUlight_AutoHideOn.jpg", "ahk_id" . CPic . " Upscale")
	GuiControl, Move, AutoHideBG, y-300	
	Gui, Add, DropDownList, % dpi("xp330 	y105 	w39 	h600 	vsystemRoll 							r26 sort 					"), a|b|c|d|e|f|h|i|j|k|l|m|n|o||p|q|r|s|t|u|v|w|x|y|z|
	Gui, add, Checkbox, 	% dpi("x5 		yp52 	w13 	h13 	vEnableRoll 		gToggleGUIElements								")			;Toggle state of Roll GUI elements
	Gui, add, Checkbox, 	% dpi("x23 		yp40 	w12 	h12  	vSplitRollASprint 	gToggleGUIElements 	Checked						")
	Gui, Add, Edit, 		% dpi("x202 	yp-14	w100 	h19 	vPlayerRoll 		gToggleGUIElements 	Lowercase -Wrap -VScroll 	"), space 	;Roll
	Gui, add, Checkbox, 	% dpi("x23 		yp41 	w12 	h12 	vEnableSprintToggle													"), 0
	Gui, Add, Edit, 		% dpi("x202 	yp-14	w100 	h19 	vPlayerSprint 							Lowercase -Wrap -VScroll 	"), lshift 	;Sprint
	Gui, Add, Edit, 		% dpi("x202 	yp27 	w100 	h19 	vRollCooldown 							Lowercase -Wrap -VScroll 	"), 300 	;Roll cooldown

	; Pouch		
	Gui, Add, checkbox, 	% dpi("x5 		y+29 	w13 	h13 	vEnablePouch 		gToggleGUIElements								"), 0		;Toggle state of Roll GUI elements
	Gui, Add, Edit, 		% dpi("x202 	yp24 	w100 	h19 	vPlayerPouch1 							Lowercase -Wrap -VScroll 	"), c		;Player Pouch Item 1
	Gui, Add, Edit, 		% dpi("x202 	yp27 	w100 	h19 	vPlayerPouch2 							Lowercase -Wrap -VScroll 	"), v 		;Player Pouch Item 2
	Gui, Add, Edit, 		% dpi("x202 	yp27 	w100 	h19 	vPlayerPouch3 							Lowercase -Wrap -VScroll 	"), b 		;Player Pouch Item 3
	Gui, Add, Edit, 		% dpi("x202 	yp27 	w100 	h19 	vPlayerPouch4 							Lowercase -Wrap -VScroll 	"), n 		;Player Pouch Item 4
	Gui, Add, Edit, 		% dpi("x202 	yp27 	w100 	h19 	vPlayerPouch5 							Lowercase -Wrap -VScroll 	"),  		;Player Pouch Item 5
	Gui, Add, Edit, 		% dpi("x202 	yp27 	w100 	h19 	vPlayerPouch6 							Lowercase -Wrap -VScroll 	"),  		;Player Pouch Item 6

	; Miscellaneous		
	Gui, Add, checkbox, 	% dpi("x5 		y+22 	w13 	h13 	vEnableMiscellaneous gToggleGUIElements								"), 0		;Toggle state of Roll GUI elements
	Gui, Add, Edit, 		% dpi("x202 	y+9 	w100 	h19 	vPlayerTwoHand 							Lowercase -Wrap -VScroll 	"), lalt 	;Player Two handing
	Gui, Add, Edit, 		% dpi("x202 	yp27 	w100 	h19 	vPlayerOffHandTwoHand 					Lowercase -Wrap -VScroll 	"), u		;Player offhand Two handing
	Gui, Add, Edit, 		% dpi("x202 	yp27 	w100 	h19 	vPlayerMap 								Lowercase -Wrap -VScroll 	"), m 		;Player Map
	Gui, Add, Edit, 		% dpi("x202 	yp27 	w100 	h19 	vPlayerPauseGame 						Lowercase -Wrap -VScroll 	"), pause 	;Player pause key
	Gui, add, Checkbox, 	% dpi("x23 		yp14 	w12 	h12 	 					gToggleGUIElements Checked vborderlessWindow	")
	Gui, Add, Edit, 		% dpi("x202 	yp13 	w100 	h19 	vPlayerPreviousQCslot 					Lowercase -Wrap -VScroll 	"),  		;Player previous spell
	Gui, Add, Edit, 		% dpi("x202 	yp27 	w100 	h19 	vPlayerPreviousQIslot 					Lowercase -Wrap -VScroll 	"),  		;Player previous item

	; =========================================== CENTER ===================================================
	Gui, font, % dpi("s8"), verdana
	AddControlEditsBGs()

	; Quick cast
	Gui, Add, checkbox, 	% dpi("x354		y149 	w13 	h13 	vEnableQC 			gToggleGUIElements")			;Toggle state of Quickcast GUI elements
	Loop 12	{
		if (A_Index = 1)
			Gui, Add, Edit, % dpi("x+5 		yp26 	w24 	h24 	vPlayerQC" . A_Index . " 				center Lowercase -Wrap -VScroll 	"), %A_Index%
		else if (A_Index = 11)
			Gui, Add, Edit, % dpi("x+5 		yp0 	w24 	h24 	vPlayerQC" . A_Index . " 				center Lowercase -Wrap -VScroll 	"), -
		else if (A_Index = 12)
			Gui, Add, Edit, % dpi("x+5 		yp0 	w24 	h24 	vPlayerQC" . A_Index . " 				center Lowercase -Wrap -VScroll 	"), =
		else{
			Gui, Add, Edit, % dpi("x+5 		yp0 	w24 	h24 	vPlayerQC" . A_Index . " 				center Lowercase -Wrap -VScroll 	"), % mod(A_Index,10)
		}
	}
	Gui, Add, checkbox, 	% dpi("x550 	yp31 	w13 	h13 	vEnableQCCastkeys 	gToggleGUIElements										")			;Toggle state of individual QC casting keys
	; Alternate cast keys
	Loop 12	{
		if (A_Index = 1)
			Gui, Add, Edit, % dpi("x374 	yp18 	w24 	h24 	 vPlayerQCCastKey" . A_Index . " 		disabled Lowercase -Wrap -VScroll 	"),
		else if (A_Index = 9)
			Gui, Add, Edit, % dpi("x+5 		yp0 	w24 	h24 	 vPlayerQCCastKey" . A_Index . " 		disabled Lowercase -Wrap -VScroll 	"),lbutton
		else
			Gui, Add, Edit, % dpi("x+5 		yp0 	w24 	h24 	 vPlayerQCCastKey" . A_Index . " 		disabled Lowercase -Wrap -VScroll 	"),
	}	
	; Attuned spells
	Gui, font, % dpi("s8"), verdana
	Gui, Add, Edit, 		% dpi("x782 	y150 	w17 	h17		vplayerChangeAttunement 				center Lowercase limit1				"), m																
	Gui, font, % dpi("s9"), verdana
	Gui, Add, dropdownlist, % dpi("x930 	yp-7 	w103 	h20		vmaximumQCSlots 						r12									"), 1|2|3||4|5|6|7|8|9|10|11|12
	Gui, Add, Edit, 		% dpi("xp0 		yp42 	w103 	h20		vPlayerUseQC 							-VScroll Lowercase -Wrap			"), rbutton 					;Global cast key

	; Quick Items
	Gui, Add, checkbox, 	% dpi("x354 	y275 	w13 	h13		vEnableQI 			gToggleGUIElements										")			;Toggle state of Quick Items GUI elements
	Gui, font, % dpi("s8"), verdana
	Gui, Add, Edit, 		% dpi("x782 	yp9 	w17 	h17		vplayerChangeItem 						center Lowercase limit1				"), i
	Gui, Add, dropdownlist, % dpi("x930 	yp-4 	w103 	h20 	vmaximumQISlots 						r10									"), 1|2|3|4|5||6|7|8|9|10|
	Loop 10	{
		if (A_Index = 1)
			Gui, Add, Edit, % dpi("x374 	yp18 	w30 	h30		vPlayerQI" . A_Index . " 				-VScroll Lowercase -Wrap 			"),
		else
			Gui, Add, Edit, % dpi("x+5 		yp0 	w30 	h30 	vPlayerQI" . A_Index . " 				-VScroll Lowercase -Wrap 			"),
	}	
	Gui, Add, Edit, 		% dpi("x930 	yp7 	w103 	h20		vPlayerUseQI 							-VScroll Lowercase -Wrap			"), r 					;Global cast key

	; Controler	
	Gui, font, % dpi("s8"), verdana
	Gui, Add, checkbox, % dpi("x354 yp51 w13 h13 vEnableController gToggleGUIElements")			;Toggle state of controller GUI elements
	Gui, Add, dropdownlist, % dpi("x+120 yp-5 w310 h20 r2 AltSubmit gToggleGUIElements vControllerInputType"), XInput - XBox, Playstation, Modern Controllers||DirectInput - Older Generic Controllers  
	Gui, font, % dpi("s8"), verdana	
	; Shoulder buttons
	addControllerEdits("x396",		"yp37",		"x+22",		"yp0",	"Controller7",	"+rbutton",	"b",	"4",	"")						;7 (L2)
	addControllerEdits("x+207",		"yp0",		"x+22",		"yp0",	"Controller8",	"+lbutton",	"n",	"2",	"")						;8 (R2)
	addControllerEdits("xp-572",	"yp43",		"x+22",		"yp0",	"Controller5",	"rbutton",	"u",	"3",	"")						;5 (L1)
	addControllerEdits("x+207",		"yp0",		"x+22",		"yp0",	"Controller6",	"lbutton",	"lalt",	"1",	"")						;6 (R1)
	; Select / start		
	addControllerEdits("xp-365",	"yp13",		"xp-58",	"yp40",	"Controller9",	"",			"",		"",		"")						;9 (select)
	addControllerEdits("x+14",		"yp-40",	"xp-58",	"yp40",	"Controller10",	"",			"",		"",		"")						;10 (start)
	; DPAD					
	addControllerEdits("xp-312",	"yp-20",	"xp-58",	"yp30",	"Controller13",	"",			"",		"",		"")						;Up 
	addControllerEdits("xp-142",	"y+20",		"xp-58",	"yp30",	"Controller15",	"",			"",		"",		"")						;left 
	addControllerEdits("x+79",		"yp-30",	"xp-58",	"yp30",	"Controller16",	"",			"",		"",		"")						;right
	addControllerEdits("xp-141",	"y+20",		"xp-58",	"yp30",	"Controller14",	"",			"",		"",		"")						;down 
	; Face buttons				
	addControllerEdits("x+316",		"yp-170",	"xp-58",	"yp30",	"Controller4",	"",			"",		"",		"")						;4 (Triangle) 
	addControllerEdits("xp-146",	"y+20",		"xp-58",	"yp30",	"Controller3",	"lshift",	"",		"x",	"")						;3 (Square)
	addControllerEdits("x+85",		"yp-30",	"xp-58",	"yp30",	"Controller2",	"",			"v",	"",		"")						;2 (Circle)
	addControllerEdits("xp-146",	"y+20",		"xp-58",	"yp30",	"Controller1",	"space",	"",		"f",	"")						;1 (X) 
	; Joysticks	
	addControllerEdits("xp-322",	"yp-20",	"xp-58",	"yp44",	"Controller11",	"",			"",		"",		"")						;11 (L3)
	addControllerEdits("x+60",		"yp-44",	"xp-58",	"yp44",	"Controller12",	"",			"",		"",		"")						;12 (R3)

	Gui, Add, Button, 		% dpi("x608 	yp-258 	w130 	h23 	vDetController				gDetectController 					"), Detect Controller
	Gui, Add, dropdownlist, % dpi("xp128 	yp+1 	w48 	h600 	vjoystick 					gToggleGUIElements r16				"), 1||2|3|4|5|6|7|8|9|10|11|12|13|14|15|16
	Gui, Add, dropdownlist, % dpi("x641 	yp145 	w55 	h20  	vSystemSwitchButton 		gToggleGUIElements r18 AltSubmit	"), None|joy1|joy2|joy3|joy4|joy5|joy6|joy7|joy8|joy9|joy10|joy11||joy12
	GuiControl, Move, %imgControllerSwitchBG%, % getEditCoordinates("SystemSwitchButton", 3, 7)
	Imagen("_images\controllerSwitchEditBG.png", "Zoom ahk_id" . imgControllerSwitchBG)
	Gui, Add, dropdownlist, % dpi("x+5 		yp0 	w55 	h20  	vSystemEventButton 			gToggleGUIElements r18 AltSubmit	"), None|joy1|joy2||joy3|joy4|joy5|joy6|joy7|joy8|joy9|joy10|joy11|joy12
	GuiControl, Move, %imgControllerEventBG%, % getEditCoordinates("SystemEventButton", 3, 7)		
	Imagen("_images\controllerEventEditBG.png", "Zoom ahk_id" . imgControllerEventBG)

	; =========================================== RIGHT SIDE ===================================================
	; Steam Controls
	Gui, Add, Edit, 		% dpi("x1277	y15 	w52 	h19 	vPlayerToggle1 									Lowercase -Wrap -VScroll"), home 			;Steam Toggle
	Gui, Add, Edit, 		% dpi("x1329 	y15 	w52 	h19 	vPlayerToggle2 									Lowercase -Wrap -VScroll"), 				;Discord Toggle
	Gui, Add, Edit, 		% dpi("xp-52 	yp27 	w104 	h19 	vPlayerTrnOn 									Lowercase -Wrap -VScroll"), PgUp 			;Turn ON
	Gui, Add, Edit, 		% dpi("xp0 		yp27 	w104 	h19 	vPlayerTrnOFf 									Lowercase -Wrap -VScroll"), PgDn 			;Turn Off
	Gui, Add, Edit, 		% dpi("xp60 	y106 	w30 	h19 	vSystemMinimumKeyPressDuration 					Lowercase -Wrap -VScroll"), 23 	
	
	; Controls
	Gui, font, % dpi("s7"), verdana
	Gui, add, Checkbox, 	% dpi("x1262 	y198 	w12 	h12 	vautoHUDhiding 				gToggleGUIElements							"), 0
	Gui, Add, Edit, 		% dpi("x1102 	y182 	w50 	h19 	vSystemMouseSelectNextQCSlot 					Lowercase -Wrap -VScroll"), 				;System Next Spell keyboard
	Gui, Add, Edit, 		% dpi("xp50 	yp0 	w50 	h19 	vSystemSelectNextQCSlot 	gToggleGUIElements 	Lowercase -Wrap -VScroll"), k				;System Next Spell Mouse
	Gui, Add, Edit, 		% dpi("xp-50 	yp27 	w50 	h19 	vSystemMouseSelectNextQISlot 					Lowercase -Wrap -VScroll"),  				;System Next Item
	Gui, Add, Edit, 		% dpi("xp50 	yp0 	w50 	h19 	vSystemSelectNextQISlot 	gToggleGUIElements 	Lowercase -Wrap -VScroll"), l 				;System Next Item
	Gui, font, % dpi("s9"), verdana
	Gui, Add, Edit, 		% dpi("xp-50 	yp26 	w100 	h19 	vSystemNextRH 									Lowercase -Wrap -VScroll"), Right 			;System Next Right-Hand Armament
	Gui, Add, Edit, 		% dpi("xp0 		yp27 	w100 	h19 	vSystemNextLH 									Lowercase -Wrap -VScroll"), Left 			;System Next LEft-Hand Armament
	Gui, Add, Edit, 		% dpi("xp0 		yp27 	w100 	h19 	vSystemR1 										Lowercase -Wrap -VScroll"), lbutton 		;System R1
	Gui, Add, Edit, 		% dpi("xp0 		yp27 	w100 	h19 	vSystemR2 										Lowercase -Wrap -VScroll"), e 				;System R2
	Gui, Add, Edit, 		% dpi("xp0 		yp27 	w100 	h19 	vSystemL1 										Lowercase -Wrap -VScroll"), rbutton 		;System L1
	Gui, Add, Edit, 		% dpi("xp0 		yp27 	w100 	h19 	vSystemEvent 				gToggleGUIElements 	Lowercase -Wrap -VScroll"), v 				;System Event
	
	; Movement
	Gui, Add, Edit, 		% dpi("x1205 	y+17 	w47 	h47 	vPlayerW 										Lowercase -Wrap -VScroll"), w 				;Forward
	Gui, Add, Edit, 		% dpi("xp-41 	yp50 	w47 	h47 	vPlayerA 										Lowercase -Wrap -VScroll"), a  				;Left
	Gui, Add, Edit, 		% dpi("xp52 	yp0 	w47 	h47 	vPlayerS 										Lowercase -Wrap -VScroll"), s 				;Back
	Gui, Add, Edit, 		% dpi("xp52 	yp0 	w47 	h47 	vPlayerD 										Lowercase -Wrap -VScroll"), d  				;Right	
	
	; =========================================== Bottom Buttons ===================================================
	Gui, font, % dpi("s9"), Verdana
	debugCheck := GUI_MAIN_BUTTON_Y - 22
	Gui, Add, checkbox, 	% dpi("x207 	y" . debugCheck . " 		w13 	h13 	vEnableDebug 			gToggleGUIElements	")						;Debug Checkbox
	Gui, font, % dpi("s9"), Verdana
	Gui, Add, Button, 		% dpi("X20 		Y" . GUI_MAIN_BUTTON_Y . " 	w150 			vActivate 				gEMUButtonActivate	"), Activate  							;Button Activate/Deactivate
	Gui, Add, dropdownlist, % dpi("x+52 	yp0 						w100 	h10  	vDebugMode 	r4 center hwndDebugList			"), KeyHistory||ListVars|ListHotkeys|ListLines
	Gui, Add, Button, 		% dpi("X+80 	yp0 						w100 									gOpenHotkeys		"), Load  											;Button Load
	Gui, Add, Button, 		% dpi("X+20 	yp0 						w100 									gSaveHotkeys		"), Save 												;Button Save
	Gui, Add, Button, 		% dpi("X+20 	yp0 						w100 									gSaveAsHotkeys		"), Save as 										;Button Save as
	Gui, Add, checkbox, 	% dpi("x+22 	yp0 						w13 	h13 	vBackupEnabled 			gToggleGUIElements	")								;Dark Souls saves Backup Checkbox
	Gui, font, % dpi("s6"), Verdana							
	Gui, Add, Button, 		% dpi("x+171 	yp-1						w80 	h15 	vSelectSaveFilePath 	gSelectSaveFilePath	"), Choose Save file 			;Choose Dark Souls saves backup path
	Gui, Add, Edit, 		% dpi("xp-184 	yp16						w265 	h15 	vSavePath"), 												;Dark Souls saves backup path
	Gui, font, % dpi("s9"), Verdana
	Gui, Add, Button, 		% dpi("X" . GUI_MAIN_RESTART_BUTTON_X . " y" . GUI_MAIN_BUTTON_Y . " w100 h24 		gEMUButtonRestart	"), Restart  			;Button Restart
	GuiControl, Focus, Activate 																	;Give Activate button focus
	
	; =========================================== Warning and prompts ===================================================
	; HELP ME
	Gui, font, % dpi("s8 underline cBlue"), Tahoma
	Gui, Add, Text, % dpi("x982 yp-20 gHelpme"), Show help  													;Show help link
	Gui, font, % dpi("s9 norm"), verdana
	
	; CONTROLLER WARNING
	Gui, font, % dpi("s8 cCE5407"), Verdana
	Gui, Add, Text, % dpi("x370 y335 vcontrollerWarning"), Warning: No Controller Detected. Activating EMU Light with Controller enabled may cause a heavy CPU usage
	GuiControl, EMU:Hide, controllerWarning

	; Hotkey Suspension warning
	Gui, font, % dpi("s10 cCE5407"), Verdana
	Gui, Add, Text, % dpi("x550 y108 vsuspendWarning"), Hotkeys Suspended due to Script Control
	GuiControl, EMU:Hide, suspendWarning
	
	; Quickcast/items menu warning
	Gui, font, % dpi("s7 c861d16"), Verdana
	Gui, Add, Text, % dpi("x1220 y172 vQCWarning"), Arrow keys may cause desync
	Gui, Add, Text, % dpi("x1220 y225 vQIWarning"), Arrow keys may cause desync

	; GUI Autohide eventkey warning
	Gui, font, % dpi("s7 c861d16"), Verdana
	Gui, Add, Text, % dpi("x1116 y363 vEventWarning"), "e" with Auto HUD hiding enabled will cause issues

	; Roll hotkey matching ingame roll warning
	Gui, font, % dpi("s7 cCE5407"), Verdana
	Gui, Add, Text, % dpi("x24 y173 vrollWarning"), Cannot match ingame roll key

	Gui, Show, % dpi("w" . GUI_MAIN_WINDOW_WIDTH) , E.M.U.Light (Enhanced Moveset Utility) for Elden Ring

	; Taskbar icon
	hIcon := DllCall("LoadImage", uint, 0, str, A_ScriptDir "\_images\icons\emu.ico"
		, uint, 1, int, 0, int, 0, uint, 0x10)  ; Type, Width, Height, Flags
	Gui +LastFound  ; Set the "last found window" for use in the next lines.
	SendMessage, 0x80, 0, hIcon  ; Set the window's small icon (0x80 is WM_SETICON).
	SendMessage, 0x80, 1, hIcon  ; Set the window's big icon to the same one.
}

; Enable/disable all the controller elements depending on the EnableController variable
ToggleGUIElements(){
	global
	Gui, Submit, NoHide
	Gui, ADVSET:Submit, NoHide
	
	; Advanced settings
	newState := ADVSETenableAttackCooldown ? "enable":"disable"
	GuiControl, ADVSET:%newState%, ADVSETAttackCooldown
	GuiControl, ADVSET:%newState%, ADVSETenableR1Cooldown
	GuiControl, ADVSET:%newState%, ADVSETenableL1Cooldown
	
	; Sprint & Roll
	newState := (PlayerRoll=systemRoll) ? "Show":"Hide"
	GuiControl, %newState%, rollWarning
	newState := enableRoll ? "enable":"disable"
	GuiControl, %newState%, PlayerRoll
	GuiControl, %newState%, RollCooldown
	GuiControl, %newState%, SplitRollASprint
	newState := (enableRoll && SplitRollASprint) ? "enable":"disable"
	GuiControl, %newState%, PlayerSprint
	GuiControl +BackgroundFF9977, PlayerSprint
	GuiControl, %newState%, EnableSprintToggle
	GuiControl, Move, disableSprint, % dpi("y" . (SplitRollASprint?-300:181))	
	GuiControl, Move, AutoHideBG, % dpi("y" . (autoHUDhiding?155:-300))
	
	; Movement
	newState := (enableRoll && SplitRollASprint)? "enable":"disable"
	GuiControl, %newState%, PlayerW
	GuiControl, %newState%, PlayerA
	GuiControl, %newState%, PlayerS
	GuiControl, %newState%, PlayerD
	
	; Pouch
	newState := EnablePouch ? "enable":"disable"
	Loop, 6 {
		GuiControl, %newState%, PlayerPouch%A_Index%
	}
	
	; Miscellaneous
	newState := (EnableMiscellaneous)? "enable":"disable"
	GuiControl, %newState%, PlayerTwoHand
	GuiControl, %newState%, PlayerOffHandTwoHand
	GuiControl, %newState%, PlayerMap
	GuiControl, %newState%, PlayerPauseGame
	GuiControl, %newState%, borderlessWindow
	GuiControl, %newState%, PlayerPreviousQCslot
	GuiControl, %newState%, PlayerPreviousQIslot
	
	; Controls
	newState := (EnableQC || EnablePouch || EnableMiscellaneous) ? "enable":"disable"
	GuiControl, %newState%, SystemSelectNextQCSlot
	newState := (EnableQC || EnableMiscellaneous) ? "enable":"disable"
	GuiControl, %newState%, SystemMouseselectNextQCSlot
	newState := (EnableQI || EnablePouch || EnableMiscellaneous) ? "enable":"disable"
	GuiControl, %newState%, SystemSelectNextQISlot
	newState := (EnableQI || EnableMiscellaneous) ? "enable":"disable"
	GuiControl, %newState%, SystemMouseSelectNextQISlot
	newState := (EnableQC|| EnableQI || EnablePouch || EnableMiscellaneous) ? "enable":"disable"
	GuiControl, %newState%, EnableMenu
	newState := (EnableQC && (SystemSelectNextQCSlot = "up" || SystemSelectNextQCSlot = "down")) ? "Show":"Hide"
	GuiControl, %newState%, QCWarning
	newState := (EnableQI  && (SystemSelectNextQISlot = "up" || SystemSelectNextQISlot = "down")) ? "Show":"Hide"
	GuiControl, %newState%, QIWarning
	newState := (EnablePouch)? "enable":"disable"
	GuiControl, %newState%, SystemNextRH
	GuiControl, %newState%, SystemNextLH
	newState := (EnableMiscellaneous)? "enable":"disable"
	GuiControl, %newState%, SystemR1
	GuiControl, %newState%, SystemL1
	newState := (EnableRoll)? "enable":"disable"
	GuiControl, %newState%, SystemR2
	newState := (EnablePouch || EnableMiscellaneous || autoHUDhiding)? "enable":"disable"
	GuiControl, %newState%, SystemEvent
	newState := (autoHUDhiding && SystemEvent = "e")? "Show":"Hide"
	GuiControl, %newState%, EventWarning
	

	; Quickcast
	newState := (EnableMiscellaneous || EnableQC)? "enable":"disable"
	GuiControl, %newState%, maximumQCSlots
	newState := EnableQC ? "enable":"disable"
	GuiControl, %newState%, PlayerUseQC
	GuiControl, %newState%, EnableQCCastkeys
	Loop, 12 {
		GuiControl, %newState%, PlayerQC%A_Index%
	}
	newState := EnableQCCastkeys ? "enable":"disable"
	Loop, 12 {
		GuiControl, %newState%, PlayerQCCastKey%A_Index%
	}
	
	; Quick Items
	newState := (EnableMiscellaneous || EnableQI)? "enable":"disable"
	GuiControl, %newState%, maximumQISlots
	newState := EnableQI ? "enable":"disable"
	GuiControl, %newState%, PlayerUseQI
	Loop, 10 {
		GuiControl, %newState%, PlayerQI%A_Index%
	}
	
	;Controller
	Loop, 16 {
		newState := (EnableController && SystemSwitchButton != A_Index + 1 && SystemEventButton != A_Index + 1)? "enable":"disable"
		GuiControl, %newState%, ZGUIController%A_Index%
		newState := (EnableController && SystemSwitchButton != 1 && SystemSwitchButton != A_Index + 1 && SystemEventButton != A_Index + 1)? "enable":"disable"
		GuiControl, %newState%, ZGUIController%A_Index%switch
		newState := (EnableController && SystemEventButton != 1 && SystemSwitchButton != A_Index + 1)? "enable":"disable"
		GuiControl, %newState%, ZGUIController%A_Index%Event
		newState := (EnableController && SystemEventButton != 1 && SystemSwitchButton != 1 && SystemSwitchButton != A_Index + 1 && SystemEventButton != A_Index + 1)? "enable":"disable"
		GuiControl, %newState%, ZGUIController%A_Index%EventSwitch
	}
	newState := EnableController ? "enable":"disable"
	GuiControl, %newState%, ControllerInputType
	GuiControl, %newState%, DetController
	GuiControl, %newState%, SystemSwitchButton
	GuiControl, %newState%, SystemEventButton
	i := 0
	d := 0
	GuiControl,, joystick , |
	; Loops available XInput controllers
	Loop 4 {
		if State := XInput_GetState(A_Index-1){
			i += 1
			if (ControllerInputType = 1)
				GuiControl,, joystick , %A_Index%
		}
	}
	; Loops available Direct Input controllers
	Loop 16 {
		if (x := GetKeyState(A_Index . "joyX")){
			d += 1
			if (ControllerInputType = 2)
				GuiControl,, joystick , %A_Index%
		}
	}
	NumberOfXIControllers := i
	NumberOfDIControllers := d
	if (ControllerInputType = 1){
		joystick := Min(NumberOfXIControllers,joystick)
		GuiControl, Choose, joystick, %joystick%
	}else{
		joystick := Min(NumberOfDIControllers,joystick)
		GuiControl, Choose, joystick, %joystick%
	}
	GuiControl, %newState%, joystick
	GuiControl, %newState%, DetController
	SystemSwitchButtontempt := SystemSwitchButton
	if (ControllerInputType = 1)
		GuiControl,, SystemSwitchButton , |None|joy1|joy2|joy3|joy4|joy5|joy6|joy7|joy8|joy9|joy10|joy11|joy12|Up|Down|Left|Right
	else
		GuiControl,, SystemSwitchButton , |None|joy1|joy2|joy3|joy4|joy5|joy6|joy7|joy8|joy9|joy10|joy11|joy12
	GuiControl, Choose, SystemSwitchButton, %SystemSwitchButtontempt%
	
	; Backup
	newState := BackupEnabled ? "enable":"disable"
	GuiControl, %newState%, SavePath	
	GuiControl, %newState%, SelectSaveFilePath	

	; Debug
	newState := EnableDebug ? "enable":"disable"
	GuiControl, %newState%, DebugMode	
}

; Shows a popup window with basic information about this software and its version
getVersion(){
	global EMUversion
	MsgBox, E.M.U. Light (Enhanced Moveset Utility)`nVersion: %EMUversion%`nOfficial page: https://www.nexusmods.com/darksouls3/mods/83`nAuthor: KowboyBebop `n`nE.M.U. Light is a free utility. You can freely distribute and modify the source code as long as you keep it freely available to others and mention everybody who worked in the development, including the author of the original code.
}

; Creates and shows a window with tutorial
helpme(){
	Gui, help:new
	Gui, help:Add, Picture, % dpi("x0 y1 w696 h760"),  %A_ScriptDir%\EMULight-help.png
	Gui, help:Add,Button, % dpi("x290 y710 w100 h30 gSubmitGUI") Default, OK
	Gui, font, % dpi("s12 underline cWhite"), Tahoma
	Gui, help:color, 252323
	Gui, help:Add,Text, % dpi("x18 y160 gshowSetup"), Detailed setup guide for EMU Light.
	Gui, font, % dpi("s12 underline cWhite"), Tahoma
	Gui, help:Add,Text, % dpi("x18 y675 gShowKeyNames"), https://www.autohotkey.com/docs/KeyList.htm
	Gui, help:Show, % dpi("w696 h760") , E.M.U. - Help
}
	
; Opents the Setu guide as picture
showSetup(){
	Run, %A_ScriptDir%\EMULight-Setup.jpg
}

; Opents the autohotkey documentation with available keys and button names
ShowKeyNames(){
	run, https://www.autohotkey.com/docs/KeyList.htm
}

; Shows the rebind window
getRebinds(){
	Gui, Rebinds:Show, % dpi("w450 h650") , E.M.U. - Rebinds
}

; Shows the advanced settings window
getADVSET(){
	Gui, ADVSET:Show, % dpi("w600 h600") , E.M.U. - Advanced Settings
}

; Additional gui window close buttons
SubmitGUI(){
	Gui, Submit, Hide  																				;Save the input from the current cuit
}

	/*
Name             : DPI
Purpose          : Return scaling factor or calculate position/values for AHK controls (font size, position (x y), width, height)
Version          : 0.31
Source           : https://github.com/hi5/dpi
AutoHotkey Forum : https://autohotkey.com/boards/viewtopic.php?f=6&t=37913
License          : see license.txt (GPL 2.0)
Documentation    : See readme.md @ https://github.com/hi5/dpi

Changes from original dpi.ahk script:
* using the window width/1920 instead of DPI for the factor

History:
* v0.31: refactored "process" code, just one line now
* v0.3: - Replaced super global variable ###dpiset with static variable within dpi() to set dpi
        - Removed r parameter, always use Round()
        - No longer scales the Rows option and others that should be skipped (h-1, *w0, hwnd etc)
* v0.2: public release
* v0.1: first draft
*/

DPI(in="",setdpi=1){
	global GUIWindowScale
	global DPI_F

	factor:=A_ScreenHeight/1080 * GUIWindowScale<0.25 || GUIWindowScale > 3?1:GUIWindowScale
	if !in
		Return factor
	out := ""
	 Loop, parse, in, %A_Space%%A_Tab%
		{
		 option:=A_LoopField
		 if RegExMatch(option,"i)(w0|h0|h-1|xp|yp|xs|ys|xm|ym)$") or RegExMatch(option,"i)(icon|hwnd)") ; these need to be bypassed
			out .= option A_Space
		 else if RegExMatch(option,"i)^\*{0,1}(x|xp|y|yp|w|h)[-+]{0,1}\K(\d+)",number) ; should be processed
			out .= StrReplace(option,number,Round(number*factor/DPI_F)) A_Space
		else if RegExMatch(option,"i)^\*{0,1}(s)[-+]{0,1}\K(\d+)",number)
			out .= StrReplace(option,number,Round(number*factor/DPI_F)) A_Space
		 else ; the rest can be bypassed as well (variable names etc)
			out .= option A_Space
		}
	 Return Trim(out)
	}
	
; width *1.1 to compensate for DPI differencies. Might not be needed
DPIFactor(){ 
DPI_value := % DllCall("GetDeviceCaps", "uint", DllCall("GetDC", "uint", 0), "uint", LOGPIXELSY := 0x5A)
if (errorlevel=1) OR (DPI_value=96 )
	return 1
else
	Return DPI_Value/96
}