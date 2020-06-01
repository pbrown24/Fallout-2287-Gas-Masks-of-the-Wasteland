Scriptname Metro:Player:BreathingHandler extends ActiveMagicEffect

import Metro
import Metro:Player:Animation
import Shared:Log


int increase = 0
int decrease = 1

int Breathing_SoundInstance
Sound akSound
UserLog Log

Event OnEffectStart(Actor akTarget, Actor akCaster)
	RegisterForCustomEvent(GearMaskBreathingPreset, "OnChanged")
	CurrentVolume_Breathing.SetValue(0.0)
	GoToState("Breathing")
EndEvent


Event OnEffectFinish(Actor akTarger, Actor akCaster)
	UnregisterForCustomEvent(GearMaskBreathingPreset, "OnChanged")
	CancelTimer(increase)
	CancelTimer(decrease)
	Sound.StopInstance(Breathing_SoundInstance)
	Breathing_SoundInstance = -1
EndEvent

State Breathing

	Event OnBeginState(String OldState)
		WriteLine(Log, "Breathing Started...")
		If MaskBreathing.GasMask_BreathingToggle.GetValue() == 1.0
			Breathing_SoundInstance = -1
			akSound = MaskBreathing.SoundBreathing
			Breathing_SoundInstance = akSound.Play(Game.GetPlayer())
			CurrentVolume_Breathing.SetValue(0.2)
			Sound.SetInstanceVolume(Breathing_SoundInstance, CurrentVolume_Breathing.GetValue())
			WriteLine(Log, "Breathing Volume: " + CurrentVolume_Breathing.GetValue())
			StartTimer(0.5, increase)
		EndIf
	EndEvent

	Event OnTimer(int aiTimerID)
		If aiTimerID == increase ; Increase the volume of breathing until it is at max : 1.0
		
				If CurrentVolume_Breathing.GetValue() < MaxVolume_Breathing.GetValue()
					CurrentVolume_Breathing.SetValue(CurrentVolume_Breathing.GetValue() + 0.2)
					Sound.SetInstanceVolume(Breathing_SoundInstance, CurrentVolume_Breathing.GetValue())
					StartTimer(0.5, increase)
				EndIf
				WriteLine(Log, "Breathing Volume: " + CurrentVolume_Breathing.GetValue())
		EndIf
		; If aiTimerID == decrease ; Decrease the volume of breathing until it is min : 0.0
				; WriteLine(Log, "Breathing Volume: " + CurrentVolume_Breathing.GetValue())
				; If CurrentVolume_Breathing.GetValue() > 0.0
					; CurrentVolume_Breathing.SetValue(CurrentVolume_Breathing.GetValue() - 0.2)
					; Sound.SetInstanceVolume(Breathing_SoundInstance, CurrentVolume_Breathing.GetValue())
					; StartTimer(0.5, decrease)
				; ElseIf CurrentVolume_Breathing.GetValue() == 0.0
					; Sound.StopInstance(Breathing_SoundInstance)
					; SendCustomEvent("EndedBreathing")
					; WriteLine(Log, "Breathing Stopped...")
					; GoToState("NotBreathing")
				; EndIf
		; EndIf
	EndEvent

EndState

Event Metro:Terminals:GearMaskBreathingPreset.OnChanged(Terminals:GearMaskBreathingPreset akSender, var[] arguments)
	int preset = (arguments[0] as Int)
	Sound.StopInstance(Breathing_SoundInstance)
	WriteLine(Log, "--Changed Preset--")
	Utility.Wait(1.0)
	GoToState("Breathing")
EndEvent


; Properties
;---------------------------------------------

Group Properties
	GlobalVariable Property CurrentVolume_Breathing Auto Mandatory
	GlobalVariable Property MaxVolume_Breathing Auto Mandatory
	Terminals:GearMaskBreathingPreset Property GearMaskBreathingPreset Auto Const Mandatory
	Gear:Mask Property Mask Auto Const Mandatory
	Gear:MaskBreathing Property MaskBreathing Auto Const Mandatory
EndGroup
