Scriptname Metro:NPC:CloakEquip extends ActiveMagicEffect
{MGEF:Metro_CloakEquipEffect}
import Metro
import Shared:Log

UserLog Log
Actor Player
Actor NPC
Armor kMask
int DatabaseLength = 0
float iRadius = 5000.0

int TimerID = 0 const
string EmptyState = "" const
string AliveState = "AliveState" const

; Properties
;---------------------------------------------

Group Context
	Gear:Database Property Database Auto Const Mandatory
	Terminals:NPCEquipMode Property NPCEquipMode Auto Const Mandatory
	Terminals:NPCCompanionMode Property NPCCompanionMode Auto Const Mandatory
	Terminals:WorldRadiationMode Property WorldRadiationMode Auto Const Mandatory
	World:Climate Property Climate Auto Const Mandatory
	World:Radiation Property Radiation Auto Const Mandatory
EndGroup

Group Properties
	Form property GasMask_AirFilter Auto Const Mandatory
	ActorValue property GasMask_AirFilter_Distance Auto Const Mandatory
	MagicEffect Property GasMask_AirFilter_SpellEffect Auto Const Mandatory
	Spell Property GasMask_NPC_CloakEquip Auto Const
	bool Property MaskEquipped = false Conditional Auto
	Keyword Property GasMask_NPC_CloakKeyword Auto
	
	Faction Property BrotherhoodofSteelFaction Auto Const Mandatory
	Faction Property RaiderFaction Auto Const Mandatory
	Faction Property GunnerFaction Auto Const Mandatory
	Faction Property GenericNPCFaction Auto Const Mandatory
	Faction Property InstituteFaction Auto Const Mandatory
	Faction Property MinutemenFaction Auto Const Mandatory
	Faction Property ChildrenOfAtomFaction Auto Const Mandatory
	Faction Property CurrentCompanionFaction Auto Const Mandatory
	
	LeveledItem Property Metro_NPC_Military_Random Auto Const Mandatory
	LeveledItem Property Metro_NPC_Science_Random Auto Const Mandatory
	LeveledItem Property Metro_NPC_Military_RandomGeneral Auto Const Mandatory
	LeveledItem Property Metro_NPC_Settler_RandomGeneral Auto Const Mandatory
	LeveledItem Property Metro_NPC_Raider_RandomGeneral Auto Const Mandatory
	
	Location Property DiamondCityLocation Auto Const Mandatory
	Location Property GoodNeighborLocation Auto Const Mandatory
EndGroup

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
	MaskEquipped = false
	If  (akTarget as objectReference).WaitFor3DLoad()
		If NPCEquipMode.Equip
			If (NPC.IsInFaction(CurrentCompanionFaction) && NPCCompanionMode.Equip) || NPC.IsInFaction(CurrentCompanionFaction) == false
				DatabaseLength = Database.Count	
				RegisterForRemoteEvent(NPC, "OnLocationChange")
				RegisterForCustomEvent(Climate, "OnWeatherChanged")
				RegisterForCustomEvent(WorldRadiationMode, "OnChanged")
				RegisterForCustomEvent(Climate, "OnLocationChanged")
				GoToState(AliveState)
			Else
				NPC.DispelSpell(GasMask_NPC_CloakEquip)
			EndIf
		Else
			NPC.DispelSpell(GasMask_NPC_CloakEquip)
			WriteLine(Log, "NPC Equip Mode = false")
		EndIf
	EndIf
EndEvent


; States
;---------------------------------------------

State AliveState

	Event OnBeginState(string asOldState)
		If(NPC != None)
			If (NPC as objectReference).WaitFor3DLoad()
				WriteLine(Log, "Entering the "+GetState()+" state from "+asOldState)
				StartTimer(0.5, TimerID)
			EndIf
		EndIf
	EndEvent


	Event OnTimer(int aiTimerID)
		If(NPC != None)
			If (NPC as objectReference).WaitFor3DLoad()
				WriteLine(Log, "OnTimer(aiTimerID="+aiTimerID+")")
				If Search() || NPC.IsInInterior()
					UnEquipHelm()
					StartTimer(10, TimerID)
					WriteLine(Log, "AFS in Distance...")
				ElseIf(IsAbleToEquip)
					WeatherConditions()
				EndIf
			EndIf
		EndIf
	EndEvent


	Event Metro:World:Climate.OnWeatherChanged(World:Climate akSender, var[] arguments)
		If(NPC != None)
			If (NPC as objectReference).WaitFor3DLoad()
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
		EndIf
	EndEvent


	Event Metro:Terminals:WorldRadiationMode.OnChanged(Terminals:WorldRadiationMode akSender, var[] arguments)
		If(NPC != None)
			If (NPC as objectReference).WaitFor3DLoad()
				WriteLine(Log, "WorldRadiationMode: OnChanged - Re-evaluating Mask conditions")
				If Search()
					UnEquipHelm()
					StartTimer(10, TimerID)
					WriteLine(Log, "AFS in Distance...")
				ElseIf(IsAbleToEquip)
					WeatherConditions()
				EndIf
			EndIf
		EndIf
	EndEvent

	Event Metro:World:Climate.OnLocationChanged(World:Climate akSender, var[] arguments)
		Utility.Wait(0.5)
		If(NPC != None)
			If (NPC as objectReference).WaitFor3DLoad()
				WriteLine(Log, "CloakEquip: Player OnLocationChanged")
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
		EndIf
	EndEvent
	
	Event Actor.OnLocationChange(Actor akNPC, Location akOldLoc, Location akNewLoc)
		Utility.Wait(0.5)
		If(NPC != None)
			If (NPC as objectReference).WaitFor3DLoad()
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

