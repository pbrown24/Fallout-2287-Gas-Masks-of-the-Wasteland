Scriptname Metro:Gear:MaskBreathing extends Metro:Core:Required
{QUST:Metro_Gear}
import Metro
import Metro:Player:Animation
import Shared:Log


UserLog Log

ImageSpaceModifier FX
int ExposureStrength = 1 const
int GasMaskONTimer = 1
int GasMaskOFFTimer = 2
bool CanDecrease = false
CustomEvent DecreaseSprinting

; Events
;---------------------------------------------

Event OnInitialize()
	Log = new UserLog
	Log.Caller = self
	Log.FileName = "MaskBreathing"
	FX = Metro_RadiationScreenFX
EndEvent


Event OnEnable()
	RegisterForCustomEvent(GearMaskBreathingPreset, "OnChanged")
	RegisterForCustomEvent(Mask, "OnChanged")
	RegisterForCustomEvent(Filter, "OnReplaced")
	RegisterForRemoteEvent(Game.GetPlayer(), "OnPlayerLoadGame")
	GoToState("ActiveState")
EndEvent


Event OnDisable()
	UnregisterForCustomEvent(GearMaskBreathingPreset, "OnChanged")
	UnregisterForCustomEvent(Mask, "OnChanged")
	UnRegisterForCustomEvent(Filter, "OnReplaced")
	UnRegisterForRemoteEvent(Game.GetPlayer(), "OnPlayerLoadGame")
	GoToState("")
EndEvent


; Methods
;---------------------------------------------

