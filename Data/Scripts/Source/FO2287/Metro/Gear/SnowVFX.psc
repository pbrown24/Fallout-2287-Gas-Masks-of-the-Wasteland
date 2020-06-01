Scriptname Metro:Gear:SnowVFX extends Metro:Core:Optional
{MGEF:Metro_Gear}
import Metro
import Metro:Player:Animation
import Shared:Log

UserLog Log

int SnowStartTimer = 1
int SnowEndTimer = 2
int SnowInventoryTimer = 3

int SnowMeltDuration = 10

Data Current

; Events
;---------------------------------------------

Event OnInitialize()
	Log = new UserLog
	Log.Caller = self
	Log.FileName = "Environmental VFX"
EndEvent


Event OnEnable()
	WriteLine(Log, "SnowVFX Initialized.")
	MaskWipeActivate = True
	SnowToggle = True
	RegisterForCustomEvent(Camera, "OnChanged")
	RegisterForCustomEvent(GearMaskWipeActivate, "OnChanged")
	RegisterForRemoteEvent(Player, "OnItemEquipped")
	RegisterForCustomEvent(Mask, "OnChanged")
	RegisterForCustomEvent(Climate, "OnWeatherChanged")
	RegisterForCustomEvent(Climate, "OnLocationChanged")
	RegisterForCustomEvent(DetectInteriors, "OnEnterInterior")
	RegisterForCustomEvent(DetectInteriors, "OnExitInterior")
	Current = new Data
	GoToState("Snow")
EndEvent


Event OnDisable()
	WriteLine(Log, "SnowVFX Disabled.")
	MaskWipeActivate = false
	SnowToggle = false
	CancelTimer(SnowInventoryTimer)
	EndSnow(True,false)
	UnRegisterForCustomEvent(Camera, "OnChanged")
	UnRegisterForCustomEvent(GearMaskWipeActivate, "OnChanged")
	UnregisterForRemoteEvent(Player, "OnItemEquipped")
	UnregisterForCustomEvent(Mask, "OnChanged")
	UnRegisterForCustomEvent(Climate, "OnWeatherChanged")
	UnRegisterForCustomEvent(Climate, "OnLocationChanged")
	UnRegisterForCustomEvent(DetectInteriors, "OnEnterInterior")
	UnRegisterForCustomEvent(DetectInteriors, "OnExitInterior")
	GoToState("")
EndEvent

Struct Data
	int SnowStage = 0
EndStruct


; Methods
;---------------------------------------------

