Scriptname Metro:Gear:OverlaySpell extends ActiveMagicEffect 

import Metro
import Shared:Log

UserLog Log

Event OnInIt()
	Log = new UserLog
	Log.Caller = self
	Log.FileName = "Gear"
EndEvent

Event OnEffectStart(Actor akTarget, Actor akCaster)
	MaskOverlay.VFX.Play(akTarget)
EndEvent

Event OnEffectFinish(Actor akTarget, Actor akCaster)
	MaskOverlay.VFX.Stop(akTarget)
EndEvent

Group Properties
	Gear:MaskOverlay Property MaskOverlay Auto Const Mandatory
EndGroup
