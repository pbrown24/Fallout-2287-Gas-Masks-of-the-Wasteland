Scriptname Metro:Gear:GearWidget extends Metro:GUI:HUDWidget
{QUST:Metro_Gear}
import Metro
import Metro:Context
import Shared:Log

UserLog Log
Actor Player

int Command_UpdateCharge = 100 const
int Command_UpdateQuantity = 200 const

string Command_MaskStatus = "StatusMaskCommand" const
string Command_Status = "StatusCommand" const
string StatusNormal = "Normal" const
string StatusDegraded = "Degraded" const
string StatusConsumed = "Consumed" const
string StatusReplaced = "Replaced" const


; Events
;---------------------------------------------

Event OnInitialize()
	Log = GetLog(self)
	Log.FileName = "HUD"
	Player = Game.GetPlayer()
EndEvent


Event OnEnable()
	TryLoad()
	AddInventoryEventFilter(Metro_GearFilter)
	RegisterForRemoteEvent(Player,"OnPlayerLoadGame")
	RegisterForRemoteEvent(Player, "OnItemAdded")
	RegisterForRemoteEvent(Player, "OnItemRemoved")
	RegisterForCustomEvent(GearMaskHUDToggleOptions, "OnToggleChanged")
	RegisterForCustomEvent(GearMaskHUDOpacityOptions, "OnOpacityChanged")
	RegisterForCustomEvent(GearMaskHUDYOptions, "OnYChanged")
	RegisterForCustomEvent(GearMaskHUDXOptions, "OnXChanged")
	RegisterForCustomEvent(GearMaskHUDScaleYOptions, "OnScaleYChanged")
	RegisterForCustomEvent(GearMaskHUDScaleXOptions, "OnScaleXChanged")
	RegisterForCustomEvent(Mask, "OnChanged")
	RegisterForCustomEvent(ConditionDatabase, "OnStatusChanged")
	RegisterForCustomEvent(Filter, "OnDegraded")
	RegisterForCustomEvent(Filter, "OnConsumed")
	RegisterForCustomEvent(Filter, "OnReplaced")
EndEvent


Event OnDisable()
	Unload()
	RemoveAllInventoryEventFilters()
	UnregisterForRemoteEvent(Player,"OnPlayerLoadGame")
	UnregisterForRemoteEvent(Player, "OnItemAdded")
	UnregisterForRemoteEvent(Player, "OnItemRemoved")
	UnRegisterForCustomEvent(GearMaskHUDToggleOptions, "OnToggleChanged")
	UnRegisterForCustomEvent(GearMaskHUDOpacityOptions, "OnOpacityChanged")
	UnRegisterForCustomEvent(GearMaskHUDYOptions, "OnYChanged")
	UnRegisterForCustomEvent(GearMaskHUDXOptions, "OnXChanged")
	UnRegisterForCustomEvent(GearMaskHUDScaleYOptions, "OnScaleYChanged")
	UnRegisterForCustomEvent(GearMaskHUDScaleXOptions, "OnScaleXChanged")
	UnRegisterForCustomEvent(ConditionDatabase, "OnStatusChanged")
	UnregisterForCustomEvent(Mask, "OnChanged")
	UnregisterForCustomEvent(Filter, "OnDegraded")
	UnregisterForCustomEvent(Filter, "OnConsumed")
	UnregisterForCustomEvent(Filter, "OnReplaced")
EndEvent


Event OnWidgetLoaded()
	Update()
EndEvent
;Opacity ---------------------
Event Metro:Terminals:GearMaskHUDOpacityOptions.OnOpacityChanged(Terminals:GearMaskHUDOpacityOptions akSender, var[] arguments)
	Utility.wait(0.2)
	SetOpacityModify(OpacityVal)
EndEvent

;Scale ------------------------
Event Metro:Terminals:GearMaskHUDScaleXOptions.OnScaleXChanged(Terminals:GearMaskHUDScaleXOptions akSender, var[] arguments)
	Utility.wait(0.2)
	SetScaleModify(ScaleX, ScaleY)
EndEvent

Event Metro:Terminals:GearMaskHUDScaleYOptions.OnScaleYChanged(Terminals:GearMaskHUDScaleYOptions akSender, var[] arguments)
	Utility.wait(0.2)
	SetScaleModify(ScaleX, ScaleY)
EndEvent
;Position ----------------------
Event Metro:Terminals:GearMaskHUDXOptions.OnXChanged(Terminals:GearMaskHUDXOptions akSender, var[] arguments)
	Utility.wait(0.2)
	SetPositionModify(X, Y)
EndEvent

Event Metro:Terminals:GearMaskHUDYOptions.OnYChanged(Terminals:GearMaskHUDYOptions akSender, var[] arguments)
	Utility.wait(0.2)
	SetPositionModify(X, Y)
