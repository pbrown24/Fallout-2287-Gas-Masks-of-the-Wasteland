ScriptName Metro:Terminals:GearMaskOverlayPresets extends Terminal
import Metro
import Metro:Gear:Mask
import Shared:Log

UserLog Log

int ReturnID = 8 const


; Events
;---------------------------------------------

Event OnInit()
	Log = new UserLog
	Log.Caller = self
	Log.FileName = Context.Title
EndEvent


Event OnMenuItemRun(int auiMenuItemID, ObjectReference akTerminalRef)
	If (auiMenuItemID == ReturnID)
		return
	ElseIf (auiMenuItemID == 1)
		MaskOverlay.OverlayToggle = true
		ConditionDatabase.GasMask_GearOverlayCurrent_Stage1 = ConditionDatabase.GasMask_GearOverlayVisual_Stage1
		ConditionDatabase.GasMask_GearOverlayCurrent_Stage2 = ConditionDatabase.GasMask_GearOverlayVisual_Stage2
		ConditionDatabase.GasMask_GearOverlayCurrent_Stage3 = ConditionDatabase.GasMask_GearOverlayVisual_Stage3
		ConditionDatabase.GasMask_GearOverlayCurrent_Stage4 = ConditionDatabase.GasMask_GearOverlayVisual_Stage4
		ConditionDatabase.GasMask_GearOverlayCurrent_Stage5 = ConditionDatabase.GasMask_GearOverlayVisual_Stage5
		ConditionDatabase.SetNewOverlay(Mask.Equipped)
		GasMask_OverlayPreset.SetValue(1.0)
	ElseIf (auiMenuItemID == 2)
		MaskOverlay.OverlayToggle = true
		ConditionDatabase.GasMask_GearOverlayCurrent_Stage1 = GasMask_GearVisorVisual_Stage1
		ConditionDatabase.GasMask_GearOverlayCurrent_Stage2 = GasMask_GearVisorVisual_Stage2
		ConditionDatabase.GasMask_GearOverlayCurrent_Stage3 = GasMask_GearVisorVisual_Stage3
		ConditionDatabase.GasMask_GearOverlayCurrent_Stage4 = GasMask_GearVisorVisual_Stage4
		ConditionDatabase.GasMask_GearOverlayCurrent_Stage5 = GasMask_GearVisorVisual_Stage5
		ConditionDatabase.SetNewOverlay(Mask.Equipped)
		GasMask_OverlayPreset.SetValue(2.0)
	ElseIf (auiMenuItemID == 3)
		MaskOverlay.OverlayToggle = true
		ConditionDatabase.GasMask_GearOverlayCurrent_Stage1 = GasMask_GearGogglesVisual_Stage1
		ConditionDatabase.GasMask_GearOverlayCurrent_Stage2 = GasMask_GearGogglesVisual_Stage2
		ConditionDatabase.GasMask_GearOverlayCurrent_Stage3 = GasMask_GearGogglesVisual_Stage3
		ConditionDatabase.GasMask_GearOverlayCurrent_Stage4 = GasMask_GearGogglesVisual_Stage4
		ConditionDatabase.GasMask_GearOverlayCurrent_Stage5 = GasMask_GearGogglesVisual_Stage5
		ConditionDatabase.SetNewOverlay(Mask.Equipped)
		GasMask_OverlayPreset.SetValue(3.0)
	ElseIf (auiMenuItemID == 4)
		MaskOverlay.OverlayToggle = true
		ConditionDatabase.GasMask_GearOverlayCurrent_Stage1 = GasMask_GearSackHoodVisual_Stage1
		ConditionDatabase.GasMask_GearOverlayCurrent_Stage2 = GasMask_GearSackHoodVisual_Stage2
		ConditionDatabase.GasMask_GearOverlayCurrent_Stage3 = GasMask_GearSackHoodVisual_Stage3
		ConditionDatabase.GasMask_GearOverlayCurrent_Stage4 = GasMask_GearSackHoodVisual_Stage4
		ConditionDatabase.GasMask_GearOverlayCurrent_Stage5 = GasMask_GearSackHoodVisual_Stage5
		ConditionDatabase.SetNewOverlay(Mask.Equipped)
		GasMask_OverlayPreset.SetValue(4.0)
	ElseIf (auiMenuItemID == 5)
		MaskOverlay.OverlayToggle = true
		ConditionDatabase.GasMask_GearOverlayCurrent_Stage1 = GasMask_GearOneEyeVisual_Stage1
		ConditionDatabase.GasMask_GearOverlayCurrent_Stage2 = GasMask_GearOneEyeVisual_Stage2
		ConditionDatabase.GasMask_GearOverlayCurrent_Stage3 = GasMask_GearOneEyeVisual_Stage3
		ConditionDatabase.GasMask_GearOverlayCurrent_Stage4 = GasMask_GearOneEyeVisual_Stage4
		ConditionDatabase.GasMask_GearOverlayCurrent_Stage5 = GasMask_GearOneEyeVisual_Stage5
		ConditionDatabase.SetNewOverlay(Mask.Equipped)
		GasMask_OverlayPreset.SetValue(5.0)
	ElseIf (auiMenuItemID == 6)
		MaskOverlay.OverlayToggle = false
		ConditionDatabase.SetNewOverlay(Mask.Equipped)
		GasMask_OverlayPreset.SetValue(6.0)
	EndIf
