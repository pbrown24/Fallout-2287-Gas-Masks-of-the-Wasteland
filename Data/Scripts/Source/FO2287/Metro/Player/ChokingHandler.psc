Scriptname Metro:Player:ChokingHandler extends ActiveMagicEffect

import Metro
import Metro:Player:Animation
import Shared:Log


int increase = 0
int decrease = 1

int Choking_SoundInstance
ImageSpaceModifier akImod
Sound akSound
UserLog Log

Event OnEffectStart(Actor akTarget, Actor akCaster)
	Choking_SoundInstance = -1
	If (Mask.IsGasMask || Mask.IsPowerArmor)
		akSound = Metro_GearChokingSFX
	Else
		akSound = Metro_GearChokingSFX_NoMask
	EndIf
	akImod = MaskBreathing.Metro_RadiationScreenFX
	CurrentVolume_Choking.SetValue(0.0)
	GoToState("Choking")
EndEvent


Event OnEffectFinish(Actor akTarget, Actor akCaster)
	akImod.Remove()
	CancelTimer(increase)
	CancelTimer(decrease)
	Sound.StopInstance(Choking_SoundInstance)
	Choking_SoundInstance = -1
EndEvent

State Choking

	Event OnBeginState(String OldState)
		WriteLine(Log, "Choking Started...")
		akImod.ApplyCrossFade(20.0)
		If MaskBreathing.GasMask_ChokingToggle.GetValue() == 1.0
			Choking_SoundInstance = akSound.Play(Game.GetPlayer())
			CurrentVolume_Choking.SetValue(0.2)
			Sound.SetInstanceVolume(Choking_SoundInstance, CurrentVolume_Choking.GetValue())
			WriteLine(Log, "Choking Volume: " + CurrentVolume_Choking.GetValue())
			StartTimer(0.5, increase)
		EndIf
	EndEvent

	Event OnTimer(int aiTimerID)
		If aiTimerID == increase ; Increase the volume of breathing until it is at max : 1.0
			If CurrentVolume_Choking.GetValue() < MaxVolume_Choking.GetValue()
				CurrentVolume_Choking.SetValue(CurrentVolume_Choking.GetValue() + 0.2)
				Sound.SetInstanceVolume(Choking_SoundInstance, CurrentVolume_Choking.GetValue())
				StartTimer(0.5, increase)
			EndIf
			WriteLine(Log, "Choking Volume: " + CurrentVolume_Choking.GetValue())
		EndIf
		If aiTimerID == decrease ; Decrease the volume of Choking until it is min : 0.0
			WriteLine(Log, "Choking Volume: " + CurrentVolume_Choking.GetValue())
			If CurrentVolume_Choking.GetValue() > 0.0
				CurrentVolume_Choking.SetValue(CurrentVolume_Choking.GetValue() - 0.2)
				Sound.SetInstanceVolume(Choking_SoundInstance, CurrentVolume_Choking.GetValue())
				StartTimer(0.5, decrease)
			ElseIf CurrentVolume_Choking.GetValue() == 0.0
				Sound.StopInstance(Choking_SoundInstance)
				WriteLine(Log, "Choking Stopped...")
			EndIf
		EndIf
	EndEvent

EndState



; Properties
;---------------------------------------------

Group Properties
	GlobalVariable Property CurrentVolume_Choking Auto Mandatory
	GlobalVariable Property MaxVolume_Choking Auto Mandatory
	Gear:Mask Property Mask Auto Const Mandatory
	Gear:MaskBreathing Property MaskBreathing Auto Const Mandatory
	Sound Property Metro_GearChokingSFX Auto Const Mandatory
	Sound Property Metro_GearChokingSFX_NoMask Auto Const Mandatory
EndGroup
