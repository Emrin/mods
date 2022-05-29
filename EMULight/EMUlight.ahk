#MenuMaskKey vkFF																					;When lalt/windows hotkey is triggered Autohotkey sends menu mask key (lcontrol default). https://www.autohotkey.com/docs/commands/_MenuMaskKey.htm#Remarks
#SingleInstance Force 																				;forces only one instance of EMUL to run at a time
#MaxHotkeysPerInterval 140 																			;sets the maximum allowed number of executing hotkeys in the default time interval
#MaxThreadsPerHotkey 1 																				;sets thread usage per hotkey
#Persistent 																						;keeps the script running until it is closed
#KeyHistory 500 																					;sets the key history to 500 keys
#NoEnv  																							;Recommended for performance and compatibility with future AutoHotkey releases.

SetWorkingDir %A_ScriptDir%   																		;makes the default directory for file manipulation to the directory of this script 
SendMode Input    																					;sets the method autohotkey (EMUL) sends keys and button signals
SendLevel, 0 																						;0 = hotkeys cannot trigger other hotkeys (This is temporarily enabled in parts of the script) 

; Include external libraries
#Include _libraries\XInput.ahk
#include _libraries\Imagen.ahk

; Include EMU Light source code
#include IOFunctions.ahk
#include GUI.ahk

; Windows that work with EMUL
SetTitleMatchMode, RegEx 																				;sets to match substring anywhere in the name of class or exe
GroupAdd, DaSGames, ahk_exe DARKSOULS.exe															;EXE file of Original Dark Souls
GroupAdd, DaSGames, ahk_exe DarkSoulsRemastered.exe													;EXE file of Remastered Dark Souls
GroupAdd, DaSGames, ahk_exe DarkSoulsII.exe															;EXE file of Dark Souls 2
GroupAdd, DaSGames, ahk_exe DarkSoulsIII.exe														;EXE file of Dark Souls 3
;GroupAdd, DaSGames, ahk_exe eldenring.exe															;EXE file of Elden Ring
GroupAdd, DaSGames, ahk_class DARK SOULS															;Window title of Original Dark Souls
GroupAdd, DaSGames, ahk_class Dark SoulsII															;Window title of Dark Souls 2
GroupAdd, DaSGames, ahk_class Dark SoulsIII															;Window title of Dark Souls 3
GroupAdd, DaSGames, ahk_class FDPclass																;Window title of Dark Souls 3 (Alternative)
GroupAdd, DaSGames, ahk_class ELDEN RING.?															;Window title of Elden Ring

;======================== Initiate variables ===================================================

; EMUL internal
currentProfileDir=%A_ScriptDir%\profiles\															;Sets the directory where profile files are kept
firstTime := 1 																						;Variable governs whether help me page should be automatically opened
EMUversion := "L1.1" 																				;Current version of EMUL
OnlineVersion := VersionCheck()																	;Current online version of EMUL
global isEMUActive := 0 																			;Toggle variable for the Activate/Deactivate 
EMUProfilePath := A_ScriptDir . "\profiles\EMUL_DefaultProfile.ini"							;File with the profile data
WATCH_AXIS_TIMER_TICK := 25 																	;Constant governing the timer for watchAxis. Also used to count down time.
isEMUDebugActive := 0
global SystemMinimumKeyPressDuration := 23
; Miscellaneous
inMenu := 0
isMenuAvailable := 1
paused := 0
; GUI
GUIWindowScale := 1.0
DPI_F := 0
; Pouch5X := (A_ScreenWidth/A_ScreenHeight = 16/9) ? (1750/1920) : (2769/3440)							;Pouch 5 x coordination on 1920 is 1750. On 3440 its 2769
; Pouch6X := (A_ScreenWidth/A_ScreenHeight = 16/9) ? (1840/1920) : (2872/3440)							;Pouch 6 x coordination on 1920 is 1840. On 3440 its 2872
; Pouch56Y := 470/1080																				; Pouch 5 and 6 y coordination on 1080 is 470
; Quick cast
global isQCAvailable := 1
global selectedQCSlot := 1 
global newQCSlot := 1
; Quick Use
global isQIAvailable := 1
global selectedQISlot := 1 
global newQISlot := 1
; Hotkeys
areHotkeysSuspended := 0																		;Variable that is used to suspend hotkey with the on/off/toggle Steam hotkeys 
SystemActiveHotkeys := []																	;An arrays with all created hotkeys
SystemActiveHotkeysCount := 0 																;Size of array above
; Sprint
sprintStart := 0
timeToSprint := 0																		;Once sprint key is pressed, this variable is set to count down the minimal time to sprint (to prevent a roll)
global timeLeftToNextRoll := 0
global isRollingPossible := 1 																		;Variable that locks roll function while previous instance of said function is being executed
global isMoving := 0 																				;Variable tracks whether character is moving or not (detected by movement keys and joystick positions)
global isSprinting := 0
global sprintToggle := 0
; Attacks
lastAttacked := 0
; Joystick
global NumberOfXIControllers
global NumberOfDIControllers
global eventButton := ""
global switchButton := "" 																			;Tracks the button assigned as switch
global isEventButtonHeld := 0
global isSwitchButtonHeld := 0 																		;Tracks whether switch button is being held down
global buttonsBeingHeldDown := [] 																	;An array that stores all held controller buttons to periodically check and release
global isJoystickTilted := 0 																;EMUL tracks the current direction of joystick to determine if it has changed
global dpadToPress := "" 																			;EMUL tracks the current direction of D-PAD to determine if it has changed
global dpadToPressPrev := ""																		;EMUL tracks the previous direction of D-PAD to determine if it has changed
;XBOX_BUTTON_MAPPING 
global xboxButtonsLastState := [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]
global XINPUT_TO_DIRECTINPUT_MAPPING := ["13","14","15","16","10","9","11","12","5","6","7","8","1","2","3","4"] 	;[up,down,left,right,options,share,L3,R3,LB,RB,LT,RT,X,circle,square,triangle]
global DIRECTINPUT_TO_XINPUT_MAPPING := ["13","14","15","16","9","10","11","12","6","5","7","8","1","2","3","4"]	

;================================= Main Script =========================================================
XInput_Init()																						;Initiates the XInput library
IniRead, profileFile, %A_ScriptDir%\EMUsys.settings, Profile, EMUProfilePath						;Preloads the path to profile file
IniRead, firstTime, %A_ScriptDir%\EMUsys.settings, Profile, firstTime								;Preloads the variable that governs if this is the first time user launched EMUL
if (profileFile != "" AND profileFile != "ERROR")													;checks if path to profile setting file was loaded correctly
	EMUProfilePath := profileFile																	;sets profile file path to EMU variable
