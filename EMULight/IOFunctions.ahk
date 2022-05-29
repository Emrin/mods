;=============================================================================== SAVE/LOAD functions =============================================================================
; Saves all relevant settings into the current profile file
saveHotkeys(){
	global
	Gui, Submit, NoHide  																			; Save the input from the user to each control's associated variable.
	Gui, ADVSET:Submit, NoHide
	Gui, Revinds:Submit, NoHide
	;Sprint & Roll
		IniWrite, %systemRoll%, %EMUProfilePath%, Moveset, systemRoll
		IniWrite, %EnableRoll%, %EMUProfilePath%, Moveset, EnableRoll
		IniWrite, %PlayerRoll%, %EMUProfilePath%, Moveset, PlayerRoll
		IniWrite, %PlayerSprint%, %EMUProfilePath%, Moveset, PlayerSprint
		IniWrite, %RollCooldown%, %EMUProfilePath%, PlayerSettings, RollCooldown
		IniWrite, %SplitRollASprint%, %EMUProfilePath%, Moveset, SplitRollASprint
		IniWrite, %EnableSprintToggle%, %EMUProfilePath%, Moveset, EnableSprintToggle
	;POUCH
		IniWrite, %EnablePouch%, %EMUProfilePath%, POUCH, EnablePouch
		Loop 6	{
			IniWrite, % PlayerPouch%A_Index%, %EMUProfilePath%, POUCH, PlayerPouch%A_Index%
		}
	;Miscellaneous
		IniWrite, %EnableMiscellaneous%, %EMUProfilePath%, Miscellaneous, EnableMiscellaneous
		IniWrite, %PlayerTwoHand%, %EMUProfilePath%, Miscellaneous, PlayerTwoHand
		IniWrite, %PlayerOffHandTwoHand%, %EMUProfilePath%, Miscellaneous, PlayerOffHandTwoHand
		IniWrite, %PlayerMap%, %EMUProfilePath%, Miscellaneous, PlayerMap
		IniWrite, %PlayerPauseGame%, %EMUProfilePath%, Miscellaneous, PlayerPauseGame
		IniWrite, %borderlessWindow%, %EMUProfilePath%, Miscellaneous, borderlessWindow
		IniWrite, %PlayerPreviousQCslot%, %EMUProfilePath%, Miscellaneous, PlayerPreviousQCslot
		IniWrite, %PlayerPreviousQIslot%, %EMUProfilePath%, Miscellaneous, PlayerPreviousQIslot
	;STEAM CONTROL
		IniWrite, %PlayerToggle1%, %EMUProfilePath%, SteamControl, PlayerToggle1
		IniWrite, %PlayerToggle2%, %EMUProfilePath%, SteamControl, PlayerToggle2
		IniWrite, %PlayerTrnOn%, %EMUProfilePath%, SteamControl, PlayerTrnOn
		IniWrite, %PlayerTrnOff%, %EMUProfilePath%, SteamControl, PlayerTrnOff
		IniWrite, %SystemMinimumKeyPressDuration%, %EMUProfilePath%, SteamControl, SystemMinimumKeyPressDuration
	;CONTROLS
		IniWrite, %SystemSelectNextQCSlot%, %EMUProfilePath%, CONTROLS, SystemSelectNextQCSlot
		IniWrite, %SystemMouseSelectNextQCSlot%, %EMUProfilePath%, CONTROLS, SystemMouseSelectNextQCSlot
		IniWrite, %SystemSelectNextQISlot%, %EMUProfilePath%, CONTROLS, SystemSelectNextQISlot
		IniWrite, %SystemMouseSelectNextQISlot%, %EMUProfilePath%, CONTROLS, SystemMouseSelectNextQISlot
		IniWrite, %autoHUDhiding%, %EMUProfilePath%, CONTROLS, autoHUDhiding
		IniWrite, %SystemNextRH%, %EMUProfilePath%, CONTROLS, SystemNextRH
		IniWrite, %SystemNextLH%, %EMUProfilePath%, CONTROLS, SystemNextLH
		IniWrite, %SystemR1%, %EMUProfilePath%, CONTROLS, SystemR1
		IniWrite, %SystemR2%, %EMUProfilePath%, CONTROLS, SystemR2
		IniWrite, %SystemL1%, %EMUProfilePath%, CONTROLS, SystemL1
		IniWrite, %SystemEvent%, %EMUProfilePath%, CONTROLS, SystemEvent
	;MOVEMENT
		IniWrite, %PlayerW%, %EMUProfilePath%, Movement, PlayerW
		IniWrite, %PlayerA%, %EMUProfilePath%, Movement, PlayerA
		IniWrite, %PlayerS%, %EMUProfilePath%, Movement, PlayerS
		IniWrite, %PlayerD%, %EMUProfilePath%, Movement, PlayerD
	;SAVE BACKUP
		IniWrite, %BackupEnabled%, %EMUProfilePath%, BackUpSettings, BackupEnabled
		IniWrite, %SavePath%, %EMUProfilePath%, BackUpSettings, SavePath
	;ADVANCED SETTINGS
		IniWrite, %ADVSETbackstep%, %EMUProfilePath%, AdvancedSettings, sprintBackstep
		IniWrite, %ADVSETenableMenu%, %EMUProfilePath%, AdvancedSettings, enableMenu
		IniWrite, %ADVSETAttackCooldown%, %EMUProfilePath%, AdvancedSettings, AttackCooldown
		IniWrite, %ADVSETenableAttackCooldown%, %EMUProfilePath%, AdvancedSettings, enableAttackCooldown
		IniWrite, %ADVSETenableR1Cooldown%, %EMUProfilePath%, AdvancedSettings, enableR1Cooldown
		IniWrite, %ADVSETenableL1Cooldown%, %EMUProfilePath%, AdvancedSettings, enableL1Cooldown
		IniWrite, %ADVSETmaxbackups%, %EMUProfilePath%, AdvancedSettings, MaxNumberOfBackups
		if (ADVSETtargetbackup != "")
			IniWrite, %ADVSETtargetbackup%, %EMUProfilePath%, AdvancedSettings, BackUpFolderOverride
		else 
			IniWrite, %OutDir%, %EMUProfilePath%, AdvancedSettings, BackUpFolderOverride
		IniWrite, %ADVSEThotkeybackup%, %EMUProfilePath%, AdvancedSettings, backUpHotkey
		IniWrite, %ADVSETnamebackups%, %EMUProfilePath%, AdvancedSettings, backupDateFormat
		IniWrite, %ADVSETWindowEnable%, %EMUProfilePath%, AdvancedSettings, windowEnable
		IniWrite, %ADVSETWindowScale%, %EMUProfilePath%, AdvancedSettings, GUIWindowScale
	;MAGIC
		IniWrite, %EnableQC%, %EMUProfilePath%, Magic, EnableQC
		IniWrite, %playerChangeAttunement%, %EMUProfilePath%, Magic, playerChangeAttunement
		Loop 12	{
			IniWrite, % PlayerQC%A_Index%, %EMUProfilePath%, Magic, PlayerQC%A_Index%
			IniWrite, % PlayerQCCastKey%A_Index%, %EMUProfilePath%, Magic, PlayerQCCastKey%A_Index%
		}
		IniWrite, %maximumQCSlots%, %EMUProfilePath%, Magic, maximumQCSlots
		IniWrite, %PlayerUseQC%, %EMUProfilePath%, Magic, PlayerUseQC
		IniWrite, %EnableQCCastkeys%, %EMUProfilePath%, Magic, EnableQCCastkeys
	;QUICK ITEMS
		IniWrite, %EnableQI%, %EMUProfilePath%, QuickItems, EnableQI
		IniWrite, %playerChangeItem%, %EMUProfilePath%, QuickItems, playerChangeItem
		Loop 10	{
			IniWrite, % PlayerQI%A_Index%, %EMUProfilePath%, QuickItems, PlayerQI%A_Index%
		}
		IniWrite, %maximumQISlots%, %EMUProfilePath%, QuickItems, maximumQISlots
		IniWrite, %PlayerUseQI%, %EMUProfilePath%, QuickItems, PlayerUseQI		
	;CONTROLLER
		Loop 16	{
			IniWrite, % ZGUIController%A_Index%, %EMUProfilePath%, Controller, ZGUIController%A_Index%
			IniWrite, % ZGUIController%A_Index%switch, %EMUProfilePath%, Controller, ZGUIController%A_Index%switch
			IniWrite, % ZGUIController%A_Index%Event, %EMUProfilePath%, Controller, ZGUIController%A_Index%Event
			IniWrite, % ZGUIController%A_Index%Eventswitch, %EMUProfilePath%, Controller, ZGUIController%A_Index%Eventswitch
		}
		IniWrite, %SystemSwitchButton%, %EMUProfilePath%, Controller, SystemSwitchButton
		IniWrite, %SystemEventButton%, %EMUProfilePath%, Controller, SystemEventButton
		IniWrite, %EnableController%, %EMUProfilePath%, Controller, EnableController
		IniWrite, %joystick%, %EMUProfilePath%, Controller, joystick
		IniWrite, %ControllerInputType%, %EMUProfilePath%, Controller, ControllerInputType
	;REBINDS
		Loop 9 {
			IniWrite, % reSource%A_Index%, %EMUProfilePath%, Rebinds, reSource%A_Index%
			IniWrite, % reTarget%A_Index%, %EMUProfilePath%, Rebinds, reTarget%A_Index%
			IniWrite, % reSentSourceToGame%A_Index%, %EMUProfilePath%, Rebinds, reSentSourceToGame%A_Index%
		}
	;TOGGLES
		Loop 3 {
			IniWrite, % reToggler%A_Index%, %EMUProfilePath%, Rebinds, reToggler%A_Index%
			IniWrite, % reToggled%A_Index%, %EMUProfilePath%, Rebinds, reToggled%A_Index%
		}
		IniWrite, %EMUProfilePath%, %A_ScriptDir%\EMUsys.settings, Profile, EMUProfilePath
		SB_SetText("Settings saved to " . EMUProfilePath . ".") 									;set statusbar text
		
	saveCurrentSlots()
	return
}
	
