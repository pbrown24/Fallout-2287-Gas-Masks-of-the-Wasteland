Scriptname Metro:Gear:RainVFX extends Metro:Core:Optional
{MGEF:Metro_Gear}
import Metro
import Metro:Player:Animation
import Shared:Log

UserLog Log

int RainStartTimer = 1
int RainLoopTimer = 2

Data Current

; EndRain(true,false,true) : End the rain and playRainEnd, set to RainStage 3, do not remove rainstage 3, and attempt to restart the rain if CanRainStart

; EndRain(false,true) : End the rain and dont playRainEnd, remove rainstage 3


; Events
;---------------------------------------------

Event OnInitialize()
	Log = new UserLog
	Log.Caller = self
	Log.FileName = "Environmental VFX"
EndEvent


Event OnEnable()
	WriteLine(Log, "RainVFX Initialized.")
	MaskWipeActivate = True
	RainToggle = True
	RegisterForCustomEvent(Camera, "OnChanged")
	RegisterForCustomEvent(GearMaskWipeActivate, "OnChanged")
	RegisterForRemoteEvent(Player, "OnItemEquipped")
	RegisterForCustomEvent(Mask, "OnChanged")
	RegisterForCustomEvent(Climate, "OnWeatherChanged")
	RegisterForCustomEvent(Climate, "OnLocationChanged")
	RegisterForCustomEvent(DetectInteriors, "OnEnterInterior")
	RegisterForCustomEvent(DetectInteriors, "OnExitInterior")
	Current = new Data
	GoToState("Rain")
EndEvent


Event OnDisable()
	WriteLine(Log, "RainVFX Disabled.")
	MaskWipeActivate = false
	RainToggle = false
	EndRain(false,true,false)
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
	int RainStage = 0
EndStruct


; Methods
;---------------------------------------------

State Rain
	Event Metro:Gear:Mask.OnChanged(Gear:Mask akSender, var[] arguments)

		If (Mask.IsGasMask)
			Utility.Wait(1.3)
			; Raining and already have rain stage
			If (CanStartRain)
				WriteLine(Log, "Equipped Mask: Raining, start VFX")
				StartTimer(Rain_Restart, RainStartTimer)
			EndIf
		Else
			Utility.Wait(0.5)
			If Current.RainStage > 0
				EndRain(false,true,false)
			EndIf
		EndIf
	EndEvent
	
	Event Metro:Player:Camera.OnChanged(Player:Camera akSender, var[] arguments)
		bool bFirstPerson = arguments[0]
		If (Mask.IsGasMask || (Mask.IsPowerArmor && GasMask_PAEnvironmentalVFX.GetValue() == 1.0))
			If (bFirstPerson)
				;Utility.Wait(0.1)
				If Current.RainStage > 0  || CanStartRain
					RainUpdate()
				EndIf
			Else
				;Utility.Wait(0.1)
				CancelTimer(RainLoopTimer)
				CancelTimer(RainStartTimer)
				Metro_GearWipeVFX_RainStart.Stop(Player)
				Metro_GearWipeVFX_RainLoop.Stop(Player)
				Metro_GearWipeVFX_RainEnd.Stop(Player)
				Metro_GearWipeVFX_RainEndLoop.Stop(Player)
			EndIf
		EndIf
	EndEvent
	
	Event Metro:World:Climate.OnWeatherChanged(World:Climate akSender, var[] arguments)
		If Mask.IsGasMask
			; Raining and starting rain
			If (CanStartRain)
				WriteLine(Log, "Started Raining, start VFX")
				StartTimer(Rain_Restart, RainStartTimer)
			; Stopped Raining, ending rain
			ElseIf (Climate.Classification != 2.0 && Current.RainStage > 0)
				WriteLine(Log, "Stopped Raining, removing VFX")
				EndRain(true,false,false)
			EndIf
		EndIf
	EndEvent
	
	Event Metro:World:Climate.OnLocationChanged(World:Climate akSender, var[] arguments)
		Utility.wait(2.0)
		If Player.IsInInterior() && (Mask.IsGasMask)
			If Current.RainStage > 0
				WriteLine(Log, "Changed Location to Interior and rain stage > 0...")
				EndRain(false,true,false)
			EndIf
		EndIf	
	EndEvent
	
	Event Metro:Gear:DetectInteriors.OnEnterInterior(Gear:DetectInteriors akSender, var[] arguments)
		If Mask.IsGasMask
			If (Current.RainStage > 0 && Climate.Classification == 2.0)
				WriteLine(Log, "Entered Interior: End Rain VFX")
				EndRain(true, false,false)
			EndIf
		EndIf
	EndEvent
	
	Event Metro:Gear:DetectInteriors.OnExitInterior(Gear:DetectInteriors akSender, var[] arguments)
		If (Mask.IsGasMask)
			If (CanStartRain)
				WriteLine(Log, "Exited Interior: start VFX")
				StartTimer(Rain_Restart, RainStartTimer)
			EndIf
		EndIf
	EndEvent
	
	Event OnTimer(int aiTimerID)
		; Start Rain
		If aiTimerID == RainStartTimer
			RainUpdate()
			WriteLine(Log, "Start RainVFX.")
		EndIf
		; Loop Rain
		If aiTimerID == RainLoopTimer
			RainUpdate()
			WriteLine(Log, "Loop RainVFX.")
		EndIf
	EndEvent

	Event Actor.OnItemEquipped(Actor akSender, Form akBaseObject, ObjectReference akReference)
		If (akBaseObject == Metro_GearWipe)
			If Current.RainStage > 0
				EndRain(false,true,true)
			EndIf
		EndIf	
		
	EndEvent