IniRead, GUIWindowScale, %EMUProfilePath%, AdvancedSettings, GUIWindowScale, 1.0
GUIWindowScale := (GUIWindowScale = "")?1:GUIWindowScale
DPI_F:=DPIFactor()
DrawGUI()																					;Draws EMUL GUI
Loadhotkeys()																					;loads hotkey from profile setting file
if (firstTime){																						;Checks if this is the first time user launched EMUL
	helpme()																				;shows help me page
	firstTime := 0																					;This is now the first time user launched EMUL
	IniWrite, %firstTime%, %A_ScriptDir%\EMUsys.settings, Profile, firstTime						;Saves the information that EMUL has been launched
	IniWrite, %EMUProfilePath%, %A_ScriptDir%\EMUsys.settings, Profile, EMUProfilePath				;Saves the correct path to profile file
	saveHotkeys()																				;Calls the save function
}	
if (BackupEnabled = 1)																				;Checks if user enabled autoamtic save file backup
	BackUpSaveFile()																			;Back ups DaS save file
ToggleGUIElements()
OnMessage(0x0006,"EMUGUIActivated")															; Message 0x0006 = window activated. Every time EMU becomes active, function EMUGUIActivated() is called.
return																								;End of autoexecute script
;============================== END of main Script ====================================================


;=============================================================================== GUI Buttons =============================================================================

; Function called when EMU Gui gains focus. Selects the Activate/deactivate button
EMUGUIActivated(){
	ControlFocus , Button14
}

; EMU Save button calls savehotkeys()
EMUButtonSave(){
	savehotkeys()
}

; EMU restart button calls savehotkeys() and reloads the script
EMUButtonRestart(){
	saveCurrentSlots()
	Reload
}

EMUButtonActivate(){
	global
	local NumberOfJoysticks
	if(isEMUActive){
		; ============================= Turn OFF ====================================
		suspend on
		GuiControl, EMU:, Activate, Activate	
		SB_SetText("EMU deactivated. No setting or hotkey will take place until reactivation.") 	;set statusbar text
		isEMUActive := 0
		ToggleHotkey("off") 																		;removes active hotkeys
		SetTimer, WatchAxis, off
		SetTimer, EMUdebug, off
		if (isEMUDebugActive)
			DetectController()
		GuiControl, Hide, controllerWarning
		CloseScript("EMULight-Controller.exe")
	}else{
		; ============================= Turn ON ====================================
		suspend off
		Gui, Submit, NoHide  																		; Save the input from the user to each control's associated variable.
		Gui, Rebinds:Submit, Hide  																	
		Gui, ADVSET:Submit, Hide  																	
		if ADVSETWindowEnable{
			GroupAdd, DaSGames																	;adds all open windows to supported games - thus enabling EMUL to work in them
			newGroupNumber := +1
		}
		;~ #IfWinActive ahk_group DaSGames 															;updates the list of applications EMUL works in
		createTimer("WatchAxis",WATCH_AXIS_TIMER_TICK)
		NumberOfJoysticks := 0
		if (EnableController = 1){
			Loop 16 {
				GetKeyState, joyName, %A_Index%joyName
				if (joyName <> ""){
					NumberOfJoysticks = %A_Index%
					break
				}
			}
			if (NumberOfJoysticks < 1){ 																	;there is no controller
				GuiControl, Show, controllerWarning
			}
			EventButton := SystemEventButton - 1
			switchButton := SystemSwitchButton - 1																;First choice of SystemSwitchButton is "None". Second choice is Joy1...
			Run, %A_ScriptDir%\_support_apps\EMULight-Controller.exe 							; running program
			GuiControl, disable, Controller%switchButton%
			GuiControl, disable, Controller%switchButton%switch	
		}
		createHotkeys() 																		;calls label "CreateHotkeys"
		if (EnableDebug){																			;ENABLES DEBUG 
			createTimer("EMUdebug", 25)
			isEMUDebugActive := !isEMUDebugActive
			if (DebugMode = "KeyHistory")
				KeyHistory
			else if (DebugMode = "ListVars")
				ListVars
			else if (DebugMode = "ListHotkeys")
				ListHotkeys
			else if (DebugMode = "ListLines")
				ListLines
		}
		isEMUActive := 1
		SB_SetText("Settings changed and actived. To save changes press ""Save"" button, press Ctrl+S or chose ""save"" from ""file"" menu.") 	;set statusbar text
		GuiControl, EMU:, Activate, Deactivate	
	}
	ToggleGUIElements()
}

;=============================================================================== Hotkeys functions =============================================================================
; Enumerates through the array SystemActiveHotkeys and changes the state. If the new state is "Off" the hotkey is forgotten and the SystemActiveHotkeysCount is decreased
ToggleHotkey(newState){
	global SystemActiveHotkeys,SystemActiveHotkeysCount
	Loop, %SystemActiveHotkeysCount% {
		hotkeyToChange := SystemActiveHotkeys[A_Index - 1]
		Hotkey, %hotkeyToChange%, %newState%
		if newState = "off"
			SystemActiveHotkeysCount -= 1
	}
}
	
; Creates and adds a single hotkey into the SystemActiveHotkeys Array
addHotkey(prefix,keyToBind,isFunction,actionToBind,functionParameter1 = "", functionParameter2 = ""){
	global SystemActiveHotkeys,SystemActiveHotkeysCount
	If (keyToBind = "")
		return
	if ((functionParameter1 != "") && (functionParameter2 != ""))
		function := Func(actionToBind).Bind(functionParameter1,functionParameter2)					;If functionPrameter is defined it creates object with bound function with that parameter isntead
	else if (functionParameter1 != "")
		function := Func(actionToBind).Bind(functionParameter1)										;If functionPrameter is defined it creates object with bound function with that parameter isntead
	else
		function := Func(actionToBind).Bind(keyToBind) 												;creates object with bound function in variable actionToBind with parameter keyToBind
	If (StrLen(keyToBind) = 1 || (!InStr(keyToBind, "+") && !InStr(keyToBind, "!") && !InStr(keyToBind, "^") && !InStr(keyToBind, "&")))
		prefix := prefix . "*" 																		;adds prefix "*" (activates the hotkey even if a modifier keys such as alt, shift or ctrl are held)
	if isFunction
		Hotkey, %prefix%%keyToBind%, % function 													;hotkey calls function
	else
		Hotkey, %prefix%%keyToBind%, %actionToBind% 												;hotkey calls a label
	SystemActiveHotkeys[SystemActiveHotkeysCount++] := prefix . keyToBind 							;saves hotkey and its prefix to SystemActiveHotkeys array and increases SystemActiveHotkeysCount
}	

; removes selected modifiers from a hotkey
removeModifiers(textValue,modifiersToRemove := "!,^,+"){
	if textValue contains %modifiersToRemove%	; If modifier key is used for quickcast, trim it so its not used for m & hotkey 
		return NewHotkey := StrLen(textValue) > 1 ? SubStr(textValue, 2 ) : textValue	
	return textValue
}

