ScriptName Metro:Gear:Database extends Metro:Core:Required
{QUST:Metro_Gear}
import Metro:Context
import Shared:Log
import Shared:Papyrus

UserLog Log

Entry[] Collection
CustomEvent OnRefreshed

string UpdateState = "UpdateState" const

Struct Entry
	string PluginFile
	int FormID = -1
	Armor Mask = none
	int TypeClass = -1
EndStruct

Group Properties
	FormList Property GasMask_DatabaseList Auto
EndGroup


; Properties
;---------------------------------------------

Group Database
	int Property Invalid = -1 AutoReadOnly

	bool Property IsBusy Hidden
		bool Function Get()
			return StateName == UpdateState
		EndFunction
	EndProperty

	int Property Count Hidden
		int Function Get()
			return Collection.Length
		EndFunction
	EndProperty
EndGroup

Group TypeClass
	int Property ClassGasMask = 0 AutoReadOnly
	int Property ClassBandana = 1 AutoReadOnly
	int Property ClassMouthOnly = 2 AutoReadOnly
EndGroup


; Events
;---------------------------------------------

Event OnInitialize()
	Log = GetLog(self)
	Log.FileName = "Gear"
	Collection = new Entry[0]
EndEvent


Event OnEnable()
	ChangeState(self, UpdateState)
	RegisterForRemoteEvent(Player, "OnPlayerLoadGame")
EndEvent


Event OnDisable()
	UnregisterForRemoteEvent(Player, "OnPlayerLoadGame")
EndEvent


Event Actor.OnPlayerLoadGame(Actor akSender)
	;ChangeState(self, UpdateState)
EndEvent


; Functions
;---------------------------------------------

Function ResetDatabase()
	ChangeState(self, UpdateState)
EndFunction

int Function GetClassification(Armor akArmor)
	int index = IndexOf(akArmor)
	If (index > Invalid)
		return Collection[index].TypeClass
	Else
		return Invalid
	EndIf
EndFunction


int Function GetArmorFormID(Armor akArmor)
	int index = IndexOf(akArmor)
	If (index > Invalid)
		return Collection[index].FormID
	Else
		return Invalid
	EndIf
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


Armor Function GetRandom()
	int index = Utility.RandomInt(0, Count)
	return Collection[index].Mask
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
			return current.PluginFile+":"+current.Mask
		Else
			return current.PluginFile+":"+current.FormID
		EndIf
	Else
		return "Invalid Entry"
	EndIf
EndFunction

Function RemoveMask(Armor mask)
	int index = IndexOf(mask)
	Collection.Remove(index)
	WriteLine(Log, "Removed Mask")
EndFunction

Function AddMask(Armor mask)
	Entry NewMask = new Entry
	NewMask.PluginFile = Context.Plugin
	NewMask.FormID = mask.GetFormID()
	NewMask.TypeClass = ClassGasMask
	NewMask.Mask = mask
	WriteLine(Log, "Added Mask: " + NewMask.FormID)
	Add(NewMask)
EndFunction

Function Add(Entry current)
	If (current)
		If (Contains(current.Mask) == false)
			Collection.Add(current)
			GasMask_DatabaseList.AddForm(current.Mask)
			WriteLine(Log, "Added the entry '"+EntryToString(current)+"' to Collection.")
		Else
			WriteLine(Log, "Collection already contains the entry '"+EntryToString(current)+"'.")
		EndIf
	Else
		WriteLine(Log, "The current entry cannot be none.")
	EndIf
EndFunction


; Methods
;---------------------------------------------