State Snow
	
	Event Metro:Player:Camera.OnChanged(Player:Camera akSender, var[] arguments)
		bool bFirstPerson = arguments[0]
		If (Mask.IsGasMask || (Mask.IsPowerArmor && GasMask_PAEnvironmentalVFX.GetValue() == 1.0))
			If (bFirstPerson)
				SnowUpdate(false)
			Else
				WriteLine(Log, "Third Person, End Snow VFX")
				EndSnow(false,false)
			EndIf
		EndIf
	EndEvent

	Event Metro:Gear:Mask.OnChanged(Gear:Mask akSender, var[] arguments)

		If (Mask.IsGasMask || Mask.IsPowerArmor)
			Utility.Wait(1.3)
			; Snowing and already have frost stage
			If (Climate.TypeClass == 0 && Current.SnowStage < 5)
				WriteLine(Log, "Equipped Mask: Snowing, start VFX")
				CancelTimer(SnowInventoryTimer)
				If Current.SnowStage == 0
					SnowUpdate(true)
				Else
					SnowUpdate(false)
				EndIf
				StartTimer(Snow_Restart, SnowStartTimer)
			; Snowing and already have frost stage
			ElseIf (Climate.TypeClass != 0 && Current.SnowStage > 0)
				WriteLine(Log, "Equipped Mask: Not Snowing, melting VFX")
				CancelTimer(SnowInventoryTimer)
				SnowUpdate(false)
				StartTimer(SnowMeltDuration, SnowEndTimer)
			EndIf
		Else
			Utility.Wait(0.5)
			If Current.SnowStage > 0
				EndSnow(false,false)
				StartTimer(SnowMeltDuration, SnowInventoryTimer)
			EndIf
		EndIf
	EndEvent
	
	Event Metro:World:Climate.OnWeatherChanged(World:Climate akSender, var[] arguments)
		If (Mask.IsGasMask || (Mask.IsPowerArmor && GasMask_PAEnvironmentalVFX.GetValue() == 1.0))	
			; Snowing and starting frost
			If (Climate.TypeClass == 0 && Current.SnowStage < 5)
				WriteLine(Log, "Started Snowing, start VFX")
				CancelTimer(SnowEndTimer)
				If Current.SnowStage == 0
					SnowUpdate(true)
				Else
					SnowUpdate(false)
				EndIf
			; Stopped Snowing and melting frost stage
			ElseIf (Climate.TypeClass != 0 && Current.SnowStage > 0)
				WriteLine(Log, "Stopped Snowing, melting VFX")
				CancelTimer(SnowStartTimer)
				StartTimer(SnowMeltDuration, SnowEndTimer)
			EndIf
		EndIf
	EndEvent
	
	Event Metro:World:Climate.OnLocationChanged(World:Climate akSender, var[] arguments)
		Utility.wait(2.0)
		If Player.IsInInterior() && (Mask.IsGasMask || (Mask.IsPowerArmor && GasMask_PAEnvironmentalVFX.GetValue() == 1.0))	
			If Current.SnowStage > 0
				WriteLine(Log, "Changed Location to Interior and snow stage > 0...")
				CancelTimer(SnowStartTimer)
				StartTimer(SnowMeltDuration, SnowEndTimer)
			EndIf
		ElseIf (Current.SnowStage < 5 && Climate.TypeClass == 0 && Current.SnowStage == 0)
			SnowUpdate(true)
		EndIf	
	EndEvent
	
	Event Metro:Gear:DetectInteriors.OnEnterInterior(Gear:DetectInteriors akSender, var[] arguments)
		If (Mask.IsGasMask || (Mask.IsPowerArmor && GasMask_PAEnvironmentalVFX.GetValue() == 1.0))	
			If (Current.SnowStage > 0 && Climate.TypeClass == 0)
				WriteLine(Log, "Entered Interior: melt VFX")
				CancelTimer(SnowStartTimer)
				StartTimer(SnowMeltDuration, SnowEndTimer)
			EndIf
		EndIf
	EndEvent
	
	Event Metro:Gear:DetectInteriors.OnExitInterior(Gear:DetectInteriors akSender, var[] arguments)
		If (Mask.IsGasMask || (Mask.IsPowerArmor && GasMask_PAEnvironmentalVFX.GetValue() == 1.0))	
			If (Current.SnowStage < 5 && Climate.TypeClass == 0)
				WriteLine(Log, "Exited Interior: start Snow VFX")
				CancelTimer(SnowEndTimer)
				If Current.SnowStage == 0
					SnowUpdate(true)
				Else
					SnowUpdate(false)
				EndIf
			EndIf
		EndIf
	EndEvent
	
	Event OnTimer(int aiTimerID)
		If aiTimerID == SnowStartTimer
			If (Mask.IsGasMask || (Mask.IsPowerArmor && GasMask_PAEnvironmentalVFX.GetValue() == 1.0) && Climate.TypeClass == 0)	
				SnowUpdate(true)
			EndIf
		EndIf
		
		If aiTimerID == SnowEndTimer
			If (Mask.IsGasMask || (Mask.IsPowerArmor && GasMask_PAEnvironmentalVFX.GetValue() == 1.0))	
				SnowMelt()
			EndIf
		EndIf
		
		If aiTimerID == SnowInventoryTimer
			If Current.SnowStage > 0
				Current.SnowStage -= 1
				StartTimer(SnowMeltDuration, SnowInventoryTimer)
			EndIf
		EndIf
	EndEvent

	Event Actor.OnItemEquipped(Actor akSender, Form akBaseObject, ObjectReference akReference)
		If (akBaseObject == Metro_GearWipe)
			If Current.SnowStage > 0
				EndSnow(true,true)
			EndIf
		EndIf	
		
	EndEvent
EndState

Event Metro:Terminals:GearMaskWipeActivate.OnChanged(Terminals:GearMaskWipeActivate akSender, var[] arguments)
		If MaskWipeActivate == false
			CancelTimer(SnowInventoryTimer)
			EndSnow(True,false)
			UnRegisterForCustomEvent(Camera, "OnChanged")
			UnregisterForRemoteEvent(Player, "OnItemEquipped")
			UnregisterForCustomEvent(Mask, "OnChanged")
			UnRegisterForCustomEvent(Climate, "OnWeatherChanged")
			UnRegisterForCustomEvent(Climate, "OnLocationChanged")
			UnRegisterForCustomEvent(DetectInteriors, "OnEnterInterior")
			UnRegisterForCustomEvent(DetectInteriors, "OnExitInterior")
			GoToState("")
		ElseIf SnowToggle == false
			CancelTimer(SnowInventoryTimer)
			EndSnow(True,false)
			UnRegisterForCustomEvent(Camera, "OnChanged")
			UnregisterForRemoteEvent(Player, "OnItemEquipped")
			UnregisterForCustomEvent(Mask, "OnChanged")
			UnRegisterForCustomEvent(Climate, "OnWeatherChanged")
			UnRegisterForCustomEvent(Climate, "OnLocationChanged")
			UnRegisterForCustomEvent(DetectInteriors, "OnEnterInterior")
			UnRegisterForCustomEvent(DetectInteriors, "OnExitInterior")
			GoToState("")
		ElseIf SnowToggle && MaskWipeActivate
			RegisterForCustomEvent(Camera, "OnChanged")
			RegisterForRemoteEvent(Player, "OnItemEquipped")
			RegisterForCustomEvent(Mask, "OnChanged")
			RegisterForCustomEvent(Climate, "OnWeatherChanged")
			RegisterForCustomEvent(Climate, "OnLocationChanged")
			RegisterForCustomEvent(DetectInteriors, "OnEnterInterior")
			RegisterForCustomEvent(DetectInteriors, "OnExitInterior")
			GoToState("Snow")
			If (Climate.TypeClass == 0 && Current.SnowStage < 5)
				WriteLine(Log, "Equipped Mask: Snowing, start VFX")
				SnowUpdate(true)
			; Stopped Snowing and melting frost stage
			ElseIf (Climate.TypeClass != 0 && Current.SnowStage > 0)
				WriteLine(Log, "Equipped Mask: Not Snowing, melting VFX")
				StartTimer(SnowMeltDuration, SnowEndTimer)
			EndIf
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

