Scriptname Metro:Gear:DustVFX extends Metro:Core:Optional
{MGEF:Metro_Gear}
import Metro
import Metro:Player:Animation
import Shared:Log

UserLog Log
Data Current

int DustStartTimer = 1

; Events
;---------------------------------------------

Event OnInitialize()
	Log = new UserLog
	Log.Caller = self
	Log.FileName = "Environmental VFX"
EndEvent


Event OnEnable()
	WriteLine(Log, "DustVFX Initialized.")
	MaskWipeActivate = True
	DustToggle = True
	Current = new Data
	RegisterForCustomEvent(Camera, "OnChanged")
	RegisterForCustomEvent(GearMaskWipeActivate, "OnChanged")
	RegisterForRemoteEvent(Player, "OnItemEquipped")
	RegisterForCustomEvent(Mask, "OnChanged")
	RegisterForCustomEvent(Climate, "OnWeatherChanged")
	RegisterForCustomEvent(Climate, "OnLocationChanged")
	RegisterForCustomEvent(DetectInteriors, "OnEnterInterior")
	RegisterForCustomEvent(DetectInteriors, "OnExitInterior")
	GoToState("Dust")
EndEvent


Event OnDisable()
	WriteLine(Log, "DustVFX Disabled.")
	EndDust(true)
	MaskWipeActivate = false
	DustToggle = false
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
	int DustStage = 0
EndStruct


; Events
;---------------------------------------------

State Dust

	Event OnBeginState(String OldState)
		EndDust(true)
	EndEvent
	
	Event Metro:Player:Camera.OnChanged(Player:Camera akSender, var[] arguments)
		bool bFirstPerson = arguments[0]
		If (Mask.IsGasMask || (Mask.IsPowerArmor && GasMask_PAEnvironmentalVFX.GetValue() == 1.0))
			If (bFirstPerson)
				;Utility.Wait(0.1)
				If Current.DustStage > 0
					DustUpdate(false)
				EndIf
			Else
				;Utility.Wait(0.1)
				WriteLine(Log, "Third Person, End VFX | DustStage: " + Current.DustStage)
				EndDust(false)
			EndIf
		EndIf
	EndEvent
	
	Event Metro:Gear:Mask.OnChanged(Gear:Mask akSender, var[] arguments)
		If (Mask.IsGasMask || (Mask.IsPowerArmor && GasMask_PAEnvironmentalVFX.GetValue() == 1.0))
			Utility.Wait(1.3)
			If Current.DustStage > 0
				DustUpdate(false)
			EndIf
			If CanStartDust
				StartTimer(Dust_Restart, DustStartTimer)
			EndIf
		Else
			Utility.Wait(0.5)
			WriteLine(Log, "No Mask, End VFX | DustStage: " + Current.DustStage)
			EndDust(false)
		EndIf
	EndEvent
	
	Event Metro:World:Climate.OnWeatherChanged(World:Climate akSender, var[] arguments)
		If (Mask.IsGasMask || (Mask.IsPowerArmor && GasMask_PAEnvironmentalVFX.GetValue() == 1.0))	
			;Starting Dust  
			If (CanStartDust)
				WriteLine(Log, "Started Dust Storm, start VFX")
				StartTimer(Dust_Restart, DustStartTimer)
			; Stopped Dust Storm, ending Dust Timer
			ElseIf (Climate.TypeClass != 1) && Current.DustStage > 0
				WriteLine(Log, "Stopped Dust Storm, removing VFX: " + Climate.TypeClass)
				cancelTimer(DustStartTimer)
			EndIf
		EndIf
	EndEvent
	
	
	Event Metro:World:Climate.OnLocationChanged(World:Climate akSender, var[] arguments)
		Utility.wait(2.0)
		If Player.IsInInterior() && (Mask.IsGasMask || (Mask.IsPowerArmor && GasMask_PAEnvironmentalVFX.GetValue() == 1.0))
			If Current.DustStage > 0
				WriteLine(Log, "Changed Location to Interior, reapplying dust stage...")
				DustUpdate(false)
			EndIf
		EndIf	
	EndEvent
	
	Event Actor.OnItemEquipped(Actor akSender, Form akBaseObject, ObjectReference akReference)
		If (akBaseObject == Metro_GearWipe)
			WriteLine(Log, "Dust Mask Wipe...")
			If Current.DustStage > 0
				EndDust(true)
			EndIf
		EndIf
	EndEvent
	
	Event OnTimer(int aiTimerID)
		If aiTimerID == DustStartTimer
			If (Mask.IsGasMask || (Mask.IsPowerArmor && GasMask_PAEnvironmentalVFX.GetValue() == 1.0))
				DustUpdate(true)
			EndIf
		EndIf
	EndEvent
	
	Event Metro:Gear:DetectInteriors.OnEnterInterior(Gear:DetectInteriors akSender, var[] arguments)
		If (Mask.IsGasMask || (Mask.IsPowerArmor && GasMask_PAEnvironmentalVFX.GetValue() == 1.0))
			If (Climate.TypeClass == 1)
				WriteLine(Log, "Entered Interior: Stop Dust Timer")
				CancelTimer(DustStartTimer)
			EndIf
		EndIf
	EndEvent
	
	Event Metro:Gear:DetectInteriors.OnExitInterior(Gear:DetectInteriors akSender, var[] arguments)
		If (CanStartDust)
			WriteLine(Log, "Exited Interior: start VFX")
			StartTimer(Dust_Restart, DustStartTimer)
		EndIf
	EndEvent
