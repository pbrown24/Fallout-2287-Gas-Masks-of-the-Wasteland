Scriptname Metro:Player:CoughingHandler extends ActiveMagicEffect

import Metro
import Metro:Player:Animation
import Shared:Log


int increase = 0
int decrease = 1

int Coughing_SoundInstance
Sound akSound
ImageSpaceModifier akImod
UserLog Log

Event OnEffectStart(Actor akTarget, Actor akCaster)
	Coughing_SoundInstance = -1
	akSound = Metro_GearCoughingSFX
	akImod = MaskBreathing.Metro_ChoughingScreenFX
	CurrentVolume_Coughing.SetValue(0.0)
	GoToState("Coughing")
EndEvent


Event OnEffectFinish(Actor akTarget, Actor akCaster)
	akImod.Remove()
	CancelTimer(increase)
	CancelTimer(decrease)
	Sound.StopInstance(Coughing_SoundInstance)
	Coughing_SoundInstance = -1
EndEvent

State Coughing

	Event OnBeginState(String OldState)
		WriteLine(Log, "Coughing Started...")
		akImod.ApplyCrossFade(10.0)
		If MaskBreathing.GasMask_CoughingToggle.GetValue() == 1.0
			Coughing_SoundInstance = akSound.Play(Game.GetPlayer())
			CurrentVolume_Coughing.SetValue(0.2)
			Sound.SetInstanceVolume(Coughing_SoundInstance, CurrentVolume_Coughing.GetValue())
			WriteLine(Log, "Coughing Volume: " + CurrentVolume_Coughing.GetValue())
			StartTimer(0.5, increase)
		EndIf
	EndEvent

	Event OnTimer(int aiTimerID)
		If aiTimerID == increase ; Increase the volume of breathing until it is at max : 1.0
		
				If CurrentVolume_Coughing.GetValue() < MaxVolume_Coughing.GetValue()
					CurrentVolume_Coughing.SetValue(CurrentVolume_Coughing.GetValue() + 0.2)
					Sound.SetInstanceVolume(Coughing_SoundInstance, CurrentVolume_Coughing.GetValue())
					StartTimer(0.5, increase)
				EndIf
				WriteLine(Log, "Coughing Volume: " + CurrentVolume_Coughing.GetValue())
		EndIf
		If aiTimerID == decrease ; Decrease the volume of Coughing until it is min : 0.0
				WriteLine(Log, "Coughing Volume: " + CurrentVolume_Coughing.GetValue())
				If CurrentVolume_Coughing.GetValue() > 0.0
					CurrentVolume_Coughing.SetValue(CurrentVolume_Coughing.GetValue() - 0.2)
					Sound.SetInstanceVolume(Coughing_SoundInstance, CurrentVolume_Coughing.GetValue())
					StartTimer(0.5, decrease)
				ElseIf CurrentVolume_Coughing.GetValue() == 0.0
					Sound.StopInstance(Coughing_SoundInstance)
					WriteLine(Log, "Coughing Stopped...")
				EndIf
		EndIf
	EndEvent

EndState


; Properties
;---------------------------------------------

Group Properties
	GlobalVariable Property CurrentVolume_Coughing Auto Mandatory
	GlobalVariable Property MaxVolume_Coughing Auto Mandatory
	Gear:Mask Property Mask Auto Const Mandatory
	Gear:MaskBreathing Property MaskBreathing Auto Const Mandatory
	Sound Property Metro_GearCoughingSFX Auto Const Mandatory
EndGroup