Event Metro:World:Climate.OnWeatherChanged(World:Climate akSender, var[] arguments)
	{EMPTY}
EndEvent

Event Metro:Gear:DetectInteriors.OnEnterInterior(Gear:DetectInteriors akSender, var[] arguments)
	{EMPTY}
EndEvent

Event Metro:Gear:DetectInteriors.OnExitInterior(Gear:DetectInteriors akSender, var[] arguments)
	{EMPTY}
EndEvent

Event Metro:Player:Camera.OnChanged(Player:Camera akSender, var[] arguments)
	{EMPTY}
EndEvent
;Function
;---------------------------------------------


Function SnowUpdate(bool Update)
	If SnowToggle && MaskWipeActivate && GasMask_MaskPercentage.GetValueInt() > 0 && Player.IsInInterior() == false && DetectInteriors.IsInFakeInterior == false
		If (Mask.IsGasMask || (Mask.IsPowerArmor && GasMask_PAEnvironmentalVFX.GetValue() == 1.0))	
			If Update && (Current.SnowStage < 5) 
				If IsFirstPerson
					If Current.SnowStage == 0 
						Metro_GearWipeVFX_Snow.Play(Player)
						StartTimer(300.0, SnowStartTimer)
						Current.SnowStage = 1
					ElseIf Current.SnowStage == 1
						Metro_GearWipeVFX_Snow2.Play(Player)
						Utility.wait(0.5)
						Metro_GearWipeVFX_Snow.Stop(Player)
						StartTimer(Snow_Restart, SnowStartTimer)
						Current.SnowStage = 2
					ElseIf Current.SnowStage == 2
						Metro_GearWipeVFX_Snow3.Play(Player)
						Utility.wait(0.5)
						Metro_GearWipeVFX_Snow2.Stop(Player)
						StartTimer(Snow_Restart, SnowStartTimer)
						Current.SnowStage = 3
					ElseIf Current.SnowStage == 3
						Metro_GearWipeVFX_Snow4.Play(Player)
						Utility.wait(0.5)
						Metro_GearWipeVFX_Snow3.Stop(Player)
						StartTimer(Snow_Restart, SnowStartTimer)
						Current.SnowStage = 4
					ElseIf Current.SnowStage == 4
						Metro_GearWipeVFX_Snow5.Play(Player)
						Utility.wait(0.5)
						Metro_GearWipeVFX_Snow4.Stop(Player)
						Current.SnowStage = 5
					EndIf
				Else
					Current.SnowStage += 1
					If Current.SnowStage > 5
						Current.SnowStage = 5
					EndIf
				EndIf
				WriteLine(Log, "Adding Snow VFX | SnowStage: " + Current.SnowStage)
			ElseIf Current.SnowStage > 0
				If Current.SnowStage == 1
					Metro_GearWipeVFX_Snow.Stop(Player)
					Utility.wait(0.1)
					Metro_GearWipeVFX_Snow.Play(Player)
				ElseIf Current.SnowStage == 2
					Metro_GearWipeVFX_Snow2.Stop(Player)
					Utility.wait(0.1)
					Metro_GearWipeVFX_Snow2.Play(Player)
				ElseIf Current.SnowStage == 3
					Metro_GearWipeVFX_Snow3.Stop(Player)
					Utility.wait(0.1)
					Metro_GearWipeVFX_Snow3.Play(Player)
				ElseIf Current.SnowStage == 4
					Metro_GearWipeVFX_Snow4.Stop(Player)
					Utility.wait(0.1)
					Metro_GearWipeVFX_Snow4.Play(Player)
				ElseIf Current.SnowStage == 5
					Metro_GearWipeVFX_Snow5.Stop(Player)
					Utility.wait(0.1)
					Metro_GearWipeVFX_Snow5.Play(Player)
				EndIf
				WriteLine(Log, "Reapplying Snow VFX | SnowStage: " + Current.SnowStage)
			EndIf
		EndIf
	Else
		WriteLine(Log, "Could not Apply Snow VFX")
	EndIf
