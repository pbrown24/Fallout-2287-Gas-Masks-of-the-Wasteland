Scriptname Metro:World:Climate extends Metro:Core:Optional
{QUST:Metro_World}
import Shared:Log

UserLog Log

WeatherData WeatherCurrent
CustomEvent OnWeatherChanged

TransitionData TransitionCurrent
CustomEvent OnWeatherTransition

LocationData LocationCurrent
CustomEvent OnLocationChanged

int ModeValue

int UpdateTimer = 0 const
int UpdateInterval = 30 const

int TransitionTimer = 0 const
int TransitionInterval = 1 const
float TransitionCompleted = 1.0 const

string ChangingState = "ChangingState" const


Struct WeatherData
	Weather Object = none
	int Classification = -1
	int TypeClass = -1
EndStruct

Struct TransitionData
	float Completion = -1.0
	int Classification = -1
EndStruct

Struct LocationData
	Location Object = none
	WorldSpace World = none
EndStruct


; Events
;---------------------------------------------

Event OnInitialize()
	Log = new UserLog
	Log.Caller = self
	Log.FileName = "Climate"
	ModeValue = ModeNone
	LocationCurrent = new LocationData
	TransitionCurrent = new TransitionData
	WeatherCurrent = new WeatherData
EndEvent


Event OnEnable()
	RegisterForRemoteEvent(Player, "OnLocationChange")
	RegisterForRemoteEvent(SanctuaryHillsLocation, "OnLocationLoaded")
	RegisterForRemoteEvent(GoodneighborLocation, "OnLocationLoaded")
	RegisterForRemoteEvent(DiamondCityLocation, "OnLocationLoaded")
EndEvent


Event OnDisable()
	UnregisterForRemoteEvent(Player, "OnLocationChange")
	UnregisterForRemoteEvent(SanctuaryHillsLocation, "OnLocationLoaded")
	UnregisterForRemoteEvent(GoodneighborLocation, "OnLocationLoaded")
	UnregisterForRemoteEvent(DiamondCityLocation, "OnLocationLoaded")
EndEvent


; Methods
;---------------------------------------------

State ActiveState
	Event OnBeginState(string asOldState)
		WriteLine(Log, "Beginning the '"+ActiveState+"' state from the '"+asOldState+"' state.")
		LocationCurrent = new LocationData
		WeatherCurrent = new WeatherData
		StartTimer(UpdateInterval, UpdateTimer)
	EndEvent


	Event OnPlayerTeleport()
		Evaluate()
	EndEvent


	Event Actor.OnLocationChange(Actor akSender, Location akOldLoc, Location akNewLoc)
		Evaluate()
	EndEvent


	Event Location.OnLocationLoaded(Location akSender)
		If (akSender == SanctuaryHillsLocation)
			Weather.ReleaseOverride()
		ElseIf (akSender == GoodneighborLocation)
			Weather.ReleaseOverride()
		ElseIf (akSender == DiamondCityLocation)
			Weather.ReleaseOverride()
		Else
			return
		EndIf
		WriteLine(Log, "Releasing weather override.")
	EndEvent


	Event OnTimer(int aiTimerID)
		If (aiTimerID == UpdateTimer)
			Evaluate()
			StartTimer(UpdateInterval, UpdateTimer)
		EndIf
	EndEvent


	Event OnEndState(string asNewState)
		WriteLine(Log, "Ending the '"+ActiveState+"' state for the '"+asNewState+"' state.")

		WeatherCurrent = new WeatherData
		LocationCurrent = new LocationData

		CancelTimer(UpdateTimer)
	EndEvent
EndState


