Scriptname Metro:NPC:CloakApply extends ActiveMagicEffect
{MGEF:Metro_CloakApplyingEffect}
import Shared:Log

UserLog Log


; Events
;---------------------------------------------

Event OnInit()
	Log = new UserLog
	Log.Caller = self
	Log.FileName = "NPC"
EndEvent


Event OnEffectStart(Actor akTarget, Actor akCaster)
	akTarget.AddSpell(Metro_NPC_CloakEquip, false)
	WriteLine(Log, "Added the spell '"+Metro_NPC_CloakEquip+"' to '"+akTarget+"'.")
EndEvent


; Properties
;---------------------------------------------

Group Properties
	Spell Property Metro_NPC_CloakEquip Auto Const Mandatory
EndGroup
