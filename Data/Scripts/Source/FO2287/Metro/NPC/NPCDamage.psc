Scriptname Metro:NPC:NPCDamage extends ActiveMagicEffect
{MGEF:GasMask_NPCDamageEffect}
import Metro
import Shared:Log
UserLog Log

Actor NPC
int UpdateTimer = 1
float UpdateInterval = 0.25

float In_target_radiation
float Exposure
float Target

Event OnInit()
	Log = new UserLog
	Log.Caller = self
	Log.FileName = "NPCDamage"
EndEvent


Event OnEffectStart(Actor akTarget, Actor akCaster)
	;RegisterForRemoteEvent(NPC, "OnItemAdded")
	;AddInventoryEventFilter(GasMask_List)
	Exposure = 0.0
	Target = 0.0
	NPC = akTarget
	If NPC != None
		WriteLine(Log, "NPC akTarget: "+ NPC)
		WriteLine(Log, "NPC akCaster: "+ akCaster)
		WriteLine(Log, "PerceptionCondition: "+ NPC.GetValue(PerceptionCondition))
		If(NPC.GetValue(PerceptionCondition) == 0)
			int random = Utility.RandomInt(1, 7)
			If random == 1
				GlassCrack_01.Play(NPC)
			ElseIf random == 2
				GlassCrack_02.Play(NPC)
			ElseIf random == 3
				GlassCrack_03.Play(NPC)
			ElseIf random == 4
				GlassCrack_04.Play(NPC)
			ElseIf random == 5
				GlassCrack_05.Play(NPC)
			ElseIf random == 6
				GlassCrack_06.Play(NPC)
			ElseIf random == 7
				GlassCrack_07.Play(NPC)
			EndIf
		EndIf
		If(IsRadioactive)
			In_target_radiation = 0
			If ((Climate.WeatherBad) && (Radiation.WeatherOnly)) || (Radiation.WeatherOnly == false && Radiation.RadWeatherOnly == false) || (Climate.RadWeatherBad && Radiation.RadWeatherOnly)
				In_target_radiation = GetMultiplier(Climate.Classification, true)
				WriteLine(Log, "NPC: In Target "+ In_target_radiation)
				Target = In_target_radiation
				NPC.AddKeyword(GasMask_Broken)
				;NPC.EvaluatePackage()
				While(Exposure < Target)
					If ((Exposure+2) < Target) && (Exposure > 6)
						Exposure += 2
						Metro_RadiationWasteland_2X.Cast(NPC, NPC)
					EndIf
					If (Exposure < Target)
						Metro_RadiationWasteland.Cast(NPC, NPC)
						Exposure += 1
					EndIf
					WriteLine(Log, "Exposure: "+ Exposure)
					Utility.Wait(UpdateInterval)
				EndWhile
			EndIf
		EndIf
	EndIf
EndEvent

Event ObjectReference.OnItemAdded(ObjectReference akItem, Form akBaseItem, int aiItemCount, ObjectReference akItemReference, ObjectReference akSourceContainer)
	NPC.ModValue(PerceptionCondition, 50.0)
	NPC.EquipItem(akBaseItem, true, true)
	NPC.RemoveKeyword(GasMask_Broken)
	;NPC.EvaluatePackage()
EndEvent

int Function GetMultiplier(int aiWeatherClass, bool abInWeather = true)
	If (aiWeatherClass == Climate.WeatherClassNone)
		return 0
	ElseIf (aiWeatherClass == Climate.WeatherClassPleasant)
		If (abInWeather)
			return Radiation.InMultiplierA + 5
		EndIf
	ElseIf (aiWeatherClass == Climate.WeatherClassCloudy)
		If (abInWeather)
			return Radiation.InMultiplierB
		EndIf
	ElseIf (aiWeatherClass == Climate.WeatherClassRainy)
		If (abInWeather)
			return Radiation.InMultiplierC
		EndIf
	ElseIf (aiWeatherClass == Climate.WeatherClassSnow)
		If (abInWeather)
			return Radiation.InMultiplierD
		EndIf
	Else
		; unknown weather class
		return 0
	EndIf
EndFunction

; Properties
;---------------------------------------------

Group Context
	World:Climate Property Climate Auto Const Mandatory
	Float Property HeadLimbValue Auto
	Sound Property GlassCrack_01 Auto
	Sound Property GlassCrack_02 Auto
	Sound Property GlassCrack_03 Auto
	Sound Property GlassCrack_04 Auto
	Sound Property GlassCrack_05 Auto
	Sound Property GlassCrack_06 Auto
	Sound Property GlassCrack_07 Auto
	ActorValue Property PerceptionCondition Auto
	Spell Property Metro_RadiationWasteland Auto Const Mandatory
	Spell Property Metro_RadiationWasteland_2X Auto Const Mandatory
	MagicEffect Property GasMask_AirFilter_SpellEffect Auto Const Mandatory
	Keyword Property ArmorTypePower Auto Const Mandatory
	Keyword Property GasMask_Broken Auto
	Gear:MaskWipe Property MaskWipe Auto Const Mandatory
	World:Radiation Property Radiation Auto Const Mandatory
	FormList Property GasMask_List Auto
	GlobalVariable Property GasMask_NPCDamage_Toggle Auto
EndGroup

bool Property IsRadioactive Hidden
		bool Function Get()
			If Radiation.NoRadiation == false
				If (NPC.IsInInterior() == false && NPC.WornHasKeyword(ArmorTypePower) == false && NPC.HasMagicEffect(GasMask_AirFilter_SpellEffect) == false )
					return true
				Else
					return false
				EndIf
			EndIf
		EndFunction
EndProperty

