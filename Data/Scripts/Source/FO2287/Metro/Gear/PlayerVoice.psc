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
		PlayerVoice1st = GasMask_SOMDialoguePlayer2D
		PlayerVoice3rd = GasMask_SOMDialoguePlayer3D
	Else
		PlayerVoice1st = SOMDialoguePlayer2D
		PlayerVoice3rd = SOMDialoguePlayer3D
	EndIf
EndEvent

;Properties ----------------------------------------
Group Properties
	Gear:Mask Property Mask Auto Const Mandatory
	Form Property Player1stVoiceOutputModel_DO Auto Mandatory
	Form Property Player3rdVoiceOutputModel_DO Auto Mandatory
	Form Property GasMask_SOMDialoguePlayer2D Auto Const Mandatory
	Form Property GasMask_SOMDialoguePlayer3D Auto Const Mandatory
	Form Property SOMDialoguePlayer2D Auto Const Mandatory
	Form Property SOMDialoguePlayer3D Auto Const Mandatory
EndGroup

Group Properties

	Form Property PlayerVoice1st Hidden
		Form Function Get()
				return Player1stVoiceOutputModel_DO.Get()
		EndFunction
		Function Set(Form OutputModel)
				WriteLine(Log, "PlayerVoice: Mask.OnChanged")
				Player1stVoiceOutputModel_DO.Set(OutputModel)
		EndFunction
	EndProperty
	
	Form Property PlayerVoice3rd Hidden
		Form Function Get()
				return Player3rdVoiceOutputModel_DO.Get()
		EndFunction
		Function Set(Form OutputModel)
				Player3rdVoiceOutputModel_DO.Set(OutputModel)
		EndFunction
	EndProperty
	
