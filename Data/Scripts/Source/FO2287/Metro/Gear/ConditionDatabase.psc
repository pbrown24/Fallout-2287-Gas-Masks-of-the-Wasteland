ScriptName Metro:Gear:ConditionDatabase extends Metro:Core:Optional
{QUST:Metro_Gear}
import Metro:Context
import Shared:Log
import Shared:Papyrus

UserLog Log

CustomEvent OnStatusChanged

Entry[] Collection

Event OnInitialize()
	Log = new UserLog
	Log.Caller = self
	Log.FileName = "ConditionDatabase"
	WriteLine(Log, "ConditionDatabase Initialized.")
	Collection = new Entry[0]
EndEvent

Struct Entry
	Armor Mask = none
	int DamageStage = 0
	int Percentage = 0
	string DamageStageName = ""
EndStruct
	


; Properties
;---------------------------------------------

Group Properties
	Metro:Gear:MaskOverlay Property MaskOverlay Auto Const Mandatory
	Metro:Gear:MaskWipe Property MaskWipe Auto Const Mandatory
	Metro:World:Radiation Property Radiation Auto Const Mandatory
	GlobalVariable Property GasMask_PlayerDamage_Toggle Auto
	GlobalVariable Property GasMask_MaskPercentage Auto
	VisualEffect Property GasMask_GearOverlayVisual_Stage1 Auto Const Mandatory
	VisualEffect Property GasMask_GearOverlayVisual_Stage2 Auto Const Mandatory
	VisualEffect Property GasMask_GearOverlayVisual_Stage3 Auto Const Mandatory
	VisualEffect Property GasMask_GearOverlayVisual_Stage4 Auto Const Mandatory
	VisualEffect Property GasMask_GearOverlayVisual_Stage5 Auto Const Mandatory
	VisualEffect Property GasMask_GearOverlayVisual_Stage6 Auto Const Mandatory
	VisualEffect Property GasMask_GearOverlayCurrent_Stage1 Auto
	VisualEffect Property GasMask_GearOverlayCurrent_Stage2 Auto
	VisualEffect Property GasMask_GearOverlayCurrent_Stage3 Auto
	VisualEffect Property GasMask_GearOverlayCurrent_Stage4 Auto
	VisualEffect Property GasMask_GearOverlayCurrent_Stage5 Auto
	VisualEffect Property GasMask_GearOverlayCurrent_Stage6 Auto
	Sound Property GasMask_GlassBreaking_01_Player Auto
	Sound Property GasMask_GlassBreaking_03_Player Auto
	Sound Property GasMask_GlassBreaking_04_Player Auto
	Sound Property GasMask_GlassBreaking_05_Player Auto
	Sound Property GasMask_GlassBreaking_06_Player Auto
	Sound Property GasMask_GlassBreaking_07_Player Auto
	ImageSpaceModifier Property GasMask_GlassCrack_IMOD Auto
	ImageSpaceModifier Property GasMask_GlassBreak_IMOD Auto
EndGroup

Group Database
	int Property Invalid = -1 AutoReadOnly
EndGroup

Group GlassStage
	int Property Undamaged = 0 AutoReadOnly
	int Property Minor_Damage = 1 AutoReadOnly
	int Property Moderate_Damage = 2 AutoReadOnly
	int Property Severe_Damage = 3 AutoReadOnly
	int Property Broken = 4 AutoReadOnly
	
	string Property Undamaged_String = "Undamaged" AutoReadOnly
	string Property Minor_Damage_String = "Minor Damage" AutoReadOnly
	string Property Moderate_Damage_String = "Moderate Damage" AutoReadOnly
	string Property Severe_Damage_String = "Severe Damage" AutoReadOnly
	string Property Broken_String = "Broken" AutoReadOnly
EndGroup

; Events
;---------------------------------------------

; Functions
;---------------------------------------------


int Function GetDamageStage(Armor akArmor)
	int index = IndexOf(akArmor)
	If (index > Invalid)
		return Collection[index].DamageStage
	Else
		return Invalid
	EndIf
EndFunction

string Function GetDamageStageName(Armor akArmor)
	int index = IndexOf(akArmor)
	If (index > Invalid)
		return Collection[index].DamageStageName
	Else
		return Invalid
	EndIf
