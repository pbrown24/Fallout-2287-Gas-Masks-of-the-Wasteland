ScriptName Metro:World:WeatherDatabase extends Metro:Core:Required
{QUST:Metro_Context}
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
	Weather WeatherID = none
	int TypeClass = -1
EndStruct


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
	int Property ClassSnow = 0 AutoReadOnly
	int Property ClassDust = 1 AutoReadOnly
	int Property ClassRain = 2 AutoReadOnly
EndGroup


; Events
;---------------------------------------------

Event OnInitialize()
	Log = GetLog(self)
	Log.FileName = "Weather"
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
	ChangeState(self, UpdateState)
EndEvent


; Functions
;---------------------------------------------

Function Add(Entry current)
	{IGNORE}
	WriteLine(Log, "Ignoring request to add '"+EntryToString(current)+"' in '"+StateName+"'.")
EndFunction


int Function GetClassification(Weather akWeather)
	int index = IndexOf(akWeather)
	If (index > Invalid)
		return Collection[index].TypeClass
	Else
		return Invalid
	EndIf
EndFunction


int Function GetWeatherFormID(Weather akWeather)
	int index = IndexOf(akWeather)
	If (index > Invalid)
		return Collection[index].FormID
	Else
		return Invalid
	EndIf
EndFunction


bool Function Contains(Weather akWeather)
	return IndexOf(akWeather) > Invalid
EndFunction


int Function IndexOf(Weather akWeather)
	If (Collection && akWeather)
		return Collection.FindStruct("WeatherID", akWeather)
	Else
		return Invalid
	EndIf
EndFunction


Weather Function GetAt(int aindex)
	return Collection[aindex].WeatherID
EndFunction