; Saves currently selected spell and item	
saveCurrentSlots(){
	global
	IniWrite, %selectedQCSlot%, %EMUProfilePath%, Magic, selectedQCSlot
	IniWrite, %selectedQISlot%, %EMUProfilePath%, QuickItems, selectedQISlot
}

; Lets user pick a new profile file and calls saveHotkeys
SaveAsHotkeys(){
	global EMUProfilePath
	FileSelectFile, EMUProfilePath, S16,  %EMUProfilePath% , "Select file with settings", settings file (*.ini)
	SplitPath, EMUProfilePath, name, ,ext
	if (ext = "") 																					;if you did not type the extension in the save dialog box it will be added.
	   EMUProfilePath=%EMUProfilePath%.ini
	IniWrite, %EMUProfilePath%, %A_ScriptDir%\EMUsys.settings, Profile, EMUProfilePath
	SaveHotkeys()
	return
}


loadHotkeyIntoGUI(category, guiElement, defaultKey, differentGuiWindow := false, differentGuiElement := false){
	global EMUProfilePath
	IniRead, OutputVar, %EMUProfilePath%, %category%, %guiElement%, %defaultKey% 					;loads value from profile file
	if (guiElement != "SavePath")
		StringLower, OutputVar, OutputVar 																;converts to lowercase
	if (differentGuiElement != false && differentGuiWindow!= false){ 								;different gui window and different gui element has been specified
		if (OutputVar != "ERROR" && differentGuiElement != "" && differentGuiWindow != "") 										
			GuiControl,%differentGuiWindow%, %differentGuiElement%, %OutputVar% 					;changes the specified differentGuiElement in the specified differentGuiWindow
	}else if(differentGuiWindow != false){
		if (OutputVar != "ERROR" && differentGuiElement != "") 	
		GuiControl,%differentGuiWindow%, %guiElement%, %OutputVar% 
	}else{
		if (OutputVar != "ERROR" && guiElement != "") 												
			GuiControl,, %guiElement%, %OutputVar% 													;changes the default gui window guiElement
	}	
}