EndFunction

int Function GetPercentage(Armor akArmor)
	int index = IndexOf(akArmor)
	If (index > Invalid)
		return Collection[index].Percentage
	Else
		return Invalid
	EndIf
EndFunction

Function Repair(Armor akArmor,int akNewPercentage)
	int index = IndexOf(akArmor)
	Collection[index].Percentage = akNewPercentage
	If(akNewPercentage >= 75 )
		Collection[index].DamageStageName = Undamaged_String
		Collection[index].DamageStage = Undamaged
		SetNewOverlay(akArmor)
		SendCustomEvent("OnStatusChanged")
	ElseIf(akNewPercentage < 75 && akNewPercentage >= 50)
		Collection[index].DamageStageName = Minor_Damage_String
		Collection[index].DamageStage = Minor_Damage
		SetNewOverlay(akArmor)
		SendCustomEvent("OnStatusChanged")
	ElseIf(akNewPercentage < 50 && akNewPercentage >= 25)
		Collection[index].DamageStageName = Moderate_Damage_String
		Collection[index].DamageStage = Moderate_Damage
		SetNewOverlay(akArmor)
		SendCustomEvent("OnStatusChanged")
	ElseIf(akNewPercentage < 25 && akNewPercentage > 0)
		Collection[index].DamageStageName = Severe_Damage_String
		Collection[index].DamageStage = Severe_Damage
		SetNewOverlay(akArmor)
		SendCustomEvent("OnStatusChanged")
	EndIf
	Radiation.CheckRadiation()
	WriteLine(Log, "Mask: " + Collection[index].Mask)
	WriteLine(Log, "DamageStage: " + Collection[index].DamageStage)
	WriteLine(Log, "DamageStageName: " + Collection[index].DamageStageName)
	WriteLine(Log, "Percentage: " + Collection[index].Percentage)
	WriteLine(Log, " ")
EndFunction

Function SetNewPercentage(Armor akArmor,int akNewPercentage, int akOldPercentage)
	int index = IndexOf(akArmor)
	Collection[index].Percentage = akNewPercentage
	If(akOldPercentage == 100 && akNewPercentage >= 75)
		Collection[index].DamageStageName = Undamaged_String
		Collection[index].DamageStage = Undamaged
		SetNewOverlay(akArmor)
		SendCustomEvent("OnStatusChanged")
	ElseIf(akOldPercentage >= 75  && akNewPercentage < 75 && akNewPercentage >= 50)
		Collection[index].DamageStageName = Minor_Damage_String
		Collection[index].DamageStage = Minor_Damage
		SetNewOverlay(akArmor)
		SendCustomEvent("OnStatusChanged")
		PlayGlassCrack(true)
	ElseIf(akOldPercentage >= 50 && akNewPercentage < 50 && akNewPercentage >= 25)
		Collection[index].DamageStageName = Moderate_Damage_String
		Collection[index].DamageStage = Moderate_Damage
		SetNewOverlay(akArmor)
		SendCustomEvent("OnStatusChanged")
		PlayGlassCrack(true)
	ElseIf(akOldPercentage >= 25 && akNewPercentage < 25 && akNewPercentage > 0)
		Collection[index].DamageStageName = Severe_Damage_String
		Collection[index].DamageStage = Severe_Damage
		SetNewOverlay(akArmor)
		SendCustomEvent("OnStatusChanged")
		PlayGlassCrack(true)
	ElseIf(akOldPercentage > 0 && akNewPercentage == 0)
		Collection[index].DamageStageName = Broken_String
		Collection[index].DamageStage = Broken
		PlayGlassCrack(false)
		GasMask_GlassBreak_IMOD.Apply()
		SetNewOverlay(akArmor)
		SendCustomEvent("OnStatusChanged")
		MaskWipe.DisableAllVFX()
		Radiation.CheckRadiation()
	EndIf
	WriteLine(Log, "Mask: " + Collection[index].Mask)
	WriteLine(Log, "DamageStage: " + Collection[index].DamageStage)
	WriteLine(Log, "DamageStageName: " + Collection[index].DamageStageName)
	WriteLine(Log, "Percentage: " + Collection[index].Percentage)
	WriteLine(Log, " ")
