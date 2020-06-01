ScriptName Metro:Gear:DetectExplosion extends ObjectReference
import Metro 
import Shared:Log

UserLog Log
Actor Player
float distance = 700.0
ObjectReference Marker

Event Onload()
	Log = new UserLog
	Log.Caller = self
	Log.FileName = "Environmental VFX"
	
	WriteLine(Log, "Explosion Detected...")
	Marker = self
	Player = Game.GetPlayer()
	If(Marker.GetDistance(Player) <= distance)
		WriteLine(Log, "Within Distance, adding mud...")
		MudVFX.MudUpdate(true)
	EndIf
	Self.disable(False)
	Self.delete()
EndEvent

; Properties
;---------------------------------------------

Group Context
	Metro:Gear:MudVFX Property MudVFX Auto Const Mandatory
EndGroup