EndState

Event Metro:Terminals:GearMaskWipeActivate.OnChanged(Terminals:GearMaskWipeActivate akSender, var[] arguments)
		If MaskWipeActivate == false
			EndRain(false,true,false)
			UnregisterForRemoteEvent(Player, "OnItemEquipped")
			UnregisterForCustomEvent(Mask, "OnChanged")
			UnRegisterForCustomEvent(Climate, "OnWeatherChanged")
			UnRegisterForCustomEvent(Climate, "OnLocationChanged")
			UnRegisterForCustomEvent(DetectInteriors, "OnEnterInterior")
			UnRegisterForCustomEvent(DetectInteriors, "OnExitInterior")
			GoToState("")
		ElseIf RainToggle == false
			EndRain(false,true,false)
			UnregisterForRemoteEvent(Player, "OnItemEquipped")
			UnregisterForCustomEvent(Mask, "OnChanged")
			UnRegisterForCustomEvent(Climate, "OnWeatherChanged")
			UnRegisterForCustomEvent(Climate, "OnLocationChanged")
			UnRegisterForCustomEvent(DetectInteriors, "OnEnterInterior")
			UnRegisterForCustomEvent(DetectInteriors, "OnExitInterior")
			GoToState("")
		ElseIf RainToggle && MaskWipeActivate
			RegisterForRemoteEvent(Player, "OnItemEquipped")
			RegisterForCustomEvent(Mask, "OnChanged")
			RegisterForCustomEvent(Climate, "OnWeatherChanged")
			RegisterForCustomEvent(Climate, "OnLocationChanged")
			RegisterForCustomEvent(DetectInteriors, "OnEnterInterior")
			RegisterForCustomEvent(DetectInteriors, "OnExitInterior")
			GoToState("Rain")
			If (CanStartRain)
				WriteLine(Log, "Equipped Mask: Raining, start VFX")
				StartTimer(Rain_Restart, RainStartTimer)
			; Stopped Raining and removing rain
			ElseIf (Climate.Classification != 2.0 && Current.RainStage > 0)
				WriteLine(Log, "Equipped Mask: Not Raining, removing VFX")
				EndRain(true,false,false)
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

; I MIGHT BE ABLE TO MAKE THESE CONSTANT NOW
Function RainUpdate()
	If RainToggle && MaskWipeActivate && GasMask_MaskPercentage.GetValueInt() > 0
		If Mask.IsGasMask  && IsFirstPerson
			If Current.RainStage == 3
				Metro_GearWipeVFX_RainEnd.Stop(Player)
				Metro_GearWipeVFX_RainEndLoop.Stop(Player)
				Current.RainStage = 0
			EndIf
			If Current.RainStage == 0
				WriteLine(Log, "Start RainVFX.")
				;MaskOverlay.Remove()
				Metro_GearWipeVFX_RainStart.Play(Player,RainDuration_Start)
				;MaskOverlay.Apply()
				StartTimer(RainDuration_Start - Rain_Start_Overlap, RainLoopTimer)
				Current.RainStage = 1
				WriteLine(Log, "Starting Rain VFX | RainStage: " + Current.RainStage)
			ElseIf Current.RainStage == 1 || Current.RainStage == 2
				WriteLine(Log, "Loop RainVFX.")
				Utility.wait(0.5)
				Metro_GearWipeVFX_RainLoop.Stop(Player)
				If Climate.Classification == 2.0
					Metro_GearWipeVFX_RainLoop.Play(Player,RainDuration_Loop)
					StartTimer(RainDuration_Loop - Rain_Loop_Overlap, RainLoopTimer)
					Current.RainStage = 2
					WriteLine(Log, "Looping Rain VFX | RainStage: " + Current.RainStage)
				EndIf
			EndIf
		EndIf
	EndIf
