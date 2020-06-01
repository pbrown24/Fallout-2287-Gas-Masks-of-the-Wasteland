Scriptname Metro:NPC:CloakDistance extends ActiveMagicEffect
{MGEF:Metro_CloakDistanceEffect}
import Metro
import ScriptObject
import Shared:Log
UserLog Log

float DistanceLess = 105.0
float DistanceGreater = 125.0
string EmptyState = "" const
string AliveState = "AliveState" const
Actor Player
Actor NPC
int TimerID = 1

CustomEvent OnNPCHit

Event OnInit()
	Log = new UserLog
	Log.Caller = self
	Log.FileName = "NPCDistance"
EndEvent


Event OnEffectStart(Actor akTarget, Actor akCaster)
	WriteLine(Log, "OnEffectStart(akTarget="+akTarget+", akCaster="+akCaster+")")
	Player = Game.GetPlayer()
	NPC = akTarget
	If(NPC != None)
		If NPC.Is3DLoaded()
			RegisterForDistanceLessThanEvent(Player, NPC, DistanceLess)	
			GoToState(AliveState)
		EndIf
	EndIf
EndEvent

State AliveState

	Event OnBeginState(string asOldState)
		If(NPC != None)
			If NPC.Is3DLoaded()
				WriteLine(Log, "Entering the "+GetState()+" state from "+asOldState)
				StartTimer(10, TimerID)
			EndIf
		Else
			GoToState("")
		EndIf
	EndEvent
	
	Event OnTimer(int aiTimerID)
		If(NPC != None)
			If NPC.Is3DLoaded()
				WriteLine(Log, "OnTimer(aiTimerID="+aiTimerID+")")
				StartTimer(10, TimerID)
			EndIf
		Else
			GoToState("")
		EndIf
	EndEvent

;Blood Mask VFX Detection ---------------
	
	Event OnHit(ObjectReference akTarget, ObjectReference akAggressor, Form akSource, Projectile akProjectile, bool abPowerAttack, bool abSneakAttack, bool abBashAttack, bool abHitBlocked, string apMaterial)
		If(NPC != None)
			If NPC.Is3DLoaded()
				If NPC.GetDistance(Player) <= 130.0
					WriteLine(Log, "Someone Hit a guy")
					BloodVFX.BloodUpdate(true)
					Utility.Wait(0.1)
					RegisterForHitEvent(NPC, akAggressorFilter = None, akSourceFilter = None, akProjectileFilter = None, aiPowerFilter = -1, aiSneakFilter = -1, aiBashFilter = -1, aiBlockFilter = 0, abMatch = true)
				EndIf
			EndIf
		Else
			GoToState("")
		EndIf 
	EndEvent

	Event OnDistanceLessThan(ObjectReference akObj1, ObjectReference akObj2, float afDistance)
		If(NPC != None)
			If NPC.Is3DLoaded()
				WriteLine(Log, "Player in range of..." + NPC)
				RegisterForHitEvent(NPC, akAggressorFilter = None, akSourceFilter = None, akProjectileFilter = None, aiPowerFilter = -1, aiSneakFilter = -1, aiBashFilter = -1, aiBlockFilter = 0, abMatch = true)
				Utility.Wait(0.2)
				RegisterForDistanceGreaterThanEvent(Player, NPC, DistanceGreater)
				If NPC.GetDistance(Player) >= 130.0
					UnRegisterForHitEvent(NPC, akAggressorFilter = None, akSourceFilter = None, akProjectileFilter = None, aiPowerFilter = -1, aiSneakFilter = -1, aiBashFilter = -1, aiBlockFilter = 0, abMatch = true)
				EndIf
			EndIf
		Else
			GoToState("")
		EndIf
	EndEvent

	Event OnDistanceGreaterThan(ObjectReference akObj1, ObjectReference akObj2, float afDistance)
		If(NPC != None)
			If NPC.Is3DLoaded()
				WriteLine(Log, "Player out of range of..." + NPC)
				UnRegisterForHitEvent(NPC, akAggressorFilter = None, akSourceFilter = None, akProjectileFilter = None, aiPowerFilter = -1, aiSneakFilter = -1, aiBashFilter = -1, aiBlockFilter = 0, abMatch = true)
				Utility.Wait(0.2)
				RegisterForDistanceLessThanEvent(Player, NPC, DistanceLess)
				If NPC.GetDistance(Player) < 125.0
					RegisterForHitEvent(NPC, akAggressorFilter = None, akSourceFilter = None, akProjectileFilter = None, aiPowerFilter = -1, aiSneakFilter = -1, aiBashFilter = -1, aiBlockFilter = 0, abMatch = true)
				EndIf
			EndIf
		Else
			GoToState("")
		EndIf
	EndEvent

;-------------------------------------------

	Event OnDying(Actor akKiller)
		WriteLine(Log, "OnDying(akKiller="+akKiller+")")
		GoToState("")
	EndEvent

	Event OnEndState(string asNewState)
		WriteLine(Log, "Ending the "+GetState()+", new state "+asNewState)
		UnRegisterForHitEvent(NPC, akAggressorFilter = None, akSourceFilter = None, akProjectileFilter = None, aiPowerFilter = -1, aiSneakFilter = -1, aiBashFilter = -1, aiBlockFilter = 0, abMatch = true)
		UnRegisterForDistanceEvents(Player, NPC)
		CancelTimer(TimerID)
	EndEvent

EndState
		
	
Event OnDistanceLessThan(ObjectReference akObj1, ObjectReference akObj2, float afDistance)
	{EMPTY}
EndEvent

Event OnDistanceGreaterThan(ObjectReference akObj1, ObjectReference akObj2, float afDistance)
	{EMPTY}
EndEvent

Event OnHit(ObjectReference akTarget, ObjectReference akAggressor, Form akSource, Projectile akProjectile, bool abPowerAttack, bool abSneakAttack, bool abBashAttack, bool abHitBlocked, string apMaterial)
	{EMPTY}
EndEvent

; Properties
;---------------------------------------------

Group Context
	Gear:BloodVFX Property BloodVFX Auto Const Mandatory
EndGroup
