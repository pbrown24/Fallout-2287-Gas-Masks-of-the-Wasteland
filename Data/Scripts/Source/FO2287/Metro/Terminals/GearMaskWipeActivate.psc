ScriptName Metro:Terminals:GearMaskWipeActivate extends Terminal
import Shared:Log

UserLog Log

int MaskWipeActivateOption = 1 const
int Blood = 2 const
int Dirt = 3 const
int Rain = 4 const
int Snow = 5 const
int Dust = 6 const
CustomEvent OnChanged

; Events
;---------------------------------------------

Event OnInit()
	Log = new UserLog
	Log.Caller = self
	Log.FileName = Context.Title
EndEvent


Event OnMenuItemRun(int auiMenuItemID, ObjectReference akTerminalRef)
	Var[] kargs = new Var[1]
    If (auiMenuItemID == MaskWipeActivateOption)
		If MaskWipe.MaskWipeActivate
			MaskWipe.MaskWipeActivate = false
			WriteLine(Log, "MaskWipeActivate Disabled")
		ElseIf MaskWipe.MaskWipeActivate == false
			MaskWipe.MaskWipeActivate = true
			WriteLine(Log, "MaskWipeActivate Activated")
		EndIf
		kargs[0] = 0
		Debug.Notification("MaskWipeActivate Toggled | " + MaskWipe.MaskWipeActivate)
		SendCustomEvent("OnChanged", kargs)
	ElseIf (auiMenuItemID == Blood)
		If BloodVFX.BloodToggle == true
			BloodVFX.BloodToggle = false
		ElseIf BloodVFX.BloodToggle == false
			BloodVFX.BloodToggle = true
		EndIf
		kargs[0] = 1
		Debug.Notification("Blood Toggled | " + BloodVFX.BloodToggle)
		SendCustomEvent("OnChanged", kargs)
	ElseIf (auiMenuItemID == Dirt)
		If MudVFX.DirtToggle == true
			MudVFX.DirtToggle = false
		ElseIf MudVFX.DirtToggle == false
			MudVFX.DirtToggle = true
		EndIf
		kargs[0] = 2
		SendCustomEvent("OnChanged", kargs)
		Debug.Notification("Dirt Toggled | " + MudVFX.DirtToggle)
	ElseIf (auiMenuItemID == Rain)
		If RainVFX.RainToggle == true
			RainVFX.RainToggle = false
		ElseIf RainVFX.RainToggle == false
			RainVFX.RainToggle = true
		EndIf
		kargs[0] = 3
		SendCustomEvent("OnChanged", kargs)
		Debug.Notification("Rain Toggled | " + RainVFX.RainToggle)
	ElseIf (auiMenuItemID == Snow)
		If SnowVFX.SnowToggle == true
			SnowVFX.SnowToggle = false
		ElseIf SnowVFX.SnowToggle == false
			SnowVFX.SnowToggle = true
		EndIf
		kargs[0] = 4
		SendCustomEvent("OnChanged", kargs)
		Debug.Notification("Snow Toggled | " + SnowVFX.SnowToggle)
	ElseIf (auiMenuItemID == Dust)
		If DustVFX.DustToggle == true
			DustVFX.DustToggle = false
		ElseIf DustVFX.DustToggle == false
			DustVFX.DustToggle = true
		EndIf
		kargs[0] = 5
		SendCustomEvent("OnChanged", kargs)
		Debug.Notification("Dust Toggled | " + DustVFX.DustToggle)
	ElseIf (auiMenuItemID == 9)
		If GasMask_PAEnvironmentalVFX.GetValue() == 1.0
			GasMask_PAEnvironmentalVFX.SetValue(0.0)
			MaskWipe.DisableAllVFX()
			WriteLine(Log, "PA Environmental VFX Disabled")
		ElseIf GasMask_PAEnvironmentalVFX.GetValue() == 0.0
			GasMask_PAEnvironmentalVFX.SetValue(1.0)
			WriteLine(Log, "PA Environmental VFX Activated")
		EndIf
		kargs[0] = 6
		Debug.Notification("PA Environmental VFX Toggled | " + GasMask_PAEnvironmentalVFX.GetValue())
		SendCustomEvent("OnChanged", kargs)
    EndIf
	
EndEvent


; Properties
;---------------------------------------------

Group Context
	Metro:Context Property Context Auto Const Mandatory
	Metro:Gear:MaskWipe Property MaskWipe Auto Const Mandatory
	Metro:Gear:BloodVFX Property BloodVFX Auto Const Mandatory
	Metro:Gear:MudVFX Property MudVFX Auto Const Mandatory
	Metro:Gear:RainVFX Property RainVFX Auto Const Mandatory
	Metro:Gear:SnowVFX Property SnowVFX Auto Const Mandatory
	Metro:Gear:DustVFX Property DustVFX Auto Const Mandatory
	GlobalVariable Property GasMask_PAEnvironmentalVFX Auto
EndGroup
