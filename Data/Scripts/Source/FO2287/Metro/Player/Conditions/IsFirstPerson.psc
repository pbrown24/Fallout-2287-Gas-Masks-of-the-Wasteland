ScriptName Metro:Player:Conditions:IsFirstPerson extends ActiveMagicEffect
import Metro
import Shared:Log

UserLog Log


; Events
;---------------------------------------------

Event OnInit()
	Log = new UserLog
	Log.Caller = self
	Log.FileName = "Player"
EndEvent


Event OnEffectStart(Actor akTarget, Actor akCaster)
	WriteLine(Log, "OnEffectStart")
	Camera.InvokeChanged(true)
EndEvent


Event OnEffectFinish(Actor akTarget, Actor akCaster)
	WriteLine(Log, "OnEffectFinish")
    Camera.InvokeChanged(false)
EndEvent


; Properties
;---------------------------------------------

Group Context
	Player:Camera Property Camera Auto Const Mandatory
EndGroup
