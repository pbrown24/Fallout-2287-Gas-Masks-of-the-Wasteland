Scriptname Metro:Gear:BloodVFX extends Metro:Core:Optional
{MGEF:Metro_Gear}
import Metro
import Metro:Player:Animation
import Shared:Log

UserLog Log
Data Current

; Events
;---------------------------------------------

Event OnInitialize()
	Log = new UserLog
	Log.Caller = self
	Log.FileName = "Environmental VFX"
EndEvent


Event OnEnable()
	WriteLine(Log, "BloodVFX Initialized.")
	MaskWipeActivate = True
	BloodToggle = True
	Current = new Data
	RegisterForCustomEvent(Camera, "OnChanged")
	RegisterForCustomEvent(GearMaskWipeActivate, "OnChanged")
	RegisterForRemoteEvent(Player, "OnItemEquipped")
	RegisterForCustomEvent(Mask, "OnChanged")
	;RegisterForCustomEvent(Climate, "OnLocationChanged")
	GoToState("Blood")
EndEvent


Event OnDisable()
	WriteLine(Log, "BloodVFX Disabled.")
	EndBloodSmear()
	EndBlood(false, false)
	MaskWipeActivate = false
	BloodToggle = false
	UnRegisterForCustomEvent(Camera, "OnChanged")
	UnRegisterForCustomEvent(GearMaskWipeActivate, "OnChanged")
	UnregisterForRemoteEvent(Player, "OnItemEquipped")
	UnregisterForCustomEvent(Mask, "OnChanged")
	;UnRegisterForCustomEvent(Climate, "OnLocationChanged")
	GoToState("")
EndEvent

Struct Data
	int BloodStage = 0
	int BloodSmearStage = 0
EndStruct


; Events
;---------------------------------------------

State Blood

	Event OnBeginState(String OldState)
		Current.BloodStage = 0
		Current.BloodSmearStage = 0
	EndEvent
	
	Event Metro:Player:Camera.OnChanged(Player:Camera akSender, var[] arguments)
		bool bFirstPerson = arguments[0]
		If (Mask.IsGasMask || (Mask.IsPowerArmor && GasMask_PAEnvironmentalVFX.GetValue() == 1.0))
			If (bFirstPerson)
				;Utility.Wait(0.1)
				If Current.BloodStage > 0
					BloodUpdate(false)
				EndIf
			Else
				;Utility.Wait(0.1)
				WriteLine(Log, "Third Person, End VFX | BloodStage: " + Current.BloodStage)
				EndBloodSmear()
				EndBlood(false, false)
			EndIf
		EndIf
	EndEvent
	
	Event Metro:Gear:Mask.OnChanged(Gear:Mask akSender, var[] arguments)
		If (Mask.IsGasMask || (Mask.IsPowerArmor && GasMask_PAEnvironmentalVFX.GetValue() == 1.0))
			Utility.Wait(1.3)
			If Current.BloodStage > 0
				BloodUpdate(false)
			EndIf
		Else
			Utility.Wait(0.5)
			WriteLine(Log, "No Mask, End VFX | BloodStage: " + Current.BloodStage)
			EndBloodSmear()
			EndBlood(false, false)
		EndIf
	EndEvent
	
	Event Metro:World:Climate.OnLocationChanged(World:Climate akSender, var[] arguments)
		Utility.wait(2.0)
		If IsFirstPerson
			If Player.IsInInterior() && (Mask.IsGasMask || (Mask.IsPowerArmor && GasMask_PAEnvironmentalVFX.GetValue() == 1.0)) && (Current.BloodStage > 0 || Current.BloodSmearStage > 0) 
				WriteLine(Log, "Changed Location to Interior and blood/smear stage > 0...")
				EndBloodSmear()
				EndBlood(false, false)
				BloodUpdate(false)
			EndIf	
		EndIf
	EndEvent
	
	Event Actor.OnItemEquipped(Actor akSender, Form akBaseObject, ObjectReference akReference)
		If (akBaseObject == Metro_GearWipe)
			WriteLine(Log, "Blood Mask Wipe...")
			If Current.BloodSmearStage > 0 
				EndBloodSmear()
			EndIf
			If Current.BloodStage > 0
				EndBlood(true, true)
			EndIf
		EndIf
	EndEvent
EndState

Event Metro:Terminals:GearMaskWipeActivate.OnChanged(Terminals:GearMaskWipeActivate akSender, var[] arguments)
		If MaskWipeActivate == false
			EndBlood(true, false)
			EndBloodSmear()
			GoToState("")
		ElseIf BloodToggle == false
			EndBlood(true, false)
			EndBloodSmear()
			GoToState("")
		ElseIf BloodToggle && MaskWipeActivate
			GoToState("Blood")
		EndIf
