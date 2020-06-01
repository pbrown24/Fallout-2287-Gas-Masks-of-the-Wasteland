Scriptname Metro:Gear:MudVFX extends Metro:Core:Optional
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
	WriteLine(Log, "MudVFX Initialized.")
	MaskWipeActivate = True
	DirtToggle = True
	RegisterForCustomEvent(Camera, "OnChanged")
	RegisterForCustomEvent(GearMaskWipeActivate, "OnChanged")
	RegisterForRemoteEvent(Player, "OnItemEquipped")
	RegisterForCustomEvent(Mask, "OnChanged")
	;RegisterForCustomEvent(Climate, "OnLocationChanged")
	Current = new Data
	GoToState("Mud")
EndEvent


Event OnDisable()
	WriteLine(Log, "Mask Wipe Disabled.")
	MaskWipeActivate = false
	DirtToggle = false
	UnRegisterForCustomEvent(Camera, "OnChanged")
	UnRegisterForCustomEvent(GearMaskWipeActivate, "OnChanged")
	UnregisterForRemoteEvent(Player, "OnItemEquipped")
	UnregisterForCustomEvent(Mask, "OnChanged")
	;UnRegisterForCustomEvent(Climate, "OnLocationChanged")
	GoToState("")
EndEvent

Struct Data
	int MudStage = 0
EndStruct


; Methods
;---------------------------------------------

State Mud

	Event Metro:Player:Camera.OnChanged(Player:Camera akSender, var[] arguments)
		bool bFirstPerson = arguments[0]
		If (Mask.IsGasMask || (Mask.IsPowerArmor && GasMask_PAEnvironmentalVFX.GetValue() == 1.0))
			If (bFirstPerson)
				;Utility.Wait(0.1)
				If Current.MudStage > 0
					MudUpdate(false)
				EndIf
			Else
				;Utility.Wait(0.1)
				WriteLine(Log, "Third Person, End VFX | MudStage: " + Current.MudStage)
				EndMud(false)
			EndIf
		EndIf
	EndEvent
	
	Event Metro:Gear:Mask.OnChanged(Gear:Mask akSender, var[] arguments)
		If (Mask.IsGasMask || (Mask.IsPowerArmor && GasMask_PAEnvironmentalVFX.GetValue() == 1.0))
			Utility.Wait(1.3)
			If Current.MudStage > 0
				MudUpdate(false)
			EndIf
		Else
			Utility.Wait(0.5)
			WriteLine(Log, "No Mask, End VFX | MudStage: " + Current.MudStage)
			EndMud(false)
		EndIf
	EndEvent
	
	Event Metro:World:Climate.OnLocationChanged(World:Climate akSender, var[] arguments)
		Utility.wait(2.0)
		If Player.IsInInterior() && (Mask.IsGasMask || (Mask.IsPowerArmor && GasMask_PAEnvironmentalVFX.GetValue() == 1.0)) && (Current.MudStage > 0)
			WriteLine(Log, "Changed Location to Interior and mud stage > 0...")
			EndMud(false)
			MudUpdate(false)
		EndIf	
	EndEvent

	Event Actor.OnItemEquipped(Actor akSender, Form akBaseObject, ObjectReference akReference)
		If (akBaseObject == Metro_GearWipe)
			WriteLine(Log, "Mud Mask Wipe...")
			If Current.MudStage > 0
				EndMud(true)
			EndIf
		EndIf
	EndEvent		
EndState

Event Metro:Terminals:GearMaskWipeActivate.OnChanged(Terminals:GearMaskWipeActivate akSender, var[] arguments)
		If MaskWipeActivate == false
			EndMud(true)
			UnregisterForRemoteEvent(Player, "OnItemEquipped")
			UnregisterForCustomEvent(Mask, "OnChanged")
			UnRegisterForCustomEvent(Climate, "OnLocationChanged")
			GoToState("")
		ElseIf DirtToggle == false
			EndMud(true)
			UnregisterForRemoteEvent(Player, "OnItemEquipped")
			UnregisterForCustomEvent(Mask, "OnChanged")
			UnRegisterForCustomEvent(Climate, "OnLocationChanged")
			GoToState("")
		ElseIf DirtToggle && MaskWipeActivate
			RegisterForRemoteEvent(Player, "OnItemEquipped")
			RegisterForCustomEvent(Mask, "OnChanged")
			RegisterForCustomEvent(Climate, "OnLocationChanged")
			GoToState("Mud")
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

