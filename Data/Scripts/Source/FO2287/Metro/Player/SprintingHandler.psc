Scriptname Metro:Player:SprintingHandler extends ActiveMagicEffect

import Metro
import Metro:Player:Animation
import Shared:Log


int increase = 0
int decrease = 1

int Sprinting_SoundInstance
Sound akSound
UserLog Log

Event OnEffectStart(Actor akTarget, Actor akCaster)
	RegisterForCustomEvent(MaskBreathing, "DecreaseSprinting")
	Sprinting_SoundInstance = -1
	akSound = Metro_GearSprintingSFX
	CurrentVolume_Sprinting.SetValue(0.0)
	GoToState("Sprinting")
EndEvent


Event OnEffectFinish(Actor akTarget, Actor akCaster)
	UnRegisterForCustomEvent(MaskBreathing, "DecreaseSprinting")
	CancelTimer(increase)
	CancelTimer(decrease)
	Sound.StopInstance(Sprinting_SoundInstance)
	Sprinting_SoundInstance = -1
EndEvent

State Sprinting

	Event OnBeginState(String OldState)
		WriteLine(Log, "Sprinting Started...")
		If MaskBreathing.GasMask_SprintingToggle.GetValue() == 1.0
			Sprinting_SoundInstance = akSound.Play(Game.GetPlayer())
			CurrentVolume_Sprinting.SetValue(0.2)
			Sound.SetInstanceVolume(Sprinting_SoundInstance, CurrentVolume_Sprinting.GetValue())
			WriteLine(Log, "Sprinting Volume: " + CurrentVolume_Sprinting.GetValue())
			StartTimer(0.5, increase)
		EndIf
	EndEvent

	Event OnTimer(int aiTimerID)
		If aiTimerID == increase ; Increase the volume of breathing until it is at max : 1.0
			If CurrentVolume_Sprinting.GetValue() < MaxVolume_Sprinting.GetValue()
				CurrentVolume_Sprinting.SetValue(CurrentVolume_Sprinting.GetValue() + 0.2)
				Sound.SetInstanceVolume(Sprinting_SoundInstance, CurrentVolume_Sprinting.GetValue())
				StartTimer(0.5, increase)
			EndIf
			WriteLine(Log, "Sprinting Volume: " + CurrentVolume_Sprinting.GetValue())
		EndIf
		If aiTimerID == decrease ; Decrease the volume of Sprinting until it is min : 0.0
			WriteLine(Log, "Sprinting Volume: " + CurrentVolume_Sprinting.GetValue())
			If CurrentVolume_Sprinting.GetValue() > 0.0
				CurrentVolume_Sprinting.SetValue(CurrentVolume_Sprinting.GetValue() - 0.2)
				Sound.SetInstanceVolume(Sprinting_SoundInstance, CurrentVolume_Sprinting.GetValue())
				StartTimer(0.3, decrease)
			ElseIf CurrentVolume_Sprinting.GetValue() == 0.0
				Sound.StopInstance(Sprinting_SoundInstance)
				WriteLine(Log, "Sprinting Stopped...")
				Self.Dispel()
			EndIf
		EndIf
	EndEvent

EndState

Event Metro:Gear:MaskBreathing.DecreaseSprinting(Gear:MaskBreathing akSender, var[] arguments)
	StartTimer(0.1, decrease)
EndEvent

; Properties
;---------------------------------------------

Group Properties
	GlobalVariable Property CurrentVolume_Sprinting Auto Mandatory
	GlobalVariable Property MaxVolume_Sprinting Auto Mandatory
	Gear:Mask Property Mask Auto Const Mandatory
	Gear:MaskBreathing Property MaskBreathing Auto Const Mandatory
	Sound Property Metro_GearSprintingSFX Auto Const Mandatory
EndGroup

