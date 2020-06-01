ScriptName Metro:Context extends Quest
import Shared:Compatibility
import Shared:Log


UserLog Log
Version LastVersion
bool Activated = false

CustomEvent OnStartup
CustomEvent OnUpgrade
CustomEvent OnShutdown


; Events
;---------------------------------------------

Event OnInit()
	Log = new UserLog
	Log.Caller = self
	Log.FileName = Title
	Activated = false
	LastVersion = Release
	RegisterForRemoteEvent(Game.GetPlayer(), "OnPlayerLoadGame")
	RegisterForRemoteEvent(Game.GetPlayer(), "OnLocationChange")
	If(HasHolotape == false)
		Game.GetPlayer().AddItem(Metro_ContextHolotape, 1)
	EndIf
EndEvent


Event OnQuestInit()
	WriteLine(Log, "OnQuestInit")
	IsActivated = true
EndEvent


Event OnStageSet(int auiStageID, int auiItemID)
	WriteLine(Log, "Quest.OnStageSet")
	IsActivated = true
EndEvent


Event Actor.OnPlayerLoadGame(Actor akSender)
	WriteLine(Log, "Reloaded "+Title+" version "+VersionToString(Release))
	Version versionNew = Release
	Version versionPrevious = LastVersion

	If (VersionGreaterThan(versionNew, versionPrevious))
		WriteChangedValue(Log, "Version", versionPrevious, versionNew)
		LastVersion = versionNew
		var[] arguments = new var[2]
		arguments[0] = versionNew
		arguments[1] = versionPrevious
		SendCustomEvent("OnUpgrade", arguments)
	Else
		WriteLine(Log, "No version change so doing nothing at all..")
	EndIf
EndEvent

Event Actor.OnLocationChange(Actor akSender, Location akOldLoc, Location akNewLoc)
	If (akNewLoc != PreWarSanctuary && akNewLoc != PreWarVault111)
		WriteLine(Log, "Leaving PreWarSanctuary, Activating...")
		If (IsActivated) 
			UnregisterForRemoteEvent(Game.GetPlayer(), "OnLocationChange")
		Else
			IsActivated = True
			UnregisterForRemoteEvent(Game.GetPlayer(), "OnLocationChange")
		EndIf
	EndIf
EndEvent




; Globals
;---------------------------------------------

string Function GetTitle() Global
	return "Gas Masks of the Wasteland"
EndFunction


string Function GetPlugin() Global
	return "Gas Masks of the Wasteland.esp"
EndFunction


int Function GetEditorID() Global
	return 0x00006381
EndFunction


Context Function GetInstance() Global
	ExternalForm contextInstance = new ExternalForm
	contextInstance.FormID = GetEditorID()
	contextInstance.PluginFile = GetPlugin()
	return GetExternalForm(contextInstance) as Context
EndFunction


UserLog Function GetLog(ScriptObject aScriptObject) Global DebugOnly
	UserLog contextLog = new UserLog
	contextLog.Caller = aScriptObject
	contextLog.FileName = GetTitle()
	return contextLog
EndFunction

Function Preset(int choice)
	If (choice == 0)
		WriteLine(Log, "Survival Preset Chosen")
	ElseIf (choice == 1)
		WriteLine(Log, "Medium Preset Chosen")
		WriteLine(Log, "Precipitation Only Radiation")
		Radiation.WeatherOnly = true
		Radiation.RadWeatherOnly = false
		Radiation.NoRadiation = false
	ElseIf (choice == 2)
		WriteLine(Log, "Easy Preset Chosen")
		WriteLine(Log, "Rad Weather Only Radiation")
		Radiation.RadWeatherOnly = true
		Radiation.WeatherOnly = false
		Radiation.NoRadiation = false
	ElseIf (choice == 3)
		WriteLine(Log, "Immersion Preset Chosen")
		GasMask_PlayerDamage_Toggle.SetValueInt(0)
		GasMask_NPCDamage_Toggle.SetValue(0.0)
		Radiation.NoRadiation = true
		Radiation.WeatherOnly = false
		Radiation.RadWeatherOnly = false
	EndIf