; Loads all relevant settings from the current profile file and updates the GUI
Loadhotkeys(){
	global
	if (isEMUActive){
		EMUButtonActivate()  																	;deactivates hotkeys in case they are active
		ToggleHotkey("off")
	}
	; TOGGLES
		loadHotkeyIntoGUI("Moveset", "EnableRoll", "1")
		loadHotkeyIntoGUI("Moveset", "SplitRollASprint", "1")
		loadHotkeyIntoGUI("POUCH", "EnablePouch", "0")
		loadHotkeyIntoGUI("Magic", "EnableQC", "1")
		loadHotkeyIntoGUI("QuickItems", "EnableQI", "0")
		loadHotkeyIntoGUI("Controller", "EnableController", "0")
		loadHotkeyIntoGUI("Moveset", "EnableSprintToggle", "0")
		loadHotkeyIntoGUI("CONTROLS", "autoHUDhiding", "0")
		loadHotkeyIntoGUI("Miscellaneous", "EnableMiscellaneous", "0")
		IniRead, OutputVar, %EMUProfilePath%, Controller, ControllerInputType, 1 					;loads list value of choosen switch button 
		if (OutputVar != "ERROR")
			GuiControl, EMU:Choose ,ControllerInputType, %OutputVar% 
		ToggleGUIElements()
	;MOVESET
		IniRead, OutputVar, %EMUProfilePath%, Moveset, systemRoll, "o" 					;loads list value of choosen switch button 
		if (OutputVar != "ERROR")
			GuiControl, EMU:Choose ,systemRoll, %OutputVar% 
		loadHotkeyIntoGUI("Moveset", "PlayerRoll", "space")
		loadHotkeyIntoGUI("Moveset", "PlayerSprint", "lshift")
	;CONTROLS
		loadHotkeyIntoGUI("CONTROLS", "SystemSelectNextQCSlot", "k")
		loadHotkeyIntoGUI("CONTROLS", "SystemMouseSelectNextQCSlot", "")
		loadHotkeyIntoGUI("CONTROLS", "SystemSelectNextQISlot", "l")
		loadHotkeyIntoGUI("CONTROLS", "SystemMouseSelectNextQISlot", "")
		loadHotkeyIntoGUI("CONTROLS", "SystemNextRH", "right")
		loadHotkeyIntoGUI("CONTROLS", "SystemNextLH", "left")
		loadHotkeyIntoGUI("CONTROLS", "SystemR1", "lbutton")
		loadHotkeyIntoGUI("CONTROLS", "SystemR2", "u")
		loadHotkeyIntoGUI("CONTROLS", "SystemL1", "rbutton")
		loadHotkeyIntoGUI("CONTROLS", "SystemEvent", "e")
	;POUCH
		loadHotkeyIntoGUI("POUCH", "PlayerPouch1", "c")
		loadHotkeyIntoGUI("POUCH", "PlayerPouch2", "v")
		loadHotkeyIntoGUI("POUCH", "PlayerPouch3", "b")
		loadHotkeyIntoGUI("POUCH", "PlayerPouch4", "n")
		loadHotkeyIntoGUI("POUCH", "PlayerPouch5", "")
		loadHotkeyIntoGUI("POUCH", "PlayerPouch6", "")
	;Miscellaneous
		loadHotkeyIntoGUI("Miscellaneous", "PlayerTwoHand", "lalt")
		loadHotkeyIntoGUI("Miscellaneous", "PlayerOffHandTwoHand", "")
		loadHotkeyIntoGUI("Miscellaneous", "PlayerMap", "m")
		loadHotkeyIntoGUI("Miscellaneous", "PlayerPauseGame", "pause")
		loadHotkeyIntoGUI("Miscellaneous", "borderlessWindow", "0")
		loadHotkeyIntoGUI("Miscellaneous", "PlayerPreviousQCslot", "")
		loadHotkeyIntoGUI("Miscellaneous", "PlayerPreviousQIslot", "")
	;STEAM CONTROL
		loadHotkeyIntoGUI("SteamControl", "PlayerToggle1", "+tab")
		loadHotkeyIntoGUI("SteamControl", "PlayerToggle2", "+``")
		loadHotkeyIntoGUI("SteamControl", "PlayerTrnOn", "PgUp")
		loadHotkeyIntoGUI("SteamControl", "PlayerTrnOff", "PgDn")
		loadHotkeyIntoGUI("SteamControl", "SystemMinimumKeyPressDuration", "23")
	;PLAYERSETTINGS
		loadHotkeyIntoGUI("PlayerSettings", "RollCooldown", "300")
	;SAVE BACKUP
		loadHotkeyIntoGUI("BackUpSettings", "BackupEnabled", "0")
		loadHotkeyIntoGUI("BackUpSettings", "SavePath", "")
	;ADVANCED SETTINGS
		loadHotkeyIntoGUI("AdvancedSettings", "sprintBackstep", "0","ADVSET:", "ADVSETbackstep")
		loadHotkeyIntoGUI("AdvancedSettings", "enableMenu", "0","ADVSET:", "ADVSETenableMenu")
		loadHotkeyIntoGUI("AdvancedSettings", "enableAttackCooldown", "0","ADVSET:", "ADVSETenableAttackCooldown")
		loadHotkeyIntoGUI("AdvancedSettings", "AttackCooldown", "300","ADVSET:", "ADVSETAttackCooldown")
		loadHotkeyIntoGUI("AdvancedSettings", "enableR1Cooldown", "1","ADVSET:", "ADVSETenableR1Cooldown")
		loadHotkeyIntoGUI("AdvancedSettings", "enableL1Cooldown", "0","ADVSET:", "ADVSETenableL1Cooldown")
		loadHotkeyIntoGUI("AdvancedSettings", "MaxNumberOfBackups", "8", "ADVSET:", "ADVSETmaxbackups")
		loadHotkeyIntoGUI("AdvancedSettings", "BackUpFolderOverride", "", "ADVSET:", "ADVSETtargetbackup")
		loadHotkeyIntoGUI("AdvancedSettings", "backUpHotkey", "", "ADVSET:", "ADVSEThotkeybackup")
		IniRead, OutputVar, %EMUProfilePath%, AdvancedSettings, backupDateFormat, yyyy-MM-dd		;cannot use loadHotkeyIntoGUI(), because it converts to lowercase.
		if (OutputVar != "ERROR")
			GuiControl, ADVSET:, ADVSETnamebackups, %OutputVar%
		loadHotkeyIntoGUI("AdvancedSettings", "windowEnable", "0", "ADVSET:", "ADVSETWindowEnable")
		loadHotkeyIntoGUI("AdvancedSettings", "GUIWindowScale", "", "ADVSET:", "ADVSETWindowScale")
	;MOVEMENT
		loadHotkeyIntoGUI("Movement", "PlayerW", "w")
		loadHotkeyIntoGUI("Movement", "PlayerA", "a")
		loadHotkeyIntoGUI("Movement", "PlayerS", "s")
		loadHotkeyIntoGUI("Movement", "PlayerD", "d")
	;MAGIC
		Loop 12 {
			if (A_Index = 11)
				loadHotkeyIntoGUI("Magic", "PlayerQC" . A_Index, "-")
			else if (A_Index = 12)
				loadHotkeyIntoGUI("Magic", "PlayerQC" . A_Index, "=")
			else
			loadHotkeyIntoGUI("Magic", "PlayerQC" . A_Index, mod(A_Index,10))
			loadHotkeyIntoGUI("Magic", "PlayerQCCastKey" . A_Index, "")
		}
		IniRead, selectedQCSlot, %EMUProfilePath%, Magic, selectedQCSlot, 1 
		loadHotkeyIntoGUI("Magic", "playerChangeAttunement", "m")
		IniRead, OutputVar, %EMUProfilePath%, Magic, maximumQCSlots, 3 						;loads list value of attuned spells 
		if (OutputVar != "ERROR")
			GuiControl, EMU:Choose ,maximumQCSlots, %OutputVar% 								;list - doesnt use the loadHotkeyIntoGUI function
		loadHotkeyIntoGUI("Magic", "PlayerUseQC", "rbutton")
		loadHotkeyIntoGUI("Magic", "EnableQCCastkeys", "0")
	;QUICKITEMS	
		Loop 10 {
			loadHotkeyIntoGUI("QuickItems", "PlayerQI" . A_Index, "")
		}
		IniRead, selectedQISlot, %EMUProfilePath%, QuickItems, selectedQISlot, 1 
		loadHotkeyIntoGUI("QuickItems", "playerChangeItem", "i")
		IniRead, OutputVar, %EMUProfilePath%, QuickItems, maximumQISlots, 5 						;loads list value of attuned spells 
		if (OutputVar != "ERROR")
			GuiControl, EMU:Choose ,maximumQISlots, %OutputVar% 								;list - doesnt use the loadHotkeyIntoGUI function
		loadHotkeyIntoGUI("QuickItems", "PlayerUseQI", "r")
	;CONTROLLER
		Loop 16 {
			loadHotkeyIntoGUI("Controller", "ZGUIController" . A_Index, "")
			loadHotkeyIntoGUI("Controller", "ZGUIController" . A_Index . "switch", "")
			loadHotkeyIntoGUI("Controller", "ZGUIController" . A_Index . "Event", "")
			loadHotkeyIntoGUI("Controller", "ZGUIController" . A_Index . "Eventswitch", "")
		}
		IniRead, OutputVar, %EMUProfilePath%, Controller, SystemSwitchButton, 12 					;loads list value of choosen switch button 
		if (OutputVar != "ERROR")
			GuiControl, EMU:Choose ,SystemSwitchButton, %OutputVar% 							;list - doesnt use the loadHotkeyIntoGUI function
		IniRead, OutputVar, %EMUProfilePath%, Controller, SystemEventButton, 12 					;loads list value of choosen switch button 
		if (OutputVar != "ERROR")
			GuiControl, EMU:Choose ,SystemEventButton, %OutputVar% 							;list - doesnt use the loadHotkeyIntoGUI function	
		IniRead, OutputVar, %EMUProfilePath%, Controller, joystick, 1 
		if (OutputVar != "ERROR")
			GuiControl, EMU:ChooseString ,joystick, %OutputVar% 
	;REBINDS	
		Loop 9 {
		loadHotkeyIntoGUI("Rebinds", "reSource" . A_Index, "", "REBINDS:")	
		loadHotkeyIntoGUI("Rebinds", "reTarget" . A_Index, "", "REBINDS:")	
		loadHotkeyIntoGUI("Rebinds", "reSentSourceToGame" . A_Index, "0", "REBINDS:")	
		}	
	;TOGGLES	
		Loop 3 {
		loadHotkeyIntoGUI("Rebinds", "reToggler" . A_Index, "", "REBINDS:")	
		loadHotkeyIntoGUI("Rebinds", "reToggled" . A_Index, "", "REBINDS:")	
		}	
		ToggleGUIElements() 																		;calls gui toggle function to update the gui
		SB_SetText("Settings loaded from " . EMUProfilePath . ".") 									;set statusbar text
}

