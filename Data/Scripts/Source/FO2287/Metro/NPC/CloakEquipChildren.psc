Scriptname Metro:NPC:CloakEquipChildren extends ActiveMagicEffect
{MGEF:Metro_CloakEquipChildEffect}
import Metro
import Shared:Log

UserLog Log
Actor Player
Actor NPC
Form kMask
int DatabaseLength = 0
float iRadius = 5000.0

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
	Player = Game.GetPlayer()
	NPC = akTarget
	If(NPC != None)
		If NPC.Is3DLoaded()
			If NPCEquipMode.Equip
				NPC = akTarget
				If NPC.IsInFaction(CurrentCompanionFaction) && NPCCompanionMode.Equip
					DatabaseLength = GasMask_List_Children.GetSize()
					RegisterForRemoteEvent(NPC, "OnLocationChange")
					RegisterForCustomEvent(Climate, "OnWeatherChanged")
					RegisterForCustomEvent(WorldRadiationMode, "OnChanged")
					RegisterForCustomEvent(Climate, "OnLocationChanged")
					GoToState(AliveState)
				ElseIf NPC.IsInFaction(CurrentCompanionFaction) == false
					DatabaseLength = GasMask_List_Children.GetSize()
					RegisterForRemoteEvent(NPC, "OnLocationChange")
					RegisterForCustomEvent(Climate, "OnWeatherChanged")
					RegisterForCustomEvent(WorldRadiationMode, "OnChanged")
					RegisterForCustomEvent(Climate, "OnLocationChanged")
					GoToState(AliveState)
				EndIf
			Else
				WriteLine(Log, "NPC Equip Mode = false")
			EndIf
		EndIf
	EndIf
EndEvent


; States
;---------------------------------------------

State AliveState
	Event OnBeginState(string asOldState)
		If(NPC != None)
			If NPC.Is3DLoaded()
				WriteLine(Log, "Entering the "+GetState()+" state from "+asOldState)
				StartTimer(2, TimerID)
			EndIf
		Else
			GoToState("")
		EndIf
	EndEvent


	Event OnTimer(int aiTimerID)
		If(NPC != None)
			If NPC.Is3DLoaded()
				WriteLine(Log, "OnTimer(aiTimerID="+aiTimerID+")")
				If Search()
					UnEquipHelm()
					StartTimer(10, TimerID)
					WriteLine(Log, "AFS in Distance...")
				ElseIf(IsAbleToEquip)
					WeatherConditions()
				EndIf
			EndIf
		Else
			GoToState("")
		EndIf
	EndEvent


	Event Metro:World:Climate.OnWeatherChanged(World:Climate akSender, var[] arguments)
		If(NPC != None)
			If NPC.Is3DLoaded()
				WriteLine(Log, "CloakEquip: OnWeatherChanged - Re-evaluating WeatherOnly")
				If Search()
					UnEquipHelm()
					StartTimer(10, TimerID)
					WriteLine(Log, "AFS in Distance...")
				ElseIf(IsAbleToEquip)
					If ((Radiation.WeatherOnly && Climate.Weatherbad == false) || (Radiation.RadWeatherOnly && Climate.RadWeatherBad == false))
						UnEquipHelm()
					ElseIf(Radiation.WeatherOnly  || Radiation.RadWeatherOnly)
						StartTimer(5, TimerID)
					EndIf
				EndIf
			EndIf
		Else
			GoToState("")
		EndIf
	EndEvent


	Event Metro:Terminals:WorldRadiationMode.OnChanged(Terminals:WorldRadiationMode akSender, var[] arguments)
		If(NPC != None)
			If NPC.Is3DLoaded()
				WriteLine(Log, "WorldRadiationMode: OnChanged - Re-evaluating Mask conditions")
				If Search()
					UnEquipHelm()
					StartTimer(10, TimerID)
					WriteLine(Log, "AFS in Distance...")
				ElseIf(IsAbleToEquip)
					WeatherConditions()
				EndIf
			EndIf
		Else
			GoToState("")
		EndIf
	EndEvent

	Event Metro:World:Climate.OnLocationChanged(World:Climate akSender, var[] arguments)
		Utility.Wait(0.5)
		If(NPC != None)
			If NPC.Is3DLoaded()
				WriteLine(Log, "CloakEquip: OnLocationChanged")
				If Search()
					UnEquipHelm()
					StartTimer(10, TimerID)
					WriteLine(Log, "AFS in Distance...")
				ElseIf(IsAbleToEquip)
					WeatherConditions()
				ElseIf NPC.IsInInterior()
					UnEquipHelm()
				EndIf
			EndIf
		Else
			GoToState("")
		EndIf
	EndEvent
	
	Event Actor.OnLocationChange(Actor akNPC, Location akOldLoc, Location akNewLoc)
		Utility.Wait(0.5)
		If(NPC != None)
			If NPC.Is3DLoaded()
				WriteLine(Log, "CloakEquip: NPC OnLocationChange")
				If Search()
					UnEquipHelm()
					StartTimer(10, TimerID)
					WriteLine(Log, "AFS in Distance...")
				ElseIf(IsAbleToEquip)
					WeatherConditions()
				ElseIf NPC.IsInInterior()
					UnEquipHelm()
				EndIf
			EndIf
		Else
			GoToState("")
		EndIf
	EndEvent


	Event OnDying(Actor akKiller)
		WriteLine(Log, "OnDying(akKiller="+akKiller+")")
		GoToState(EmptyState)
	EndEvent


	Event OnEndState(string asNewState)
		WriteLine(Log, "Ending the "+GetState()+", new state "+asNewState)
		UnRegisterForRemoteEvent(NPC, "OnLocationChange")
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

