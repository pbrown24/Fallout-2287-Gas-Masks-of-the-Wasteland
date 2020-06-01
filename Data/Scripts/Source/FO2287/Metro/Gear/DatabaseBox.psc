Scriptname Metro:Gear:DatabaseBox extends ActiveMagicEffect
import Metro
import Metro:Context
import Shared:Log
import Shared:Papyrus

UserLog Log

objectreference box

Event OnEffectStart(Actor akTarget, Actor akCaster)
	Log = GetLog(self)
	Log.FileName = "Gear"
	Actor Player = Game.GetPlayer()
	Player.AddItem(GasMask_GearDatabaseMenu, 1)
	box = Player.PlaceAtMe(GasMask_GasMaskBox, 1)
	RegisterForRemoteEvent(box, "OnClose")
	RegisterForRemoteEvent(box, "OnItemAdded")
	AddInventoryEventFilter(none)
EndEvent

Event ObjectReference.OnItemAdded(ObjectReference akSender, Form akBaseItem, int aiItemCount, ObjectReference akItemReference, ObjectReference akSourceContainer)
	WriteLine(Log, "Box: OnItemAdded")
	If akBaseItem != None
		GasMask_Database_Container.AddForm(akBaseItem)
		WriteLine(Log, "	[Added " + akBaseItem + "]")
	EndIf
EndEvent

Event ObjectReference.OnClose(ObjectReference akSender ,ObjectReference akActionRef)
	WriteLine(Log, "Box: OnClose")
	Menu()
EndEvent

Function Menu()
	int button = GasMask_Database_Menu.Show()
	int i = 0
	If button == 0
		If(GasMask_Database_Container != None)
			While ( i < GasMask_Database_Container.GetSize())
				If Database.Contains(GasMask_Database_Container.GetAt(i) as Armor)
					WriteLine(Log, "Database: Mask already in Database")
					GasMask_NoMaskAdded.show()
				Else
					WriteLine(Log, "Database: Mask NOT in Database adding mask")
					Database.AddMask(GasMask_Database_Container.GetAt(i) as Armor)
					GasMask_MaskAdded.show()
				EndIf
				i += 1
			EndWhile
		EndIf
		box.RemoveAllItems(Game.GetPlayer())
		box.Delete()
		GasMask_Database_Container.Revert()
	ElseIf button == 1
		If(GasMask_Database_Container != None)
			While ( i < GasMask_Database_Container.GetSize())
				If Database.Contains(GasMask_Database_Container.GetAt(i) as Armor)
					Mask.RemoveMask()
					Database.RemoveMask(GasMask_Database_Container.GetAt(i) as Armor)
					WriteLine(Log, "Database: Mask IN Database removing mask")
					GasMask_MaskRemoved.show()
				Else
					WriteLine(Log, "Database: Mask already not in Database")
					GasMask_NoMaskRemoved.show()
				EndIf
				i += 1
			EndWhile
		EndIf
		box.RemoveAllItems(Game.GetPlayer())
		box.Delete()
		GasMask_Database_Container.Revert()
	ElseIf button == 2
		Database.ResetDatabase()
		Menu()
	ElseIf button == 3
		; Do Nothing
		box.RemoveAllItems(Game.GetPlayer())
		box.Delete()
		GasMask_Database_Container.Revert()
	EndIf
EndFunction

Event OnEffectFinish(Actor akTarget, Actor akCaster)
	box.RemoveAllItems(Game.GetPlayer())
	box.Delete()
	GasMask_Database_Container.Revert()
EndEvent


; Properties
;---------------------------------------------
Group Context
	Gear:Mask Property Mask Auto Const Mandatory
	Gear:Database Property Database Auto Const Mandatory
EndGroup 

Group Properties
	FormList Property GasMask_Database_Container Auto
	Message Property GasMask_Database_Menu Auto
	Message Property GasMask_NoMaskAdded Auto
	Message Property GasMask_MaskAdded Auto
	Message Property GasMask_NoMaskRemoved Auto
	Message Property GasMask_MaskRemoved Auto
	Container Property GasMask_GasMaskBox Auto
	Potion Property GasMask_GearDatabaseMenu Auto
EndGroup
