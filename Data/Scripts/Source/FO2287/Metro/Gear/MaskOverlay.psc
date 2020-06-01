Scriptname Metro:Gear:MaskOverlay extends Metro:Core:Optional
{QUST:Metro_Gear}
import Metro
import Shared:Log

UserLog Log

ImageSpaceModifier IMOD
VisualEffect VFX
int IMOD_Strength = 1 const


; Events
;---------------------------------------------

Event OnInitialize()
	Log = new UserLog
	Log.Caller = self
	Log.FileName = "MaskOverlay"
	IMOD = Metro_GearOverlayIMOD
	VFX = Metro_GearOverlayVisual
EndEvent


Event OnEnable()
	RegisterForCustomEvent(Mask, "OnChanged")
	RegisterForCustomEvent(Camera, "OnChanged")
	OverlayToggle = true
EndEvent


Event OnDisable()
	UnregisterForCustomEvent(Mask, "OnChanged")
	UnregisterForCustomEvent(Camera, "OnChanged")
	OverlayToggle = false
EndEvent


; Methods
;---------------------------------------------

State ActiveState
	Event Metro:Player:Camera.OnChanged(Player:Camera akSender, var[] arguments)
		bool bFirstPerson = arguments[0]
		If (Mask.IsGasMask || (Mask.IsPowerArmor && GasMask_PAEnvironmentalVFX.GetValue() == 1.0))
			If (bFirstPerson)
				Apply()
				WriteLine(Log, "Applied overlay for first person camera.")
			Else
				Remove()
				WriteLine(Log, "Removed overlay for third person camera.")
			EndIf
		EndIf
	EndEvent


	Event Metro:Gear:Mask.OnChanged(Gear:Mask akSender, var[] arguments)
		If (Mask.IsGasMask || (Mask.IsPowerArmor && GasMask_PAEnvironmentalVFX.GetValue() == 1.0))
			ConditionDatabase.SetCurrentOverlay(Mask.Equipped)
			Utility.Wait(1.3)
			Game.ForceFirstPerson()
			Apply()
			WriteLine(Log, "Applied overlay for equipped mask.")
		Else
			Utility.Wait(0.5)
			Remove()
			WriteLine(Log, "Removed overlay for unequipped mask.")
		EndIf
	EndEvent


	Event OnEndState(string asNewState)
		Remove()
		WriteLine(Log, "Removed overlay for end of state.")
	EndEvent
EndState


Event Metro:Gear:Mask.OnChanged(Gear:Mask akSender, var[] arguments)
	{EMPTY}
EndEvent


Event Metro:Player:Camera.OnChanged(Player:Camera akSender, var[] arguments)
	{EMPTY}
EndEvent


; Properties
;---------------------------------------------
Function Apply()
	If (IsReady && (Mask.IsGasMask || (Mask.IsPowerArmor && GasMask_PAEnvironmentalVFX.GetValue() == 1.0)))
		If IsFirstPerson
			If ImageSpace != None
				ImageSpace.Apply(IMOD_Strength)
			EndIf
			If OverlayToggle
				If VFX != None
					VFX.Stop(Game.GetPlayer())
					VFX.Play(Game.GetPlayer())
				EndIf
				WriteLine(Log, "Applied the mask overlay.")
			Else
				VFX.Stop(Game.GetPlayer())
			EndIf
			WriteLine(Log, "mask overlay toggled off.")
		Else
			WriteLine(Log, "The mask overlay is not ready to apply.")
		EndIf
	Else
		WriteLine(Log, "The mask overlay is not ready to apply.")
	EndIf
EndFunction


Function Remove()
	If ImageSpace != None
		ImageSpace.Remove()
	Endif
	VFX.Stop(Game.GetPlayer())
	WriteLine(Log, "Removed the mask overlay.")
EndFunction

Function RemoveVFX()
	VFX.Stop(Game.GetPlayer())
EndFunction

Function RemoveIMod()
	If ImageSpace != None
		ImageSpace.Remove()
	Endif
EndFunction


; Properties
;---------------------------------------------

Group Context
	Gear:ConditionDatabase Property ConditionDatabase Auto Const Mandatory
	Gear:Mask Property Mask Auto Const Mandatory
	Player:Camera Property Camera Auto Const Mandatory
EndGroup

Group Properties
	ImageSpaceModifier Property Metro_GearOverlayIMOD Auto Const
	VisualEffect Property Metro_GearOverlayVisual Auto Mandatory
	GlobalVariable Property GasMask_PAEnvironmentalVFX Auto
EndGroup

Group Camera
	bool Property IsFirstPerson Hidden
		bool Function Get()
			return Camera.IsFirstPerson
		EndFunction
	EndProperty
EndGroup

Group Overlays
	bool property OverlayToggle Auto
	
	ImageSpaceModifier Property ImageSpace Hidden ; The terminal uses the public setter
		ImageSpaceModifier Function Get()
			return IMOD
		EndFunction
		Function Set(ImageSpaceModifier value)
			If (value)
				If (IMOD != value)
					WriteChangedValue(Log, "ImageSpace", IMOD, value)
					IMOD.Remove()
					IMOD = value
				Else
					WriteLine(Log, "The mask overlay already equals "+value)
				EndIf
			Else
				WriteLine(Log, "Ignoring none overlay ImageSpace." )
				RemoveIMod()
				IMOD = none
			EndIf
		EndFunction
	EndProperty
	
	VisualEffect Property VisualFX Hidden ; The terminal uses the public setter
		VisualEffect Function Get()
			return VFX
		EndFunction
		
		Function Set(VisualEffect value)
			If (value)
				If (VFX != value)
					WriteChangedValue(Log, "Visual Effect", VFX, value)
					VFX.Stop(Player)
					VFX = value
				Else
					WriteLine(Log, "The mask overlay already equals "+value)
				EndIf
			Else
				WriteLine(Log, "Ignoring none overlay VisualEffect." )
			EndIf
		EndFunction
	EndProperty
EndGroup