EndEvent
;Hud Toggle ----------------------
Event Metro:Terminals:GearMaskHUDToggleOptions.OnToggleChanged(Terminals:GearMaskHUDToggleOptions akSender, var[] arguments)
	Utility.wait(0.2)
	If HUDToggle == false
		HUDToggle = true
		If(TryLoad())
			WriteLine(Log, "Loaded widget.")
		EndIf
	Else
		If(Unload())
			WriteLine(Log, "Unloaded widget.")
		EndIf
		HUDToggle = false
	EndIf
	Debug.Notification("Gear Widget | HUD Toggle: " + HUDToggle)
EndEvent

Event Actor.OnPlayerLoadGame(Actor akActor)
	Utility.Wait(1.0)
	TryLoad()
EndEvent

Event Metro:Gear:Mask.OnChanged(Gear:Mask akSender, var[] arguments)
	If (TryLoad())
		WriteLine(Log, "Loaded widget for equipped mask.")
	Else
		If (Unload())
			WriteLine(Log, "Unloaded widget for unequipped mask.")
		EndIf
	EndIf
EndEvent


Event Metro:Gear:Filter.OnDegraded(Gear:Filter akSender,var[] arguments)
	SendText(Command_Status, StatusDegraded)
	Update()
	WriteLine(Log, "Updated widget for the filter degrade event.")
EndEvent


Event Metro:Gear:Filter.OnConsumed(Gear:Filter akSender,var[] arguments)
	SendText(Command_Status, StatusConsumed)
	Update()
	WriteLine(Log, "Updated widget for the filter consumed event.")
EndEvent


Event Metro:Gear:Filter.OnReplaced(Gear:Filter akSender, var[] arguments)
	SendText(Command_Status, StatusReplaced)
	Update()
	WriteLine(Log, "Updated widget for the filter replaced event.")
EndEvent

Event Metro:Gear:ConditionDatabase.OnStatusChanged(Gear:ConditionDatabase akSender, var[] arguments)
	Update()
	WriteLine(Log, "Updated widget for the mask status event.")
EndEvent


Event ObjectReference.OnItemAdded(ObjectReference akSender, Form akBaseItem, int aiItemCount, ObjectReference akItemReference, ObjectReference akSourceContainer)
	Update()
	WriteLine(Log, "Updated widget for added filter item.")
EndEvent


Event ObjectReference.OnItemRemoved(ObjectReference akSender, Form akBaseItem, int aiItemCount, ObjectReference akItemReference, ObjectReference akDestContainer)
	Update()
	WriteLine(Log, "Updated widget for added filter item.")
EndEvent


; Methods
;---------------------------------------------

WidgetData Function Create()
	WidgetData widget = new WidgetData
	widget.ID = "GearWidget.swf"
	widget.X = X
	widget.Y = Y
	return widget
EndFunction


; Functions
;---------------------------------------------

bool Function TryLoad()
	If (Mask.IsGasMask)
		If(HUDToggle)
			If (Load())
				Update()
				return true
			Else
				WriteLine(Log, "Could not try to load the widget.")
				return false
			EndIf
		Else
			WriteLine(Log, "Could not load the widget, it is toggled off.")
			return false
		EndIf
	Else
		WriteLine(Log, "Cannot load widget without an equipped gas mask.")
		return false
	EndIf
EndFunction


Function Update()
	SendNumber(Command_UpdateCharge, Filter.Charge)
	SendNumber(Command_UpdateQuantity, Filter.Quantity + Filter.UsedQuantity)
	sendText(Command_MaskStatus, ConditionDatabase.GetDamageStageName(Mask.Equipped))
EndFunction


; Properties
;---------------------------------------------

Group Context
	Terminals:GearMaskHUDXOptions Property GearMaskHUDXOptions Auto Const Mandatory
	Terminals:GearMaskHUDYOptions Property GearMaskHUDYOptions Auto Const Mandatory
	Terminals:GearMaskHUDScaleXOptions Property GearMaskHUDScaleXOptions Auto Const Mandatory
	Terminals:GearMaskHUDScaleYOptions Property GearMaskHUDScaleYOptions Auto Const Mandatory
	Terminals:GearMaskHUDOpacityOptions Property GearMaskHUDOpacityOptions Auto Const Mandatory
	Terminals:GearMaskHUDToggleOptions Property GearMaskHUDToggleOptions Auto Const Mandatory
	Gear:ConditionDatabase Property ConditionDatabase Auto Const Mandatory
	Gear:Mask Property Mask Auto Const Mandatory
	Gear:Filter Property Filter Auto Const Mandatory
;	World:Radiation Property Radiation Auto Const Mandatory
EndGroup

Group Properties
	float property OpacityVal = 1.0 Auto 
	float property ScaleX = 1.0 Auto
	float property ScaleY = 1.0 Auto
	int property X = 10 Auto
	int property Y = 10 Auto
	Potion Property Metro_GearFilter Auto Const Mandatory
	ActorValue Property Rads Auto Const Mandatory
	bool property HUDToggle Auto 
EndGroup