EndEvent

Event Metro:Gear:Mask.OnChanged(Gear:Mask akSender, var[] arguments)
	{EMPTY}
EndEvent

Event Actor.OnItemEquipped(Actor akSender, Form akBaseObject, ObjectReference akReference)
	{EMPTY}
EndEvent

Event Metro:World:Climate.OnLocationChanged(World:Climate akSender, var[] arguments)
	{EMPTY}
EndEvent

Event Metro:Player:Camera.OnChanged(Player:Camera akSender, var[] arguments)
	{EMPTY}
EndEvent


;Function
;---------------------------------------------


;Npc has been hit within range.
Function BloodUpdate(bool update)
	If BloodToggle && MaskWipeActivate && GasMask_MaskPercentage.GetValueInt() > 0
		If (Mask.IsGasMask || (Mask.IsPowerArmor && GasMask_PAEnvironmentalVFX.GetValue() == 1.0))
			If update && (Current.BloodStage < 5)
				If Current.BloodStage == 0
					Current.BloodStage = 1
					Metro_GearWipeVFX_BloodStageOne.Play(Player)
				ElseIf Current.BloodStage == 1
					Current.BloodStage = 2
					Metro_GearWipeVFX_BloodStageTwo.Play(Player)
					Utility.wait(0.5)
					Metro_GearWipeVFX_BloodStageOne.Stop(Player)
				ElseIf Current.BloodStage == 2
					Current.BloodStage = 3
					Metro_GearWipeVFX_BloodStageThree.Play(Player)
					Utility.wait(0.5)
					Metro_GearWipeVFX_BloodStageTwo.Stop(Player)
				ElseIf Current.BloodStage == 3
					Current.BloodStage = 4
					Metro_GearWipeVFX_BloodStageFour.Play(Player)
					Utility.wait(0.5)
					Metro_GearWipeVFX_BloodStageThree.Stop(Player)
				ElseIf Current.BloodStage == 4
					Current.BloodStage = 5
					Metro_GearWipeVFX_BloodStageFive.Play(Player)
					Utility.wait(0.5)
					Metro_GearWipeVFX_BloodStageFour.Stop(Player)
				EndIf
				WriteLine(Log, "Adding Blood VFX | Stage: " + Current.BloodStage)
			ElseIf update == false
				If Current.BloodStage == 1
					Metro_GearWipeVFX_BloodStageOne.Play(Player)
				ElseIf Current.BloodStage == 2
					Metro_GearWipeVFX_BloodStageTwo.Play(Player)
				ElseIf Current.BloodStage == 3
					Metro_GearWipeVFX_BloodStageThree.Play(Player)
				ElseIf Current.BloodStage == 4
					Metro_GearWipeVFX_BloodStageFour.Play(Player)
				ElseIf Current.BloodStage == 5
					Metro_GearWipeVFX_BloodStageFive.Play(Player)
				EndIf
				WriteLine(Log, "Adding Current Blood VFX | Stage: " + Current.BloodStage)
			Else
				WriteLine(Log, "Max Blood Stage Reached | Stage: " + Current.BloodStage)
			EndIf
		EndIf
	EndIf
EndFunction

Function EndBlood(bool restart, bool addSmear)
	If Current.BloodStage > 0
		WriteLine(Log, "Removing Blood VFX")
		If Current.BloodStage == 1
			Utility.wait(0.15)
			Metro_GearWipeVFX_BloodStageOne.Stop(Player)
			;Metro_GearWipeVFX_BloodFadeHStageOne.Play(Player, 0.5)
			If addSmear
				Metro_GearWipeVFX_BloodSmearStageOne.Play(Player)
				Current.BloodSmearStage = 1
			EndIf
		ElseIf Current.BloodStage == 2
			Utility.wait(0.15)
			Metro_GearWipeVFX_BloodStageTwo.Stop(Player)
			;Metro_GearWipeVFX_BloodFadeHStageTwo.Play(Player, 0.5)
			If addSmear
				Metro_GearWipeVFX_BloodSmearStageTwo.Play(Player)
				Current.BloodSmearStage = 2
			EndIf
		ElseIf Current.BloodStage == 3
			Utility.wait(0.15)
			Metro_GearWipeVFX_BloodStageThree.Stop(Player)
			;Metro_GearWipeVFX_BloodFadeHStageThree.Play(Player, 0.5)
			If addSmear
				Metro_GearWipeVFX_BloodSmearStageThree.Play(Player)
				Current.BloodSmearStage = 3
			EndIf
		ElseIf Current.BloodStage == 4
			Utility.wait(0.15)
			Metro_GearWipeVFX_BloodStageFour.Stop(Player)
			;Metro_GearWipeVFX_BloodFadeHStageFour.Play(Player, 0.5)
			If addSmear
				Metro_GearWipeVFX_BloodSmearStageFour.Play(Player)
				Current.BloodSmearStage = 4
			EndIf
		ElseIf Current.BloodStage == 5
			Utility.wait(0.15)
			Metro_GearWipeVFX_BloodStageFive.Stop(Player)
			;Metro_GearWipeVFX_BloodFadeHStageFive.Play(Player, 0.5)
			If addSmear
				Metro_GearWipeVFX_BloodSmearStageFive.Play(Player)
				Current.BloodSmearStage = 5
			EndIf
		EndIf
		If restart
			Current.BloodStage = 0
		EndIf
		WriteLine(Log, "Removing Blood VFX | Stage: " + Current.BloodStage + " | Adding Smear: " + Current.BloodSmearStage)
	EndIf