State ChangingState
	Event OnBeginState(string asOldState)
		WriteLine(Log, "Beginning the '"+ChangingState+"' state from the '"+asOldState+"' state.")
		TransitionCurrent = new TransitionData
	EndEvent


	Event Actor.OnLocationChange(Actor akSender, Location akOldLoc, Location akNewLoc)
		Evaluate()
	EndEvent


	Event OnPlayerTeleport()
		Evaluate()
	EndEvent


	Event OnTimer(int aiTimerID)
		If (aiTimerID == TransitionTimer)
			float fTransition = Weather.GetCurrentWeatherTransition()

			If (fTransition == TransitionCompleted)

				If (WeatherChanged())
					WriteLine(Log, "The weather transition has completed.")
					GotoState(ActiveState)
					return
				EndIf

			ElseIf (fTransition > TransitionCurrent.Completion)
				TransitionCurrent.Completion = fTransition
				SendCustomEvent("OnWeatherTransition")
			EndIf

			StartTimer(TransitionInterval, TransitionTimer)
		EndIf
	EndEvent


	Event OnEndState(string asNewState)
		WriteLine(Log, "Ending the '"+ChangingState+"' state for the '"+asNewState+"' state.")
		TransitionCurrent = new TransitionData
	EndEvent
EndState


Event Actor.OnLocationChange(Actor akSender, Location akOldLoc, Location akNewLoc)
	{EMPTY}
EndEvent


Event Location.OnLocationLoaded(Location akSender)
	{EMPTY}
EndEvent


; Functions
;---------------------------------------------

Function Evaluate()
	If (LocationChanged())
		WriteLine(Log, "Evaluated a location change.")
		 If (IsInSpecialArea == false)
		 	If (Mode == ModeLite)
		 		Metro_World_DustyLiteWeather.SetActive()
		 		WriteLine(Log, "Setting weather to dusty lite.")
		 	ElseIf (Mode == ModeHeavy)
		 		Metro_World_DustyHeavyWeather.SetActive()
		 		WriteLine(Log, "Setting weather to dusty heavy.")
		 	EndIf
		 EndIf
	EndIf
	If (WeatherChanged())
		WriteLine(Log, "Evaluated a weather change.")
	EndIf
EndFunction


bool Function LocationChanged()
	Location kLocation = Player.GetCurrentLocation()
	If (kLocation)
		If (kLocation != LocationCurrent.Object)
			LocationCurrent.Object = kLocation
			LocationCurrent.World = Player.GetWorldSpace()
			SendCustomEvent("OnLocationChanged")
			;CGShockWaveOnDustStorm()
			return true
		Else
			WriteLine(Log, "Ignoring, no changes to the current location.")
			return false
		EndIf
	Else
		WriteLine(Log, "Ignoring, the current location is none.")
		return false
	EndIf
EndFunction


bool Function WeatherChanged()
	Weather kWeather = Weather.GetCurrentWeather()
	If (kWeather)
		If (kWeather != WeatherCurrent.Object)
			WeatherCurrent.Object = kWeather
			WeatherCurrent.Classification = kWeather.GetClassification()
			If WeatherDatabase.Contains(WeatherCurrent.Object)
				WeatherCurrent.TypeClass = WeatherDatabase.GetClassification(WeatherCurrent.Object)
				If WeatherCurrent.TypeClass == 0
					WriteLine(Log, "New weather is Snow.")
				ElseIf WeatherCurrent.TypeClass == 1
					WriteLine(Log, "New weather is DustStorm.")
					;CGShockWaveOnDustStorm()
				EndIf
			Else
				WeatherCurrent.TypeClass = -1
			EndIf
			SendCustomEvent("OnWeatherChanged")
			return true
		Else
			WriteLine(Log, "Ignoring, no changes to the current weather.")
			return false
		EndIf
	Else
		WriteLine(Log, "Ignoring, the current weather is none.")
		return false
	EndIf
EndFunction