EndEvent


; Properties
;---------------------------------------------

Group Context
	Metro:Context Property Context Auto Const Mandatory
	Gear:Mask Property Mask Auto Const Mandatory
	Gear:MaskOverlay Property MaskOverlay Auto Const Mandatory
	Gear:ConditionDatabase Property ConditionDatabase Auto Const Mandatory
	GlobalVariable Property GasMask_OverlayPreset Auto
EndGroup


Group Properties
	VisualEffect Property GasMask_GearGogglesVisual_Stage1 Auto Const Mandatory
	VisualEffect Property GasMask_GearGogglesVisual_Stage2 Auto Const Mandatory
	VisualEffect Property GasMask_GearGogglesVisual_Stage3 Auto Const Mandatory
	VisualEffect Property GasMask_GearGogglesVisual_Stage4 Auto Const Mandatory
	VisualEffect Property GasMask_GearGogglesVisual_Stage5 Auto Const Mandatory
	VisualEffect Property GasMask_GearGogglesVisual_Stage6 Auto Const Mandatory
	
	VisualEffect Property GasMask_GearOneEyeVisual_Stage1 Auto Const Mandatory
	VisualEffect Property GasMask_GearOneEyeVisual_Stage2 Auto Const Mandatory
	VisualEffect Property GasMask_GearOneEyeVisual_Stage3 Auto Const Mandatory
	VisualEffect Property GasMask_GearOneEyeVisual_Stage4 Auto Const Mandatory
	VisualEffect Property GasMask_GearOneEyeVisual_Stage5 Auto Const Mandatory
	VisualEffect Property GasMask_GearOneEyeVisual_Stage6 Auto Const Mandatory

	VisualEffect Property GasMask_GearSackHoodVisual_Stage1 Auto Const Mandatory
	VisualEffect Property GasMask_GearSackHoodVisual_Stage2 Auto Const Mandatory
	VisualEffect Property GasMask_GearSackHoodVisual_Stage3 Auto Const Mandatory
	VisualEffect Property GasMask_GearSackHoodVisual_Stage4 Auto Const Mandatory
	VisualEffect Property GasMask_GearSackHoodVisual_Stage5 Auto Const Mandatory
	VisualEffect Property GasMask_GearSackHoodVisual_Stage6 Auto Const Mandatory

	VisualEffect Property GasMask_GearVisorVisual_Stage1 Auto Const Mandatory
	VisualEffect Property GasMask_GearVisorVisual_Stage2 Auto Const Mandatory
	VisualEffect Property GasMask_GearVisorVisual_Stage3 Auto Const Mandatory
	VisualEffect Property GasMask_GearVisorVisual_Stage4 Auto Const Mandatory
	VisualEffect Property GasMask_GearVisorVisual_Stage5 Auto Const Mandatory
	VisualEffect Property GasMask_GearVisorVisual_Stage6 Auto Const Mandatory
EndGroup
