Scriptname Metro:NPC:Cloak extends Metro:Core:Optional
{QUST:Metro_NPC}
import Shared:Log

UserLog Log


; Events
;---------------------------------------------

Event OnInitialize()
	Log = new UserLog
	Log.Caller = self
	Log.FileName = "NPC"
EndEvent

Event OnEnable()
	WriteLine(Log, "Adding the cloak spell '"+Metro_NPC_Cloak+"'' to player.")
	Player.AddSpell(Metro_NPC_Cloak, false)
EndEvent

Event OnDisable()
	WriteLine(Log, "Removing the cloak spell '"+Metro_NPC_Cloak+"'' from player.")
	Player.RemoveSpell(Metro_NPC_Cloak)
EndEvent


; Properties
;---------------------------------------------

Group Properties
	Spell Property Metro_NPC_Cloak Auto Const Mandatory
EndGroup