; Lets user pick a new profile file and calls loadHotkeys
OpenHotkeys(){
	global EMUProfilePath
	FileSelectFile, EMUProfilePath,, %A_ScriptDir%\profiles\ , "Select file with settings", settings file (*.ini)
	if (EMUProfilePath = ""){
		EMUProfilePath := profileFile	
		return
	}	
	SB_SetText("Settings from " . EMUProfilePath . " has been loaded.") 							;set statusbar text
	IniWrite, %EMUProfilePath%, %A_ScriptDir%\EMUsys.settings, Profile, EMUProfilePath
	Loadhotkeys()
	return
}



; Checks the backup directory, removes old backups if necessary, creates a new backup
BackUpSaveFile(){ 
	global ADVSETtargetbackup,ADVSETnamebackups,ADVSETmaxbackups,SavePath
	FileList = ;        
	NumberOfBackups = 0;
	Gui, ADVSET:Submit, NoHide
	if (ADVSETtargetbackup != "")
		OutDir := ADVSETtargetbackup 																;the folder to save backups was specified in advanced settings
	else
		SplitPath, SavePath , , OutDir, 															;the folder to save backups is the same the location of DaS save files
	OutDir := OutDir . "\EMUsaveBackUp\"
	Loop, Files, %OutDir%*.backup 
	{
		FileList = %FileList%%A_LoopFileTimeCreated%`t%A_LoopFileFullPath%`n    					;Save list of file names and creation dates to a string
		NumberOfBackups := A_Index
	}
	Sort, FileList  																				;sorts the file list by name (which is also its date)
	FilesToDelete := NumberOfBackups - ADVSETmaxbackups 											;decides how many old saves to be deleted
	Loop, parse, FileList, `n     
	{                                         														;Get first file name on list 
		if (FilesToDelete < 1)
			break																					;No need to delete more files
		StringSplit, Target, A_LoopField, %A_Tab%                        							;Split into two parts at the tab char.
		FileDelete, %Target2%                                            							;Save the name
		FilesToDelete--
	}      
	if (SavePath = ""){
		SB_SetText("Cannot create a save backup - No save file selected") 							
		return 																						;Savepath is empty - error state. 
	}
	FormatTime, CurrentDateTime,A_Now, % ADVSETnamebackups
	SplitPath, SavePath , OutFileName, OutDir, OutExtension, OutNameNoExt, OutDrive					;prepares all file path variables
	if (ADVSETtargetbackup != "")
		outDir := ADVSETtargetbackup
	SB_SetText("Save file backed up to " . OutDir . "\EMUsaveBackUp\" . OutNameNoExt . "_" . CurrentDateTime . "." OutExtension . ".backup") 				
	FileCreateDir, %OutDir%\EMUsaveBackUp\
	FileCopy, %SavePath%, %OutDir%\EMUsaveBackUp\%OutNameNoExt%_%CurrentDateTime%.%OutExtension%.backup, 1 ; Creates backup of save file
}

; Lets user pick the path to DaS save file to be backedup
SelectSaveFilePath(){
	FileSelectFile, SavePath,, C:\Users\%A_UserName%\AppData\Roaming\EldenRing , Select game's save file, Save file (*.SL2)
	if (SavePath = ""){
		SB_SetText("Error: No file selected") 														
		return
	}	
	GuiControl, , SavePath, % SavePath
	SB_SetText("Save file selected - " . SavePath) 													
}