State ActiveState
	
	Event Actor.OnPlayerLoadGame(Actor akSender)
		If (Mask.IsGasMask || Mask.IsPowerArmor)
			CancelTimer(GasMaskOFFTimer)
			Player.DispelSpell(GasMask_ChokingHandler)
			StartTimer(1.0, GasMaskONTimer)
		Else
			CancelTimer(GasMaskONTimer)
			Player.DispelSpell(GasMask_CoughingHandler)
			Player.DispelSpell(GasMask_SprintingHandler)
			Player.DispelSpell(GasMask_BreathingHandler)
			Player.DispelSpell(GasMask_ChokingHandler)
			StartTimer(1.0, GasMaskOFFTimer)
		EndIf
	EndEvent
	
	Event OnTimer(int aiTimerID)
		
		If aiTimerID == GasMaskONTimer
			If Player.isTalking()
				StartTimer(1.0, GasMaskONTimer)
			ElseIf Player.isSprinting() && (Player.HasMagicEffect(GasMask_SprintingHandler_MGEF) == False) && (Player.HasMagicEffect(GasMask_RadiationEffect) == False)
				WriteLine(Log,"MaskBreathing: Sprinting")
				CanDecrease = true
				Player.DispelSpell(GasMask_CoughingHandler)
				;Player.DispelSpell(GasMask_SprintingHandler)
				Player.DispelSpell(GasMask_BreathingHandler)
				Player.DispelSpell(GasMask_ChokingHandler)
				GasMask_SprintingHandler.Cast(Player, Player)
				WriteLine(Log, "Started Sprinting SFX")
				StartTimer(0.25, GasMaskONTimer)
			ElseIf (Player.isSprinting() == false) && (Player.HasMagicEffect(GasMask_SprintingHandler_MGEF)) && CanDecrease
				CanDecrease = false
				SendCustomEvent("DecreaseSprinting")
				WriteLine(Log,"MaskBreathing: Decrease Sprinting")
				StartTimer(0.25, GasMaskONTimer)
			ElseIf (Filter.Charge <= 5.0) && (Filter.Charge > 0.0) && (Player.HasMagicEffect(GasMask_CoughingHandler_MGEF) == False) && (Player.HasMagicEffect(GasMask_RadiationEffect) == False)
				WriteLine(Log,"MaskBreathing: Coughing")
				;Player.DispelSpell(GasMask_CoughingHandler)
				Player.DispelSpell(GasMask_SprintingHandler)
				Player.DispelSpell(GasMask_BreathingHandler)
				Player.DispelSpell(GasMask_ChokingHandler)
				GasMask_CoughingHandler.Cast(Player, Player)
				WriteLine(Log, "Started Coughing SFX")
				StartTimer(1.0, GasMaskONTimer)
			ElseIf Player.HasMagicEffect(GasMask_RadiationEffect) && (Player.HasMagicEffect(GasMask_ChokingHandler_MGEF) == False)
				WriteLine(Log,"MaskBreathing: Choking")
				Player.DispelSpell(GasMask_CoughingHandler)
				Player.DispelSpell(GasMask_SprintingHandler)
				Player.DispelSpell(GasMask_BreathingHandler)
				;Player.DispelSpell(GasMask_ChokingHandler)
				GasMask_ChokingHandler.Cast(Player,Player)
				WriteLine(Log, "Started Choking SFX")
				StartTimer(1.0, GasMaskONTimer)
			ElseIf (Player.HasMagicEffect(GasMask_BreathingHandler_MGEF) == False) && (Player.HasMagicEffect(GasMask_SprintingHandler_MGEF) == False) && (Player.HasMagicEffect(GasMask_ChokingHandler_MGEF) == False) && (Player.HasMagicEffect(GasMask_CoughingHandler_MGEF) == False)
				WriteLine(Log,"MaskBreathing: Breathing")
				Player.DispelSpell(GasMask_CoughingHandler)
				Player.DispelSpell(GasMask_SprintingHandler)
				;Player.DispelSpell(GasMask_BreathingHandler)
				Player.DispelSpell(GasMask_ChokingHandler)
				GasMask_BreathingHandler.Cast(Player,Player)
				WriteLine(Log, "Started Breathing SFX")
				StartTimer(1.0, GasMaskONTimer)
			Else
				StartTimer(1.0, GasMaskONTimer)
			EndIf
		ElseIf aiTimerId == GasMaskOFFTimer
			If Player.HasMagicEffect(GasMask_RadiationEffect) && (Player.HasMagicEffect(GasMask_ChokingHandler_MGEF) == False)
				GasMask_ChokingHandler.Cast(Player,Player)
				WriteLine(Log, "Started Choking SFX")
			EndIf
			StartTimer(1.0, GasMaskOFFTimer)
		EndIf
	EndEvent
	
	Event Metro:Gear:Mask.OnChanged(Gear:Mask akSender, var[] arguments)
		WriteLine(Log, "MaskBreathing: Mask.OnChanged")
		If (Mask.IsGasMask || Mask.IsPowerArmor)
			CancelTimer(GasMaskOFFTimer)
			Player.DispelSpell(GasMask_ChokingHandler)
			StartTimer(1.0, GasMaskONTimer)
		Else
			CancelTimer(GasMaskONTimer)
			Player.DispelSpell(GasMask_CoughingHandler)
			Player.DispelSpell(GasMask_SprintingHandler)
			Player.DispelSpell(GasMask_BreathingHandler)
			Player.DispelSpell(GasMask_ChokingHandler)
			StartTimer(1.0, GasMaskOFFTimer)
		EndIf
	EndEvent
	
	Event Metro:Gear:Filter.OnReplaced(Gear:Filter akSender, var[] arguments)
		WriteLine(Log, "Filter Replaced: " + Filter.Charge)
		If (Player.HasMagicEffect(GasMask_CoughingHandler_MGEF))
			WriteLine(Log, "	Disabling Coughing SFX")
			Player.DispelSpell(GasMask_CoughingHandler)
		EndIf
		;StartTimer(1.0, GasMaskONTimer)
	EndEvent
		
EndState

Event Metro:Gear:Mask.OnChanged(Gear:Mask akSender, var[] arguments)
	{EMPTY}
EndEvent

Event Metro:Gear:Filter.OnReplaced(Gear:Filter akSender, var[] arguments)
	{EMPTY}
EndEvent

Event Actor.OnPlayerLoadGame(Actor akSender)
	{EMPTY}
