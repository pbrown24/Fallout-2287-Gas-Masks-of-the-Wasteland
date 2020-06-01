Scriptname Metro:Gear:MaskWipe extends Metro:Core:Optional
{MGEF:Metro_Gear}
import Metro
import Metro:Player:Animation
import Shared:Log

UserLog Log

; Events
;---------------------------------------------

Event OnInitialize()
	Log = new UserLog
	Log.Caller = self
	Log.FileName = "Mask Wipe"
EndEvent


Event OnEnable()
	WriteLine(Log, "Mask Wipe Initialized.")
	MaskWipeActivate = True
	RegisterForCustomEvent(GearMaskWipeActivate, "OnChanged")
	RegisterForRemoteEvent(Player, "OnItemEquipped")
	RegisterForCustomEvent(Mask, "OnChanged")
	;RegisterForCustomEvent(Climate, "OnLocationChanged")
EndEvent


Event OnDisable()
	WriteLine(Log, "Mask Wipe Disabled.")
	MaskWipeActivate = false
	UnRegisterForCustomEvent(GearMaskWipeActivate, "OnChanged")
	UnregisterForRemoteEvent(Player, "OnItemEquipped")
	UnregisterForCustomEvent(Mask, "OnChanged")
	;UnRegisterForCustomEvent(Climate, "OnLocationChanged")
EndEvent


; Methods
;---------------------------------------------

State ActiveState
	Event Metro:Gear:Mask.OnChanged(Gear:Mask akSender, var[] arguments)
		int iCount = Player.GetItemCount(Metro_GearWipe)
		int repairKit = Player.GetItemCount(GasMask_GearRepairKit)
		;Player.RemoveItem(Metro_GearWipe, iCount, abSilent = true)

		If (Mask.IsGasMask || (Mask.IsPowerArmor && GasMask_PAEnvironmentalVFX.GetValue() == 1.0))
			WriteLine(Log, "Gas Mask Equipped...")
			If iCount < 2
				Player.AddItem(Metro_GearWipe, 1, abSilent = true)
				WriteLine(Log, "Added the mask wipe item.")
			EndIf
			If repairKit < 2
				Player.AddItem(GasMask_GearRepairKit, 1, abSilent = true)
			EndIf
		Else
			Player.RemoveItem(Metro_GearWipe, 1, true)
		EndIf
	EndEvent
	
	Event Actor.OnItemEquipped(Actor akSender, Form akBaseObject, ObjectReference akReference)
		If (akBaseObject == Metro_GearWipe)
				GasMask_CanPlayAnim.SetValueInt(1)
				If (Utility.IsInMenuMode())
					Metro_GearExitPipboyMessage.Show()
				EndIf
				If (Player.GetItemCount(Metro_GearWipe) == 0)
					Player.AddItem(Metro_GearWipe, 1, abSilent = true)
					WriteLine(Log, "Refunding the mask wipe item.")
				EndIf
				GasMask_Gear_MaskWipeFade.Apply(1.0)
				If Mask.IsGasMask
					If(IsFirstPerson)
						IdlePlay(Player, MaskWipeIdleFP, Log)
					Else
						IdlePlay(Player, MaskWipeIdleTP, Log)
					EndIf
				ElseIf (Mask.IsPowerArmor && GasMask_PAEnvironmentalVFX.GetValue() == 1.0)
					If(IsFirstPerson)
						IdlePlay(Player, MaskWipeIdleFP, Log)
					Else
						Game.ForceFirstPerson()
						IdlePlay(Player, MaskWipeIdleFP, Log)
						Utility.wait(1.0)
						Game.ForceThirdPerson()
					EndIf
				EndIf
				Metro_GearWipeSFX.Play(Player)
				GasMask_CanPlayAnim.SetValueInt(0)
		EndIf
	EndEvent
	
EndState

Event Metro:Terminals:GearMaskWipeActivate.OnChanged(Terminals:GearMaskWipeActivate akSender, var[] arguments)
		If MaskWipeActivate
			GoToState("ActiveState")
		Else
			GoToState("")
		EndIf
EndEvent

Event Metro:Gear:Mask.OnChanged(Gear:Mask akSender, var[] arguments)
	{EMPTY}
EndEvent

Event Actor.OnItemEquipped(Actor akSender, Form akBaseObject, ObjectReference akReference)
	{EMPTY}
EndEvent

; Functions
;---------------------------------------------

Function DisableAllVFX()
	BloodVFX.EndBlood(true, false)
	Utility.Wait(0.1)
	BloodVFX.EndBloodSmear()
	Utility.Wait(0.1)
	DustVFX.EndDust(true)
	Utility.Wait(0.1)
	RainVFX.EndRain(false,true,false)
	Utility.Wait(0.1)
	MudVFX.EndMud(true)
	Utility.Wait(0.1)
	SnowVFX.EndSnow(True, true)
EndFunction

; Properties
;---------------------------------------------

Group Context
	Terminals:GearMaskWipeActivate Property GearMaskWipeActivate Auto Const Mandatory
	Metro:Gear:BloodVFX Property BloodVFX Auto Const Mandatory
	Metro:Gear:MudVFX Property MudVFX Auto Const Mandatory
	Metro:Gear:RainVFX Property RainVFX Auto Const Mandatory
	Metro:Gear:SnowVFX Property SnowVFX Auto Const Mandatory
	Metro:Gear:DustVFX Property DustVFX Auto Const Mandatory
	Gear:Mask Property Mask Auto Const Mandatory
	Gear:MaskOverlay Property MaskOverlay Auto Const Mandatory
	World:Climate Property Climate Auto Const Mandatory 
	Player:Camera Property Camera Auto Const Mandatory
EndGroup

Group Properties
	ImageSpaceModifier property GasMask_Gear_MaskWipeFade Auto Const Mandatory
	bool property MaskWipeActivate Auto
	Potion Property Metro_GearWipe Auto Const Mandatory
	Potion property GasMask_GearRepairKit Auto
	Sound Property Metro_GearWipeSFX Auto Const Mandatory
	Message Property Metro_GearExitPipboyMessage Auto Const Mandatory
	Idle property MaskWipeIdleFP Auto Const Mandatory
	Idle property MaskWipeIdleTP Auto Const Mandatory
	GlobalVariable Property GasMask_CanPlayAnim Auto
	GlobalVariable Property GasMask_PAEnvironmentalVFX Auto
EndGroup

Group Camera
	bool Property IsFirstPerson Hidden
		bool Function Get()
			return Camera.IsFirstPerson
		EndFunction
	EndProperty
EndGroup

