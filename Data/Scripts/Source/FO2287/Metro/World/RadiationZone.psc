Scriptname Metro:World:RadiationZone extends ActiveMagicEffect

import Metro
import Shared:Log

UserLog Log

; Events
;---------------------------------------------

Event OnEffectStart(Actor akTarget, Actor akCaster)
	;Give the spell a value that it will generally follow. 7 = 7-14
	GasMask_RadZone_TargetRads.SetValue(TargetRads)
	Radiation.CheckRadiation()
EndEvent

Event OnEffectFinish(Actor akTarget, Actor akCaster)
	Radiation.CheckRadiation()
EndEvent

;Properties
;---------------------------------------------

Group Context
	World:Radiation Property Radiation Auto Const Mandatory
	float property TargetRads Auto
	GlobalVariable Property GasMask_RadZone_TargetRads Auto
EndGroup

