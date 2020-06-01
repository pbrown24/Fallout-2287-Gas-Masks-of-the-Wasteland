ScriptName Metro:Player:Camera extends Metro:Core:Required
{QUST:Metro_Player}
import Shared:Log


UserLog Log
CustomEvent OnChanged
bool CameraValue


; Events
;---------------------------------------------

Event OnInitialize()
	Log = new UserLog
	Log.FileName = "Player"
	Log.Caller = self
EndEvent


Event OnEnable()
	Player.AddSpell(GasMask_Condition_IsFirstPerson, false)
	GasMask_Condition_IsFirstPerson.Cast(none, Player)
	WriteLine(Log, "Added the '"+GasMask_Condition_IsFirstPerson+"' spell.")
EndEvent


Event OnDisable()
	Player.DispelSpell(GasMask_Condition_IsFirstPerson)
	Player.RemoveSpell(GasMask_Condition_IsFirstPerson)
	WriteLine(Log, "Removed the '"+GasMask_Condition_IsFirstPerson+"' spell.")
EndEvent


; Functions
;---------------------------------------------

Function InvokeChanged(bool abFirstPerson)
	;WriteMessage(Log, "InvokeChanged(abFirstPerson='"+abFirstPerson+"')")
	If Mask.IsGasMask || (Mask.IsPowerArmor && GasMask_PAEnvironmentalVFX.GetValue() == 1.0)
		;GasMask_CameraChange_IMOD.Apply(1.0)
	EndIf
	var[] arguments = new var[1]
	arguments[0] = abFirstPerson 
	CameraValue = abFirstPerson
	;Debug.Notification("Camera Spell: " + abFirstPerson)
	self.SendCustomEvent("OnChanged", arguments)
EndFunction


; Properties
;---------------------------------------------

Group Properties
	Metro:Gear:Mask Property Mask Auto Const Mandatory
	GlobalVariable Property GasMask_PAEnvironmentalVFX Auto
	Spell Property GasMask_Condition_IsFirstPerson Auto Const Mandatory
	ImageSpaceModifier Property GasMask_CameraChange_IMOD Auto
EndGroup


Group Camera
	bool Property IsFirstPerson Hidden
		bool Function Get()
			return CameraValue
		EndFunction
	EndProperty
EndGroup