EndFunction

Function SnowMelt()
	If SnowToggle && MaskWipeActivate
		If Current.SnowStage > 0
			If Current.SnowStage == 1
				Metro_GearWipeVFX_Snow.Stop(Player)
				Current.SnowStage = 0
			ElseIf Current.SnowStage == 2
				Metro_GearWipeVFX_Snow.Play(Player)
				Utility.wait(0.5)
				Metro_GearWipeVFX_Snow2.Stop(Player)
				StartTimer(SnowMeltDuration, SnowEndTimer)
				Current.SnowStage = 1
			ElseIf Current.SnowStage == 3
				Metro_GearWipeVFX_Snow2.Play(Player)
				Utility.wait(0.5)
				Metro_GearWipeVFX_Snow3.Stop(Player)
				StartTimer(SnowMeltDuration, SnowEndTimer)
				Current.SnowStage = 2
			ElseIf Current.SnowStage == 4
				Metro_GearWipeVFX_Snow3.Play(Player)
				Utility.wait(0.5)
				Metro_GearWipeVFX_Snow4.Stop(Player)
				StartTimer(SnowMeltDuration, SnowEndTimer)
				Current.SnowStage = 3
			ElseIf Current.SnowStage == 5
				Metro_GearWipeVFX_Snow4.Play(Player)
				Utility.wait(0.5)
				Metro_GearWipeVFX_Snow5.Stop(Player)
				StartTimer(SnowMeltDuration, SnowEndTimer)
				Current.SnowStage = 4
			EndIf
			WriteLine(Log, "Snow Melting: Current Stage = " + Current.SnowStage)
		EndIf
	EndIf
EndFunction

Function EndSnow(bool reset, bool restart)
	If Current.SnowStage > 0
		WriteLine(Log, "Removing Snow VFX")
		If Current.SnowStage == 1
			Metro_GearWipeVFX_Snow.Stop(Player)
		ElseIf Current.SnowStage == 2
			Metro_GearWipeVFX_Snow2.Stop(Player)
		ElseIf Current.SnowStage == 3
			Metro_GearWipeVFX_Snow3.Stop(Player)
		ElseIf Current.SnowStage == 4
			Metro_GearWipeVFX_Snow4.Stop(Player)
		ElseIf Current.SnowStage == 5
			Metro_GearWipeVFX_Snow5.Stop(Player)
		EndIf
		CancelTimer(SnowEndTimer)
		CancelTimer(SnowStartTimer)
		If reset
			Current.SnowStage = 0
		EndIf
		If restart
			SnowUpdate(true)
		EndIf
	Else
		CancelTimer(SnowEndTimer)
		CancelTimer(SnowStartTimer)
	EndIf
EndFunction

; Properties
;---------------------------------------------

Group Context
	Terminals:GearMaskWipeActivate Property GearMaskWipeActivate Auto Const Mandatory
	Gear:DetectInteriors Property DetectInteriors Auto Const Mandatory
	Gear:Mask Property Mask Auto Const Mandatory
	World:WeatherDatabase Property WeatherDatabase Auto Const Mandatory
	World:Climate Property Climate Auto Const Mandatory 
	Player:Camera Property Camera Auto Const Mandatory
EndGroup

Group Properties
	bool property SnowToggle Auto
	bool property MaskWipeActivate Auto
	Potion Property Metro_GearWipe Auto Const Mandatory
	GlobalVariable Property GasMask_MaskPercentage Auto
	GlobalVariable Property GasMask_PAEnvironmentalVFX Auto
EndGroup

Group VFX

	;Snow ---------------------------------
	VisualEffect property Metro_GearWipeVFX_Snow Auto Const Mandatory
	VisualEffect property Metro_GearWipeVFX_Snow2 Auto Const Mandatory
	VisualEffect property Metro_GearWipeVFX_Snow3 Auto Const Mandatory
	VisualEffect property Metro_GearWipeVFX_Snow4 Auto Const Mandatory
	VisualEffect property Metro_GearWipeVFX_Snow5 Auto Const Mandatory
	Int property Snow_Restart Auto
	{Duration before snow effect restarts after being wiped away}
EndGroup


Group Camera
	bool Property IsFirstPerson Hidden
		bool Function Get()
			return Camera.IsFirstPerson
		EndFunction
	EndProperty
EndGroup