; Creates all hotkeys from GUIs
createHotkeys(){
	global
	Gui, Submit, NoHide
	Hotkey, IfWinActive, ahk_group DaSGames
	;MOVEMENT
	if (enableRoll){
		SystemActiveHotkeys := []																	;clears hotkeys
		SystemActiveHotkeysCount := 0
		if (SplitRollASprint = 1){
			addHotkey("~",PlayerRoll,false,"Roll") 													;Hotkey calls subroutine Roll
			addhotkey("~",PlayerRoll . " up", false,"EndRollHotkeyHandler")
			addHotkey("~",PlayerSprint,false,"SprintHotkeyHandler")
			addHotkey("~",PlayerSprint . " up",false,"EndSprintHotkeyHandler")
		}else{
			addHotkey("~",PlayerRoll,false,"SprintRoll")
			addhotkey("~",PlayerRoll . " up", false,"EndSprintHotkeyHandler")
		}
	}

	;POUCH
	if (enablePouch){
		addHotkey("~",PlayerPouch1,true,"usePouchItem",SystemSelectNextQCSlot)
		addHotkey("~",SystemEvent . " & ~" . SystemSelectNextQCSlot,false,"doNothing")
		addHotkey("~",PlayerPouch2,true,"usePouchItem",SystemSelectNextQISlot)
		addHotkey("~",SystemEvent . " & ~" . SystemSelectNextQISlot,false,"doNothing")
		addHotkey("~",PlayerPouch3,true,"usePouchItem",SystemNextRH)
		addHotkey("~",SystemEvent . " & ~" . SystemNextRH,false,"doNothing")
		addHotkey("~",PlayerPouch4,true,"usePouchItem",SystemNextLH)
		addHotkey("~",SystemEvent . " & ~" . SystemNextLH,false,"doNothing")
		addHotkey("~",PlayerPouch5,true,"usePouchItem",5)
		addHotkey("~",PlayerPouch6,true,"usePouchItem",6)
	}

	;MISC
	if (EnableMiscellaneous){
		addHotkey("~",PlayerTwohand,true,"twoHanding",PlayerTwohand,0)
		addHotkey("~",PlayerOffhandTwohand,true,"twoHanding",PlayerOffhandTwohand,1)
		addHotkey("~",PlayerMap,true,"toggleMap")
		addHotkey("~",PlayerPreviousQCslot,true,"selectPreviousSlot","QC")
		addHotkey("~",PlayerPreviousQIslot,true,"selectPreviousSlot","QI")
		addHotkey("~",PlayerPauseGame,true,"pauseGame")
	}

	;MOVEMENT
	if (enableRoll){
		If (PlayerW != ""){
			addHotkey("~",PlayerW,true,"Movement")
			Hotkey, ~*%PlayerW% up, EndOfMovement
		}
		If (PlayerA != ""){
			addHotkey("~",PlayerA,true,"Movement")
			Hotkey, ~*%PlayerA% up, EndOfMovement
		}
		If (PlayerS != ""){
			addHotkey("~",PlayerS,true,"Movement")
			Hotkey, ~*%PlayerS% up, EndOfMovement
		}
		If (PlayerD != ""){
			addHotkey("~",PlayerD,true,"Movement")
			Hotkey, ~*%PlayerD% up, EndOfMovement
		}
	}

	;STEAM CONTROL
		addHotkey("~",PlayerToggle1,false,"Steamtoggle")
		addHotkey("~",PlayerToggle2,false,"Steamtoggle")
		addHotkey("~",PlayerTrnOn,false,"trnon")
		addHotkey("~",PlayerTrnOff,false,"trnoff")

	;MAGIC
	Loop, 12 {
		NewHotkey := % PlayerQC%A_Index%
		if (NewHotkey = "")
			continue
		if (EnableQC)	
			addHotkey("~",NewHotkey,true,"quickcast","QC",A_Index)
		NewHotkey := removeModifiers(NewHotkey)
		if (playerChangeAttunement != "")
			addHotkey("~", playerChangeAttunement . " & " . NewHotkey,true,"changeAvailableSlots","QC",A_Index)
	}
	addHotkey("",SystemSelectNextQCSlot,true,"selectNextSlot","QC")
	addHotkey("~",SystemMouseSelectNextQCSlot,true,"selectNextSlot","QC",1)
	Hotkey, ~*%SystemSelectNextQCSlot% up, doNothing

	;QuickUse
	Loop, 10 {
		NewHotkey := % PlayerQI%A_Index%
		if (NewHotkey = "")
			continue
		if (EnableQI)
			addHotkey("~",NewHotkey,true,"quickcast","QI",A_Index)
		NewHotkey := removeModifiers(NewHotkey)
		if (playerChangeItem != "")
		addHotkey("~", playerChangeItem . " & " . NewHotkey,true,"changeAvailableSlots","QI",A_Index)
	}	
	addHotkey("",SystemSelectNextQISlot,true,"selectNextSlot","QI")
	addHotkey("~",SystemMouseSelectNextQISlot,true,"selectNextSlot","QI",1)
	Hotkey, ~*%SystemSelectNextQISlot% up, doNothing	

	;CONTROLLER
	if (EnableController && ControllerInputType = 2){
		Loop, 12 {
			if (A_index = switchButton && switchButton != "")
				addHotkey("",%joystick%joy%A_Index%,true,"SwitchDown","Switch")
			else if(A_index = eventButton && eventButton != "")
				addHotkey("",%joystick%joy%A_Index%,true,"SwitchDown","Event")
			else{
				addHotkey("",%joystick%joy%A_Index%,true,"joyNumber",A_Index)
			}
		}
	}

	;REBINDS
		Loop 9 {
			NewHotkeySource := reSource%A_Index%
			NewHotkeyTarget := reTarget%A_Index%
			if (NewHotkeySource = "" || NewHotkeyTarget = "")
				continue
			prefix := ""
			if (reSentSourceToGame%A_Index%)
				prefix := "~"
	    	addHotkey(prefix,NewHotkeySource,True,"rebindDown",NewHotkeyTarget)
	    	addHotkey(prefix,NewHotkeySource . " up",True,"rebindUp",NewHotkeyTarget)
		}

	;TOGGLES	
		Loop 3 {
			if ((Toggler := reToggler%A_Index%) = "" || (Toggled := reToggled%A_Index%) = "")
				continue
			prefix := ""
	    	addHotkey(prefix,Toggler,True,"Toggle",Toggled)
		}

	; Advanced Settings
		addHotkey("~",ADVSEThotkeybackup,false,"BackUpSaveFile")
		if (ADVSETenableAttackCooldown && ADVSETenableR1Cooldown)
			addhotkey("~",SystemR1, true, "performAttack","numpad1", SystemR1)
		if (ADVSETenableAttackCooldown && ADVSETenableL1Cooldown)	
			addhotkey("~",SystemL1, true, "performAttack","numpad2", SystemL1)
				
	;MENU TOGGLE
	if (ADVSETEnableMenu){
		addHotkey("","escape",true,"menuToggle")
		addHotkey("","escape up",false,"doNothing")
	}

	; Turns all hotkeys on
	ToggleHotkey("on")
}

;=============================================================================== Game functions =============================================================================
; Navigates to "Explanation" menu which stops time ingame
pauseGame(){
	global borderlessWindow,paused,SystemMinimumKeyPressDuration,inMenu
	if (!paused){
		if (inMenu != 1){
			PressKey("escape")
			sleep %SystemMinimumKeyPressDuration%
		}
		PressKey("e")
		sleep %SystemMinimumKeyPressDuration%
		PressKey("g")
		sleep %SystemMinimumKeyPressDuration%
		PressKey("up")
		sleep %SystemMinimumKeyPressDuration%
		PressKey("e")
		paused := 1
	}else{
		PressKey("escape")
		sleep 250
		PressKey("escape")
		paused := 0
	}
	if (borderlessWindow)
		showPausedGUI(paused)
}

