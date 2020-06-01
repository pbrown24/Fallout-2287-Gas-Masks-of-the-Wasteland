ScriptName Metro:Gear:Mask extends Metro:Core:Required
{QUST:Metro_Gear}
import Metro
import Metro:Context
import Shared:Log

; Notes
; I have doubts about the power armor detection.

UserLog Log

Armor Current
Armor LastEquippedArmor
CustomEvent OnChanged


; Events
;---------------------------------------------

Event OnInitialize()
	Log = GetLog(self)
	Log.FileName = "Gear"
EndEvent


Event OnEnable()
	; I cannot get the current mask without an equip event
	RegisterForRemoteEvent(Player, "OnItemEquipped")
	RegisterForRemoteEvent(Player, "OnItemUnequipped")
	AnimationEquip = 0
EndEvent


Event OnDisable()
	Current = none
	LastEquippedArmor = none
	UnregisterForRemoteEvent(Player, "OnItemEquipped")
	UnregisterForRemoteEvent(Player, "OnItemUnequipped")
EndEvent


; Methods
;---------------------------------------------

Event Actor.OnItemEquipped(Actor akSender, Form akBaseObject, ObjectReference akReference)
	Utility.wait(0.6)
	;Normal Equip
	If(AnimationEquip == 0)
		Armor equipment = akBaseObject as Armor
		If(akbaseObject as Armor)
			LastEquippedArmor = equipment
			If (IsSupported(equipment))
				If (Player.IsEquipped(equipment))
					ChangeTo(equipment)
				Else
					WriteLine(Log, "The equipment is not actually equipped.")
				EndIf
			EndIf
		EndIf
	EndIf
EndEvent


Event Actor.OnItemUnequipped(Actor akSender, Form akBaseObject, ObjectReference akReference)
	Utility.wait(0.6)
	If(AnimationEquip == 0)
		Armor equipment = akBaseObject as Armor

		If (IsSupported(equipment))
			If (Player.IsEquipped(equipment) == false)
				ChangeTo(none)
			Else
				WriteLine(Log, "The equipment is not actually unequipped.")
			EndIf
		EndIf	
	EndIf
EndEvent


; Functions
;---------------------------------------------

Function RemoveMask()
		Armor equipment = Equipped

		If (IsSupported(equipment))
				ChangeTo(none)
		EndIf	
EndFunction

bool Function ChangeTo(Armor akEquipment)
	If (akEquipment != Current)
		WriteChangedValue(Log, "Current", Current, akEquipment)
		Current = akEquipment
		SendCustomEvent("OnChanged")
		return true
	Else
		WriteLine(Log, "There is no change to exposure equipment.")
		return false
	EndIf
EndFunction


bool Function IsSupported(Armor akEquipment)
	If (akEquipment)
		return Database.Contains(akEquipment) || akEquipment.HasKeyword(dn_PowerArmor_Helmet)
	Else
		return false
	EndIf
EndFunction
	

; Properties
;---------------------------------------------

Group Context
	Gear:Database Property Database Auto Const Mandatory
	Gear:FilterReplace Property FilterReplace Auto Const Mandatory
	Player:Camera Property Camera Auto Const Mandatory
EndGroup


Group Properties
	Keyword Property dn_PowerArmor_Helmet Auto Const Mandatory
	Int Property AnimationEquip Auto
EndGroup


Group ReadOnly

	Int Property FormID Hidden
		Int Function Get()
			return Database.GetArmorFormID(Current)
		EndFunction
	EndProperty
	
	Armor Property Equipped Hidden
		Armor Function Get()
			return Current
		EndFunction
	EndProperty
	
	Armor Property LastEquipped Hidden
		Armor Function Get()
			return LastEquippedArmor
		EndFunction
	EndProperty

	bool Property IsProtection Hidden
		bool Function Get()
			return IsPowerArmor || IsGasMask || IsBandana
		EndFunction
	EndProperty

	bool Property UsesFilters Hidden
		bool Function Get()
			return IsPowerArmor == false || IsGasMask
		EndFunction
	EndProperty

	bool Property IsPowerArmor Hidden
		bool Function Get()
			If (Current)
				return (Current.HasKeyword(dn_PowerArmor_Helmet) || Player.IsInPowerArmor())
			Else
				return false
			EndIf
		EndFunction
	EndProperty

	bool Property IsGasMask Hidden
		bool Function Get()
			return Database.GetClassification(Current) == Database.ClassGasMask
		EndFunction
	EndProperty
	

	bool Property IsBandana Hidden
		bool Function Get()
			return Database.GetClassification(Current) == Database.ClassBandana
		EndFunction
	EndProperty
EndGroup
