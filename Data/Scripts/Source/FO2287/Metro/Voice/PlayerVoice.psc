ScriptName Metro:Voice:PlayerVoice extends Metro:Core:Required
import DefaultObject
import Metro
import Shared:Log

UserLog Log

Event OnInitialize()
	Log = new UserLog
	Log.Caller = self
	Log.FileName = "PlayerVoice"
EndEvent

Event OnEnable()
	RegisterForCustomEvent(Mask, "OnChanged")
EndEvent


Event OnDisable()
	UnregisterForCustomEvent(Mask, "OnChanged")
EndEvent

Event Metro:Gear:Mask.OnChanged(Gear:Mask akSender, var[] arguments)
	WriteLine(Log, "PlayerVoice: Mask.OnChanged")
	If (Mask.IsGasMask && Mask.IsPowerArmor == false)
		Player1stVoiceOutputModel_DO.Set(GasMask_SOMDialoguePlayer2D)
		Player3rdVoiceOutputModel_DO.Set(GasMask_SOMDialoguePlayer3D)
		WriteLine(Log, "Voice set to Gas Mask: " + Player1stVoiceOutputModel_DO.Get())
	Else
		Player1stVoiceOutputModel_DO.Set(SOMDialoguePlayer2D)
		Player3rdVoiceOutputModel_DO.Set(SOMDialoguePlayer3D)
		WriteLine(Log, "Voice set to Default: " + Player1stVoiceOutputModel_DO.Get())
	EndIf
EndEvent

;Properties ----------------------------------------
Group Properties
	Gear:Mask Property Mask Auto Const Mandatory
	OutputModel Property GasMask_SOMDialoguePlayer2D Auto Const Mandatory
	OutputModel Property GasMask_SOMDialoguePlayer3D Auto Const Mandatory
	OutputModel Property SOMDialoguePlayer2D Auto
	OutputModel Property SOMDialoguePlayer3D Auto
	DefaultObject Property Player1stVoiceOutputModel_DO Auto
	DefaultObject Property Player3rdVoiceOutputModel_DO Auto
EndGroup