EndFunction

Function SetNewOverlay(Armor akArmor)
	MaskOverlay.Remove()
	SetCurrentOverlay(akArmor)
	Utility.wait(0.1)
	MaskOverlay.Apply()
EndFunction

Function SetCurrentOverlay(Armor akArmor)
	If(GetDamageStage(akArmor) == 0)
		MaskOverlay.VisualFX = GasMask_GearOverlayCurrent_Stage1
	ElseIf(GetDamageStage(akArmor) == 1)
		MaskOverlay.VisualFX = GasMask_GearOverlayCurrent_Stage2
	ElseIf(GetDamageStage(akArmor) == 2)
		MaskOverlay.VisualFX = GasMask_GearOverlayCurrent_Stage3
	ElseIf(GetDamageStage(akArmor) == 3)
		MaskOverlay.VisualFX = GasMask_GearOverlayCurrent_Stage4
	ElseIf(GetDamageStage(akArmor) == 4)
		MaskOverlay.VisualFX = GasMask_GearOverlayCurrent_Stage5
	EndIf
EndFunction

Function SetCurrentPercentage(Armor akArmor)
	GasMask_MaskPercentage.SetValueInt(GetPercentage(akArmor))
EndFunction


bool Function Contains(Armor akArmor)
	return IndexOf(akArmor) > Invalid
EndFunction


int Function IndexOf(Armor akArmor)
	If (Collection && akArmor)
		return Collection.FindStruct("Mask", akArmor)
	Else
		return Invalid
	EndIf
EndFunction


Armor Function GetAt(int aindex)
	return Collection[aindex].Mask
EndFunction


int Function GetRandomDamageStage()
	int index = Utility.RandomInt(0, 3)
	return index
EndFunction

Function AddMask(Armor mask)
	Entry NewMask = new Entry
	NewMask.DamageStageName = Undamaged_String
	NewMask.DamageStage = Undamaged
	NewMask.Percentage = 100
	NewMask.Mask = mask
	WriteLine(Log, "Added Mask: " + NewMask.Mask)
	Add(NewMask)
	SetCurrentOverlay(mask)
EndFunction


Entry[] Function GetEntries()
	Entry[] array = new Entry[0]

	int index = 0
	While (index < Collection.Length)
		array.Add(Collection[index])
		index += 1
	EndWhile

	return array
EndFunction


string Function EntryToString(Entry current) Global
	If (current)
		If (current.Mask)
			return current.Mask
		EndIf
	Else
		return "Invalid Entry"
	EndIf
EndFunction


Function Add(Entry current)
	If (current)
			If (current.Mask)
				If (Contains(current.Mask) == false)
					Collection.Add(current)
					WriteLine(Log, "Added the entry '"+EntryToString(current)+"' to Collection.")
				Else
					WriteLine(Log, "Collection already contains the entry '"+EntryToString(current)+"'.")
				EndIf
			Else
				WriteLine(Log, "The entry '"+EntryToString(current)+"' does not exist or is not of the object type Armor.")
			EndIf
	Else
		WriteLine(Log, "The current entry cannot be none.")
	EndIf
EndFunction

Function PlayGlassCrack(bool Crack)
	int random
	If Crack
		random = Utility.RandomInt(1, 4)
		If random == 1
			GasMask_GlassBreaking_03_Player.Play(Player)
		ElseIf random == 2
			GasMask_GlassBreaking_04_Player.Play(Player)
		ElseIf random == 3
			GasMask_GlassBreaking_05_Player.Play(Player)
		ElseIf random == 4
			GasMask_GlassBreaking_07_Player.Play(Player)
		EndIf
		GasMask_GlassCrack_IMOD.Apply()
	Else
		random = Utility.RandomInt(1, 3)
		If random == 1
			GasMask_GlassBreaking_01_Player.Play(Player)
		ElseIf random == 2
			GasMask_GlassBreaking_06_Player.Play(Player)
		ElseIf random == 3
			GasMask_GlassBreaking_07_Player.Play(Player)
		EndIf
		GasMask_GlassBreak_IMOD.Apply()
	EndIf
EndFunction


