Scriptname Metro:Gear:PlayerDamage extends Metro:Core:Optional
{QUST:Metro_Gear}
import Metro
import Shared:Log
UserLog Log

Float PlayerHealth

Event OnInitialize()
	Log = new UserLog
	Log.Caller = self
	Log.FileName = "PlayerDamage"
	WriteLine(Log, "PlayerDamage Initialized.")
EndEvent

Event OnEnable()
	WriteLine(Log, "PlayerDamage Initialized.")
	PlayerHealth = Player.GetValue(Health)
	RegisterForCustomEvent(Mask,"OnChanged")
	RegisterForCustomEvent(GearPlayerDamageToggle,"OnChanged")
	InitializeStart()
EndEvent


Event OnDisable()
	WriteLine(Log, "PlayerDamage Disabled.")
	UnRegisterForCustomEvent(Mask,"OnChanged")
	UnRegisterForAllHitEvents(Player)
	GoToState("")
EndEvent

Event Metro:Terminals:GearPlayerDamageToggle.OnChanged(Terminals:GearPlayerDamageToggle akSender, var[] arguments)
	InitializeStart()
EndEvent

State ActiveState
	
	Event OnBeginState(String asOldState)
		If Mask.IsGasMask
			If ConditionDatabase.Contains(Mask.Equipped)
				WriteLine(Log, "PlayerDamage: Mask in Database | Current: " + GasMask_MaskPercentage.GetValueInt() + "%")
				ConditionDatabase.SetCurrentPercentage(Mask.Equipped)
			Else
				WriteLine(Log, "PlayerDamage: Mask NOT in Database adding mask")
				ConditionDatabase.AddMask(Mask.Equipped)
			EndIf
			RegisterForHitEvents()
			Radiation.CalcRadiation()
		EndIf
	EndEvent

	Event Metro:Gear:Mask.OnChanged(Gear:Mask akSender, var[] arguments)
		WriteLine(Log, "PlayerDamage: Mask.OnChanged")
		Utility.wait(0.2)
		If Mask.IsGasMask && GasMask_PlayerDamage_Toggle.GetValueInt() == 1
			If ConditionDatabase.Contains(Mask.Equipped)
				WriteLine(Log, "PlayerDamage: Mask in Database | Current: " + GasMask_MaskPercentage.GetValueInt() + "%")
				ConditionDatabase.SetCurrentPercentage(Mask.Equipped)
			Else
				WriteLine(Log, "PlayerDamage: Mask NOT in Database adding mask")
				ConditionDatabase.AddMask(Mask.Equipped)
			EndIf
			RegisterForHitEvents()
			Radiation.CalcRadiation()
		Else
			GasMask_MaskPercentage.SetValueInt(100)
			UnRegisterForAllHitEvents(Player)
			WriteLine(Log, "PlayerDamage: Removed mask, unregistering hit events")
		EndIf
	EndEvent

	Event OnHit(ObjectReference akTarget, ObjectReference akAggressor, Form akSource, Projectile akProjectile, bool abPowerAttack, bool abSneakAttack, bool abBashAttack, bool abHitBlocked, string apMaterial)
		int Old = GasMask_MaskPercentage.GetValueInt()
		int Current = Old
		If Old > 0
			WriteLine(Log, "akSource = " + akSource + " | akProjectile = " + akProjectile)
			If GasMask_VeryHighDamage.HasForm(akSource) || GasMask_VeryHighDamage.HasForm(akProjectile)
				Current = Current - 20
			ElseIf GasMask_HighDamage.HasForm(akSource) || GasMask_HighDamage.HasForm(akProjectile)
				Current = Current - 10
			ElseIf GasMask_MediumDamage.HasForm(akSource) || GasMask_MediumDamage.HasForm(akProjectile)
				Current = Current - 4
			ElseIf GasMask_LowDamage.HasForm(akSource) || GasMask_LowDamage.HasForm(akProjectile)
				Current = Current - 2
			ElseIf  GasMask_NoDamage.HasForm(akSource) || GasMask_NoDamage.HasForm(akProjectile)
				;Do Nothing
			ElseIf PlayerHealth > Player.GetValue(Health)
				PlayerHealth = Player.GetValue(Health)
				Current = Current - 1
			EndIf
			;If the new percentage is less than 0, set it to 0
			If Current < 0
				Current = 0
				GasMask_MaskPercentage.SetValueInt(0)
			Else
				GasMask_MaskPercentage.SetValueInt(Current)
			EndIf
			ConditionDatabase.SetNewPercentage(Mask.Equipped,Current,Old)
			;Debug.Notification("Current: " + GasMask_MaskPercentage.GetValueInt())
			WriteLine(Log, "Mask: " + Mask.Equipped +  " | " + GasMask_MaskPercentage.GetValueInt() + "%")
			Utility.Wait(0.1)
			RegisterForHitEvents()
		Else ;Maybe?
			Utility.Wait(0.2)
			RegisterForHitEvents()
		EndIf
	EndEvent
	
EndState

Event Metro:Gear:Mask.OnChanged(Gear:Mask akSender, var[] arguments)
	{EMPTY}
EndEvent

Event OnHit(ObjectReference akTarget, ObjectReference akAggressor, Form akSource, Projectile akProjectile, bool abPowerAttack, bool abSneakAttack, bool abBashAttack, bool abHitBlocked, string apMaterial)
	{EMPTY}
EndEvent

; Functions
;--------------------------------------------

Function RegisterForHitEvents()
	RegisterForHitEvent(Player, akAggressorFilter = None, akSourceFilter = None, akProjectileFilter = None, aiPowerFilter = -1, aiSneakFilter = -1, aiBashFilter = -1, aiBlockFilter = 0, abMatch = true)
EndFunction

Function InitializeStart()
	If GasMask_PlayerDamage_Toggle.GetValueInt() == 1
		WriteLine(Log, "PlayerDamage: Player Damage Toggle Changed: " + GasMask_PlayerDamage_Toggle.GetValueInt())
		RegisterForCustomEvent(Mask,"OnChanged")
		GoToState("ActiveState")
	Else
		GasMask_MaskPercentage.SetValueInt(100)
		Radiation.CalcRadiation()
		UnRegisterForAllHitEvents(Player)
		UnRegisterForCustomEvent(Mask,"OnChanged")
		GoToState("")
	EndIf
EndFunction


; Properties
;---------------------------------------------

Group Context
	ActorValue Property PerceptionCondition Auto
	ActorValue Property Health Auto
	Keyword Property ArmorTypePower Auto Const Mandatory
	Keyword Property GasMask_Broken Auto
	Gear:Mask Property Mask Auto Const Mandatory
	Gear:MaskWipe Property MaskWipe Auto Const Mandatory
	Gear:ConditionDatabase Property ConditionDatabase Auto Const Mandatory
	Terminals:GearPlayerDamageToggle Property GearPlayerDamageToggle Auto Const Mandatory
	World:Radiation Property Radiation Auto Const Mandatory
	FormList Property GasMask_List Auto
	GlobalVariable Property GasMask_PlayerDamage_Toggle Auto
	GlobalVariable Property GasMask_MaskPercentage Auto
	
	FormList Property GasMask_NoDamage Auto Const
	FormList Property GasMask_LowDamage Auto Const
	FormList Property GasMask_MediumDamage Auto Const
	FormList Property GasMask_HighDamage Auto Const
	FormList Property GasMask_VeryHighDamage Auto Const
EndGroup
