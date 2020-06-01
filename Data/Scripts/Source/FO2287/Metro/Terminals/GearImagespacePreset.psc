ScriptName Metro:Terminals:GearImagespacePreset extends Terminal
import Metro
import Shared:Log

UserLog Log

int ReturnID = 6 const
int OverlayID = 1 const
int LensID = 2 const
int BlurID = 3 const
int NoneID = 4 const
int DesaturateID = 5 const


; Events
;---------------------------------------------

Event OnInit()
	Log = new UserLog
	Log.Caller = self
	Log.FileName = Context.Title
EndEvent


Event OnMenuItemRun(int auiMenuItemID, ObjectReference akTerminalRef)
	If (auiMenuItemID == ReturnID || auiMenuItemID == OverlayID )
		return
	ElseIf (auiMenuItemID == LensID)
		MaskOverlay.ImageSpace = GasMask_GearScreenFX_Heavy
		GasMask_IMODPreset.SetValue(LensID)
	ElseIf (auiMenuItemID == BlurID)
		MaskOverlay.ImageSpace = GasMask_GearScreenFX
		GasMask_IMODPreset.SetValue(BlurID)
	ElseIf (auiMenuItemID == NoneID)
		MaskOverlay.ImageSpace = None
		GasMask_IMODPreset.SetValue(NoneID)
	ElseIf (auiMenuItemID == DesaturateID)
		MaskOverlay.ImageSpace = GasMask_GearDesaturateFX
		GasMask_IMODPreset.SetValue(DesaturateID)
	EndIf
EndEvent


; Properties
;---------------------------------------------

Group Context
	Metro:Context Property Context Auto Const Mandatory
	Gear:MaskOverlay Property MaskOverlay Auto Const Mandatory
EndGroup


Group Properties
	ImageSpaceModifier Property GasMask_GearScreenFX Auto Const Mandatory
	ImageSpaceModifier Property GasMask_GearScreenFX_Heavy Auto Const Mandatory
	ImageSpaceModifier Property GasMask_GearDesaturateFX Auto Const Mandatory
	GlobalVariable Property GasMask_IMODPreset Auto
EndGroup