Event Actor.OnLocationChange(Actor akNPC, Location akOldLoc, Location akNewLoc)
	{EMPTY}
EndEvent


; Functions
;---------------------------------------------

Function AddMask()
	If (NPC.HasKeyword(Metro_NPC_CloakKeyword) == False)
		NPC.AddItem(Metro_NPC_Child,1,true)
		WriteLine(Log, "The NPC '"+NPC+"' added the gas mask '"+Metro_NPC_Child+"'.")
		StartTimer(5, TimerID)
	EndIf
EndFunction

Function Equip()
	WriteLine(Log, "Equip()...")
	int index = 0
	While(index <= DatabaseLength - 1)
		kMask = GasMask_List_Children.GetAt(index)
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
		index += 1
	EndWhile
EndFunction

Function WeatherConditions()
	If ((Radiation.WeatherOnly && Climate.WeatherBad) || (Radiation.RadWeatherOnly && Climate.RadWeatherBad) || (Radiation.WeatherOnly == false && Radiation.RadWeatherOnly == false))
			Equip()
			AddMask()
	ElseIf((Radiation.RadWeatherOnly && Climate.RadWeatherBad == false) || (Radiation.WeatherOnly && Climate.WeatherBad == false))
			UnEquipHelm()
	EndIf
EndFunction

Function UnEquipHelm()
	If(NPC != None)
		If NPC.Is3DLoaded()
			If kMask != None
				If(NPC.IsEquipped(kMask) == true)
					NPC.UnEquipItem(kMask, false, true)
					If NPC.HasKeyword(Metro_NPC_CloakKeyword) == true
						NPC.RemoveKeyword(Metro_NPC_CloakKeyword)
					EndIf
					WriteLine(Log, NPC+" unequipped '"+kMask+"''.IsEquipped=="+NPC.IsEquipped(kMask))
				EndIf
			EndIf
		EndIf
	EndIf
EndFunction

bool Function Search()
	; Searches for a Nearby AFS, if one is in the area, unequip mask.
	ObjectReference AirFilter
	float X
	float Y
	float Z
	X = NPC.GetPositionX()
	Y = NPC.GetPositionY()
	Z = NPC.GetPositionZ()
	AirFilter = Game.FindClosestReferenceOfType(GasMask_AirFilter, X, Y, Z, iRadius)
	If(AirFilter != None)
		If (AirFilter.IsPowered() && NPC.GetDistance(AirFilter) <= AirFilter.GetValue(GasMask_AirFilter_Distance))
			return True
		Else
			StartTimer(10, TimerID)
			return False
		EndIf
	Else
		return False
	EndIf
EndFunction

; Properties
;---------------------------------------------

Group Context
	Terminals:NPCEquipMode Property NPCEquipMode Auto Const Mandatory
	Terminals:WorldRadiationMode Property WorldRadiationMode Auto Const Mandatory
	Terminals:NPCCompanionMode Property NPCCompanionMode Auto Const Mandatory
	World:Climate Property Climate Auto Const Mandatory
	World:Radiation Property Radiation Auto Const Mandatory
EndGroup

Group Properties
	Form property GasMask_AirFilter Auto Const Mandatory
	ActorValue property GasMask_AirFilter_Distance Auto Const Mandatory
	Faction Property ChildrenOfAtomFaction Auto Const Mandatory
	Faction Property CurrentCompanionFaction Auto Const Mandatory
	Keyword Property ArmorTypePower Auto Const Mandatory
	Keyword Property Metro_NPC_CloakKeyword Auto Const Mandatory
	LeveledItem Property Metro_NPC_Child Auto Const Mandatory
	FormList Property GasMask_List_Children Auto 
EndGroup

Group Conditions
	bool Property IsAbleToEquip Hidden
		bool Function Get()
			If (NPC.IsInInterior() == false && NPC.IsInPowerArmor() == false)
				return true
			Else
				return false
			EndIf
		EndFunction
	EndProperty
EndGroup
