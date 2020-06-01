Scriptname Metro:World:AirFilter_Power extends ObjectReference

import Metro
import Metro:World
import Shared:Log

UserLog Log
ObjectReference AirFilter
String MessageText
Actor Player
int UpdateTimer = 0
int UpdateTimerOne = 1
int UpgradeLevel = 0

float Aluminum
float Screws
float Circuitry
float Copper
float Filters


; Events
;---------------------------------------------

Event OnLoad()
	Log = new UserLog
	Log.Caller = self
	Log.FileName = "Air Filter"
	Player = Game.GetPlayer()
	AirFilter = self
	If(Player.GetDistance(AirFilter) < Distance && AirFilter.IsPowered() == true)
		Player.AddSpell(GasMask_AirFilter_Spell)
	EndIf
	WriteLine(Log, "Air Filter Spell Added")
	GoToState("SpellOff")
EndEvent

State SpellOff

	Event OnBeginState(string oldState)
		RegisterForDistanceLessThanEvent(Player, AirFilter, Distance)
	EndEvent

	Event OnPowerOn(ObjectReference akPowerGenerator)
		AirFilter = self
		WriteLine(Log, "Air Filter System Powered")
		RegisterForDistanceLessThanEvent(Player, AirFilter, Distance)
		WriteLine(Log, AirFilter + " Powered On")
		
		If (Player.GetDistance(AirFilter) <= Distance)
			WriteLine(Log, "Air Filtration System distance less than: " + Distance)
			GoToState("SpellOn")
		EndIf
	EndEvent

	Event OnDistanceLessThan(ObjectReference akObj1, ObjectReference akObj2, float afDistance)
		 If (Player.GetDistance(AirFilter) <= Distance && AirFilter.IsPowered() == true)
			WriteLine(Log, "Event:Air Filtration System distance less than: " + Distance)
			GasMask_AirFiltration_AirFiltered.Show()
			GoToState("SpellOn")
		EndIf
	EndEvent

EndState

State SpellOn

	Event OnBeginState(string oldState)
		GasMask_AirFilter_Spell.Cast(AirFilter, Player)
		WriteLine(Log, "Air Filter Spell Cast")
		StartTimer(5.2, UpdateTimer)
		If(Player.HasMagicEffect(GasMask_RadiationEffect) == true)
			Radiation.Dispel_Rad()
		EndIf
	EndEvent

	
EndState

Event OnActivate(ObjectReference akActionRef)
	int message_num
	if akActionRef == Game.GetPlayer()
		GetPlayerComponents()
		If UpgradeLevel == 0
			message_num = GasMask_AirFiltration_UpgradeMenu.show(15.7, 21.4, Filters, 5, Aluminum, Screws, Copper, Circuitry, 0)
			if message_num == 0
				;show the message that tells the player they have upgraded
				Player.RemoveItem(GasMask_GearFilter, 5)
				Player.RemoveItem(c_Aluminum, 10)
				Player.RemoveItem(c_Screws, 5)
				Player.RemoveItem(c_Copper, 5)
				UpgradeLevel = 1
				GetPlayerComponents()
				UpgradeSuccessful_Level1.show()
				AirFilter.ModValue(GasMask_AirFilter_Distance, 1500.0)
				Distance = 1500.0
				WriteLine(Log, "System Upgraded:  0 to 1")
			endif
		EndIf
		
		If UpgradeLevel == 1
			message_num = GasMask_AirFiltration_UpgradeMenu.show(21.4, 27.1, Filters, 5, Aluminum, Screws, Copper, Circuitry, 0)
			if message_num == 0
				;show the message that tells the player they have upgraded
				Player.RemoveItem(GasMask_GearFilter, 5)
				Player.RemoveItem(c_Aluminum, 10)
				Player.RemoveItem(c_Screws, 5)
				Player.RemoveItem(c_Copper, 5)
				Player.RemoveItem(c_Circuitry, 5)
				UpgradeLevel = 2
				GetPlayerComponents()
				UpgradeSuccessful_Level2.show()
				AirFilter.ModValue(GasMask_AirFilter_Distance, 1900.0)
				Distance = 1900.0
				WriteLine(Log, "System Upgraded:  1 to 2")
			endif
		EndIf
		
		If UpgradeLevel == 2
			message_num = GasMask_AirFiltration_UpgradeMenu.show(27.1, 35.7, Filters, 10, Aluminum, Screws, Copper, Circuitry, 5)
			if message_num == 0
				;show the message that tells the player they have upgraded
				Player.RemoveItem(GasMask_GearFilter, 10)
				Player.RemoveItem(c_Aluminum, 10)
				Player.RemoveItem(c_Screws, 5)
				Player.RemoveItem(c_Copper, 5)
				Player.RemoveItem(c_Circuitry, 5)
				UpgradeLevel = 3
				GetPlayerComponents()
				UpgradeSuccessful_Level3.show()
				AirFilter.ModValue(GasMask_AirFilter_Distance, 2500.0)
				Distance = 2500.0
				WriteLine(Log, "System Upgraded:  2 to 3")
			endif
		EndIf
		
		If UpgradeLevel == 3
			message_num = GasMask_AirFiltration_UpgradeMenu.show(35.7, 47.1, Filters, 10, Aluminum, Screws, Copper, Circuitry, 5)
			if message_num == 0
				;show the message that tells the player they have upgraded
				Player.RemoveItem(GasMask_GearFilter, 10)
				Player.RemoveItem(c_Aluminum, 10)
				Player.RemoveItem(c_Screws, 5)
				Player.RemoveItem(c_Copper, 5)
				Player.RemoveItem(c_Circuitry, 5)
				UpgradeLevel = 4
				UpgradeSuccessful_Level4.show()
				AirFilter.ModValue(GasMask_AirFilter_Distance, 3300.0)
				Distance = 3300.0
				WriteLine(Log, "System Upgraded:  3 to 4")
			endif
		EndIf
		
		if UpgradeLevel == 4
			GasMask_AirFiltration_Max.show()
		endif
		
	endif
