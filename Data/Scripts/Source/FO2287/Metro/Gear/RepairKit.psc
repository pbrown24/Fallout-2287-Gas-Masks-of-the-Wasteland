Scriptname Metro:Gear:RepairKit extends ActiveMagicEffect
import Metro
import Shared:Log

Actor Player
float Rubber
float Glass
float Adhesive

Event OnEffectStart(Actor akTarget, Actor akCaster)
	Player = Game.GetPlayer()
	Player.AddItem(GasMask_GearRepairKit, 1, abSilent = true)
	If Player.IsInCombat()
		GasMask_Repair_InCombat.Show()
	Else
		GasMask_RepairSFX.Play(Player)
		GasMask_RepairFadeIMOD.Apply()
		Utility.Wait(3.0)
		Menu()
		ConditionDatabase.Repair(Mask.Equipped,GasMask_MaskPercentage.GetValueInt())
		;Debug.Notification("Current: " + GasMask_MaskPercentage.GetValueInt())
	EndIf
EndEvent

Function Menu()
	int percentage = GasMask_MaskPercentage.GetValueInt()
	int charges = GasMask_RepairCharges.GetValueInt()
	int button = GasMask_Repair_Menu.Show(GasMask_RepairCharges.GetValue(),Player.GetItemCount(Mask.Equipped) - 1,GasMask_MaskPercentage.GetValue())
	If button == 0	
		ComponentMenu()
	ElseIf button == 1
		charges = charges - 1
		GasMask_RepairCharges.SetValueInt(charges)
		GasMask_MaskPercentage.SetValueInt(percentage + 50)
		If GasMask_MaskPercentage.GetValueInt() > 100
			GasMask_MaskPercentage.SetValueInt(100)
		EndIf
		percentage = GasMask_MaskPercentage.GetValueInt()
		Menu()
	ElseIf button == 2
		MakeRepairKits()
	ElseIf button == 3
		If Player.GetItemCount(Mask.Equipped) > 1
			Player.RemoveItem(Mask.Equipped, 1)
			GasMask_MaskPercentage.SetValueInt(percentage + 90)
			If GasMask_MaskPercentage.GetValueInt() > 100
				GasMask_MaskPercentage.SetValueInt(100)
			EndIf
			percentage = GasMask_MaskPercentage.GetValueInt()
		EndIf
			Menu()
	Else
		return		
	EndIf
EndFunction

Function ComponentMenu()
	GetPlayerComponents()
	int percentage = GasMask_MaskPercentage.GetValueInt()
	int charges = GasMask_RepairCharges.GetValueInt()
	int button = GasMask_Repair_SpendComp.Show(GasMask_MaskPercentage.GetValue(), Adhesive, Glass, Rubber)
	If button == 0
		Player.RemoveItem(c_adhesive,1)
		Player.RemoveItem(c_glass,2)
		Player.RemoveItem(c_rubber,2)
		GasMask_MaskPercentage.SetValueInt(percentage + 25)
		If GasMask_MaskPercentage.GetValueInt() > 100
			GasMask_MaskPercentage.SetValueInt(100)
		EndIf
		percentage = GasMask_MaskPercentage.GetValueInt()
		ComponentMenu()
	ElseIf button == 1
		Player.RemoveItem(c_adhesive,2)
		Player.RemoveItem(c_glass,4)
		Player.RemoveItem(c_rubber,4)
		GasMask_MaskPercentage.SetValueInt(percentage + 50)
		If GasMask_MaskPercentage.GetValueInt() > 100
			GasMask_MaskPercentage.SetValueInt(100)
		EndIf
		percentage = GasMask_MaskPercentage.GetValueInt()
		ComponentMenu()
	ElseIf button == 2
		Player.RemoveItem(c_adhesive,4)
		Player.RemoveItem(c_glass,8)
		Player.RemoveItem(c_rubber,8)
		GasMask_MaskPercentage.SetValueInt(percentage + 100)
		If GasMask_MaskPercentage.GetValueInt() > 100
			GasMask_MaskPercentage.SetValueInt(100)
		EndIf
		percentage = GasMask_MaskPercentage.GetValueInt()
		ComponentMenu()
	ElseIf button == 3
		Menu()
	Else
		return
	EndIf
EndFunction

Function MakeRepairKits()
	GetPlayerComponents()
	int percentage = GasMask_MaskPercentage.GetValueInt()
	int charges = GasMask_RepairCharges.GetValueInt()
	int button = GasMask_Repair_RepairKits.Show(GasMask_MaxRepairCharges.GetValue(),GasMask_RepairCharges.GetValue(),GasMask_MaskPercentage.GetValue(), Adhesive, Glass, Rubber)
	If button == 0
		Player.RemoveItem(c_adhesive,2)
		Player.RemoveItem(c_glass,4)
		Player.RemoveItem(c_rubber,4)
		charges = charges + 1
		GasMask_RepairCharges.SetValueInt(charges)
		MakeRepairKits()
	ElseIf button == 1
		charges = charges - 1
		GasMask_RepairCharges.SetValueInt(charges)
		GasMask_MaskPercentage.SetValueInt(percentage + 50)
		If GasMask_MaskPercentage.GetValueInt() > 100
			GasMask_MaskPercentage.SetValueInt(100)
		EndIf
		percentage = GasMask_MaskPercentage.GetValueInt()
		MakeRepairKits()
	ElseIf button == 2
		Menu()
	ElseIf button == 3
		return
	EndIf
EndFunction

Function GetPlayerComponents()
	Adhesive = Player.GetItemCount(c_adhesive) + Player.GetItemCount(c_adhesive_scrap)
	Rubber = Player.GetItemCount(c_rubber) + Player.GetItemCount(c_rubber_scrap)
	Glass = Player.GetItemCount(c_glass) + Player.GetItemCount(c_glass_scrap)
EndFunction

Group Properties
	Sound Property GasMask_RepairSFX Auto
	Potion property GasMask_GearRepairKit Auto
	ImageSpaceModifier Property GasMask_RepairFadeIMOD Auto
	Component Property c_rubber Auto
	Component Property c_glass Auto
	Component Property c_adhesive Auto
	form Property c_rubber_scrap Auto
	form Property c_glass_scrap Auto
	form Property c_adhesive_scrap Auto
	Message Property GasMask_Repair_Menu Auto
	Message Property GasMask_Repair_RepairKits Auto
	Message Property GasMask_Repair_SpendComp Auto
	Message Property GasMask_Repair_InCombat Auto
	Gear:Mask Property Mask Auto Const Mandatory
	Gear:ConditionDatabase Property ConditionDatabase Auto Const Mandatory
	GlobalVariable Property GasMask_MaskPercentage Auto
	GlobalVariable Property GasMask_RepairCharges Auto
	GlobalVariable Property GasMask_MaxRepairCharges Auto
EndGroup