; Presses "G" and "Escape" at the same time to toggle map with on button
toggleMap(){
	global PlayerMap,inMenu
	if inMenu != 0
		return
	Send {Escape Down}
	Send {G down}
	sleep 50
	Send {Escape Up}
	Send {G up}
	KeyWait, %PlayerMap%, L T5
}

; Performs an attack and then wait for the Attack Cooldown
performAttack(attackToPerform, AttackHotkey){
	global ADVSETAttackCooldown,ADVSETenableAttackCooldown,ADVSETenableR1Cooldown,ADVSETenableL1CooldownattackBlock,lastAttacked
	if (attackBlock)
		return
	lastAttacked := A_TickCount 
	send {%attackToPerform% down}
	keywait, %AttackHotkey%,
	send {%attackToPerform% up}
	if (ADVSETenableAttackCooldown){
		if (AttackHotkey = SystemR1 && !ADVSETenableR1Cooldown)
			return
		else if (AttackHotkey = SystemL1 && !ADVSETenableL1Cooldown)
			return
		else
			sleep %ADVSETAttackCooldown%			;delay between attacks
	}
	return
}

; Twohands a weapon with one button (Event + R1/L1)
twoHanding(keyToCheck,isReversed := 0){
	global
	local sleepTime
	if !EnableMiscellaneous
		return
	sleepTime := max(700 - (A_TickCount - lastAttacked),200)												;sets the time before event key should be released (important for twohand queueing)
	attackBlock := 1																						;prevent character from attacking
	Send {%SystemEvent% Down}
	keywait, %keyToCheck%, L T0.25
	if (isReversed)
		keyToTwohand := ErrorLevel? ((ADVSETenableAttackCooldown && ADVSETenableR1Cooldown)? "numpad1" : SystemR1 ) : ((ADVSETenableAttackCooldown && ADVSETenableL1Cooldown)? "numpad2" : SystemL1 ) 
	else
		keyToTwohand := ErrorLevel? ((ADVSETenableAttackCooldown && ADVSETenableL1Cooldown)? "numpad2" : SystemL1 ) : ((ADVSETenableAttackCooldown && ADVSETenableR1Cooldown)? "numpad1" : SystemR1 )
	SendLevel, 0
	pressKey(keyToTwohand,50)
	Sleep %sleepTime%
	Send {%SystemEvent% Up}
	keywait, %keyToCheck%, L
	attackBlock := 0
}
	
; Starts/Stops tracking menu progress when Escape is pressed	
menuToggle(){
	global isMenuAvailable,inMenu
	if (!isMenuAvailable)
		return
	isMenuAvailable := 0
	KeyWait, Escape,T0.2
	if (ErrorLevel){
		inMenu := 0									; Hold to reset inMenu to 0
	}else{
		pressKey("escape",50)
		if (inMenu != 0){
			inMenu := 0
			SetTimer, WatchEQLMB, off
		}else{
			inMenu := 1
			createTimer("WatchEQLMB", 23)
		}
		
	}
	KeyWait, Escape,
	createTimer("MenuToggleOn",-1)
}

; Timer that watches for E,Q and LMB presses to track menu progress
WatchEQLMB(){
	global inMenu
	if (inMenu = 0){
		SetTimer, WatchEQLMB, off
		return
	}
	if (GetKeyState("lbutton","P") && inMenu = 1){
		MouseGetPos, MouseX,
		inMenu := (MouseX > 0.10 * A_ScreenWidth)?0:2
		KeyWait, lbutton, T2
	}else if (GetKeyState("e","P")){
		inMenu += 1
		KeyWait, e, T2
	}else if (GetKeyState("q","P")){
		inMenu := Max(inMenu - 1,0)
		KeyWait, q, T2
	}
}

MenuToggleOn(){
	global isMenuAvailable := 1
}
	
;======================================================================== DEDICATED ROLL & SPRINT BUTTONS =================================================================================

; This function is used when Sprint key is held but character is not moving and sprint button is not allowed to backstep. It is periodically called until the character starts moving or sprint key is released
PreSprint(SprintHotkey){
	global
	if !EnableRoll
		return
	If !GetKeyState(SprintHotkey){
		SetTimer, , off 																			;Sprint button is no longer held, no need to wait
		return
	}
	if (isMoving OR isJoystickTilted){
		SetTimer, , off 
		gosub Sprint																				;Sprint is held and a character starts moving. Its time to start running
	}
	return 																							;Sprint is still held, but the character is not moving. The timer is not turned off and will call this function again shortly
}

; Sprint key/button handler function. Checks if the character is moving and calls Sprint and waits for sprint key release. If not and sprint cannot backstep it calls presprint. 
SprintHotkeyHandler:
	if (!EnableRoll)
		return
	if !ADVSETbackstep && sprintToggle != 2{
		if (!GetKeyState(PlayerW, "P") AND !GetKeyState(PlayerA, "P") AND !GetKeyState(PlayerS, "P") AND !GetKeyState(PlayerD, "P") AND !isJoystickTilted){
			thisHotkey := RegExReplace(PlayerSprint, "[^a-zA-Z]", "")									;Grabs the hotkey that initiated this functions
			createTimer("PreSprint",16,thisHotkey)													;Passes that hotkey to PreSprint function
			return
		}
	}
	createTimer("Sprint",-1)
	Keywait, %PlayerSprint%, L
return

; Holds down the system sprint key and sets up minimal time to sprint 
Sprint:
critical
	if (EnableSprintToggle)
		sprintToggle := (A_ThisHotkey = "~*" . PlayerSprint) ? Mod(sprintToggle += 1,3) : sprintToggle
	isSprinting := 1
	Send {%SystemRoll% Down}
	sprintStart := A_TickCount 						
return

; Sprint key/button Up handler function. It waits the remaining time to run (starts at minimum time to run and counts down) and then calls EndSprint
EndSprintHotkeyHandler:
critical	
	if (!isSprinting || sprintToggle = 2)
		return
	timeToSprint := 500 - (A_TickCount - sprintStart)
	if (timeToSprint > 0)
		createTimer("EndSprint","-" . timeToSprint)											;Ensures that once sprint is pressed, it is virtually held for the duration required to not turn into a roll						
	else
		gosub EndSprint
return
	
; Checks if sprint toggle is on and if not it stops	
EndSprint:
critical
	if (sprintToggle = 2)
		return
	Send {%SystemRoll% Up}
	sprintToggle = 0
	isSprinting := 0
	sleep 35
return