EndEvent

Event OnTimer(int aiTimerID)
	
	If(aiTimerID == UpdateTimer)
	
		;Player -------------------------------------
			If(Player.GetDistance(AirFilter) < Distance)
				WriteLine(Log, "Air Filtration System distance less than: " + Distance)
				GasMask_AirFilter_Spell.Cast(AirFilter, Player)
				WriteLine(Log, "Air Filter Spell Cast")
				StartTimer(5.0, UpdateTimer)
				If(Player.HasMagicEffect(GasMask_RadiationEffect) == true)
					Radiation.Dispel_Rad()
				EndIf
			Else
				WriteLine(Log, "Air Filtration System outside Distance going to state SpellOff")
				GasMask_AirFiltration_AirToxic.Show()
				Radiation.CheckRadiation()
				GoToState("SpellOff")
			EndIf
			
	EndIf
EndEvent

Event OnPowerOff()
	WriteLine(Log, AirFilter + " Powered Off")
	UnregisterForDistanceEvents(Player, AirFilter)
	CancelTimer(UpdateTimer)
	CancelTimer(UpdateTimerOne)
	Radiation.CheckRadiation()
	GoToState("SpellOff")
EndEvent

Event OnDistanceLessThan(ObjectReference akObj1, ObjectReference akObj2, float afDistance)
	{EMPTY}
EndEvent

; Functions
;---------------------------------------------

Function GetPlayerComponents()
	Aluminum = Player.GetItemCount(c_Aluminum) + Player.GetItemCount(c_Aluminum_scrap)
	Screws = Player.GetItemCount(c_Screws) + Player.GetItemCount(c_Screws_scrap)
	Circuitry = Player.GetItemCount(c_Circuitry) + Player.GetItemCount(c_Circuitry_scrap)
	Copper = Player.GetItemCount(c_Copper) + Player.GetItemCount(c_Copper_scrap)
	Filters = Player.GetItemCount(GasMask_GearFilter)
	Upgrade()
EndFunction

Function Upgrade()
	If UpgradeLevel == 0
		If((Filters >= 5) && (Aluminum >= 10) && (Screws >= 5) && (Copper >= 5))
			CanUpgrade.SetValueInt(1)
		Else
			CanUpgrade.SetValueInt(0)
		EndIf
	ElseIf UpgradeLevel == 1
		If((Filters >= 5) && (Aluminum >= 10) && (Screws >= 5) && (Copper >= 5) && (Circuitry >= 5))
			CanUpgrade.SetValueInt(1)
		Else
			CanUpgrade.SetValueInt(0)
		EndIf
	ElseIf UpgradeLevel == 2 || UpgradeLevel == 3
		If((Filters >= 10) && (Aluminum >= 10) && (Screws >= 5) && (Copper >= 5) && (Circuitry >= 5))
			CanUpgrade.SetValueInt(1)
		Else
			CanUpgrade.SetValueInt(0)
		EndIf
	Else
		CanUpgrade.SetValueInt(0)
	EndIf		
	WriteLine(Log, "CanUpgrade: " + CanUpgrade.GetValue())
EndFunction


; Properties
;---------------------------------------------

Group Context
	World:Radiation Property Radiation Auto Const Mandatory
EndGroup

Group Properties
	GlobalVariable Property CanUpgrade Auto
	ActorValue Property GasMask_AirFilter_Distance Auto
	Form Property c_Aluminum Auto Const Mandatory
	Form Property c_Circuitry Auto Const Mandatory
	Form Property c_Copper Auto Const Mandatory
	Form Property c_Screws Auto Const Mandatory
	Form Property c_Aluminum_scrap Auto Const Mandatory
	Form Property c_Circuitry_scrap Auto Const Mandatory
	Form Property c_Copper_scrap Auto Const Mandatory
	Form Property c_Screws_scrap Auto Const Mandatory
	Potion Property GasMask_GearFilter Auto Const Mandatory
	Spell Property GasMask_AirFilter_Spell Auto Const Mandatory
	MagicEffect Property GasMask_RadiationEffect Auto Const Mandatory
	Message Property GasMask_AirFiltration_AirFiltered Auto
	Message Property GasMask_AirFiltration_AirToxic Auto
	Message Property GasMask_AirFiltration_UpgradeMenu Auto
	Message Property GasMask_AirFiltration_Max Auto
	Message Property UpgradeSuccessful_Level1 Auto
	Message Property UpgradeSuccessful_Level2 Auto
	Message Property UpgradeSuccessful_Level3 Auto
	Message Property UpgradeSuccessful_Level4 Auto
	float Property Distance Auto Mandatory
	{The distance from the player at which the spell can be cast}
EndGroup

