Scriptname Metro:Gear:FilterPerks extends Metro:Core:Optional
{MGEF:Metro_Gear}
import Metro
import Metro:Player:Animation
import Shared:Log

UserLog Log
int numActivations = 0

; Events
;---------------------------------------------

Event OnInitialize()
	Log = new UserLog
	Log.Caller = self
	Log.FileName = "Filter Perks"
EndEvent


Event OnEnable()
	WriteLine(Log, "Filter Perk Initialized.")
	RegisterForRemoteEvent(Player,"OnSit")
	RegisterForRemoteEvent(Player,"OnGetUp")
EndEvent


Event OnDisable()
	WriteLine(Log, "Filter Perk Disabled.")
	UnRegisterForRemoteEvent(Player,"OnSit")
	UnRegisterForRemoteEvent(Player,"OnGetUp")
EndEvent


; Methods
;---------------------------------------------

Event Actor.OnSit(Actor akActor,ObjectReference akFurniture)
	If (akFurniture.GetBaseObject() == ChemStationA) || (akFurniture.GetBaseObject() == ChemStationB)
		WriteLine(Log, "Entered chem station.")
		RegisterForRemoteEvent(Player,"OnItemAdded")
		AddInventoryEventFilter(GasMask_Filter)
	EndIf
EndEvent

Event ObjectReference.OnItemAdded(ObjectReference Item, Form akBaseItem, int aiItemCount, ObjectReference akItemReference, ObjectReference akSourceContainer)
	FilterCraftCount += 1
	WriteLine(Log, "Made a filter.")
	If FilterCraftCount == 8
		Player.AddPerk(GasMask_Filter_Crafting_Rank1_Perk)
		GasMask_FilterPerkRank.SetValue(1.0)
	ElseIf FilterCraftCount == 23
		Player.AddPerk(GasMask_Filter_Crafting_Rank2_Perk)
		GasMask_FilterPerkRank.SetValue(2.0)
	ElseIf FilterCraftCount == 43
		Player.AddPerk(GasMask_Filter_Crafting_Rank3_Perk)
		GasMask_FilterPerkRank.SetValue(3.0)
	EndIf
EndEvent

Event Actor.OnGetUp(Actor akActor,ObjectReference akFurniture)
  If (akFurniture.GetBaseObject() == ChemStationA) || (akFurniture.GetBaseObject() == ChemStationB)
	WriteLine(Log, "Left chem Station.")
	UnRegisterForRemoteEvent(Player, "OnItemAdded")
	If numActivations <= 3
		Utility.Wait(2.0)
		int button
		button = GasMask_FilterHelpMessage.show()
		If button == 1
			numActivations = 4
		Else
			numActivations += 1
		EndIf
	EndIf
  EndIf
EndEvent

; Properties
;---------------------------------------------


Group Properties
	int property FilterCraftCount Auto
	Furniture Property ChemStationA Auto Const
	Furniture Property ChemStationB Auto Const
	Form property GasMask_Filter Auto Const
	Perk property GasMask_Filter_Crafting_Rank1_Perk Auto Const
	Perk property GasMask_Filter_Crafting_Rank2_Perk Auto Const
	Perk property GasMask_Filter_Crafting_Rank3_Perk Auto Const
	GlobalVariable property GasMask_FilterPerkRank Auto
	Message property GasMask_FilterHelpMessage Auto Const
EndGroup