; Function checks if character is sprinting and if so, releases the sprint. Performs a roll and checks if character is should be sprinting and if so calls the sprint function. Then waits until another roll is possible 
Roll:
critical
	if (!isRollingPossible || !EnableRoll)
		return
	isRollingPossible := 0	
	timeLeftToNextRoll := RollCooldown
	if isSprinting { 																			;Character is sprinting. Sprint button is released and roll is executed
		Send {%SystemRoll% Up}
		sleep 35
	}
	pressKey(SystemRoll,GetKeyState(SystemR2)?150:SystemMinimumKeyPressDuration)					;If Player is holding down R2. Dodge cancel needs longer dodge input
	sleep 35
	if (isSprinting)
		Send {%SystemRoll% Down}
	if (PlayerRoll = "wheelup" || PlayerRoll = "wheeldown")
		isRollingPossible := 1 	
	sleep 35	
return

; The function reneables rolling after the roll button is released
EndRollHotkeyHandler:
	if !EnableRoll
		return
	createTimer("EndRoll","-" . timeLeftToNextRoll)	
return

EndRoll:
	if (GetKeyState(SystemRoll) && !isSprinting){
		sleep 35
		Send {%SystemRoll% Up}
		sleep 35
	}
	isRollingPossible := 1 		;Having this on playerRoll up hotkey prevents the character from rolling multiple time when the roll key is held
return


; Function serving both Sprint and roll which causes the roll to activate on key release instead of key press, making it slower.
SprintRoll:
	if !EnableRoll
		return
	Send {%SystemRoll% Down}
	keywait, % PlayerRoll, L T0.3 																	;Checks if SprintRoll is being held for more than 300 ms (time it takes DaS games to start sprinting instead or rolling)
	if (ErrorLevel){	
		isSprinting := 1 																			;SprintRoll button is held.
	}else{ 																							;SprintRoll button was pressed. roll is executed and function waits until another roll is possible.
		Send {Blind}{%SystemRoll% Up}
		sleep %RollCooldown%
	}
	KeyWait, %PlayerRoll%, L
return

; Activated by chosen PlayerWASD to track if character is moving
Movement(){
	global isMoving
	isMoving := 1
	return
}

; Checks PlayerWASD and if none is held down then the character is not moving
EndOfMovement:
sleep 50
	if (GetKeyState(PlayerW) || GetKeyState(PlayerA) || GetKeyState(PlayerS) || GetKeyState(PlayerD))
		return
	isMoving := 0
return


;=============================================================================== Pouch functions =============================================================================

; Uses Item in a pouch using the global Event key + passed itemKey variable.
usePouchItem(itemKey){
	critical
	global SystemEvent,EnablePouch,PlayerW,PlayerA,PlayerS,PlayerD
	if !EnablePouch
		return
	if (itemKey = 6){
		sequence := ["escape","left","down","down","e","escape"]
	}else if (itemKey = 5){
		sequence := ["escape","right","down","down","e","escape"]
	}else{
		Send {%SystemEvent% Down}
		Send {%itemKey% Down}
		Sleep 50
		Send {%SystemEvent% Up}
		Send {%itemKey% Up}
		return
	}
	BlockInput, On
	Loop, % sequence.Length()
	{
		pressKey(sequence[A_Index])
		sleep %SystemMinimumKeyPressDuration%
	}
	BlockInput, Off
	; resynchronize player WASD
	WASD := ["PlayerW","PlayerA","PlayerS","PlayerD"]
	For i, WASDkey in WASD {
		if (GetKeyState(%WASDkey%,"P") != GetKeyState(%WASDkey%)){
			Send % "{" . %WASDkey% . (GetKeyState(%WASDkey%,"P")?" down}":" up}")
		}
	}	
	return
}

;=============================================================================== Spell functions =============================================================================
; If SystemSelectNext%type%Slot is held, sets the selected%type%Slot to 1. If it was pressed increases the selected%type%Slot by one (cycling back to 1 if selected%type%Slot>maximum%type%Slots)
selectNextSlot(type,mouse := 0){
	global
	if (inMenu != 0)
		return
	local longpress := 0
	local key := SystemSelectNext%type%Slot
	if (autoHUDhiding){
		pressKey(SystemEvent)
		sleep 50
		Send {%key% down}
	}
	if (!mouse){
		keywait, %key%, L T0.6
		longpress := ErrorLevel
	}else{
		sleep 50
	}
	Send {%key% up}
	new%type%Slot := longpress ? 1: Mod(selected%type%Slot,maximum%type%Slots) + 1
	selected%type%Slot := new%type%Slot
	keywait,%key%,
	return
}

; Sets selected%type%Slot to previous value and calls LoopBack(type)
selectPreviousSlot(type){
	global
	if (inMenu != 0)
		return
	if (is%type%Available)
		new%type%Slot := selected%type%Slot
	selected%type%Slot := selected%type%Slot=1?(maximum%type%Slots):(selected%type%Slot -1)		;select previous slot
	if (autoHUDhiding){
		pressKey(SystemEvent)
		sleep 50
	}
	if (is%type%Available)
		createTimer("LoopBack","-1",type)
	return
}

; Loops spells/items until selected%type%Slot is selected
LoopBack(type){
	global
	is%type%Available := 0
	NextSlot := SystemSelectNext%type%Slot
	While (new%type%Slot != selected%type%Slot){ 																	;loops through next spells to reach the requested new slot
		sleep %SystemMinimumKeyPressDuration%												;21 is the bare minimum wait time DaS3 recognizes as pressed key, I chose 23 for reliability
		pressKey(NextSlot)
		new%type%Slot :=  Mod(new%type%Slot,maximum%type%Slots) + 1
	}
	is%type%Available := 1
}

; Quickly changes the number of attuned spells and play a beep of different pitch accordingly to let the player know
changeAvailableSlots(type,newValue){
	global
	maximum%type%Slots := newValue
	GuiControl, EMU:Choose ,maximum%type%Slots, %newValue%
	local beep := 100 * newValue 																			;changes the pitch according to the new value
	SoundBeep ,%beep% 																				;play a beep indicating new value being set to the player
	return
}

; Calculates the difference between currently selected spell and spell in the "slot". Selects and casts the new spell by pressing the "next spell" key. If held, selets first spell, then selects the new spell without casting.
quickcast(type,slot){	
	global
	; Checks if function can continue and if so, sets all required variables
	if (!is%type%Available || slot > maximum%type%Slots || !Enable%type% || inMenu != 0)
		return 
	is%type%Available := 0
	local longpress := 0
	local loopsToNewSlot := 0
	local NextSlot := SystemSelectNext%type%Slot
	local UseSlot := (Enable%type%Castkeys = 1 && Player%type%CastKey%slot% != "") ? Player%type%CastKey%slot% : PlayerUse%type%																		;uses globalcast key PlayerUseQC
	local currentHotkey := removeModifiers(Player%type%%slot%)							;removes prefix
	if (autoHUDhiding)
		pressKey(SystemEvent)

	; Manages the long press to resnychronize portion
	local keyHoldTime := -250														;The total wait time is either 50 (short press), 250 (long press, different slot) or 550 (long press, same slot)
	if (slot = selected%type%Slot){
		keyHoldTime -= 300													;Diffent slot. The NextSlot key will be held up to
	}else
		send {%NextSlot% down} 												;To make the function quicker unless the right slot is already selected, immediatelly start holding down next slot
	keywait, %currentHotkey%, L T0.3										;Waiting for key release for maximum of 300 ms
	if (ErrorLevel){
		longpress := 1														;300 ms ran out, the slot shall be reset to 1.
		selected%type%Slot := 1 
		send {%NextSlot% down}												;Either sents NextSlot for the first time, or sends it while its already down (no effect)
		keyHoldTime := -keyHoldTime
	}else{
		loopsToNewSlot -= 1													;First press of next spell key has already happened, so substracts one from the loopSpellsToNewSlot
		keyHoldTime += 300														;Short press, the wait time is set to short yet relaible 50 ms
	}

	; Cycles through spells to the selected slot
	sleep %keyHoldTime%														;Holds down NextSlot to reset the slot to 1																		
	send {%NextSlot% up}
	loopsToNewSlot+=Mod((maximum%type%Slots-selected%type%Slot)+slot,maximum%type%Slots)
	Loop, %loopsToNewSlot%	{ 													;loops through next spells to reach the requested new slot
		sleep %SystemMinimumKeyPressDuration%
		pressKey(NextSlot)
	}

	; Casts the correct spell
	If(!longpress && UseSlot != ""){ 											;if the currentSpellHotkey wasnt held and currentUseKey has been set
		sleep 30
		pressKey(UseSlot,40)
	}														
	new%type%Slot := slot
	selected%type%Slot := new%type%Slot 														;updates the currently selected attunement slot to slot	
	keywait, %currentHotkey%, L 																;waits for player to release the hotkey
	sleep 50
	is%type%Available := 1
	return
}