Weather Function GetRandom()
	int index = Utility.RandomInt(0, Count)
	return Collection[index].WeatherID
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
		If (current.WeatherID)
			return current.PluginFile+":"+current.WeatherID
		Else
			return current.PluginFile+":"+current.FormID
		EndIf
	Else
		return "Invalid Entry"
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
				current.WeatherID = Game.GetFormFromFile(current.FormID, current.PluginFile) as Weather

				If (current.WeatherID)
					If (Contains(current.WeatherID) == false)
						Collection.Add(current)
						WriteLine(Log, "Added the entry '"+EntryToString(current)+"' to Collection.")
					Else
						WriteLine(Log, "Collection already contains the entry '"+EntryToString(current)+"'.")
					EndIf
				Else
					WriteLine(Log, "The entry '"+EntryToString(current)+"' does not exist or is not of the object type Weather.")
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

		;GMOW
		Entry GasMask_DustHeavy = new Entry
		GasMask_DustHeavy.PluginFile = Context.Plugin
		GasMask_DustHeavy.FormID = 0x0000638A
		GasMask_DustHeavy.TypeClass = ClassDust
		Add(GasMask_DustHeavy)
		
		Entry GasMask_DustLite = new Entry
		GasMask_DustLite.PluginFile = Context.Plugin
		GasMask_DustLite.FormID = 0x0000638C
		GasMask_DustLite.TypeClass = ClassDust
		Add(GasMask_DustLite)
	
		string Fallout4_ESM = "Fallout4.esm" const
		
		Entry CommonwealthDusty = new Entry
		CommonwealthDusty.PluginFile = Fallout4_ESM
		CommonwealthDusty.FormID = 0x001F61A1
		CommonwealthDusty.TypeClass = ClassDust
		Add(CommonwealthDusty)
		
		string NAC_ESM = "NAC.esm"
		
		Entry NACGiantRedStorm = new Entry
		NACGiantRedStorm.PluginFile = NAC_ESM
		NACGiantRedStorm.FormID = 0x0000082F
		NACGiantRedStorm.TypeClass = ClassDust
		Add(NACGiantRedStorm)
		
		Entry NACGiantRedStormOVC = new Entry
		NACGiantRedStormOVC.PluginFile = NAC_ESM
		NACGiantRedStormOVC.FormID = 0x0000082F
		NACGiantRedStormOVC.TypeClass = ClassDust
		Add(NACGiantRedStormOVC)
		
		Entry GSNACGiantRedStorm = new Entry
		GSNACGiantRedStorm.PluginFile = NAC_ESM
		GSNACGiantRedStorm.FormID = 0x00087F86
		GSNACGiantRedStorm.TypeClass = ClassDust
		Add(GSNACGiantRedStorm)
		
		Entry GSNACGiantRedStormOVC = new Entry
		GSNACGiantRedStormOVC.PluginFile = NAC_ESM
		GSNACGiantRedStormOVC.FormID = 0x00087F87
		GSNACGiantRedStormOVC.TypeClass = ClassSnow
		Add(GSNACGiantRedStormOVC)
		
		Entry NAC_SnowMist = new Entry
		NAC_SnowMist.PluginFile = NAC_ESM
		NAC_SnowMist.FormID = 0x0D0449AA
		NAC_SnowMist.TypeClass = ClassSnow
		Add(NAC_SnowMist)
		
		Entry NACSandStorm = new Entry
		NACSandStorm.PluginFile = NAC_ESM
		NACSandStorm.FormID = 0x00054BDD
		NACSandStorm.TypeClass = ClassDust
		Add(NACSandStorm)
		
		Entry NAC_SnowFoggy = new Entry
		NAC_SnowFoggy.PluginFile = NAC_ESM
		NAC_SnowFoggy.FormID = 0x0D040CB1
		NAC_SnowFoggy.TypeClass = ClassSnow
		Add(NAC_SnowFoggy)
		
		Entry NACClearColdSnow = new Entry
		NACClearColdSnow.PluginFile = NAC_ESM
		NACClearColdSnow.FormID = 0x0D040CB3
		NACClearColdSnow.TypeClass = ClassSnow
		Add(NACClearColdSnow)
		
		Entry NACSnowStorm = new Entry
		NACSnowStorm.PluginFile = NAC_ESM
		NACSnowStorm.FormID = 0x0D040CB2
		NACSnowStorm.TypeClass = ClassSnow
		Add(NACSnowStorm)
		
		
		
		string VividWeathers_ESP = "Vivid Weathers - FO4.esp"
		
		Entry VW_Radstorm_Blue_Snow = new Entry
		VW_Radstorm_Blue_Snow.PluginFile = VividWeathers_ESP
		VW_Radstorm_Blue_Snow.FormID = 0x0001C15E
		VW_Radstorm_Blue_Snow.TypeClass = ClassSnow
		Add(VW_Radstorm_Blue_Snow)
		
		Entry VW_Radstorm_Red_Snow = new Entry
		VW_Radstorm_Red_Snow.PluginFile = VividWeathers_ESP
		VW_Radstorm_Red_Snow.FormID = 0x0001C160
		VW_Radstorm_Red_Snow.TypeClass = ClassSnow
		Add(VW_Radstorm_Red_Snow)
		
		Entry VW_Radstorm_Green_Snow = new Entry
		VW_Radstorm_Green_Snow.PluginFile = VividWeathers_ESP
		VW_Radstorm_Green_Snow.FormID = 0x0001C15F
		VW_Radstorm_Green_Snow.TypeClass = ClassSnow
		Add(VW_Radstorm_Green_Snow)
		
		Entry VW_Radstorm_Blue_SnowGS = new Entry
		VW_Radstorm_Blue_SnowGS.PluginFile = VividWeathers_ESP
		VW_Radstorm_Blue_SnowGS.FormID = 0x00028702
		VW_Radstorm_Blue_SnowGS.TypeClass = ClassSnow
		Add(VW_Radstorm_Blue_SnowGS)
		
		Entry VW_Radstorm_Red_SnowGS = new Entry
		VW_Radstorm_Red_SnowGS.PluginFile = VividWeathers_ESP
		VW_Radstorm_Red_SnowGS.FormID = 0x00028705
		VW_Radstorm_Red_SnowGS.TypeClass = ClassSnow
		Add(VW_Radstorm_Red_SnowGS)
		
		Entry VW_Radstorm_Green_SnowGS = new Entry
		VW_Radstorm_Green_SnowGS.PluginFile = VividWeathers_ESP
		VW_Radstorm_Green_SnowGS.FormID = 0x00028708
		VW_Radstorm_Green_SnowGS.TypeClass = ClassSnow
		Add(VW_Radstorm_Green_SnowGS)
		
		Entry VW_Pallout_blizzard = new Entry
		VW_Pallout_blizzard.PluginFile = VividWeathers_ESP
		VW_Pallout_blizzard.FormID = 0x0002B4B3
		VW_Pallout_blizzard.TypeClass = ClassSnow
		Add(VW_Pallout_blizzard)
		
		Entry VW_Pallout = new Entry
		VW_Pallout.PluginFile = VividWeathers_ESP
		VW_Pallout.FormID = 0x0001B9BC
		VW_Pallout.TypeClass = ClassSnow
		Add(VW_Pallout)
		
		Entry VW_Pallout_2 = new Entry
		VW_Pallout_2.PluginFile = VividWeathers_ESP
		VW_Pallout_2.FormID = 0x0001C157
		VW_Pallout_2.TypeClass = ClassSnow
		Add(VW_Pallout_2)
		
		Entry VW_Pallout_3 = new Entry
		VW_Pallout_3.PluginFile = VividWeathers_ESP
		VW_Pallout_3.FormID = 0x0001C15A
		VW_Pallout_3.TypeClass = ClassSnow
		Add(VW_Pallout_3)
		
		Entry VW_Pallout_3_GS = new Entry
		VW_Pallout_3_GS.PluginFile = VividWeathers_ESP
		VW_Pallout_3_GS.FormID = 0x0002870A
		VW_Pallout_3_GS.TypeClass = ClassSnow
		Add(VW_Pallout_3_GS)
		
		
	
		ChangeState(self, EmptyState)
		
	EndEvent
	
EndState