EndEvent

Event Metro:Terminals:GearMaskBreathingPreset.OnChanged(Terminals:GearMaskBreathingPreset akSender, var[] arguments)
	int preset = (arguments[0] as Int)
	UsePreset(preset)
	WriteLine(Log, "--Changed Preset--")
EndEvent

; Functions
;---------------------------------------------

Function UsePreset(int aiPreset)
	If (aiPreset >= SoundPresetA && aiPreset <= SoundPresetD)
		SoundPreset.SetValue(aiPreset)
	Else
		WriteLine(Log, "Cannot use the out of range audio preset '"+aiPreset+"'.")
	EndIf
EndFunction

; Properties
;---------------------------------------------

Group Context
	Gear:Mask Property Mask Auto Const Mandatory
	Gear:Filter Property Filter Auto Const Mandatory
	Terminals:GearMaskBreathingPreset Property GearMaskBreathingPreset Auto Const Mandatory
EndGroup


Group Properties
	Sound Property Metro_DummySound Auto Const 
	Sound Property Metro_GearBreathingSFX_STD Auto Const Mandatory
	Sound Property Metro_GearBreathingSFX_Alt1 Auto Const Mandatory
	Sound Property Metro_GearBreathingSFX_Alt2 Auto Const Mandatory
	Sound Property Metro_GearBreathingSFX_FemaleAlt3 Auto Const Mandatory
	GlobalVariable Property SoundPreset Auto Mandatory
	GlobalVariable Property GasMask_BreathingToggle Auto Const Mandatory
	GlobalVariable Property GasMask_SprintingToggle Auto Const Mandatory
	GlobalVariable Property GasMask_CoughingToggle Auto Const Mandatory
	GlobalVariable Property GasMask_ChokingToggle Auto Const Mandatory
	Spell Property GasMask_BreathingHandler Auto
	Spell Property GasMask_SprintingHandler Auto
	Spell Property GasMask_CoughingHandler Auto
	Spell Property GasMask_ChokingHandler Auto
	MagicEffect Property GasMask_RadiationEffect Auto
	MagicEffect Property GasMask_BreathingHandler_MGEF Auto
	MagicEffect Property GasMask_SprintingHandler_MGEF Auto
	MagicEffect Property GasMask_CoughingHandler_MGEF Auto
	MagicEffect Property GasMask_ChokingHandler_MGEF Auto
	ImageSpaceModifier Property Metro_RadiationScreenFX Auto Const Mandatory
	ImageSpaceModifier Property Metro_ChoughingScreenFX Auto
EndGroup

Group Overlays
	ImageSpaceModifier Property ScreenFX Hidden
		ImageSpaceModifier Function Get()
			return FX
		EndFunction
		Function Set(ImageSpaceModifier value)
			If (FX != value)
				WriteChangedValue(Log, "ScreenFX", FX, value)
				FX.Remove()
				FX = value
			Else
				WriteLine(Log, "ScreenFX already equals "+value)
			EndIf
		EndFunction
	EndProperty
EndGroup

Group Sounds
	int Property SoundPresetA = 2 AutoReadOnly
	int Property SoundPresetB = 3 AutoReadOnly
	int Property SoundPresetC = 4 AutoReadOnly
	int Property SoundPresetD = 5 AutoReadOnly

	Sound Property SoundBreathing Hidden
		Sound Function Get()
			If (SoundPreset.GetValue() == SoundPresetA)
				return Metro_GearBreathingSFX_Alt1
			ElseIf (SoundPreset.GetValue() == SoundPresetB)
				return Metro_GearBreathingSFX_Alt2
			ElseIf (SoundPreset.GetValue() == SoundPresetD)
				return Metro_GearBreathingSFX_FemaleAlt3
			ElseIf (SoundPreset.GetValue() == SoundPresetC)
				return Metro_GearBreathingSFX_STD
			Else
				return Metro_DummySound
			EndIf
		EndFunction
	EndProperty
EndGroup