EndFunction


Function EndRain(bool playRainEnd, bool endStageThree, bool restart)
	WriteLine(Log, "Removing Rain VFX")
	CancelTimer(RainLoopTimer)
	CancelTimer(RainStartTimer)
	If Current.RainStage == 1
		Metro_GearWipeVFX_RainStart.Stop(Player)
	ElseIf Current.RainStage == 2
		Metro_GearWipeVFX_RainLoop.Stop(Player)
	ElseIf Current.RainStage == 3 || endStageThree
		Metro_GearWipeVFX_RainEnd.Stop(Player)
		Metro_GearWipeVFX_RainEndLoop.Stop(Player)
	EndIf
	If(playRainEnd && Current.RainStage != 3)
		Current.RainStage = 3
		Metro_GearWipeVFX_RainEnd.Play(Player,RainDuration_End)
		Metro_GearWipeVFX_RainEndLoop.Play(Player)
	Else 
		Current.RainStage = 0
	EndIf
	If (CanStartRain && restart)
		StartTimer(Rain_Restart, RainStartTimer)
	EndIf
EndFunction

; Properties
;---------------------------------------------

Group Context
	Terminals:GearMaskWipeActivate Property GearMaskWipeActivate Auto Const Mandatory
	Gear:DetectInteriors Property DetectInteriors Auto Const Mandatory
	Gear:Mask Property Mask Auto Const Mandatory
	Gear:MaskOverlay Property MaskOverlay Auto Const Mandatory
	World:WeatherDatabase Property WeatherDatabase Auto Const Mandatory
	World:Climate Property Climate Auto Const Mandatory 
	Player:Camera Property Camera Auto Const Mandatory
EndGroup

Group Properties
	bool property RainToggle Auto
	bool property MaskWipeActivate Auto
	Potion Property Metro_GearWipe Auto Const Mandatory
	GlobalVariable Property GasMask_MaskPercentage Auto
	
	bool property CanStartRain Hidden
		bool Function Get()
			If ( (Mask.IsGasMask && GasMask_MaskPercentage.GetValueInt() > 0) && (Climate.Classification == 2.0) && RainToggle && MaskWipeActivate && (DetectInteriors.IsInFakeInterior == false) && (Current.RainStage == 0 || Current.RainStage == 3) && Player.IsInInterior() == false && (Climate.TypeClass != 1 && Climate.TypeClass != 0) )
				return true
			Else
				return false
			EndIf
		EndFunction
	EndProperty
EndGroup

Group VFX
	GlobalVariable Property GasMask_PAEnvironmentalVFX Auto
	;Rain -------------------------------
	VisualEffect property Metro_GearWipeVFX_RainStart Auto Const Mandatory
	VisualEffect property Metro_GearWipeVFX_RainLoop Auto Const Mandatory
	VisualEffect property Metro_GearWipeVFX_RainEnd Auto Const Mandatory
	VisualEffect property Metro_GearWipeVFX_RainEndLoop Auto Const Mandatory
	Int property RainDuration_Start Auto
	{Duration of Rain start.}
	Int property RainDuration_Loop Auto
	{Duration of the Rain loop.}
	Int property RainDuration_End Auto
	{Duration after Rain Weather for Rain effect to end.}
	Int property Rain_Start_Overlap Auto
	{RainDuration_Start - Overlap}
	Int property Rain_Loop_Overlap Auto
	{RainDuration_Loop - Overlap}
	Int property Rain_End_Overlap Auto
	{RainDuration_End - Overlap}
	Int property Rain_Restart Auto
	{Duration before rain effect restarts after being wiped away}
EndGroup


Group Camera
	bool Property IsFirstPerson Hidden
		bool Function Get()
			return Camera.IsFirstPerson
		EndFunction
	EndProperty
EndGroup