State UpdateState
	Entry[] Function GetEntries()
		{IGNORE}
		WriteLine(Log, "Ignoring GetEntries in '"+StateName+"'.")
		return none
	EndFunction


	Function Add(Entry current)
		If (current)
			If (Game.IsPluginInstalled(current.PluginFile))
				current.Mask = Game.GetFormFromFile(current.FormID, current.PluginFile) as Armor

				If (current.Mask)
					If (Contains(current.Mask) == false)
						Collection.Add(current)
						GasMask_DatabaseList.AddForm(current.Mask)
						WriteLine(Log, "Added the entry '"+EntryToString(current)+"' to Collection.")
					Else
						WriteLine(Log, "Collection already contains the entry '"+EntryToString(current)+"'.")
					EndIf
				Else
					WriteLine(Log, "The entry '"+EntryToString(current)+"' does not exist or is not of the object type Armor.")
				EndIf
			Else
				WriteLine(Log, "The plugin for entry '"+EntryToString(current)+"' is not installed.")
			EndIf
		Else
			WriteLine(Log, "The current entry cannot be none.")
		EndIf
	EndFunction


	Event OnEndState(string asNewState)
		WriteLine(Log, "Sending the OnRefreshed event for collection..")
		SendCustomEvent("OnRefreshed")
	EndEvent


	Event OnBeginState(string asOldState)
		Collection = new Entry[0]
		
		;Truly_Britsy
		Entry GP5 = new Entry
		GP5.PluginFile = Context.Plugin
		GP5.FormID = 0x00000F99
		GP5.TypeClass = ClassGasMask
		Add(GP5)
		
		Entry GP5Hat = new Entry
		GP5Hat.PluginFile = Context.Plugin
		GP5Hat.FormID = 0x00002DFF
		GP5Hat.TypeClass = ClassGasMask
		Add(GP5Hat)
		
		Entry GP5Hose = new Entry
		GP5Hose.PluginFile = Context.Plugin
		GP5Hose.FormID = 0x00007A5F
		GP5Hose.TypeClass = ClassGasMask
		Add(GP5Hose)
		
		Entry GP5HoseHat = new Entry
		GP5HoseHat.PluginFile = Context.Plugin
		GP5HoseHat.FormID = 0x0000A980
		GP5HoseHat.TypeClass = ClassGasMask
		Add(GP5HoseHat)

		; Dogtoothcg
		Entry GasMaskM1A211 = new Entry
		GasMaskM1A211.PluginFile = Context.Plugin
		GasMaskM1A211.FormID = 0x00007A77
		GasMaskM1A211.TypeClass = ClassGasMask
		Add(GasMaskM1A211)
		
		; Nutulator
		Entry GasMaskPMK1 = new Entry
		GasMaskPMK1.PluginFile = Context.Plugin
		GasMaskPMK1.FormID = 0x000035A7
		GasMaskPMK1.TypeClass = ClassGasMask
		Add(GasMaskPMK1)
		
		Entry GasMaskPPM88 = new Entry
		GasMaskPPM88.PluginFile = Context.Plugin
		GasMaskPPM88.FormID = 0x0000928E
		GasMaskPPM88.TypeClass = ClassGasMask
		Add(GasMaskPPM88)
		
		Entry GasMaskM17 = new Entry
		GasMaskM17.PluginFile = Context.Plugin
		GasMaskM17.FormID = 0x00002672
		GasMaskM17.TypeClass = ClassGasMask
		Add(GasMaskM17)
		

		string Fallout4_ESM = "Fallout4.esm" const
		
		Entry Armor_InstituteCleanRoomSuit = new Entry
		Armor_InstituteCleanRoomSuit.PluginFile = Fallout4_ESM
		Armor_InstituteCleanRoomSuit.FormID = 0x00115AEC
		Armor_InstituteCleanRoomSuit.TypeClass = ClassGasMask
		Add(Armor_InstituteCleanRoomSuit)
		
		Entry Armor_DCGuardHeavy = new Entry
		Armor_DCGuardHeavy.PluginFile = Fallout4_ESM
		Armor_DCGuardHeavy.FormID = 0x000AF0F7
		Armor_DCGuardHeavy.TypeClass = ClassGasMask
		Add(Armor_DCGuardHeavy)
		
		Entry Armor_HazmatSuitDamaged = new Entry
		Armor_HazmatSuitDamaged.PluginFile = Fallout4_ESM
		Armor_HazmatSuitDamaged.FormID = 0x0018B214
		Armor_HazmatSuitDamaged.TypeClass = ClassGasMask
		Add(Armor_HazmatSuitDamaged)
		
		Entry Armor_HazmatSuit = new Entry
		Armor_HazmatSuit.PluginFile = Fallout4_ESM
		Armor_HazmatSuit.FormID = 0x000CEAC4
		Armor_HazmatSuit.TypeClass = ClassGasMask
		Add(Armor_HazmatSuit)
		
		Entry Armor_Gasmask = new Entry
		Armor_Gasmask.PluginFile = Fallout4_ESM
		Armor_Gasmask.FormID = 0x001184C1
		Armor_Gasmask.TypeClass = ClassGasMask
		Add(Armor_Gasmask)

		Entry Armor_Raider_Gasmask = new Entry
		Armor_Raider_Gasmask.PluginFile = Fallout4_ESM
		Armor_Raider_Gasmask.FormID = 0x000787D8
		Armor_Raider_Gasmask.TypeClass = ClassGasMask
		Add(Armor_Raider_Gasmask)

		Entry Armor_Raider_GreenHoodGasmask = new Entry
		Armor_Raider_GreenHoodGasmask.PluginFile = Fallout4_ESM
		Armor_Raider_GreenHoodGasmask.FormID = 0x0007239E
		Armor_Raider_GreenHoodGasmask.TypeClass = ClassGasMask
		Add(Armor_Raider_GreenHoodGasmask)

		Entry Armor_FlightHelmet = new Entry
		Armor_FlightHelmet.PluginFile = Fallout4_ESM
		Armor_FlightHelmet.FormID = 0x00042565
		Armor_FlightHelmet.TypeClass = ClassGasMask
		Add(Armor_FlightHelmet)

		Entry Armor_FlightHelmetBrown = new Entry
		Armor_FlightHelmetBrown.PluginFile = Fallout4_ESM
		Armor_FlightHelmetBrown.FormID = 0x000D4166
		Armor_FlightHelmetBrown.TypeClass = ClassGasMask
		Add(Armor_FlightHelmetBrown)

		Entry Armor_FlightHelmetRed = new Entry
		Armor_FlightHelmetRed.PluginFile = Fallout4_ESM
		Armor_FlightHelmetRed.FormID = 0x0004322C
		Armor_FlightHelmetRed.TypeClass = ClassGasMask
		Add(Armor_FlightHelmetRed)
		
		Entry Clothes_RaiderMod_Hood1 = new Entry
        Clothes_RaiderMod_Hood1.PluginFile = Fallout4_ESM
        Clothes_RaiderMod_Hood1.FormID = 0x0018E417
        Clothes_RaiderMod_Hood1.TypeClass = ClassBandana
        Add(Clothes_RaiderMod_Hood1)

		Entry Clothes_RaiderMod_Hood2 = new Entry
		Clothes_RaiderMod_Hood2.PluginFile = Fallout4_ESM
		Clothes_RaiderMod_Hood2.FormID = 0x0018E419
		Clothes_RaiderMod_Hood2.TypeClass = ClassGasMask
		Add(Clothes_RaiderMod_Hood2)

		Entry Clothes_RaiderMod_Hood3 = new Entry
		Clothes_RaiderMod_Hood3.PluginFile = Fallout4_ESM
		Clothes_RaiderMod_Hood3.FormID = 0x0018E41B
		Clothes_RaiderMod_Hood3.TypeClass = ClassGasMask
		Add(Clothes_RaiderMod_Hood3)

		Entry ClothesDog_Bandana = new Entry
		ClothesDog_Bandana.PluginFile = Fallout4_ESM
		ClothesDog_Bandana.FormID = 0x0009C05B
		ClothesDog_Bandana.TypeClass = ClassBandana
		Add(ClothesDog_Bandana)

		Entry ClothesDog_BandanaBlue = new Entry
		ClothesDog_BandanaBlue.PluginFile = Fallout4_ESM
		ClothesDog_BandanaBlue.FormID = 0x0017E917
		ClothesDog_BandanaBlue.TypeClass = ClassBandana
		Add(ClothesDog_BandanaBlue)

		Entry ClothesDog_BandanaGunnerCamo = new Entry
		ClothesDog_BandanaGunnerCamo.PluginFile = Fallout4_ESM
		ClothesDog_BandanaGunnerCamo.FormID = 0x0017E922
		ClothesDog_BandanaGunnerCamo.TypeClass = ClassBandana
		Add(ClothesDog_BandanaGunnerCamo)

		Entry ClothesDog_BandanaGunnerGreen = new Entry
		ClothesDog_BandanaGunnerGreen.PluginFile = Fallout4_ESM
		ClothesDog_BandanaGunnerGreen.FormID = 0x0017E923
		ClothesDog_BandanaGunnerGreen.TypeClass = ClassBandana
		Add(ClothesDog_BandanaGunnerGreen)

		Entry ClothesDog_BandanaLeopard = new Entry
		ClothesDog_BandanaLeopard.PluginFile = Fallout4_ESM
		ClothesDog_BandanaLeopard.FormID = 0x0017E91B
		ClothesDog_BandanaLeopard.TypeClass = ClassBandana
		Add(ClothesDog_BandanaLeopard)

		Entry ClothesDog_BandanaMonkey = new Entry
		ClothesDog_BandanaMonkey.PluginFile = Fallout4_ESM
		ClothesDog_BandanaMonkey.FormID = 0x0017E91C
		ClothesDog_BandanaMonkey.TypeClass = ClassBandana
		Add(ClothesDog_BandanaMonkey)

		Entry ClothesDog_BandanaSkull = new Entry
		ClothesDog_BandanaSkull.PluginFile = Fallout4_ESM
		ClothesDog_BandanaSkull.FormID = 0x0017E91D
		ClothesDog_BandanaSkull.TypeClass = ClassBandana
		Add(ClothesDog_BandanaSkull)

		Entry ClothesDog_BandanaStarsNStripes = new Entry
		ClothesDog_BandanaStarsNStripes.PluginFile = Fallout4_ESM
		ClothesDog_BandanaStarsNStripes.FormID = 0x0017E925
		ClothesDog_BandanaStarsNStripes.TypeClass = ClassBandana
		Add(ClothesDog_BandanaStarsNStripes)

		Entry ClothesDog_BandanaStripes = new Entry
		ClothesDog_BandanaStripes.PluginFile = Fallout4_ESM
		ClothesDog_BandanaStripes.FormID = 0x0017E924
		ClothesDog_BandanaStripes.TypeClass = ClassBandana
		Add(ClothesDog_BandanaStripes)
		
		Entry Clothes_Raider_SurgicalMask = new Entry
		Clothes_Raider_SurgicalMask.PluginFile = Fallout4_ESM
		Clothes_Raider_SurgicalMask.FormID = 0x000787DA
		Clothes_Raider_SurgicalMask.TypeClass = ClassBandana
		Add(Clothes_Raider_SurgicalMask)
		


		string DLCCoast_ESM = "DLCCoast.esm" const

		Entry DLC03_Armor_Marine_Helmet = new Entry
		DLC03_Armor_Marine_Helmet.PluginFile = DLCCoast_ESM
		DLC03_Armor_Marine_Helmet.FormID = 0x00009E58
		DLC03_Armor_Marine_Helmet.TypeClass = ClassGasMask
		Add(DLC03_Armor_Marine_Helmet)

		Entry DLC03_CoA_InquisitorsCowl = new Entry
		DLC03_CoA_InquisitorsCowl.PluginFile = DLCCoast_ESM
		DLC03_CoA_InquisitorsCowl.FormID = 0x000247C5
		DLC03_CoA_InquisitorsCowl.TypeClass = ClassGasMask
		Add(DLC03_CoA_InquisitorsCowl)

		Entry DLC03_Armor_Marine_UnderArmor_Helmet = new Entry
		DLC03_Armor_Marine_UnderArmor_Helmet.PluginFile = DLCCoast_ESM
		DLC03_Armor_Marine_UnderArmor_Helmet.FormID = 0x0003A557
		DLC03_Armor_Marine_UnderArmor_Helmet.TypeClass = ClassGasMask
		Add(DLC03_Armor_Marine_UnderArmor_Helmet)

		Entry DLC03_Armor_DiverSuit = new Entry
		DLC03_Armor_DiverSuit.PluginFile = DLCCoast_ESM
		DLC03_Armor_DiverSuit.FormID = 0x0004885A
		DLC03_Armor_DiverSuit.TypeClass = ClassGasMask
		Add(DLC03_Armor_DiverSuit)

		Entry DLC03_Armor_Trapper_Hunter_Hood = new Entry
		DLC03_Armor_Trapper_Hunter_Hood.PluginFile = DLCCoast_ESM
		DLC03_Armor_Trapper_Hunter_Hood.FormID = 0x000540FC
		DLC03_Armor_Trapper_Hunter_Hood.TypeClass = ClassBandana
		Add(DLC03_Armor_Trapper_Hunter_Hood)


		string DLCNukaWorld_ESM = "DLCNukaWorld.esm" const

		Entry Pack_Elephant_Helmet = new Entry
		Pack_Elephant_Helmet.PluginFile = DLCNukaWorld_ESM
		Pack_Elephant_Helmet.FormID = 0x00027705
		Pack_Elephant_Helmet.TypeClass = ClassGasMask
		Add(Pack_Elephant_Helmet)

		Entry Pack_Jaguar_Helmet = new Entry
		Pack_Jaguar_Helmet.PluginFile = DLCNukaWorld_ESM
		Pack_Jaguar_Helmet.FormID = 0x00027706
		Pack_Jaguar_Helmet.TypeClass = ClassGasMask
		Add(Pack_Jaguar_Helmet)

		Entry Pack_Buffalo_Helmet = new Entry
		Pack_Buffalo_Helmet.PluginFile = DLCNukaWorld_ESM
		Pack_Buffalo_Helmet.FormID = 0x00027707
		Pack_Buffalo_Helmet.TypeClass = ClassGasMask
		Add(Pack_Buffalo_Helmet)

		Entry Pack_Deer_Helmet = new Entry
		Pack_Deer_Helmet.PluginFile = DLCNukaWorld_ESM
		Pack_Deer_Helmet.FormID = 0x00027708
		Pack_Deer_Helmet.TypeClass = ClassBandana
		Add(Pack_Deer_Helmet)

		Entry Spacesuit_Costume_Helmet = new Entry
		Spacesuit_Costume_Helmet.PluginFile = DLCNukaWorld_ESM
		Spacesuit_Costume_Helmet.FormID = 0x000296B8
		Spacesuit_Costume_Helmet.TypeClass = ClassGasMask
		Add(Spacesuit_Costume_Helmet)

		Entry NukaGirl_Rocketsuit = new Entry
		NukaGirl_Rocketsuit.PluginFile = DLCNukaWorld_ESM
		NukaGirl_Rocketsuit.FormID = 0x00029C0D
		NukaGirl_Rocketsuit.TypeClass = ClassGasMask
		Add(NukaGirl_Rocketsuit)

		Entry Disciples_Hood = new Entry
		Disciples_Hood.PluginFile = DLCNukaWorld_ESM
		Disciples_Hood.FormID = 0x0003B557
		Disciples_Hood.TypeClass = ClassBandana
		Add(Disciples_Hood)

		Entry Disciples_Head_Covering = new Entry
		Disciples_Head_Covering.PluginFile = DLCNukaWorld_ESM
		Disciples_Head_Covering.FormID = 0x00026BBD
		Disciples_Head_Covering.TypeClass = ClassBandana
		Add(Disciples_Head_Covering)


		; V1.0
		string CO2AssaultArmor_ESP = "CO2AssaultArmor.esp" const

		Entry CO2_Assault_Helmet = new Entry
		CO2_Assault_Helmet.PluginFile = CO2AssaultArmor_ESP
		CO2_Assault_Helmet.FormID = 0x00000998
		CO2_Assault_Helmet.TypeClass = ClassGasMask
		Add(CO2_Assault_Helmet)

		Entry CO2_Assault_Helmet2 = new Entry
		CO2_Assault_Helmet2.PluginFile = CO2AssaultArmor_ESP
		CO2_Assault_Helmet2.FormID = 0x00000800
		CO2_Assault_Helmet2.TypeClass = ClassGasMask
		Add(CO2_Assault_Helmet2)


		; V2.41
		string ModernFirearms_ESP = "modern firearms.esp" const

		Entry Compact_F2_Gas_Mask = new Entry
		Compact_F2_Gas_Mask.PluginFile = ModernFirearms_ESP
		Compact_F2_Gas_Mask.FormID = 0x000CA131
		Compact_F2_Gas_Mask.TypeClass = ClassGasMask
		Add(Compact_F2_Gas_Mask)

		Entry F2_Gas_Mask = new Entry
		F2_Gas_Mask.PluginFile = ModernFirearms_ESP
		F2_Gas_Mask.FormID = 0x000CA137
		F2_Gas_Mask.TypeClass = ClassGasMask
		Add(F2_Gas_Mask)

		Entry Balaclava = new Entry
		Balaclava.PluginFile = ModernFirearms_ESP
		Balaclava.FormID = 0x000CA121
		Balaclava.TypeClass = ClassBandana
		Add(Balaclava)


		; V1.8
		string HelmlessHazmat_ESP = "Helmless Hazmat.esp" const

		Entry Damaged_Hazmat_Helmet = new Entry
		Damaged_Hazmat_Helmet.PluginFile = HelmlessHazmat_ESP
		Damaged_Hazmat_Helmet.FormID = 0x00000803
		Damaged_Hazmat_Helmet.TypeClass = ClassGasMask
		Add(Damaged_Hazmat_Helmet)

		Entry Hazmat_Helmet = new Entry
		Hazmat_Helmet.PluginFile = HelmlessHazmat_ESP
		Hazmat_Helmet.FormID = 0x00000805
		Hazmat_Helmet.TypeClass = ClassGasMask
		Add(Hazmat_Helmet)

		Entry Hazmat_Helmet_H = new Entry
		Hazmat_Helmet_H.PluginFile = HelmlessHazmat_ESP
		Hazmat_Helmet_H.FormID = 0x00000811
		Hazmat_Helmet_H.TypeClass = ClassGasMask
		Add(Hazmat_Helmet_H)


		; V0.33
		string RangerGearNew_ESP = "Rangergearnew.esp" const

		Entry Veteran_Ranger_Mask = new Entry
		Veteran_Ranger_Mask.PluginFile = RangerGearNew_ESP
		Veteran_Ranger_Mask.FormID = 0x00000805
		Veteran_Ranger_Mask.TypeClass = ClassGasMask
		Add(Veteran_Ranger_Mask)

		Entry NCR_Ranger_Mask = new Entry
		NCR_Ranger_Mask.PluginFile = RangerGearNew_ESP
		NCR_Ranger_Mask.FormID = 0x0000083E
		NCR_Ranger_Mask.TypeClass = ClassGasMask
		Add(NCR_Ranger_Mask)

		Entry Riot_Gear_Rebreather = new Entry
		Riot_Gear_Rebreather.PluginFile = RangerGearNew_ESP
		Riot_Gear_Rebreather.FormID = 0x000017F6
		Riot_Gear_Rebreather.TypeClass = ClassGasMask
		Add(Riot_Gear_Rebreather)

		Entry Adv_Riot_Gear_Rebreather = new Entry
		Adv_Riot_Gear_Rebreather.PluginFile = RangerGearNew_ESP
		Adv_Riot_Gear_Rebreather.FormID = 0x000017F7
		Adv_Riot_Gear_Rebreather.TypeClass = ClassGasMask
		Add(Adv_Riot_Gear_Rebreather)

		Entry Elite_Riot_Gear_Rebreather = new Entry
		Elite_Riot_Gear_Rebreather.PluginFile = RangerGearNew_ESP
		Elite_Riot_Gear_Rebreather.FormID = 0x000017F8
		Elite_Riot_Gear_Rebreather.TypeClass = ClassGasMask
		Add(Elite_Riot_Gear_Rebreather)

		Entry Tanners_Rebreather = new Entry
		Tanners_Rebreather.PluginFile = RangerGearNew_ESP
		Tanners_Rebreather.FormID = 0x0000A13C
		Tanners_Rebreather.TypeClass = ClassGasMask
		Add(Tanners_Rebreather)

		Entry Riot_Mask = new Entry
		Riot_Mask.PluginFile = RangerGearNew_ESP
		Riot_Mask.FormID = 0x0000A560
		Riot_Mask.TypeClass = ClassGasMask
		Add(Riot_Mask)

		Entry Adv_Riot_Mask = new Entry
		Adv_Riot_Mask.PluginFile = RangerGearNew_ESP
		Adv_Riot_Mask.FormID = 0x0000A561
		Adv_Riot_Mask.TypeClass = ClassGasMask
		Add(Adv_Riot_Mask)

		Entry Elite_Riot_Mask = new Entry
		Elite_Riot_Mask.PluginFile = RangerGearNew_ESP
		Elite_Riot_Mask.FormID = 0x0000A562
		Elite_Riot_Mask.TypeClass = ClassGasMask
		Add(Elite_Riot_Mask)
		
		Entry Armor_NVrangerhelmRiot = new Entry
		Armor_NVrangerhelmRiot.PluginFile = RangerGearNew_ESP
		Armor_NVrangerhelmRiot.FormID = 0x0000A563
		Armor_NVrangerhelmRiot.TypeClass = ClassGasMask
		Add(Armor_NVrangerhelmRiot)


		; V10.1
		string RaiderOverhaul_ESP = "RaiderOverhaul.esp" const

		Entry Laughing_Gas_Mask = new Entry
		Laughing_Gas_Mask.PluginFile = RaiderOverhaul_ESP
		Laughing_Gas_Mask.FormID = 0x00000826
		Laughing_Gas_Mask.TypeClass = ClassGasMask
		Add(Laughing_Gas_Mask)

		Entry Piggsy_Gas_Mask = new Entry
		Piggsy_Gas_Mask.PluginFile = RaiderOverhaul_ESP
		Piggsy_Gas_Mask.FormID = 0x00000828
		Piggsy_Gas_Mask.TypeClass = ClassGasMask
		Add(Piggsy_Gas_Mask)

		Entry Union_Jack_Mask = new Entry
		Union_Jack_Mask.PluginFile = RaiderOverhaul_ESP
		Union_Jack_Mask.FormID = 0x0000082A
		Union_Jack_Mask.TypeClass = ClassGasMask
		Add(Union_Jack_Mask)

		Entry Kabuki_Mask = new Entry
		Kabuki_Mask.PluginFile = RaiderOverhaul_ESP
		Kabuki_Mask.FormID = 0x0000082B
		Kabuki_Mask.TypeClass = ClassGasMask
		Add(Kabuki_Mask)

		Entry Bullets_and_Bones = new Entry
		Bullets_and_Bones.PluginFile = RaiderOverhaul_ESP
		Bullets_and_Bones.FormID = 0x0000082C
		Bullets_and_Bones.TypeClass = ClassGasMask
		Add(Bullets_and_Bones)

		Entry Bozo_Gas_Mask = new Entry
		Bozo_Gas_Mask.PluginFile = RaiderOverhaul_ESP
		Bozo_Gas_Mask.FormID = 0x0000082D
		Bozo_Gas_Mask.TypeClass = ClassGasMask
		Add(Bozo_Gas_Mask)

		Entry Face_Wrap = new Entry
		Face_Wrap.PluginFile = RaiderOverhaul_ESP
		Face_Wrap.FormID = 0x0000089A
		Face_Wrap.TypeClass = ClassBandana
		Add(Face_Wrap)

		Entry Forged_Magnate_Armor = new Entry
		Forged_Magnate_Armor.PluginFile = RaiderOverhaul_ESP
		Forged_Magnate_Armor.FormID = 0x000008A6
		Forged_Magnate_Armor.TypeClass = ClassGasMask
		Add(Forged_Magnate_Armor)

		Entry Anti_C_Helmet = new Entry
		Anti_C_Helmet.PluginFile = RaiderOverhaul_ESP
		Anti_C_Helmet.FormID = 0x0000090B
		Anti_C_Helmet.TypeClass = ClassGasMask
		Add(Anti_C_Helmet)

		Entry Red_Angry_Bandana = new Entry
		Red_Angry_Bandana.PluginFile = RaiderOverhaul_ESP
		Red_Angry_Bandana.FormID = 0x0000121F
		Red_Angry_Bandana.TypeClass = ClassBandana
		Add(Red_Angry_Bandana)

		Entry Black_Angry_Bandana = new Entry
		Black_Angry_Bandana.PluginFile = RaiderOverhaul_ESP
		Black_Angry_Bandana.FormID = 0x00001220
		Black_Angry_Bandana.TypeClass = ClassBandana
		Add(Black_Angry_Bandana)


		; V6.2
		string NanoSuit_ESP = "NanoSuit.esp" const

		Entry Nano_Mask = new Entry
		Nano_Mask.PluginFile = NanoSuit_ESP
		Nano_Mask.FormID = 0x0000080D
		Nano_Mask.TypeClass = ClassGasMask
		Add(Nano_Mask)

		Entry Nano_Mask_Glasses_Up = new Entry
		Nano_Mask_Glasses_Up.PluginFile = NanoSuit_ESP
		Nano_Mask_Glasses_Up.FormID = 0x0000080E
		Nano_Mask_Glasses_Up.TypeClass = ClassGasMask
		Add(Nano_Mask_Glasses_Up)


		; V6.2
		string NanoSuit_AWKCR_ESP = "NanoSuit_AWKCR_AE.esp" const

		Entry Nano_Mask_AWKCR = new Entry
		Nano_Mask_AWKCR.PluginFile = NanoSuit_AWKCR_ESP
		Nano_Mask_AWKCR.FormID = 0x0000080D
		Nano_Mask_AWKCR.TypeClass = ClassGasMask
		Add(Nano_Mask_AWKCR)

		Entry Nano_Mask_Glasses_Up_AWKCR = new Entry
		Nano_Mask_Glasses_Up_AWKCR.PluginFile = NanoSuit_AWKCR_ESP
		Nano_Mask_Glasses_Up_AWKCR.FormID = 0x0000080E
		Nano_Mask_Glasses_Up_AWKCR.TypeClass = ClassGasMask
		Add(Nano_Mask_Glasses_Up_AWKCR)
		
		string The_Rebel_ESP = "The Rebel.esp" const
		
		Entry Armor_Rebel_Gasmask = new Entry
		Armor_Rebel_Gasmask.PluginFile = The_Rebel_ESP
		Armor_Rebel_Gasmask.FormID = 0x00000848
		Armor_Rebel_Gasmask.TypeClass = ClassGasMask
		Add(Armor_Rebel_Gasmask)
		
		string CROSS_TechMask_ESP = "CROSS_TechMask.esp" const
		
		Entry CROSS_TechMask_armor = new Entry
		CROSS_TechMask_armor.PluginFile = CROSS_TechMask_ESP
		CROSS_TechMask_armor.FormID = 0x00000804
		CROSS_TechMask_armor.TypeClass = ClassGasMask
		Add(CROSS_TechMask_armor)
		
		;0.9
		string Mercenary_ESP = "Mercenary.esp" const
		
		Entry Armor_Mercenary_Mask_A = new Entry
		Armor_Mercenary_Mask_A.PluginFile = Mercenary_ESP
		Armor_Mercenary_Mask_A.FormID = 0x00000851
		Armor_Mercenary_Mask_A.TypeClass = ClassGasMask
		Add(Armor_Mercenary_Mask_A)
		
		Entry Armor_Mercenary_Mask_B = new Entry
		Armor_Mercenary_Mask_B.PluginFile = Mercenary_ESP
		Armor_Mercenary_Mask_B.FormID = 0x00000852
		Armor_Mercenary_Mask_B.TypeClass = ClassGasMask
		Add(Armor_Mercenary_Mask_B)
		
		Entry Armor_Mercenary_Mask_A_Gunner = new Entry
		Armor_Mercenary_Mask_A_Gunner.PluginFile = Mercenary_ESP
		Armor_Mercenary_Mask_A_Gunner.FormID = 0x0000094F
		Armor_Mercenary_Mask_A_Gunner.TypeClass = ClassGasMask
		Add(Armor_Mercenary_Mask_A_Gunner)
		
		Entry Armor_Mercenary_Mask_B_Gunner = new Entry
		Armor_Mercenary_Mask_A_Gunner.PluginFile = Mercenary_ESP
		Armor_Mercenary_Mask_A_Gunner.FormID = 0x00000950
		Armor_Mercenary_Mask_A_Gunner.TypeClass = ClassGasMask
		Add(Armor_Mercenary_Mask_A_Gunner)
		
		Entry Armor_Wastelander_Mask_A = new Entry
		Armor_Wastelander_Mask_A.PluginFile = Mercenary_ESP
		Armor_Wastelander_Mask_A.FormID = 0x0000098E
		Armor_Wastelander_Mask_A.TypeClass = ClassGasMask
		Add(Armor_Wastelander_Mask_A)
		
		Entry Armor_Wastelander_Mask_B = new Entry
		Armor_Wastelander_Mask_B.PluginFile = Mercenary_ESP
		Armor_Wastelander_Mask_B.FormID = 0x0000098E
		Armor_Wastelander_Mask_B.TypeClass = ClassGasMask
		Add(Armor_Wastelander_Mask_B)
		
		Entry Armor_Merc_Rebel_Mask = new Entry
		Armor_Merc_Rebel_Mask.PluginFile = Mercenary_ESP
		Armor_Merc_Rebel_Mask.FormID = 0x00000CAC
		Armor_Merc_Rebel_Mask.TypeClass = ClassGasMask
		Add(Armor_Merc_Rebel_Mask)
		
		Entry Armor_Merc_Rebel_Mask_Beard = new Entry
		Armor_Merc_Rebel_Mask_Beard.PluginFile = Mercenary_ESP
		Armor_Merc_Rebel_Mask_Beard.FormID = 0x00003889
		Armor_Merc_Rebel_Mask_Beard.TypeClass = ClassGasMask
		Add(Armor_Merc_Rebel_Mask_Beard)
		
		Entry Armor_Scavenged_NCR_Mask = new Entry
		Armor_Scavenged_NCR_Mask.PluginFile = Mercenary_ESP
		Armor_Scavenged_NCR_Mask.FormID = 0x0000AB0C
		Armor_Scavenged_NCR_Mask.TypeClass = ClassGasMask
		Add(Armor_Scavenged_NCR_Mask)
		
		Entry Armor_Scavenged_NCR_Mask_Under = new Entry
		Armor_Scavenged_NCR_Mask_Under.PluginFile = Mercenary_ESP
		Armor_Scavenged_NCR_Mask_Under.FormID = 0x000037B8
		Armor_Scavenged_NCR_Mask_Under.TypeClass = ClassGasMask
		Add(Armor_Scavenged_NCR_Mask_Under)
		
		Entry Armor_Scavenged_NCR_Mask_Hood = new Entry
		Armor_Scavenged_NCR_Mask_Hood.PluginFile = Mercenary_ESP
		Armor_Scavenged_NCR_Mask_Hood.FormID = 0x000037B9
		Armor_Scavenged_NCR_Mask_Hood.TypeClass = ClassGasMask
		Add(Armor_Scavenged_NCR_Mask_Hood)
		
		Entry Armor_Rebel_Balaclava = new Entry
		Armor_Rebel_Balaclava.PluginFile = Mercenary_ESP
		Armor_Rebel_Balaclava.FormID = 0x00000934
		Armor_Rebel_Balaclava.TypeClass = ClassBandana
		Add(Armor_Rebel_Balaclava)
		
		Entry Armor_Merc_Balaclava = new Entry
		Armor_Merc_Balaclava.PluginFile = Mercenary_ESP
		Armor_Merc_Balaclava.FormID = 0x00000998
		Armor_Merc_Balaclava.TypeClass = ClassBandana
		Add(Armor_Merc_Balaclava)
		
		Entry Armor_Merc_Balaclava_Comb = new Entry
		Armor_Merc_Balaclava_Comb.PluginFile = Mercenary_ESP
		Armor_Merc_Balaclava_Comb.FormID = 0x000009B2
		Armor_Merc_Balaclava_Comb.TypeClass = ClassBandana
		Add(Armor_Merc_Balaclava_Comb)
		
		Entry Armor_Merc_Balaclava_Under = new Entry
		Armor_Merc_Balaclava_Under.PluginFile = Mercenary_ESP
		Armor_Merc_Balaclava_Under.FormID = 0x000037BB
		Armor_Merc_Balaclava_Under.TypeClass = ClassBandana
		Add(Armor_Merc_Balaclava_Under)
		
		Entry Armor_Rebel_Balaclava_Under = new Entry
		Armor_Rebel_Balaclava_Under.PluginFile = Mercenary_ESP
		Armor_Rebel_Balaclava_Under.FormID = 0x000037BC
		Armor_Rebel_Balaclava_Under.TypeClass = ClassBandana
		Add(Armor_Rebel_Balaclava_Under)
		
		;FROST Masks v0.3
		string Frost_ESP = "FROST.esp"
		
		Entry Armor_GasmaskBozo = new Entry
		Armor_GasmaskBozo.PluginFile = Frost_ESP
		Armor_GasmaskBozo.FormID = 0x0004195E
		Armor_GasmaskBozo.TypeClass = ClassGasMask
		Add(Armor_GasmaskBozo)
		
		Entry Armor_GasmaskBulletsBones = new Entry
		Armor_GasmaskBulletsBones.PluginFile = Frost_ESP
		Armor_GasmaskBulletsBones.FormID = 0x0004195F
		Armor_GasmaskBulletsBones.TypeClass = ClassGasMask
		Add(Armor_GasmaskBulletsBones)
		
		Entry Armor_GasmaskLaughing = new Entry
		Armor_GasmaskLaughing.PluginFile = Frost_ESP
		Armor_GasmaskLaughing.FormID = 0x00041960
		Armor_GasmaskLaughing.TypeClass = ClassGasMask
		Add(Armor_GasmaskLaughing)
		
		Entry Armor_GasmaskPiggsy = new Entry
		Armor_GasmaskPiggsy.PluginFile = Frost_ESP
		Armor_GasmaskPiggsy.FormID = 0x00041961
		Armor_GasmaskPiggsy.TypeClass = ClassGasMask
		Add(Armor_GasmaskPiggsy)
		
		Entry Armor_Gun_Helm = new Entry
		Armor_Gun_Helm.PluginFile = Frost_ESP
		Armor_Gun_Helm.FormID = 0x0006956E
		Armor_Gun_Helm.TypeClass = ClassGasMask
		Add(Armor_Gun_Helm)
		
		Entry Armor_Heavy_Helm = new Entry
		Armor_Heavy_Helm.PluginFile = Frost_ESP
		Armor_Heavy_Helm.FormID = 0x00069570
		Armor_Heavy_Helm.TypeClass = ClassGasMask
		Add(Armor_Heavy_Helm)
		
		Entry Armor_Tech_Helm = new Entry
		Armor_Tech_Helm.PluginFile = Frost_ESP
		Armor_Tech_Helm.FormID = 0x00069574
		Armor_Tech_Helm.TypeClass = ClassGasMask
		Add(Armor_Tech_Helm)
		
		; FROST Bandanas
		Entry Clothes_Raider_SurgicalMaskKabuki = new Entry
		Clothes_Raider_SurgicalMaskKabuki.PluginFile = Frost_ESP
		Clothes_Raider_SurgicalMaskKabuki.FormID = 0x000467BB
		Clothes_Raider_SurgicalMaskKabuki.TypeClass = ClassBandana
		Add(Clothes_Raider_SurgicalMaskKabuki)
		
		Entry Clothes_Raider_SurgicalMaskOMGDIE = new Entry
		Clothes_Raider_SurgicalMaskOMGDIE.PluginFile = Frost_ESP
		Clothes_Raider_SurgicalMaskOMGDIE.FormID = 0x000467BC
		Clothes_Raider_SurgicalMaskOMGDIE.TypeClass = ClassBandana
		Add(Clothes_Raider_SurgicalMaskOMGDIE)
		
		Entry Clothes_Raider_SurgicalMaskUnionJack = new Entry
		Clothes_Raider_SurgicalMaskUnionJack.PluginFile = Frost_ESP
		Clothes_Raider_SurgicalMaskUnionJack.FormID = 0x000467BD
		Clothes_Raider_SurgicalMaskUnionJack.TypeClass = ClassBandana
		Add(Clothes_Raider_SurgicalMaskUnionJack)
		
		;The Headpiece Dispatcher
		string Headpiece_Dispatcher_ESP = "The Headpiece Dispatcher.esp"
		
		Entry Armor_TinCanMask = new Entry
		Armor_TinCanMask.PluginFile = Headpiece_Dispatcher_ESP
		Armor_TinCanMask.FormID = 0x00007A04
		Armor_TinCanMask.TypeClass = ClassGasMask
		Add(Armor_TinCanMask)
		
		Entry Armor_RaiderCustomGasmask_V3 = new Entry
		Armor_RaiderCustomGasmask_V3.PluginFile = Headpiece_Dispatcher_ESP
		Armor_RaiderCustomGasmask_V3.FormID = 0x0000BE6E
		Armor_RaiderCustomGasmask_V3.TypeClass = ClassGasMask
		Add(Armor_RaiderCustomGasmask_V3)
		
		Entry Armor_RaiderCustomGasmask_V2 = new Entry
		Armor_RaiderCustomGasmask_V2.PluginFile = Headpiece_Dispatcher_ESP
		Armor_RaiderCustomGasmask_V2.FormID = 0x0000C60A
		Armor_RaiderCustomGasmask_V2.TypeClass = ClassGasMask
		Add(Armor_RaiderCustomGasmask_V2)
		
		Entry Armor_RaiderCustomGasmask_V1 = new Entry
		Armor_RaiderCustomGasmask_V1.PluginFile = Headpiece_Dispatcher_ESP
		Armor_RaiderCustomGasmask_V1.FormID = 0x0000CDA6
		Armor_RaiderCustomGasmask_V1.TypeClass = ClassGasMask
		Add(Armor_RaiderCustomGasmask_V1)
		
		 string LTW_MOPP_Suit_ESP = "LTW MOPP Suit.esp"

		Entry XLTW_PreWar_MOPP_Suit = new Entry
		XLTW_PreWar_MOPP_Suit.PluginFile = LTW_MOPP_Suit_ESP
		XLTW_PreWar_MOPP_Suit.FormID = 0x00000F99
		XLTW_PreWar_MOPP_Suit.TypeClass = ClassGasMask
		add(XLTW_PreWar_MOPP_Suit)

		Entry XLTW_PreWar_MOPP_Suit_Hood = new Entry
		XLTW_PreWar_MOPP_Suit_Hood.PluginFile = LTW_MOPP_Suit_ESP
		XLTW_PreWar_MOPP_Suit_Hood.FormID = 0x00002E0D
		XLTW_PreWar_MOPP_Suit_Hood.TypeClass = ClassGasMask
		add(XLTW_PreWar_MOPP_Suit_Hood)
		
		;SPECIAL Raider Gas Masks
		string SPECIAL_Raider_Gas_Masks_ESP = "SPECIAL_Raider_Gas_Masks.esp"
		
		Entry Pearly_Whites_Gas_Mask = new Entry
		Pearly_Whites_Gas_Mask.PluginFile = SPECIAL_Raider_Gas_Masks_ESP
		Pearly_Whites_Gas_Mask.FormID = 0x00000800
		Pearly_Whites_Gas_Mask.TypeClass = ClassGasMask
		Add(Pearly_Whites_Gas_Mask)
		
		Entry Bullseye_Gas_Mask = new Entry
		Bullseye_Gas_Mask.PluginFile = SPECIAL_Raider_Gas_Masks_ESP
		Bullseye_Gas_Mask.FormID = 0x00000808
		Bullseye_Gas_Mask.TypeClass = ClassGasMask
		Add(Bullseye_Gas_Mask)
		
		Entry Bloodsucker_Gas_Mask = new Entry
		Bloodsucker_Gas_Mask.PluginFile = SPECIAL_Raider_Gas_Masks_ESP
		Bloodsucker_Gas_Mask.FormID = 0x0000080B
		Bloodsucker_Gas_Mask.TypeClass = ClassGasMask
		Add(Bloodsucker_Gas_Mask)
		
		Entry Doomsday_Gas_Mask = new Entry
		Doomsday_Gas_Mask.PluginFile = SPECIAL_Raider_Gas_Masks_ESP
		Doomsday_Gas_Mask.FormID = 0x0000080E
		Doomsday_Gas_Mask.TypeClass = ClassGasMask
		Add(Doomsday_Gas_Mask)
		
		Entry Grease_Monkey_Gas_Mask = new Entry
		Grease_Monkey_Gas_Mask.PluginFile = SPECIAL_Raider_Gas_Masks_ESP
		Grease_Monkey_Gas_Mask.FormID = 0x00000811
		Grease_Monkey_Gas_Mask.TypeClass = ClassGasMask
		Add(Grease_Monkey_Gas_Mask)
		
		Entry Green_Phantom_Gas_Mask = new Entry
		Green_Phantom_Gas_Mask.PluginFile = SPECIAL_Raider_Gas_Masks_ESP
		Green_Phantom_Gas_Mask.FormID = 0x00000814
		Green_Phantom_Gas_Mask.TypeClass = ClassGasMask
		Add(Green_Phantom_Gas_Mask)
		
		Entry Lucky_Bastard_Gas_Mask = new Entry
		Lucky_Bastard_Gas_Mask.PluginFile = SPECIAL_Raider_Gas_Masks_ESP
		Lucky_Bastard_Gas_Mask.FormID = 0x00000817
		Lucky_Bastard_Gas_Mask.TypeClass = ClassGasMask
		Add(Lucky_Bastard_Gas_Mask)
		
		;Half Gas Masks
		string HalfGasMask_ESP = "HalfGasMask.esp" Const

		Entry Armor_ChildrenOfAtom_GasMask = new Entry
		Armor_ChildrenOfAtom_GasMask.PluginFile = HalfGasMask_ESP
		Armor_ChildrenOfAtom_GasMask.FormID = 0x00002686
		Armor_ChildrenOfAtom_GasMask.TypeClass = ClassGasMask
		add(Armor_ChildrenOfAtom_GasMask)
		
		Entry Armor_HalfAssault_GasMask = new Entry
		Armor_HalfAssault_GasMask.PluginFile = HalfGasMask_ESP
		Armor_HalfAssault_GasMask.FormID = 0x00000801
		Armor_HalfAssault_GasMask.TypeClass = ClassGasMask
		add(Armor_HalfAssault_GasMask)
		
		Entry Armor_HalfOne_GasMask = new Entry
		Armor_HalfOne_GasMask.PluginFile = HalfGasMask_ESP
		Armor_HalfOne_GasMask.FormID = 0x00000803
		Armor_HalfOne_GasMask.TypeClass = ClassGasMask
		add(Armor_HalfOne_GasMask)
		
		Entry Armor_HalfTwo_GasMask = new Entry
		Armor_HalfTwo_GasMask.PluginFile = HalfGasMask_ESP
		Armor_HalfTwo_GasMask.FormID = 0x00000804
		Armor_HalfTwo_GasMask.TypeClass = ClassGasMask
		add(Armor_HalfTwo_GasMask)
		
		Entry Armor_HalfThree_GasMask = new Entry
		Armor_HalfThree_GasMask.PluginFile = HalfGasMask_ESP
		Armor_HalfThree_GasMask.FormID = 0x00000808
		Armor_HalfThree_GasMask.TypeClass = ClassGasMask
		add(Armor_HalfThree_GasMask)
		
		Entry Armor_HalfRaider_GasMask = new Entry
		Armor_HalfRaider_GasMask.PluginFile = HalfGasMask_ESP
		Armor_HalfRaider_GasMask.FormID = 0x0000080F
		Armor_HalfRaider_GasMask.TypeClass = ClassGasMask
		add(Armor_HalfRaider_GasMask)
		
		Entry Armor_HalfMetal_GasMask = new Entry
		Armor_HalfMetal_GasMask.PluginFile = HalfGasMask_ESP
		Armor_HalfMetal_GasMask.FormID = 0x00000813
		Armor_HalfMetal_GasMask.TypeClass = ClassGasMask
		add(Armor_HalfMetal_GasMask)
		
		Entry Armor_HalfSpike_GasMask = new Entry
		Armor_HalfSpike_GasMask.PluginFile = HalfGasMask_ESP
		Armor_HalfSpike_GasMask.FormID = 0x00000FAE
		Armor_HalfSpike_GasMask.TypeClass = ClassGasMask
		add(Armor_HalfSpike_GasMask)
		
		Entry Armor_HalfCombat_GasMask = new Entry
		Armor_HalfCombat_GasMask.PluginFile = HalfGasMask_ESP
		Armor_HalfCombat_GasMask.FormID = 0x00000FB1
		Armor_HalfCombat_GasMask.TypeClass = ClassGasMask
		add(Armor_HalfCombat_GasMask)
		
		Entry Armor_HalfLeather_GasMask = new Entry
		Armor_HalfLeather_GasMask.PluginFile = HalfGasMask_ESP
		Armor_HalfLeather_GasMask.FormID = 0x00000FB3
		Armor_HalfLeather_GasMask.TypeClass = ClassGasMask
		add(Armor_HalfLeather_GasMask)
		
		Entry Armor_HalfSynth_GasMask = new Entry
		Armor_HalfSynth_GasMask.PluginFile = HalfGasMask_ESP
		Armor_HalfSynth_GasMask.FormID = 0x00000FB5
		Armor_HalfSynth_GasMask.TypeClass = ClassGasMask
		add(Armor_HalfSynth_GasMask)
		
		Entry Armor_HalfMascot_GasMask = new Entry
		Armor_HalfMascot_GasMask.PluginFile = HalfGasMask_ESP
		Armor_HalfMascot_GasMask.FormID = 0x00002689
		Armor_HalfMascot_GasMask.TypeClass = ClassGasMask
		add(Armor_HalfMascot_GasMask)
		
		Entry Armor_HalfSkull_GasMask = new Entry
		Armor_HalfSkull_GasMask.PluginFile = HalfGasMask_ESP
		Armor_HalfSkull_GasMask.FormID = 0x00002E25
		Armor_HalfSkull_GasMask.TypeClass = ClassGasMask
		add(Armor_HalfSkull_GasMask)
		
		string DX_Black_Widow_esp = "DX_Black_Widow.esp" Const
		
		Entry BlackWidowHood = new Entry
		BlackWidowHood.PluginFile = DX_Black_Widow_esp
		BlackWidowHood.FormID =  0x00001FBD
		BlackWidowHood.TypeClass = ClassGasMask
		Add(BlackWidowHood)
		
		;Chinese Stealth Suit
		string ChineseStealthSuit_ESP = "ChineseStealthSuit.esp" Const
		
		Entry Armor_ChineseStealthHelmet = new Entry
		Armor_ChineseStealthHelmet.PluginFile = ChineseStealthSuit_ESP	
		Armor_ChineseStealthHelmet.FormID = 0x00014F8E
		Armor_ChineseStealthHelmet.TypeClass = ClassGasMask
		Add (Armor_ChineseStealthHelmet)
		
		Entry Armor_DragoonHelm = new Entry
		Armor_DragoonHelm.PluginFile = ChineseStealthSuit_ESP	
		Armor_DragoonHelm.FormID = 0x00014F9C
		Armor_DragoonHelm.TypeClass = ClassGasMask
		Add (Armor_DragoonHelm)
		
		; N7
		string Merge_N7_Complete_ESP = "Merge N7 Complete.esp" Const
		
		Entry masseffect_vis = new Entry
		masseffect_vis.PluginFile = Merge_N7_Complete_ESP
		masseffect_vis.FormID = 0x00000F9A
		masseffect_vis.TypeClass = ClassGasMask
		Add(masseffect_vis)	

		; Desert Ranger Combat Helmet MKII
		string wkzz_dr_combat_ranger_helm_mod_ESP = "wkzz_dr_combat_ranger_helm_mod.esp" Const
		
		Entry DesertRangerHelm = new Entry
		DesertRangerHelm.PluginFile = wkzz_dr_combat_ranger_helm_mod_ESP
		DesertRangerHelm.FormID = 0x00000800
		DesertRangerHelm.TypeClass = ClassGasMask
		Add(DesertRangerHelm)	
		
		string MetroArmor_ESP = "MetroArmourPorts.esp" Const
		
		Entry  Metro_GasMask1 = new Entry
		Metro_GasMask1.PluginFile = MetroArmor_ESP
		Metro_GasMask1.FormID = 0x00000808
		Metro_GasMask1.TypeClass = ClassGasMask
		Add(Metro_GasMask1)
		
		string CROSS_BallisticMask_ESP = "CROSS_BallisticMask.esp" Const

        Entry CROSSarmor_Headwear_BallisticMask = new Entry
        CROSSarmor_Headwear_BallisticMask.PluginFile = CROSS_BallisticMask_ESP
        CROSSarmor_Headwear_BallisticMask.FormID = 0x000009D3
        CROSSarmor_Headwear_BallisticMask.TypeClass = ClassGasMask
        Add(CROSSarmor_Headwear_BallisticMask)
		
		string Metro_Gas_Masks_ESP = "Metro Gas Masks.esp" Const

        Entry Armor_Metro_PPM_88 = new Entry
        Armor_Metro_PPM_88.PluginFile = Metro_Gas_Masks_ESP
        Armor_Metro_PPM_88.FormID = 0x00000F99
        Armor_Metro_PPM_88.TypeClass = ClassGasMask
        Add(Armor_Metro_PPM_88)
		
		Entry Armor_Metro_PMK_1 = new Entry
        Armor_Metro_PMK_1.PluginFile = Metro_Gas_Masks_ESP
        Armor_Metro_PMK_1.FormID = 0x000035A7
        Armor_Metro_PMK_1.TypeClass = ClassGasMask
        Add(Armor_Metro_PMK_1)
		
		Entry Armor_Metro_M17 = new Entry
		Armor_Metro_M17.PluginFile = Context.Plugin
		Armor_Metro_M17.FormID = 0x00002672
		Armor_Metro_M17.TypeClass = ClassGasMask
		Add(Armor_Metro_M17)
		
		string FOC_NCR_Armors_ESP = "FOC_NCR_Armors.esp" Const
		
		Entry Armor_NCR_Helm_Gasmask = new Entry
        Armor_NCR_Helm_Gasmask.PluginFile = FOC_NCR_Armors_ESP
        Armor_NCR_Helm_Gasmask.FormID = 0x005600BB
        Armor_NCR_Helm_Gasmask.TypeClass = ClassGasMask
        Add(Armor_NCR_Helm_Gasmask)
		
		string Institute_Assassin_ESP = "Crimsonrider's Institute Assassin.esp" const
		
		Entry MaskB = new Entry
        MaskB.PluginFile = Institute_Assassin_ESP
        MaskB.FormID = 0x00003086
        MaskB.TypeClass = ClassGasMask
        Add(MaskB)
		
		Entry MaskW = new Entry
        MaskW.PluginFile = Institute_Assassin_ESP
        MaskW.FormID = 0x00003087
        MaskW.TypeClass = ClassGasMask
        Add(MaskW)
		
		Entry HoodForsaken = new Entry
        HoodForsaken.PluginFile = Institute_Assassin_ESP
        HoodForsaken.FormID = 0x0000308C
        HoodForsaken.TypeClass = ClassGasMask
        Add(HoodForsaken)
		
		Entry MaskMouth = new Entry
        MaskMouth.PluginFile = Institute_Assassin_ESP
        MaskMouth.FormID = 0x000030A2
        MaskMouth.TypeClass = ClassGasMask
        Add(MaskMouth)
		
		string FV20_BreathingMask_ESP = "FV20_BreathingMask.esp" const
		
		Entry BreathingMask = new Entry
		BreathingMask.PluginFile = FV20_BreathingMask_ESP
		BreathingMask.FormID = 0x00000FA0 					
		BreathingMask.TypeClass = ClassGasMask
		Add(BreathingMask)
		
		string SIERRA117_ESP = "Sierra117.esp" Const
		
		Entry Sierra117Helmet = new Entry
		Sierra117Helmet.PluginFile = SIERRA117_ESP
		Sierra117Helmet.FormID = 0x00001735				
		Sierra117Helmet.TypeClass = ClassGasMask
		Add(Sierra117Helmet)

		string HN66_SIRIUSARMOR_ESP = "HN66-SiriusArmor.esp" Const
		
		Entry HNSiriusHelmet = new Entry
		HNSiriusHelmet.PluginFile = HN66_SIRIUSARMOR_ESP
		HNSiriusHelmet.FormID = 0x00009872				
		HNSiriusHelmet.TypeClass = ClassGasMask
		Add(HNSiriusHelmet)

		Entry HNSiriusHelmetClosed = new Entry
		HNSiriusHelmetClosed.PluginFile = HN66_SIRIUSARMOR_ESP
		HNSiriusHelmetClosed.FormID = 0x0001568E				
		HNSiriusHelmetClosed.TypeClass = ClassGasMask
		Add(HNSiriusHelmetClosed)
		
		string CROSS_BrotherhoodRecon_ESP = "CROSS_BrotherhoodRecon.esp" Const
		
		Entry BoSReconMask = new Entry
		BoSReconMask.PluginFile = CROSS_BrotherhoodRecon_ESP
		BoSReconMask.FormID = 0x000008F7
		BoSReconMask.TypeClass = ClassGasMask
		Add(BoSReconMask)
		
		string Corpus_Praesidium_ESP = "CorpusPraesidium.esp" Const
		
		Entry Corpus_Praesidium_helmet = new Entry
		Corpus_Praesidium_helmet.PluginFile = Corpus_Praesidium_ESP
		Corpus_Praesidium_helmet.FormID = 0x00000f9c					
		Corpus_Praesidium_helmet.TypeClass = ClassGasMask
		Add(Corpus_Praesidium_helmet)
		
		Entry Corpus_Praesidium_Prersecutoris_helmet = new Entry
		Corpus_Praesidium_Prersecutoris_helmet.PluginFile = Corpus_Praesidium_ESP
		Corpus_Praesidium_Prersecutoris_helmet.FormID = 0x0000266f					
		Corpus_Praesidium_Prersecutoris_helmet.TypeClass = ClassGasMask
		Add(Corpus_Praesidium_Prersecutoris_helmet)

		Entry Corpus_Praesidium_Emendator_helmet = new Entry
		Corpus_Praesidium_Emendator_helmet.PluginFile = Corpus_Praesidium_ESP
		Corpus_Praesidium_Emendator_helmet.FormID = 0x00002e0f					
		Corpus_Praesidium_Emendator_helmet.TypeClass = ClassGasMask
		Add(Corpus_Praesidium_Emendator_helmet)
		
		string FV20_DreadHG_ESP = "FV20_DreadHG.esp" Const
		
		Entry steampunkmaskClosedgrey = new Entry
        steampunkmaskClosedgrey.PluginFile = FV20_DreadHG_ESP
        steampunkmaskClosedgrey.FormID = 0x00000F9E
        steampunkmaskClosedgrey.TypeClass = ClassGasMask
        Add(steampunkmaskClosedgrey)
		
		Entry steampunkmaskopengrey = new Entry
        steampunkmaskopengrey.PluginFile = FV20_DreadHG_ESP
        steampunkmaskopengrey.FormID = 0x00000FA0
        steampunkmaskopengrey.TypeClass = ClassGasMask
        Add(steampunkmaskopengrey)
		
		Entry insectGMClosedDark = new Entry
        insectGMClosedDark.PluginFile = FV20_DreadHG_ESP
        insectGMClosedDark.FormID = 0x00001743
        insectGMClosedDark.TypeClass = ClassGasMask
        Add(insectGMClosedDark)
		
		Entry insectGMopenDark = new Entry
        insectGMopenDark.PluginFile = FV20_DreadHG_ESP
        insectGMopenDark.FormID = 0x00001745
        insectGMopenDark.TypeClass = ClassGasMask
        Add(insectGMopenDark)
		
		Entry Armor_Dread_1 = new Entry
		Armor_Dread_1.PluginFile = FV20_DreadHG_ESP
		Armor_Dread_1.FormID = 0x00000F9C			
		Armor_Dread_1.TypeClass = ClassGasMask
		Add(Armor_Dread_1)
		
		Entry Armor_Dread_3 = new Entry
		Armor_Dread_3.PluginFile = FV20_DreadHG_ESP
		Armor_Dread_3.FormID = 0x0000173D			
		Armor_Dread_3.TypeClass = ClassGasMask
		Add(Armor_Dread_3)
		
		
		string CROSS_CourserStrigidae_esp = "CROSS_CourserStrigidae.esp" Const
		
		Entry CROSSArmor_CE_Helmet01 = new Entry
		CROSSArmor_CE_Helmet01.PluginFile = CROSS_CourserStrigidae_esp
		CROSSArmor_CE_Helmet01.FormID = 0x0000083F
		CROSSArmor_CE_Helmet01.TypeClass = ClassGasMask
		Add(CROSSArmor_CE_Helmet01)
		
		Entry CROSSArmor_CE_Helmet02 = new Entry
		CROSSArmor_CE_Helmet02.PluginFile = CROSS_CourserStrigidae_esp
		CROSSArmor_CE_Helmet02.FormID = 0x00000837
		CROSSArmor_CE_Helmet02.TypeClass = ClassGasMask
		Add(CROSSArmor_CE_Helmet02)
		
		string Last_Light_ESP1 = "Last_Light.esp" Const
		
		Entry Ranger_Visor_Low1 = new Entry
        Ranger_Visor_Low1.PluginFile = Last_Light_ESP1
        Ranger_Visor_Low1.FormID = 0x000008A9
        Ranger_Visor_Low1.TypeClass = ClassGasMask
        Add(Ranger_Visor_Low1)
		
		Entry Hansa_Gasmask1 = new Entry
        Hansa_Gasmask1.PluginFile = Last_Light_ESP1
        Hansa_Gasmask1.FormID = 0x0000095E
        Hansa_Gasmask1.TypeClass = ClassGasMask
        Add(Hansa_Gasmask1)
		
		string Apal_ESP = "ApalCSA.esp" Const
		
		Entry ChineseHelmetNPC = new Entry
        ChineseHelmetNPC.PluginFile = Apal_ESP
        ChineseHelmetNPC.FormID = 0x000044F9
        ChineseHelmetNPC.TypeClass = ClassGasMask
        Add(ChineseHelmetNPC)

		Entry ChineseHelmetApal = new Entry
        ChineseHelmetApal.PluginFile = Apal_ESP
        ChineseHelmetApal.FormID = 0x00002666
        ChineseHelmetApal.TypeClass = ClassGasMask
        Add(ChineseHelmetApal)
		
		string ChineseStealthHelmet_ESP = "APAL_CSA_Mod3.esp" Const

		Entry ChineseHelmetMod3 = new Entry
        ChineseHelmetMod3.PluginFile = ChineseStealthHelmet_ESP
        ChineseHelmetMod3.FormID = 0x000044F9
        ChineseHelmetMod3.TypeClass = ClassGasMask
        Add(ChineseHelmetMod3)

		Entry ChineseHelmet = new Entry
        ChineseHelmet.PluginFile = ChineseStealthHelmet_ESP
        ChineseHelmet.FormID = 0x00002666
        ChineseHelmet.TypeClass = ClassGasMask
        Add(ChineseHelmet)
		
		string Last_Light_ESP = "last light.esp" Const
		
		Entry Ranger_Visor_Low = new Entry
        Ranger_Visor_Low.PluginFile = Last_Light_ESP
        Ranger_Visor_Low.FormID = 0x000008A9
        Ranger_Visor_Low.TypeClass = ClassGasMask
        Add(Ranger_Visor_Low)
		
		Entry Hansa_Gasmask = new Entry
        Hansa_Gasmask.PluginFile = Last_Light_ESP
        Hansa_Gasmask.FormID = 0x0000095E
        Hansa_Gasmask.TypeClass = ClassGasMask
        Add(Hansa_Gasmask)
		
		Entry Hazard_Suit_Mask = new Entry
        Hazard_Suit_Mask.PluginFile = Last_Light_ESP
        Hazard_Suit_Mask.FormID = 0x0000096F
        Hazard_Suit_Mask.TypeClass = ClassGasMask
        Add(Hazard_Suit_Mask)
		
		string Wolfenstein_ESP = "Wolfenstein.esp" Const
		
		Entry FlameHelm = new Entry
        FlameHelm.PluginFile = Wolfenstein_ESP
        FlameHelm.FormID = 0x000081AB
        FlameHelm.TypeClass = ClassGasMask
        Add(FlameHelm)
		
		string UniversalGasMasks_ESP = "Universal Gas Masks.esp" Const
		
		Entry Universal54 = new Entry
		Universal54.PluginFile = Context.Plugin
		Universal54.FormID = 0x0000A119
		Universal54.TypeClass = ClassGasMask
		Add(Universal54)
		
		Entry Universal55 = new Entry
		Universal55.PluginFile = Context.Plugin
		Universal55.FormID = 0x0000A11A
		Universal55.TypeClass = ClassGasMask
		Add(Universal55)
		
		Entry Universal56 = new Entry
		Universal56.PluginFile = Context.Plugin
		Universal56.FormID = 0x0000A11B
		Universal56.TypeClass = ClassGasMask
		Add(Universal56)
		
		Entry Universal57 = new Entry
		Universal57.PluginFile = Context.Plugin
		Universal57.FormID = 0x0000A11C
		Universal57.TypeClass = ClassGasMask
		Add(Universal57)
		
		Entry Universal58 = new Entry
		Universal58.PluginFile = Context.Plugin
		Universal58.FormID = 0x0000A11D
		Universal58.TypeClass = ClassGasMask
		Add(Universal58)
		
		string FV20_RSS_ESP = "FV20_RSS.esp" const
 
		Entry ThatcherHelmet1 = new Entry
		ThatcherHelmet1.PluginFile = FV20_RSS_ESP
		ThatcherHelmet1.FormID = 0x00005BBC
		ThatcherHelmet1.TypeClass = ClassGasMask
		Add(ThatcherHelmet1)
		
		string DEOXstorm_ESP = "DEOXstorm.esp" const
		
		Entry Armor_Deox_Helm_Gunner = new Entry
		Armor_Deox_Helm_Gunner.PluginFile = DEOXstorm_ESP
		Armor_Deox_Helm_Gunner.FormID = 0x0000E4DB
		Armor_Deox_Helm_Gunner.TypeClass = ClassGasMask
		Add(Armor_Deox_Helm_Gunner)
		
		Entry Armor_Deox_Helm_Snow = new Entry
		Armor_Deox_Helm_Snow.PluginFile = DEOXstorm_ESP
		Armor_Deox_Helm_Snow.FormID = 0x0000E4DA
		Armor_Deox_Helm_Snow.TypeClass = ClassGasMask
		Add(Armor_Deox_Helm_Snow)
		
		Entry Armor_Deox_Helm_Trooper = new Entry
		Armor_Deox_Helm_Trooper.PluginFile = DEOXstorm_ESP
		Armor_Deox_Helm_Trooper.FormID = 0x00001ECF
		Armor_Deox_Helm_Trooper.TypeClass = ClassGasMask
		Add(Armor_Deox_Helm_Trooper)
		
		string Gasmask_mimi_ESP = "Gasmask mimi.esp"
		
		Entry LatexGasMask = new Entry
		LatexGasMask.PluginFile = Gasmask_mimi_ESP
		LatexGasMask.FormID = 0x00000800
		LatexGasMask.TypeClass = ClassGasMask
		Add(LatexGasMask)
		
		Entry MSAGasMask = new Entry
		MSAGasMask.PluginFile = Gasmask_mimi_ESP
		MSAGasMask.FormID = 0x00000802
		MSAGasMask.TypeClass = ClassGasMask
		Add(MSAGasMask)
		
		string Commando_esp = "Commando.esp" Const
		
		Entry Armor_ModCommando_MouthGuard = new Entry
		Armor_ModCommando_MouthGuard.PluginFile = Commando_esp
		Armor_ModCommando_MouthGuard.FormID = 0x00000FA8			
		Armor_ModCommando_MouthGuard.TypeClass = ClassGasMask
		Add(Armor_ModCommando_MouthGuard)
		
		string Rage_XOF_armor_pack_ESP = "Rage_XOF_armor_pack.esp" Const
		
		Entry Armor_Rage = new Entry
		Armor_Rage.PluginFile = Rage_XOF_armor_pack_ESP
		Armor_Rage.FormID = 0x000008AE			
		Armor_Rage.TypeClass = ClassGasMask
		Add(Armor_Rage)
		
		string Heavy_BoS_ESP = "Heavy BoS.esp" Const
		
		Entry Armor_B_35C = new Entry
		Armor_B_35C.PluginFile = Heavy_BoS_ESP
		Armor_B_35C.FormID = 0x00002E04		
		Armor_B_35C.TypeClass = ClassGasMask
		Add(Armor_B_35C)
		
		string MorganSpaceSuitNOCC_ESP = "MorganSpaceSuitNOCC.esp" Const
		
		Entry MorganHelmet = new Entry
		MorganHelmet.PluginFile = MorganSpaceSuitNOCC_ESP
		MorganHelmet.FormID = 0x00000F9C		
		MorganHelmet.TypeClass = ClassGasMask
		Add(MorganHelmet)	

		string DogtoothCG_M1A211_Gas_Mask_ESP = "DogtoothCG M1A211 Gas Mask.esp" Const
		
		Entry GasMask_Dogtooth = new Entry
		GasMask_Dogtooth.PluginFile = DogtoothCG_M1A211_Gas_Mask_ESP
		GasMask_Dogtooth.FormID = 0x00007A77		
		GasMask_Dogtooth.TypeClass = ClassGasMask
		Add(GasMask_Dogtooth)	
		
		string MOPP_Suit_ESP = "MOPP Suit.esp"
		
		Entry MOPP = new Entry
		MOPP.PluginFile = MOPP_Suit_ESP
		MOPP.FormID = 0x00000F9B
		MOPP.TypeClass = ClassGasMask
		Add(MOPP)
		
		string UNSCArmory_ESP = "UNSCArmory.esp" Const
		
		Entry ReachODSThelmet = new Entry
		ReachODSThelmet.PluginFile = UNSCArmory_ESP
		ReachODSThelmet.FormID = 0x00001737
		ReachODSThelmet.TypeClass = ClassGasMask
		Add (ReachODSThelmet)
		
		Entry ReachODSThelmetWC = new Entry
		ReachODSThelmetWC.PluginFile = UNSCArmory_ESP
		ReachODSThelmetWC.FormID = 0x00001F19
		ReachODSThelmetWC.TypeClass = ClassGasMask
		Add (ReachODSThelmetWC)
		
		Entry ReachODSThelmetDC = new Entry
		ReachODSThelmetDC.PluginFile = UNSCArmory_ESP
		ReachODSThelmetDC.FormID = 0x00001F8E
		ReachODSThelmetDC.TypeClass = ClassGasMask
		Add (ReachODSThelmetDC)
		
		string DX_Rogue_Prototype_ESP = "DX_Rogue_Prototype.esp" Const
		
		Entry Armor_DXM_N_Visor = new Entry
		Armor_DXM_N_Visor.PluginFile = DX_Rogue_Prototype_ESP
		Armor_DXM_N_Visor.FormID = 0x00006BEC		
		Armor_DXM_N_Visor.TypeClass = ClassGasMask
		Add(Armor_DXM_N_Visor)
		
		string TheFourHorsemenMasks_ESP = "TheFourHorsemenMasks.esp" Const
		
		Entry T4HDogOfWar = new Entry
		T4HDogOfWar.PluginFile = TheFourHorsemenMasks_ESP
		T4HDogOfWar.FormID = 0x00000F9F		
		T4HDogOfWar.TypeClass = ClassGasMask
		Add(T4HDogOfWar)

		Entry T4HDogOfWarSkullHooded = new Entry
		T4HDogOfWarSkullHooded.PluginFile = TheFourHorsemenMasks_ESP
		T4HDogOfWarSkullHooded.FormID = 0x00002E41		
		T4HDogOfWarSkullHooded.TypeClass = ClassBandana
		Add(T4HDogOfWarSkullHooded)

		Entry T4HHoodedSkullMask = new Entry
		T4HHoodedSkullMask.PluginFile = TheFourHorsemenMasks_ESP
		T4HHoodedSkullMask.FormID = 0x000035DD		
		T4HHoodedSkullMask.TypeClass = ClassBandana
		Add(T4HHoodedSkullMask)

		Entry T4HPlagueMask = new Entry
		T4HPlagueMask.PluginFile = TheFourHorsemenMasks_ESP
		T4HPlagueMask.FormID = 0x0000268D		
		T4HPlagueMask.TypeClass = ClassBandana
		Add(T4HPlagueMask)
		
		Entry T4HBunnyOfDeath = new Entry
		T4HBunnyOfDeath.PluginFile = TheFourHorsemenMasks_ESP
		T4HBunnyOfDeath.FormID = 0x00000F9E		
		T4HBunnyOfDeath.TypeClass = ClassBandana
		Add(T4HBunnyOfDeath)

		Entry T4HHoodNBalaclava = new Entry
		T4HHoodNBalaclava.PluginFile = TheFourHorsemenMasks_ESP
		T4HHoodNBalaclava.FormID = 0x00003D79		
		T4HHoodNBalaclava.TypeClass = ClassBandana
		Add(T4HHoodNBalaclava)
		
		string CROSS_InstituteExpeditionarySuit_ESP = "CROSS_InstituteExpeditionarySuit.esp" Const
		
		Entry CROSSArmo_ret_Mask01 = new Entry
		CROSSArmo_ret_Mask01.PluginFile = CROSS_InstituteExpeditionarySuit_ESP
		CROSSArmo_ret_Mask01.FormID = 0x00000848		
		CROSSArmo_ret_Mask01.TypeClass = ClassGasMask
		Add(CROSSArmo_ret_Mask01)
		
		string Institute_Assassin_Phantom_ESP = "Crimsomrider's Phantom Of Far Harbor.esp" const
		
		Entry PhantomMaskChin = new Entry
        PhantomMaskChin.PluginFile = Institute_Assassin_Phantom_ESP
        PhantomMaskChin.FormID = 0x00000804
        PhantomMaskChin.TypeClass = ClassGasMask
        Add(PhantomMaskChin)
		
		Entry PhantomMaskMouth = new Entry
        PhantomMaskMouth.PluginFile = Institute_Assassin_Phantom_ESP
        PhantomMaskMouth.FormID = 0x00000826
        PhantomMaskMouth.TypeClass = ClassGasMask
        Add(PhantomMaskMouth)
		
		Entry PhantomMaskChinLessHair = new Entry
        PhantomMaskChinLessHair.PluginFile = Institute_Assassin_Phantom_ESP
        PhantomMaskChinLessHair.FormID = 0x0000083e
        PhantomMaskChinLessHair.TypeClass = ClassGasMask
        Add(PhantomMaskChinLessHair)
		
		Entry PhantomMaskMouthLessHair = new Entry
        PhantomMaskMouthLessHair.PluginFile = Institute_Assassin_Phantom_ESP
        PhantomMaskMouthLessHair.FormID = 0x0000083f
        PhantomMaskMouthLessHair.TypeClass = ClassGasMask
        Add(PhantomMaskMouthLessHair)
		
		string GP5_ESP = "GP5.esp"
		
		Entry GP51 = new Entry
		GP51.PluginFile = GP5_ESP
		GP51.FormID = 0x00000F99
		GP51.TypeClass = ClassGasMask
		Add(GP51)
		
		Entry GP5Hat2 = new Entry
		GP5Hat2.PluginFile = GP5_ESP
		GP5Hat2.FormID = 0x00002DFF
		GP5Hat2.TypeClass = ClassGasMask
		Add(GP5Hat2)
		
		;Doom Marine Helmet
		string doommarinearmor_ESL = "ccbgsfo4041-doommarinearmor.esl" Const

		Entry Armor_doommarineHelmet = new Entry
		Armor_doommarineHelmet.PluginFile = doommarinearmor_ESL
		Armor_doommarineHelmet.FormID = 0x01000804
		Armor_doommarineHelmet.TypeClass = ClassGasMask
		Add(Armor_doommarineHelmet)

        ;Chinese Stealth Armor
		string chinesestealtharmor_ESM = "ccbgsfo4019-chinesestealtharmor.esm" Const
		
		Entry Armor_chinesestealtharmor = new Entry
		Armor_chinesestealtharmor.PluginFile = chinesestealtharmor_ESM	
		Armor_chinesestealtharmor.FormID = 0x01000F99
		Armor_chinesestealtharmor.TypeClass = ClassGasMask
		Add (Armor_chinesestealtharmor)

		;Prey Armor
		string ccbgsfo4016prey_ESM = "ccbgsfo4016-prey.esm" Const

		Entry Armor_ccbgsfo4016prey = new Entry
		Armor_ccbgsfo4016prey.PluginFile = ccbgsfo4016prey_ESM
		Armor_ccbgsfo4016prey.FormID = 0x01000F99
		Armor_ccbgsfo4016prey.TypeClass = ClassGasMask
		Add(Armor_ccbgsfo4016prey)
		
		string MilitarizedMinutemen_ESP = "MilitarizedMinutemen.esp" const

        Entry Milmin_Armor_Gasmask = new Entry
        Milmin_Armor_Gasmask.PluginFile = MilitarizedMinutemen_ESP
		Milmin_Armor_Gasmask.FormID = 0x00010CBC
        Milmin_Armor_Gasmask.TypeClass = ClassGasMask
        Add(Milmin_Armor_Gasmask)
		
		string CROSS_CoA_ESP = "CROSS_CoA.esp" const

		Entry CROSSArmo_coa_Mask01 = new Entry
		CROSSArmo_coa_Mask01.PluginFile = CROSS_CoA_ESP
		CROSSArmo_coa_Mask01.FormID = 0x0000085A
		CROSSArmo_coa_Mask01.TypeClass = ClassGasMask
		Add(CROSSArmo_coa_Mask01)
		
		string Manhunt_ESP = "CROSS_MojaveManhunter.esp" const

        Entry Armor_Manhunt_Gasmask = new Entry
        Armor_Manhunt_Gasmask.PluginFile = Manhunt_ESP
        Armor_Manhunt_Gasmask.FormID = 0x0000085a
        Armor_Manhunt_Gasmask.TypeClass = ClassGasMask
        Add(Armor_Manhunt_Gasmask)

		string outlawer_MetroLL_ESP = "outlawer MetroLL.esp"
		Entry Outlawers_Fo4_outfit_pack =  New Entry 
		Outlawers_Fo4_outfit_pack.PluginFile = outlawer_MetroLL_ESP
		Outlawers_Fo4_outfit_pack.FormID = 0x000008A6
		Outlawers_Fo4_outfit_pack.TypeClass = ClassGasMask 
		Add(Outlawers_Fo4_outfit_pack)
		
		string MyCart_Biohazard_ESP = "MyCart_Biohazard.esp"
		Entry Biohazard_Suit =  New Entry 
		Biohazard_Suit.PluginFile = MyCart_Biohazard_ESP
		Biohazard_Suit.FormID = 0x00000800
		Biohazard_Suit.TypeClass = ClassGasMask 
		Add(Biohazard_Suit)
		; Add your Armor here
		
		;Enclave Remnants Armor
		string Enclave_Remnants_ESP = "ECV_RemnantsArmor.esp" const

		Entry Armor_ECV_Helmet = New Entry
		Armor_ECV_Helmet.PluginFile = Enclave_Remnants_ESP
		Armor_ECV_Helmet.FormID = 0x00001732
		Armor_ECV_Helmet.TypeClass = ClassGasMask
		Add(Armor_ECV_Helmet)
		
		Entry Armor_ECV_Helmet_Tesla
		Armor_ECV_Helmet_Tesla.PluginFile = Enclave_Remnants_ESP
		Armor_ECV_Helmet_Tesla.FormID = 0x00001EDE
		Armor_ECV_Helmet_Tesla.TypeClass = ClassGasMask
		Add(Armor_ECV_Helmet_Tesla)

		
		
		ChangeState(self, EmptyState)
	EndEvent
EndState