EndState

Event Metro:Terminals:GearMaskWipeActivate.OnChanged(Terminals:GearMaskWipeActivate akSender, var[] arguments)
		If MaskWipeActivate == false
			EndDust(true)
			GoToState("")
		ElseIf DustToggle == false
			EndDust(true)
			GoToState("")
		ElseIf DustToggle && MaskWipeActivate
			GoToState("Dust")
			If CanStartDust
				StartTimer(Dust_Restart, DustStartTimer)
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


;update dust with next overlay, they stack 1->2->3.
Function DustUpdate(bool update)
	If DustToggle && MaskWipeActivate && GasMask_MaskPercentage.GetValueInt() > 0
		If (Mask.IsGasMask || (Mask.IsPowerArmor && GasMask_PAEnvironmentalVFX.GetValue() == 1.0))
			If update
				If Current.DustStage <= 3
					WriteLine(Log, "Adding Dust VFX | DustStage: " + Current.DustStage)
					If Current.DustStage == 0
						Current.DustStage = 1
					EndIf
					If Current.DustStage == 1
						Metro_GearWipeVFX_Dust.Play(Player)
						Current.DustStage = 2
						StartTimer(60.0, DustStartTimer)
					ElseIf Current.DustStage == 2
						Metro_GearWipeVFX_Dust2.Play(Player)
						Current.DustStage = 3
						StartTimer(240.0, DustStartTimer)
					ElseIf Current.DustStage == 3
						Metro_GearWipeVFX_Dust3.Play(Player)
						Current.DustStage = 4
					EndIf
				EndIf
			ElseIf Current.DustStage > 0
				If Current.DustStage == 1
					Metro_GearWipeVFX_Dust.Play(Player)
				ElseIf Current.DustStage == 3
					Metro_GearWipeVFX_Dust.Play(Player)
					Metro_GearWipeVFX_Dust2.Play(Player)
				ElseIf Current.DustStage > 3
					Metro_GearWipeVFX_Dust.Play(Player)
					Metro_GearWipeVFX_Dust2.Play(Player)
					Metro_GearWipeVFX_Dust3.Play(Player)
				EndIf
				WriteLine(Log, "Reapplying Dust VFX | DustStage: " + Current.DustStage)
			EndIf
		EndIf
	EndIf
EndFunction

Function EndDust(bool restart)
	If Current.DustStage > 0
		WriteLine(Log, "Removing Dust VFX")
		If Current.DustStage == 1
			Utility.wait(0.15)
			Metro_GearWipeVFX_Dust.Stop(Player)
		ElseIf Current.DustStage == 2
			Utility.wait(0.15)
			Metro_GearWipeVFX_Dust.Stop(Player)
			Metro_GearWipeVFX_Dust2.Stop(Player)
		ElseIf Current.DustStage >= 3
			Utility.wait(0.15)
			Metro_GearWipeVFX_Dust.Stop(Player)
			Metro_GearWipeVFX_Dust2.Stop(Player)
			Metro_GearWipeVFX_Dust3.Stop(Player)
		EndIf
		If restart
			Current.DustStage = 0
		EndIf
		If (CanStartDust)
			StartTimer(Dust_Restart, DustStartTimer)
		EndIf
		WriteLine(Log, "Removing Dust VFX | Stage: " + Current.DustStage)
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
	bool property DustToggle Auto
	bool property MaskWipeActivate Auto
	Potion Property Metro_GearWipe Auto Const Mandatory 
	GlobalVariable Property GasMask_MaskPercentage Auto
	GlobalVariable Property GasMask_PAEnvironmentalVFX Auto
EndGroup

Group VFX
	;Dust ------------------------------
	
	VisualEffect property  Metro_GearWipeVFX_Dust Auto Const Mandatory
	VisualEffect property Metro_GearWipeVFX_Dust2  Auto Const Mandatory
	VisualEffect property Metro_GearWipeVFX_Dust3 Auto Const Mandatory
	Int property Dust_Restart Auto
	{Duration before dust effect restarts after being wiped away}
EndGroup


Group Camera
	bool Property IsFirstPerson Hidden
		bool Function Get()
			return Camera.IsFirstPerson
		EndFunction
	EndProperty
EndGroup

bool property CanStartDust Hidden
	bool Function Get()
		If ( (Mask.IsGasMask || (Mask.IsPowerArmor && GasMask_PAEnvironmentalVFX.GetValue() == 1.0)) && (Climate.TypeClass == 1) && DustToggle && MaskWipeActivate && (DetectInteriors.IsInFakeInterior == false) && (Current.DustStage == 0) && Player.IsInInterior() == false)
			WriteLine(Log, "CanStartDust: true")
			return true
		Else
			WriteLine(Log, "CanStartDust: false")
			return false
		EndIf
	EndFunction
EndProperty
