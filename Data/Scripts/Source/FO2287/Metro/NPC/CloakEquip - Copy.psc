Scriptname Metro:NPC:CloakEquip extends ActiveMagicEffect
{MGEF:Metro_CloakEquipEffect}
import Metro
import Shared:Log

UserLog Log
Actor NPC
Form kMask
int DatabaseLength = 0

int TimerID = 0 const
string EmptyState = "" const
string AliveState = "AliveState" const


; Events
;---------------------------------------------

Event OnInit()
	Log = new UserLog
	Log.Caller = self
	Log.FileName = "NPC"
EndEvent


Event OnEffectStart(Actor akTarget, Actor akCaster)
	WriteLine(Log, "OnEffectStart(akTarget="+akTarget+", akCaster="+akCaster+")")
	If NPCEquipMode.Equip
		DatabaseLength = Database.Count
		RegisterForCustomEvent(Climate, "OnWeatherChanged")
		RegisterForCustomEvent(WorldRadiationMode, "OnChanged")
		RegisterForCustomEvent(Climate, "OnLocationChanged")
		NPC = akTarget
		GoToState(AliveState)
	Else
		WriteLine(Log, "NPC Equip Mode = false")
	EndIf
	
EndEvent


; States
;---------------------------------------------

State AliveState
	Event OnBeginState(string asOldState)
		WriteLine(Log, "Entering the "+GetState()+" state from "+asOldState)
		StartTimer(2, TimerID)
	EndEvent


	Event OnTimer(int aiTimerID)
		WriteLine(Log, "OnTimer(aiTimerID="+aiTimerID+")")
		If(IsAbleToEquip)
			WeatherConditions()
		EndIf
	EndEvent


	Event Metro:World:Climate.OnWeatherChanged(World:Climate akSender, var[] arguments)
		WriteLine(Log, "CloakEquip: OnWeatherChanged - Re-evaluating WeatherOnly")
		If(IsAbleToEquip)
			If ((Radiation.WeatherOnly && Climate.Weatherbad == false) || (Radiation.RadWeatherOnly && Climate.RadWeatherBad == false))
				NPC.UnEquipItem(kMask, false, true)
				NPC.RemoveKeyword(Metro_NPC_CloakKeyword)
				WriteLine(Log, NPC+" unequipped '"+kMask+"''.IsEquipped=="+NPC.IsEquipped(kMask))
			ElseIf(Radiation.WeatherOnly  || Radiation.RadWeatherOnly)
				StartTimer(5, TimerID)
			EndIf
		EndIf
	EndEvent


	Event Metro:Terminals:WorldRadiationMode.OnChanged(Terminals:WorldRadiationMode akSender, var[] arguments)
		WriteLine(Log, "WorldRadiationMode: OnChanged - Re-evaluating Mask conditions")
		If(IsAbleToEquip)
			WeatherConditions()
		EndIf
	EndEvent

	Event Metro:World:Climate.OnLocationChanged(World:Climate akSender, var[] arguments)
		Utility.Wait(0.5)
		WriteLine(Log, "CloakEquip: OnLocationChanged")
		If(IsAbleToEquip)
			WeatherConditions()
		EndIf
	EndEvent


	Event OnDying(Actor akKiller)
		WriteLine(Log, "OnDying(akKiller="+akKiller+")")
		GoToState(EmptyState)
	EndEvent


	Event OnEndState(string asNewState)
		WriteLine(Log, "Ending the "+GetState()+", new state "+asNewState)
		UnregisterForCustomEvent(Climate, "OnWeatherChanged")
		UnregisterForCustomEvent(Climate, "OnLocationChanged")
		UnregisterForCustomEvent(WorldRadiationMode, "OnChanged")
		CancelTimer(TimerID)
	EndEvent
EndState

Event Metro:Terminals:WorldRadiationMode.OnChanged(Terminals:WorldRadiationMode akSender, var[] arguments)
	{EMPTY}
EndEvent

Event Metro:World:Climate.OnWeatherChanged(World:Climate akSender, var[] arguments)
	{EMPTY}
EndEvent

Event Metro:World:Climate.OnLocationChanged(World:Climate akSender, var[] arguments)
	{EMPTY}
EndEvent


; Functions
;---------------------------------------------

Function AddMask()
	If (NPC.HasKeyword(Metro_NPC_CloakKeyword) == False)
		NPC.AddItem(Metro_NPC_Raider_RandomGeneral,1,true)
		WriteLine(Log, "The NPC '"+NPC+"' added the gas mask '"+Metro_NPC_Raider_RandomGeneral+"'.")
		StartTimer(5, TimerID)
	EndIf
EndFunction

Function Equip()
	WriteLine(Log, "Equip()...")
	int index = DatabaseLength - 1
	While(index >= 0)
		kMask = Database.GetAt(index)
		If(NPC.IsEquipped(kMask) == true)
			NPC.AddKeyword(Metro_NPC_CloakKeyword)
			WriteLine(Log, NPC+" already has the gas mask " + kMask + " equipped")
			return
		ElseIf (NPC.GetItemCount(kMask) >= 1)
			NPC.EquipItem(kMask, true, true)
			WriteLine(Log, NPC+" has the gas mask '"+kMask+"''. IsEquipped=="+NPC.IsEquipped(kMask))
			NPC.AddKeyword(Metro_NPC_CloakKeyword)
			return
		EndIf
		index -= 1
	EndWhile
EndFunction

Function WeatherConditions()
	If ((Radiation.WeatherOnly && Climate.WeatherBad) || (Radiation.RadWeatherOnly && Climate.RadWeatherBad) || (Radiation.WeatherOnly == false && Radiation.RadWeatherOnly == false))
			Equip()
			AddMask()
	ElseIf((Radiation.RadWeatherOnly && Climate.RadWeatherBad == false) || (Radiation.WeatherOnly && Climate.WeatherBad == false))
			NPC.UnEquipItem(kMask, false, true)
			NPC.RemoveKeyword(Metro_NPC_CloakKeyword)
			WriteLine(Log, NPC+" unequipped '"+kMask+"''.IsEquipped=="+NPC.IsEquipped(kMask))
	EndIf
EndFunction



; Properties
;---------------------------------------------

Group Context
	Gear:Database Property Database Auto Const Mandatory
	Terminals:NPCEquipMode Property NPCEquipMode Auto Const Mandatory
	Terminals:WorldRadiationMode Property WorldRadiationMode Auto Const Mandatory
	World:Climate Property Climate Auto Const Mandatory
	World:Radiation Property Radiation Auto Const Mandatory
EndGroup

Group Properties
	Faction Property ChildrenOfAtomFaction Auto Const Mandatory
	Keyword Property ArmorTypePower Auto Const Mandatory
	Keyword Property Metro_NPC_CloakKeyword Auto Const Mandatory
	LeveledItem Property Metro_NPC_Raider_RandomGeneral Auto Const Mandatory
EndGroup

Group Conditions
	bool Property IsAbleToEquip Hidden
		bool Function Get()
			If (NPC.IsInInterior() == false && NPC.WornHasKeyword(ArmorTypePower) == false)
				return true
			Else
				return false
			EndIf
		EndFunction
	EndProperty
EndGroup