; Holds down a key for a specified duration or SystemMinimumKeyPressDuration before releasing it
PressKey(key, duration := 0){
	global SystemMinimumKeyPressDuration
	duration := duration?duration:SystemMinimumKeyPressDuration
	Send {%key% down}
	Sleep %duration%
	Send {%key% up}
}

; Load the newest version uploaded to nexusmods
VersionCheck(){
	; Code by dnllln
    ; Creates a WinHttp object, opens the mods URL, waits for a response and parses out the current version from the raw text of the page
    try {
        whr := ComObjCreate("WinHttp.WinHttpRequest.5.1")
        whr.Open("GET", "https://www.nexusmods.com/eldenring/mods/31", true)
		whr.setRequestHeader("Cache-Control", "no-cache, no-store, max-age=0")
        whr.Send()
        whr.WaitForResponse(10)
    } catch e {
        return false
    }

	; Display the load in human readable form
	; arr := whr.responseBody
	; pData := NumGet(ComObjValue(arr) + 8 + A_PtrSize)
	; length := arr.MaxIndex() + 1
	; MsgBox, % text := StrGet(pData, length, "utf-8")

    if (whr.Status = 200) {
        RegExMatch(whr.ResponseText, "L\d+(?:\.\d+)+", versionParsed)
        return versionParsed
    } else
        return false
}

;Function for closing exes (used to close Controller auxilery dummy application)
CloseScript(Name){																					
	DetectHiddenWindows On
	SetTitleMatchMode RegEx
	IfWinExist, i)%Name%.* ahk_class AutoHotkey
		{
		WinClose
		WinWaitClose, i)%Name%.* ahk_class AutoHotkey, , 2
		If ErrorLevel
			return "Unable to close " . Name
		else
			return "Closed " . Name
	}else
		return Name . " not found"
}

; Code by a kind anonymous contributor
createTimer(fn, period, args*) {
    if (args.MaxIndex() != "")
        fn := Func(fn).Bind(args*)
    SetTimer % fn, % period
}

; removes tooltips
RemoveToolTip(){
	SetTimer, RemoveToolTip, Off
	ToolTip
}

; Activates when EMU GUI is closed. Closes the controller placeholder exe and saves the current item and spell slots 
EMUGuiClose(){
	CloseScript("EMULight-Controller.exe")
	saveCurrentSlots()
	ExitApp
}

; dummy label that does nothing
doNothing:
return

; =========================================================================== REBINDS & TOGGLES =================================================================================================

; Simply presses target key
rebindDown(Target){
	send, {%target% down}
}

; releases target key
rebindUp(Target){
	send, {%target% up}
}
	
Toggle(Toggled){
	if GetKeyState(Toggled)
		Send {%Toggled% Up}
	else
		Send {%Toggled% Down}
}

; =========================================================================== Script Control =================================================================================================
; The hotkeys are renabled
trnon:
	Suspend, Permit
	Menu, Tray, Icon, %A_ScriptDir%\_images\icons\emu.ico,,
	areHotkeysSuspended = 0
	GuiControl, EMU:Hide, suspendWarning
	Suspend off
return

; Suspends hotkeys
trnoff:	
	Suspend, Permit
	areHotkeysSuspended = 1
	GuiControl, EMU:Show, suspendWarning
	suspend on
return

; Toggle trnon and turnoff (useful for steam overlay)
Steamtoggle:
	Suspend, Permit
    areHotkeysSuspended := !areHotkeysSuspended
    if (areHotkeysSuspended = true)
		Gosub trnoff
    else
		Gosub trnon
return