EndFunction


; Properties
;---------------------------------------------

Group Context
	string Property Title Hidden
		string Function Get()
			return GetTitle()
		EndFunction
	EndProperty

	string[] Property Authors Hidden
		string[] Function Get()
			string[] strings = new string[3]
			strings[0] = "D1v1ne122"
			strings[1] = "MaxG3D"
			strings[2] = "Scrivener07"
			return strings
		EndFunction
	EndProperty

	string Property Plugin Hidden
		string Function Get()
			return GetPlugin()
		EndFunction
	EndProperty

	int Property EditorID Hidden
		int Function Get()
			return GetEditorID()
		EndFunction
	EndProperty

	Version Property Release Hidden
		Version Function Get()
			Version ver = new Version
			ver.Distribution = false
			ver.Major = 1
			ver.Minor = 0
			ver.Build = 6
			ver.Revision = 1
			return ver
		EndFunction
	EndProperty
EndGroup


Group Conditions
	Quest property MQ102 Auto Const Mandatory
	Location property PreWarSanctuary Auto Const Mandatory
	Location property PreWarVault111 Auto Const Mandatory
	
	bool Property IsReady Hidden
		bool Function Get()
			return (MQ102.IsStageDone(1) || (Game.GetPlayer().GetCurrentLocation() != PreWarSanctuary && Game.GetPlayer().GetCurrentLocation() != PreWarVault111))
		EndFunction
	EndProperty

	bool Property IsActivated Hidden
		bool Function Get()
			return Activated
		EndFunction
		Function Set(bool aValue)
			If (Activated == aValue)
				WriteLine(Log, "Activated is already equal to "+aValue)
				return
			Else
				If (IsReady)
					Activated = aValue
					If (aValue)
						WriteNotification(Log, Title+" is starting..")
						If(HasHolotape == false)
							Game.GetPlayer().AddItem(Metro_ContextHolotape, 1)
						EndIf
						SendCustomEvent("OnStartup")
						;I should add widget location X/Y for convenience
						
						; Preset Options ---------------------------------
						int option = GasMask_Start_Preset.Show()
						If (option < 4)
							Preset(option)
						ElseIf(option == 4)
							WriteLine(Log, "Custom Preset Chosen")
						;-------------------------------------------------
						
							; Radiation Options ---------------------------------
							option = GasMask_Start_RadiationMode.Show()
							If(option == 0)
								WriteLine(Log, "Normal Radiation")
								Radiation.NoRadiation = false
								Radiation.WeatherOnly = false
								Radiation.RadWeatherOnly = false
							ElseIf(option == 1)
								WriteLine(Log, "Precipitation Only Radiation")
								Radiation.WeatherOnly = true
								Radiation.RadWeatherOnly = false
								Radiation.NoRadiation = false
							ElseIf(option == 2)
								WriteLine(Log, "Rad Weather Only Radiation")
								Radiation.RadWeatherOnly = true
								Radiation.WeatherOnly = false
								Radiation.NoRadiation = false
							ElseIf(option == 3)
								WriteLine(Log, "No Radiation")
								Radiation.NoRadiation = true
								Radiation.WeatherOnly = false
								Radiation.RadWeatherOnly = false
							EndIf
							;-----------------------------------------------------
							
							; Filter Duration Options --------------------------
							option = GasMask_Start_FilterDuration.Show()
							If(option == 0)
								Filter.Interval = 10
							ElseIf(option == 1)
								Filter.Interval = 20
							ElseIf(option == 2)
								Filter.Interval = 30
							ElseIf(option == 3)
								Filter.Interval = 40
							ElseIf(option == 4)
								Filter.Interval = 50
							ElseIf(option == 5)
								Filter.Interval = 60
							ElseIf(option == 6)
								Filter.Interval = 70
							ElseIf(option == 7)
								Filter.Interval = 120
							EndIf
							WriteLine(Log, "Filter Duration: " + Filter.Interval)
							;----------------------------------------------------
							
							; Radiation Options ---------------------------------
							option = GasMask_Start_NPCEquip.Show()
							If(option == 0)
								NPCEquipMode.Equip = true
							ElseIf(option == 1)
								NPCEquipMode.Equip = false
							EndIf
							WriteLine(Log, "NPC Equip Mode: " + NPCEquipMode.Equip)
							;-----------------------------------------------------
							
							; DustStorm Options ---------------------------------
							option = GasMask_Start_DustStorms.Show()
							If(option == 0)
								Climate.Mode = Climate.ModeHeavy
							ElseIf(option == 1)
								Climate.Mode = Climate.ModeLite
							ElseIf(option == 2)
								Climate.Mode = Climate.ModeNone
							EndIf
							WriteLine(Log, "Climate Mode: " + Climate.Mode)
							;-----------------------------------------------------
							
							; NPC Damage Options ---------------------------------
							option = GasMask_Start_NPCDamage.Show()
							If(option == 0)
								GasMask_NPCDamage_Toggle.SetValue(1.0)
							ElseIf(option == 1)
								GasMask_NPCDamage_Toggle.SetValue(0.0)
							EndIf
							WriteLine(Log, "NPC Gas Mask Damage: " + GasMask_NPCDamage_Toggle)
							;-----------------------------------------------------
							
							; Player Damage Options ---------------------------------
							option = GasMask_Start_PlayerDamage.Show()
							If(option == 0)
								GasMask_PlayerDamage_Toggle.SetValueInt(1)
							ElseIf(option == 1)
								GasMask_PlayerDamage_Toggle.SetValueInt(0)
							EndIf
							WriteLine(Log, "Player Gas Mask Damage: " + GasMask_PlayerDamage_Toggle)
							;-----------------------------------------------------
							
							; Environmental VFX Options ---------------------------------
							option = GasMask_Start_EnvironmentalVFX.Show()
							If(option == 0)
								WriteLine(Log, "Environmental VFX")
								MaskWipe.MaskWipeActivate = true
								BloodVFX.BloodToggle = true
								MudVFX.DirtToggle = true
								RainVFX.RainToggle = true
								SnowVFX.SnowToggle = true
								DustVFX.DustToggle = true
							ElseIf(option == 1)
								WriteLine(Log, "No Environmental VFX")
								MaskWipe.MaskWipeActivate = false
								BloodVFX.BloodToggle = false
								MudVFX.DirtToggle = false
								RainVFX.RainToggle = false
								SnowVFX.SnowToggle = false
								DustVFX.DustToggle = false
							ElseIf(option == 2)
								WriteLine(Log, "Custom Environmental VFX")
							;-----------------------------------------------------
							
								; Rain VFX Options ---------------------------------
								option = GasMask_Start_RainVFX.Show()
								If(option == 0)
									RainVFX.RainToggle = true
								ElseIf(option == 1)
									RainVFX.RainToggle = false
								EndIf
								WriteLine(Log, "Rain Toggle: " + RainVFX.RainToggle)
								;-----------------------------------------------------
								
								; Blood VFX Options ---------------------------------
								option = GasMask_Start_BloodVFX.Show()
								If(option == 0)
									BloodVFX.BloodToggle = true
								ElseIf(option == 1)
									BloodVFX.BloodToggle = false
								EndIf
								WriteLine(Log, "Blood Toggle: " + BloodVFX.BloodToggle)
								;-----------------------------------------------------
								
								; Dirt VFX Options ---------------------------------
								option = GasMask_Start_DirtVFX.Show()
								If(option == 0)
									MudVFX.DirtToggle = true
								ElseIf(option == 1)
									MudVFX.DirtToggle = false
								EndIf
								WriteLine(Log, "Dirt Toggle: " + MudVFX.DirtToggle)
								;-----------------------------------------------------
								
								; Dust VFX Options ---------------------------------
								option = GasMask_Start_DustVFX.Show()
								If(option == 0)
									DustVFX.DustToggle = true
								ElseIf(option == 1)
									DustVFX.DustToggle = false
								EndIf
								WriteLine(Log, "Dust Toggle: " + DustVFX.DustToggle)
								;-----------------------------------------------------
								
								; Snow VFX Options ---------------------------------
								option = GasMask_Start_SnowVFX.Show()
								If(option == 0)
									SnowVFX.SnowToggle = true
								ElseIf(option == 1)
									SnowVFX.SnowToggle = false
								EndIf
								WriteLine(Log, "Snow Toggle: " + SnowVFX.SnowToggle)
								;-----------------------------------------------------
							
							EndIf
							
						EndIf
						; More -----------------------------------------------
						If (GasMask_StartMessage1.Show() == 0)
							If (GasMask_StartMessage2.Show() == 0)
								 GasMask_StartMessage3.Show()
							EndIf
						EndIf
						;-----------------------------------------------------
						Game.GetPlayer().AddPerk(GasMask_NPCDamagePerk)
					Else
						WriteNotification(Log, Title+" is shutting down.")
						SendCustomEvent("OnShutdown")
					EndIf
					UnregisterForRemoteEvent(MQ102, "OnStageSet")
				Else
					WriteLine(Log, Title+" is not ready.")
					RegisterForRemoteEvent(MQ102, "OnStageSet")
				EndIf
			EndIf
		EndFunction
	EndProperty