EndFunction

Function EndBloodSmear()
	If Current.BloodSmearStage > 0
		If Current.BloodSmearStage == 1
			Utility.wait(0.2)
			Metro_GearWipeVFX_BloodSmearStageOne.Stop(Player)
		ElseIf Current.BloodSmearStage == 2
			Utility.wait(0.2)
			Metro_GearWipeVFX_BloodSmearStageTwo.Stop(Player)
		ElseIf Current.BloodSmearStage == 3
			Utility.wait(0.2)
			Metro_GearWipeVFX_BloodSmearStageThree.Stop(Player)
		ElseIf Current.BloodSmearStage == 4
			Utility.wait(0.2)
			Metro_GearWipeVFX_BloodSmearStageFour.Stop(Player)
		ElseIf Current.BloodSmearStage == 5
			Utility.wait(0.2)
			Metro_GearWipeVFX_BloodSmearStageFive.Stop(Player)
		EndIf
		WriteLine(Log, "Removing Blood Smear VFX | Stage: " + Current.BloodSmearStage)
		Current.BloodSmearStage = 0
	Else
		WriteLine(Log, "Removing Blood Smear VFX | No Blood Smear to be removed.")
	EndIf
EndFunction

; Properties
;---------------------------------------------

Group Context
	Terminals:GearMaskWipeActivate Property GearMaskWipeActivate Auto Const Mandatory
	Gear:Mask Property Mask Auto Const Mandatory
	Gear:MaskWipe Property MaskWipe Auto Const Mandatory
	World:Climate Property Climate Auto Const Mandatory 
	Player:Camera Property Camera Auto Const Mandatory
EndGroup

Group Properties
	bool property BloodToggle Auto
	bool property MaskWipeActivate Auto
	Potion Property Metro_GearWipe Auto Const Mandatory
	GlobalVariable Property GasMask_MaskPercentage Auto
	GlobalVariable Property GasMask_PAEnvironmentalVFX Auto
EndGroup

Group VFX
	;Blood ------------------------------
	VisualEffect property Metro_GearWipeVFX_BloodFadeHStageOne Auto Const Mandatory
	VisualEffect property Metro_GearWipeVFX_BloodFadeHStageTwo Auto Const Mandatory
	VisualEffect property Metro_GearWipeVFX_BloodFadeHStageThree Auto Const Mandatory
	VisualEffect property Metro_GearWipeVFX_BloodFadeHStageFour Auto Const Mandatory
	VisualEffect property Metro_GearWipeVFX_BloodFadeHStageFive Auto Const Mandatory
	
	VisualEffect property Metro_GearWipeVFX_BloodSmearStageOne Auto Const Mandatory
	VisualEffect property Metro_GearWipeVFX_BloodSmearStageTwo Auto Const Mandatory
	VisualEffect property Metro_GearWipeVFX_BloodSmearStageThree Auto Const Mandatory
	VisualEffect property Metro_GearWipeVFX_BloodSmearStageFour Auto Const Mandatory
	VisualEffect property Metro_GearWipeVFX_BloodSmearStageFive Auto Const Mandatory
	
	VisualEffect property Metro_GearWipeVFX_BloodStageOne Auto Const Mandatory
	VisualEffect property Metro_GearWipeVFX_BloodStageTwo Auto Const Mandatory
	VisualEffect property Metro_GearWipeVFX_BloodStageThree Auto Const Mandatory
	VisualEffect property Metro_GearWipeVFX_BloodStageFour Auto Const Mandatory
	VisualEffect property Metro_GearWipeVFX_BloodStageFive Auto Const Mandatory
EndGroup


Group Camera
	bool Property IsFirstPerson Hidden
		bool Function Get()
			return Camera.IsFirstPerson
		EndFunction
	EndProperty
EndGroup