; Shows debug information as a tooltop next toi the mouse pointer (will minimize the game unless ran in windowed mode)
EMUDebug:
	DebugMessage := ""
	if (EnableDebug){
		; Mouse & Keyboard
		buttons_down := ""
		EMU_buttons_down := ""
		keys := ";,1,2,3,4,5,6,7,8,9,0,-,=K,L,q,w,e,r,t,y,u,i,o,p,[,],\,a,s,d,f,g,h,j,k,l,;,',z,x,c,v,b,n,m,,,.,/,alt,shift,lshift,rshift,ctrl,tab,Escape,enter,space,Lbutton,Rbutton,Mbutton,XButton1,XButton2,WheelDown,WheelUp,WheelLeft,WheelRight,up,down,left,right,ScrollLock,CapsLock,NumLock,TAB,Escape,BS,Enter,PrintScreen,Pause,LControl,RControl,LAlt,RAlt,LWin,RWin,F1,F2,F3,F4,F5,F6,F7,F8,F9,F10,F11,F12,Home,End,PgUp,PgDn,Del,Ins,Numpad0,Numpad1,Numpad2,Numpad3,Numpad4,Numpad5,Numpad6,Numpad7,Numpad8,Numpad9,NumpadDiv,NumpadMult,NumpadAdd,NumpadSub,NumpadEnter"
		Loop, parse, keys, `, 	
		{
			if (GetKeyState(A_LoopField,"P"))
				buttons_down .= A_LoopField . " "									;key is physically held - adds it to buttons_down string
			else if (GetKeyState(A_LoopField))
				EMU_buttons_down .= A_LoopField . " "						;key is logically held - adds it to EMU_buttons_down string
		}
		
		; Debug Message
		
		DebugMessage .= "EMU Light VARIABLES`n"
		DebugMessage .= "isQIAvailable: " . isQIAvailable . " isQCAvailable: " . isQCAvailable . " Current Selected Spell: " . selectedQCSlot . "(" . newQCSlot . "/" . maximumQCSlots . ") Item: " . selectedQISlot . "(" . newQISlot . "/" . maximumQISlots . ")`n"
		DebugMessage .= "Character isRunning: " . isSprinting . " sprintToggle: " . sprintToggle . " and isRollingPossible: " . isRollingPossible . " and isMoving: " . isMoving . " isJoystickTilted: " . isJoystickTilted . " inMenu: " . inMenu . "`n"
		DebugMessage .= "Keys physically pressed: " . buttons_down . "`n"
		DebugMessage .= "Keys pressed by EMU Light: " . EMU_buttons_down . "`n"
	}
	if (EnableController){
		; DirectInput
		joystickNumber := joystick
		GetKeyState, joy_name, %joystickNumber%joyName
		GetKeyState, joy_info, %joystickNumber%joyInfo
		GetKeyState, joy_buttons, %joystickNumber%joyButtons 											;puts the state of all controller buttons to joy_buttons array
		DirectInputButtonsDown := ""
		
		Loop, %joy_buttons% {
			GetKeyState, joyState, %joystickNumber%joy%a_index%
			if joyState= D
				DirectInputButtonsDown .= a_index . " "									;button is physically held - adds it to buttons_down string
		}
		DIaxis_info := ""
		DIaxis_info .= !InStr(joy_info, "R") ? "":" R:" . Ceil(GetKeyState(joystickNumber . "JoyR"))		; Right stick X
		DIaxis_info .= !InStr(joy_info, "U") ? "":" U:" . Ceil(GetKeyState(joystickNumber . "JoyU"))		; Right stick y
		DIaxis_info .= !InStr(joy_info, "Z") ? "":" RT+LT:" . Ceil(GetKeyState(joystickNumber . "JoyZ"))	; R2 + L2 
		DIaxis_info .= !InStr(joy_info, "P") ? "":" POV:" . Ceil(GetKeyState(joystickNumber . "JoyPOV"))	; DPAD

		
		; XInput
		gosub WatchAxis
		XInputButtonsDown := ""
		for index, element in xboxButtonsLastState{
		if (element = 1)
			XInputButtonsDown .= XINPUT_TO_DIRECTINPUT_MAPPING[index] . " "
		}
		
		; EMULight buttons down
		EMULightButtonsDown := ""
		for index, WatchedButtonPair in buttonsBeingHeldDown { 											;Enumerates through the buttonsBeingHeldDown array
			ControllerButton := WatchedButtonPair.ControllerButton 										;Gets the controller button of the pair
			XinputButton := WatchedButtonPair.XInputButton
			KeyboardKey := WatchedButtonPair.KeyboardKey 												;Gets the KB&M key of the pair
			EMULightButtonsDown .= ControllerButton . "(" . XinputButton . ")" . "=" . KeyboardKey . " "  
		}
	
		; Debug Message
		DebugMessage .= "Found " . NumberOfDIControllers . " DirectInput and " . NumberOfXIControllers . " XInput Controllers. `n"
		DebugMessage .= "Selected controller: " . joystickNumber  . " - " . (ControllerInputType = 1 ? "XInput based controller":joy_name)   . " (" . (ControllerInputType = 1 ? "XInput":"Direct Input") .  ")`n"
		if (ControllerInputType = 1)
			DebugMessage .= "XInput X:" . XBOX_L_X . " Y:" . XBOX_L_Y . " R:" . XBOX_R_X . " U:" . XBOX_R_Y . " LT:" . XBOX_LT  . " RT:" . XBOX_RT . " buttons pressed:" . XInputButtonsDown . "`n"
		else
			DebugMessage .= "DirectInput X:" . joyX . " Y:" . joyY . " " . DIaxis_info . " buttons pressed: " . DirectInputButtonsDown . "`n"
		DebugMessage .= "Buttons pressed by EMU Light:" . EMULightButtonsDown . "`n"
		DebugMessage .= "Switch Button Held: " . isSwitchButtonHeld . " Event button Held: " . isEventButtonHeld
	}
	tooltip %DebugMessage%
	createTimer("RemoveToolTip",-200)
return



;=============================================================================== Controller functions =============================================================================

; Run/closes the joystick_test.exe and sets the button in GUI
DetectController(){
	global isEMUDebugActive
	if (isEMUDebugActive := !isEMUDebugActive){
		GuiControl, , DetController, Stop detection
		createTimer("EMUdebug",25)
	}else{
		SetTimer, EMUdebug, off
		GuiControl, , DetController, Detect Controller
	}
}

; Switch button is down. Sets timer to periodically check if it is still beign held down
SwitchDown(type){
	global SystemEvent
	is%type%ButtonHeld := 1
	if (type = "event")
		send {%SystemEvent% down}
	createTimer("SwitchUp", 16, type)
}

; Checks if switch is still beign held down. If it isnt the timer is canceled
SwitchUp(type){
	global SystemEvent
	buttonXInput := DIRECTINPUT_TO_XINPUT_MAPPING[%type%Button]
	buttonFullName := % joystick . "joy" . type . "" . Button
	if(GetKeyState(buttonFullName, "P") || xboxButtonsLastState[buttonXInput])
		return
	SetTimer, , off
	is%Type%ButtonHeld := 0
	if (type = "event")
		send {%SystemEvent% up}
}

; Controller button %number% is down. Sets keyToHoldDown to basic or switch action accordingly. Creates a pair (button + keyToHoldDown) and pushes it into the buttonsBeingHeldDown array. Finally pushes down keyToHoldDown
joyDown(idNumberOfPushedKey){
	global
	local modifier,keyToHoldDown,ButtonPair
	
	if (isSwitchButtonHeld && isEventButtonHeld)
		keyToHoldDown := ZGUIController%idNumberOfPushedKey%EventSwitch
	else if (isSwitchButtonHeld)
		keyToHoldDown := ZGUIController%idNumberOfPushedKey%Switch
	else if (isEventButtonHeld)
		keyToHoldDown := ZGUIController%idNumberOfPushedKey%Event
	else
		keyToHoldDown := ZGUIController%idNumberOfPushedKey%
	if (keyToHoldDown = "")
		return
	send {%SystemEvent% up}
	if (keyToHoldDown != SystemEvent && keyToHoldDown !="wheeldown" && keyToHoldDown !="wheelup"){
		ButtonPair := new ControllerButtonPair(joystick,idNumberOfPushedKey,keyToHoldDown,modifier)
		buttonsBeingHeldDown.Push(ButtonPair)
	}
	
	modifier := ""
	If (InStr(keyToHoldDown, "+") AND (StrLen(keyToHoldDown) > 1))
		modifier := "lshift"
	If (InStr(keyToHoldDown, "!") AND (StrLen(keyToHoldDown) > 1))
		modifier := "lalt"
	If (InStr(keyToHoldDown, "^") AND (StrLen(keyToHoldDown) > 1))
		modifier := "lctrl"
	keyToHoldDown := removeModifiers(keyToHoldDown) 			;removes prefix
	if (modifier != "")
		send {%modifier% down}
	SendLevel, 1
	sleep %SystemMinimumKeyPressDuration%
	send {%keyToHoldDown% down}
	Sleep 30
	SendLevel, 01
	return
}

