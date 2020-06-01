ScriptName Metro:Gear:GasMaskBox extends Form
import Metro
import Shared:Log

UserLog Log

FormList GasMask_Database_Container

; Events
;---------------------------------------------	

Event OnOpen(ObjectReference akActionRef)
	AddInventoryEventFilter(none)
EndEvent

Event OnItemAdded(Form akBaseItem, int aiItemCount, ObjectReference akItemReference, ObjectReference akSourceContainer)
	GasMask_Database_Container.AddForm(akBaseItem)
EndEvent

Event OnClose(ObjectReference akActionRef)
	RemoveAllinventoryEventFilters()
	Menu()
EndEvent

Function Menu()
	int button = GasMask_Database_Menu.Show()
	int i = 0
	If button == 0
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
		self.RemoveAllItems(Game.GetPlayer())
		self.Delete()
	ElseIf button == 1
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
		self.RemoveAllItems(Game.GetPlayer())
		self.Delete()
	ElseIf button == 2
		Database.ResetDatabase()
		Menu()
	ElseIf button == 3
		; Do Nothing
		self.RemoveAllItems(Game.GetPlayer())
		self.Delete()
	EndIf
EndFunction


; Properties
;---------------------------------------------
Group Context
	Gear:Mask Property Mask Auto Const Mandatory
	Gear:Database Property Database Auto Const Mandatory
EndGroup 

Group Properties
	Message Property GasMask_Database_Menu Auto
	
	Message Property GasMask_NoMaskAdded Auto
	Message Property GasMask_MaskAdded Auto
	
	Message Property GasMask_NoMaskRemoved Auto
	Message Property GasMask_MaskRemoved Auto
EndGroup