EndGroup

Group Scripts
	Gear:Filter Property Filter Auto Const Mandatory
	Metro:Gear:MaskWipe Property MaskWipe Auto Const Mandatory
	Metro:Gear:BloodVFX Property BloodVFX Auto Const Mandatory
	Metro:Gear:MudVFX Property MudVFX Auto Const Mandatory
	Metro:Gear:RainVFX Property RainVFX Auto Const Mandatory
	Metro:Gear:SnowVFX Property SnowVFX Auto Const Mandatory
	Metro:Gear:DustVFX Property DustVFX Auto Const Mandatory
	Metro:Gear:PlayerDamage Property PlayerDamage Auto Const Mandatory
	World:Climate Property Climate Auto Const Mandatory
	World:Radiation Property Radiation Auto Const Mandatory
	Metro:Terminals:NPCEquipMode Property NPCEquipMode Auto Const Mandatory
EndGroup

Group Properties
	GlobalVariable Property GasMask_NPCDamage_Toggle Auto
	GlobalVariable Property GasMask_PlayerDamage_Toggle Auto
	Message Property GasMask_StartMessage1 Auto
	Message Property GasMask_StartMessage2 Auto
	Message Property GasMask_StartMessage3 Auto
	Message Property GasMask_Start_Preset Auto
	Message Property GasMask_Start_RadiationMode Auto
	Message Property GasMask_Start_FilterDuration Auto
	Message Property GasMask_Start_NPCEquip Auto
	Message	Property GasMask_Start_DustStorms Auto
	Message Property GasMask_Start_NPCDamage Auto
	Message Property GasMask_Start_PlayerDamage Auto
	Message Property GasMask_Start_EnvironmentalVFX Auto
	Message Property GasMask_Start_RainVFX Auto
	Message Property GasMask_Start_BloodVFX Auto 
	Message Property GasMask_Start_DirtVFX Auto
	Message Property GasMask_Start_DustVFX Auto
	Message Property GasMask_Start_SnowVFX Auto
	Perk Property GasMask_NPCDamagePerk Auto Const
	Holotape Property Metro_ContextHolotape Auto Const Mandatory
EndGroup

Group Setup
	bool Property HasHolotape Hidden
		bool Function Get()
			return Game.GetPlayer().GetItemCount(Metro_ContextHolotape) >= 1
		EndFunction
	EndProperty
EndGroup