; Converts int to hex while invoking timers with button press actions 
checkXInputButtons(int){
	global xboxButtonsLastStateBin,xboxButtonsLastState,XINPUT_TO_DIRECTINPUT_MAPPING
	Loop, 16 {
		if (A_Index=11 || A_Index=12){
			ch := xboxButtonsLastState[A_Index]
		}else{
			if ((int & 1) = 0){
				ch := 0
			}else{
				ch := 1
				getXInputButtonState(1,A_Index,XINPUT_TO_DIRECTINPUT_MAPPING[A_Index])
			}
		}
		xboxButtonsStateBin := ch . xboxButtonsStateBin
		xboxButtonsLastState[A_Index] := ch
		int := int >> 1
	}
    return xboxButtonsLastStateBin := xboxButtonsStateBin
}

getXInputButtonState(XInputButtonState,XInputButton,DirectInputButton){
	global switchButton,eventButton,xboxButtonsLastState,isEMUActive
	if (xboxButtonsLastState[XInputButton] = XInputButtonState || !isEMUActive)
		return
	xboxButtonsLastState[XInputButton] := XInputButtonState
	if !XInputButtonState
		return
	if (DirectInputButton = switchButton)
		SwitchDown("Switch")
	else if (DirectInputButton = eventButton){
		;createTimer("joyDown",-1,DirectInputButton)
		SwitchDown("Event")
	}
	else
		createTimer("joyDown",-1,DirectInputButton)
}

; Periodically checks the state of controller D-pad and joystick and held buttons (if it finds a button not being held anymore it releases it and removes it from the buttonsBeingHeldDown array)
WatchAxis:
	timeLeftToNextRoll := Max(timeLeftToNextRoll - WATCH_AXIS_TIMER_TICK,0)

	if !EnableController																			;Stop if Controller is not enabled
		return 	
	
	; HELD BUTTONS RELEASE WATCH 			
	for index, WatchedButtonPair in buttonsBeingHeldDown { 											;Enumerates through the buttonsBeingHeldDown array
		ControllerButton := WatchedButtonPair.ControllerButton 										;Gets the controller button of the pair
		XinputButton := WatchedButtonPair.XInputButton
		if(GetKeyState(ControllerButton, "P") || xboxButtonsLastState[XinputButton]) 				;If the button is still held, skips it
			continue
		modifierToRelease := WatchedButtonPair.modifier
		KeyboardKey := WatchedButtonPair.KeyboardKey 												;Gets the KB&M key of the pair
		buttonsBeingHeldDown.Remove(index) 															;Removes the button from the buttonsBeingHeldDown array
		if (isEMUActive){
			SendLevel, 1 																				;Lets hotkeys activate other hotkeys
			send {%KeyboardKey% up} 																;releases the KB&M key
			SendLevel, 0 																				;Stops hotkeys from activating other hotkeys
			Sleep 70
			if (modifierToRelease != "")
				send {%modifierToRelease% up}
		}
	}	
	
	; JoySTICK WATCH 
	joyX := Ceil(GetKeyState(joystickNumber . "joyX"))																		;Get position of X axis.
	joyY := Ceil(GetKeyState(joystickNumber . "joyY"))
	if (ControllerInputType = 1){
		isJoystickTilted := ((XBOX_L_X > 30 AND XBOX_L_X < 70) AND (XBOX_L_Y > 30 AND XBOX_L_Y < 70))? 0:1 							;Determines if the joystick is in neutral or not
	}else{
		isJoystickTilted := ((joyX > 30 AND joyX < 70) AND (joyY > 30 AND joyY < 70))? 0:1 
	}
	
	if (ControllerInputType = 1){
		; XBOX WATCH
		if State:= XInput_GetState(NumberOfXIControllers-1){
			XBOX_Buttons := checkXInputButtons(State.wButtons)
			getXInputButtonState(XBOX_LT := State.bLeftTrigger / 255 * 100  > 50 ? 1:0,11,7)
			getXInputButtonState(XBOX_RT := State.bRightTrigger / 255 * 100  > 50 ? 1:0,12,8)
			XBOX_L_X := Ceil((((State.sThumbLX / 32768) * 100) + 100)/2)
			XBOX_L_Y := Abs(Ceil((((State.sThumbLY / 32768) * 100) - 100)/2))
			XBOX_R_X := Ceil((((State.sThumbRX / 32768) * 100) + 100)/2)
			XBOX_R_Y := Abs(Ceil((((State.sThumbRY / 32768) * 100) - 100)/2))
		}
	}else{
		; DPAD WATCH 
		GetKeyState, POV, joyPOV  																		;Get position of the POV control.
		if POV < 0   																					;No angle to report
			dpadToPress := ""
		else if POV > 31500                 															;315 to 360 degrees: Forward
			dpadToPress := "up"
		else if POV between 0 and 4500      															;0 to 45 degrees: Forward
			dpadToPress := "up"
		else if POV between 4501 and 13500  															;45 to 135 degrees: Right
			dpadToPress := "right"
		else if POV between 13501 and 22500 															;135 to 225 degrees: Down
			dpadToPress := "down"
		else                                															;225 to 315 degrees: Left
			dpadToPress := "left"
		if (dpadToPress = dpadToPressPrev)  															;The correct key is already down (or no key is needed).
			return  																					;Do nothing.
		if (keyToHoldDown != "")
			Send, {%keyToHoldDown% up}  																;Releases previous POV button if it changed
		dpadToPressPrev := dpadToPress
		if (dpadToPress = "")																			;No button is to be pressed
			return
		if (isSwitchButtonHeld && isEventrButtonHeld)
			keyToHoldDown := Controller%dpadToPress%EventSwitch
		else if (isSwitchButtonHeld)
			keyToHoldDown := Controller%dpadToPress%switch
		else if (isEventButtonHeld)
			keyToHoldDown := Controller%dpadToPress%Event
		SendLevel, 1
		if (keyToHoldDown != "" && isEMUActive)
			Send, {%keyToHoldDown% down} 																;presses the KB&M key down
		SendLevel, 0
	}
return	

class ControllerButtonPair{
	ControllerButton := ""
	XInputButton := ""
	KeyboardKey := ""
	modifier := ""
		
	  __New(Controller, ControlButton, KeyboardKey, modifier := ""){
	    this.ControllerButton := Controller . "joy" . ControlButton
		this.KeyboardKey := KeyboardKey
		this.XInputButton := DIRECTINPUT_TO_XINPUT_MAPPING[ControlButton]
		if (modifier != "")
			this.modifier := modifier
	  }
	}
	


	;====================================================================== Included EXE files source codes ===========================================================================
	;====================================== EMULight-Controller.exe ============================
	; #SingleInstance Force
	; #InstallKeybdHook
	; #If WinActive("ahk_exe nothingButADummyProgramThatDoesntExist_FullWithInsaneCharactersToMakeSureItsNotTriggeréd°š78<_>.notAnActualExtension")
	; Menu, Tray, Icon, .\_images\icons\emu_controller_icon.ico,,
	; Menu, Tray, Tip , EMULight - Controller enabled
	; return
	
	;====================================== EMULight.exe ============================
	;~ #NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
	;~ SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
	;~ Run, _support_apps\AutoHotkeyU64.exe "EMULight.ahk"
	
	
	
	
	