; Function CGShockWaveOnDustStorm()
	; ObjectReference CGNukeShockwave = Player.PlaceAtMe(CGNukeShockwaveProp)
	; float X
	; float Y
	; float Z
	; X = Player.GetPositionX()
	; Y = Player.GetPositionY()
	; Z = Player.GetPositionZ()
	; CGNukeShockwave.MoveTo(Player)
	; CGNukeShockwave.SplineTranslateTo(X + 2000.0, Y + 2000.0, Z, 0.0, 0.0, 0.0, afTangentMagnitude = 1.0, afSpeed = 66.0, afMaxRotationSpeed = 10.0)
	; CGNukeShockwave.PlayGamebryoAnimation("WaveMoving",true,3.0)
; EndFunction

; Properties
;---------------------------------------------

Group Context
	Metro:World:WeatherDatabase Property WeatherDatabase Auto Const Mandatory
	Form Property CGNukeShockwaveProp Auto Const Mandatory
EndGroup

Group Modes
	int Property ModeNone = 4 AutoReadOnly
	int Property ModeLite = 2 AutoReadOnly
	int Property ModeHeavy = 3 AutoReadOnly

	int Property Mode Hidden
		int Function Get()
			return ModeValue
		EndFunction
		Function Set(int value)
			If (value == ModeNone || value == ModeLite || value == ModeHeavy)
				ModeValue = value
			Else
				WriteLine(Log, "Ignoring invalid mode flag of value '"+value+"'.")
			EndIf
		EndFunction
	EndProperty
EndGroup


Group Location
	Location Property DiamondCityLocation Auto Const Mandatory
	Location Property GoodneighborLocation Auto Const Mandatory
	Location Property SanctuaryHillsLocation Auto Const Mandatory

	bool Property IsOutside Hidden
		bool Function Get()
			return Player.IsInInterior() == false
		EndFunction
	EndProperty

	bool Property IsInSpecialArea Hidden
		bool Function Get()
			return LocationCurrent.Object \
			&& LocationCurrent.Object == DiamondCityLocation \
			|| LocationCurrent.Object == GoodneighborLocation \
			|| LocationCurrent.Object == SanctuaryHillsLocation
		EndFunction
	EndProperty
EndGroup


Group Weather
	Weather Property Metro_World_DustyHeavyWeather Auto Const Mandatory
	Weather Property Metro_World_DustyLiteWeather Auto Const Mandatory
	Weather Property Metro_World_DustyCityWeather Auto Const Mandatory

	int Property WeatherClassNone = -1 AutoReadOnly
	int Property WeatherClassPleasant = 0 AutoReadOnly
	int Property WeatherClassCloudy = 1 AutoReadOnly
	int Property WeatherClassRainy = 2 AutoReadOnly
	int Property WeatherClassSnow = 3 AutoReadOnly


	bool Property WeatherBad Hidden
		bool Function Get()
			If (WeatherCurrent.Object)
				int iWeatherClass = WeatherCurrent.Object.GetClassification()
				int iPleasant = 0 const
				int iCloudy = 1 const
				int iRainy = 2 const
				int iSnow = 3 const

				If (iWeatherClass == iRainy)
					return true
				ElseIf (iWeatherClass == iSnow)
					return true
				Else
					return false
				EndIf
			Else
				return false
			EndIf
		EndFunction
	EndProperty
	
	bool Property RadWeatherBad Hidden
		bool Function Get()
			If (WeatherCurrent.Object)
				int iWeatherClass = WeatherCurrent.Object.GetClassification()
				int iSnow = 3 const

				If (iWeatherClass == iSnow)
					return true
				Else
					return false
				EndIf
			Else
				return false
			EndIf
		EndFunction
	EndProperty


	float Property Transition Hidden
		float Function Get()
			return TransitionCurrent.Completion
		EndFunction
	EndProperty

	int Property Classification Hidden
		int Function Get()
			return WeatherCurrent.Classification
		EndFunction
	EndProperty
	
	int Property TypeClass Hidden
		int Function Get()
			return WeatherCurrent.TypeClass
		EndFunction
	EndProperty
EndGroup