;In range of an explosion.
Function MudUpdate(bool update)
	If DirtToggle && MaskWipeActivate && GasMask_MaskPercentage.GetValueInt() > 0
		If (Mask.IsGasMask || (Mask.IsPowerArmor && GasMask_PAEnvironmentalVFX.GetValue() == 1.0))
			If update && (Current.MudStage < 4)
				If Current.MudStage == 0
					Current.MudStage = 1
					Metro_GearWipeVFX_MudStageOne.Play(Player)
				ElseIf Current.MudStage == 1
					Current.MudStage = 2
					Metro_GearWipeVFX_MudStageTwo.Play(Player)
					Utility.wait(0.5)
					Metro_GearWipeVFX_MudStageOne.Stop(Player)
				ElseIf Current.MudStage == 2
					Current.MudStage = 3
					Metro_GearWipeVFX_MudStageThree.Play(Player)
					Utility.wait(0.5)
					Metro_GearWipeVFX_MudStageTwo.Stop(Player)
				ElseIf Current.MudStage == 3
					Current.MudStage = 4
					Metro_GearWipeVFX_MudStageFour.Play(Player)
					Utility.wait(0.5)
					Metro_GearWipeVFX_MudStageThree.Stop(Player)
				EndIf
				WriteLine(Log, "Adding Mud VFX | Stage: " + Current.MudStage)
			ElseIf update == false
				If Current.MudStage == 1
					Metro_GearWipeVFX_MudStageOne.Play(Player)
				ElseIf Current.MudStage == 2
					Metro_GearWipeVFX_MudStageTwo.Play(Player)
				ElseIf Current.MudStage == 3
					Metro_GearWipeVFX_MudStageThree.Play(Player)
				ElseIf Current.MudStage == 4
					Metro_GearWipeVFX_MudStageFour.Play(Player)
				EndIf
				WriteLine(Log, "Adding Current Mud VFX | Stage: " + Current.MudStage)
			EndIf
		EndIf
	EndIf
EndFunction

Function EndMud(bool restart)
	If Current.MudStage > 0
		WriteLine(Log, "Removing Mud VFX")
		If Current.MudStage == 1
			Metro_GearWipeVFX_MudStageOne.Stop(Player)
		ElseIf Current.MudStage == 2
			Metro_GearWipeVFX_MudStageTwo.Stop(Player)
		ElseIf Current.MudStage == 3
			Metro_GearWipeVFX_MudStageThree.Stop(Player)
		ElseIf Current.MudStage == 4
			Metro_GearWipeVFX_MudStageFour.Stop(Player)
		EndIf
		If restart
			Current.MudStage = 0
		EndIf
	EndIf
EndFunction

; Properties
;---------------------------------------------

Group Context
	Terminals:GearMaskWipeActivate Property GearMaskWipeActivate Auto Const Mandatory
	Gear:Mask Property Mask Auto Const Mandatory
	World:Climate Property Climate Auto Const Mandatory 
	Player:Camera Property Camera Auto Const Mandatory
EndGroup

Group Properties
	bool property DirtToggle Auto
	bool property MaskWipeActivate Auto
	Potion Property Metro_GearWipe Auto Const Mandatory
	GlobalVariable Property GasMask_MaskPercentage Auto
	GlobalVariable Property GasMask_PAEnvironmentalVFX Auto
EndGroup

Group VFX
	;Mud ---------------------------------
	VisualEffect property Metro_GearWipeVFX_MudStageOne Auto Const Mandatory
	VisualEffect property Metro_GearWipeVFX_MudStageTwo Auto Const Mandatory
	VisualEffect property Metro_GearWipeVFX_MudStageThree Auto Const Mandatory
	VisualEffect property Metro_GearWipeVFX_MudStageFour Auto Const Mandatory
EndGroup