; Event ObjectReference.OnItemRemoved(ObjectReference akNPC, Form akBaseItem, int aiItemCount, ObjectReference akItemReference, ObjectReference akDestContainer)
	; {EMPTY}
; EndEvent


; Functions
;---------------------------------------------

Function AddMask()
	If NPC.IsInFaction(RaiderFaction)
		WriteLine(Log, "NPC is Raider")
		NPC.AddItem(Metro_NPC_Raider_RandomGeneral,1,true)
	ElseIf NPC.IsInFaction(GunnerFaction)
		WriteLine(Log, "NPC is Gunner")
		NPC.AddItem(Metro_NPC_Military_RandomGeneral,1,true)
	ElseIf NPC.IsInFaction(BrotherhoodofSteelFaction)
		WriteLine(Log, "NPC is BoS")
		NPC.AddItem(Metro_NPC_Military_Random,1,true)
	ElseIf NPC.IsInFaction(MinutemenFaction)
		WriteLine(Log, "NPC is Minutemen")
		NPC.AddItem(Metro_NPC_Settler_RandomGeneral,1,true)
	ElseIf NPC.IsInFaction(InstituteFaction)
		WriteLine(Log, "NPC is Institute")
		NPC.AddItem(Metro_NPC_Science_Random,1,true)
	ElseIf NPC.IsInFaction(GenericNPCFaction)
		WriteLine(Log, "NPC is Generic")
		NPC.AddItem(Metro_NPC_Settler_RandomGeneral,1,true)
	Else
		WriteLine(Log, "NPC is Other")
		NPC.AddItem(Metro_NPC_Settler_RandomGeneral,1,true)
	EndIf
	Equip()
EndFunction

Function Equip()
	WriteLine(Log, "Equip()...")
	If  (NPC as objectReference).WaitFor3DLoad()
		int index = 0
		While(index < Database.Count && MaskEquipped == false)
			kMask = Database.GetAt(index)
			If(Database.GetClassification(kMask) == 0) ;Check that it is ClassGasMask
				If(NPC.IsEquipped(kMask) == true) ;Already Equipped? Add Keyword.
					MaskEquipped = true
					NPC.AddKeyword(GasMask_NPC_CloakKeyword)
					WriteLine(Log, NPC+" already has the gas mask " + kMask + " equipped")
					return
				ElseIf (NPC.GetItemCount(kMask) > 0) ;Else if it is in inventory, Equip it.
					NPC.EquipItem(kMask, true, true)
					WriteLine(Log, NPC+" has the gas mask '"+kMask+"''. IsEquipped=="+NPC.IsEquipped(kMask))
					MaskEquipped = true
					NPC.AddKeyword(GasMask_NPC_CloakKeyword)
					return
				EndIf
			EndIf
			index += 1
		EndWhile
		If MaskEquipped == false
			AddMask()
		EndIf
	EndIf
EndFunction

Function WeatherConditions()
	If ((Radiation.WeatherOnly && Climate.WeatherBad) || (Radiation.RadWeatherOnly && Climate.RadWeatherBad) || (Radiation.WeatherOnly == false && Radiation.RadWeatherOnly == false))
		Equip()
	Else;If((Radiation.WeatherOnly && Climate.WeatherBad == false) || (Radiation.RadWeatherOnly && Climate.RadWeatherBad == false))
		UnEquipHelm()
	EndIf
EndFunction

Function UnEquipHelm()
	If  (NPC as objectReference).WaitFor3DLoad()
		If(kMask != None)
			If(NPC.IsEquipped(kMask) == true)
				NPC.UnEquipItem(kMask, false, true)
				kMask = none
				;WriteLine(Log, NPC+" unequipped '"+kMask+"''.IsEquipped=="+NPC.IsEquipped(kMask))
			EndIf
		EndIf
		If MaskEquipped == true
			NPC.RemoveKeyword(GasMask_NPC_CloakKeyword)
			MaskEquipped = false
		EndIf
	EndIf
	;UnRegisterForRemoteEvent(NPC, "OnItemRemoved")
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
	ElseIf(NPC.GetCurrentLocation() == DiamondCityLocation || NPC.GetCurrentLocation() == GoodNeighborLocation) && ((Climate.WeatherBad == false) || (Climate.RadWeatherBad == false))
		return True
	Else
		return False
	EndIf
EndFunction


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


