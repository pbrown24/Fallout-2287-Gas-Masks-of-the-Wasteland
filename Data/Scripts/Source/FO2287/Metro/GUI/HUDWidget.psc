Scriptname Metro:GUI:HUDWidget extends Metro:GUI:HUD Hidden
import Metro:Context
import Shared:Compatibility
import Shared:Log
import Shared:Papyrus

UserLog Log

HUDFramework HUD
WidgetData Widget

Struct WidgetData
	string ID = "I_Forgot_To_Set_A_Widget_ID"
	{The path to your widget's SWF file. The root directory is WidgetData\Interface.}

	bool LoadNow = false
	{Load the widget immediately after registration. (default: false)}

	bool AutoLoad = false
	{Automatically load the widget whenever the game starts. (default: false)}

	int X = 0
	{The X axis coordinates to position the HUD widget.}

	int Y = 0
	{The Y axis coordinates to position the HUD widget.}

	float ScaleX = 1.0
	{The X axis scaling to transform the HUD widget.}

	float ScaleY = 1.0
	{The Y axis scaling to transform the HUD widget.}

	float Opacity = 1.0
	{The new opacity of the HUD widget. Ranges from 0 to 1.}
EndStruct


; Events
;---------------------------------------------

Event OnInit()
	Log = GetLog(self)
	Log.FileName = "HUD"
	Widget()
	parent.OnInit()
EndEvent


Event Metro:Context.OnStartup(Metro:Context akSender, var[] arguments)
	If (WidgetRegister(HUD, Widget, self))
		self.OnEnable()
		WriteLine(Log, "The widget has enabled with the 'OnStartup' event.")
	EndIf
EndEvent


Event Metro:Context.OnShutdown(Metro:Context akSender, var[] arguments)
	If (WidgetUnregister(HUD, Widget))
		self.OnDisable()
		WriteLine(GetLog(self), "The widget has disabled with the 'OnShutdown' event.")
	EndIf
EndEvent


Event Metro:Context.OnUpgrade(Metro:Context akSender, var[] arguments)
	Version newVersion = arguments[0] as Version
	Version oldVersion = arguments[1] as Version
	Widget()
	self.OnUpgrade(newVersion, oldVersion)
	WriteLine(GetLog(self), "The widget has upgraded to version '"+VersionToString(newVersion)+"' from '"+VersionToString(oldVersion)+"' with the 'OnUpgrade' event.")
EndEvent


; Methods
;---------------------------------------------

; @HudFramework
Function HUD_WidgetLoaded(string asWidgetID)
	If (asWidgetID == Widget.ID)
		self.OnWidgetLoaded()
		WriteLine(Log, "HUD Framework has loaded the '"+asWidgetID+"' widget.")
	EndIf
EndFunction


; Functions
;---------------------------------------------

Function Widget()
	HUDFramework framework = HUDFramework.GetInstance()
	If (framework)
		HUD = framework

		WidgetData created = Create()
		If (created)
			Widget = created
			WriteLine(Log, "The '"+WidgetToString(created)+"' widget was created.")
		Else
			WriteLine(Log, "The created widget is equal to none.")
		EndIf
	Else
		WriteLine(Log, "Could not get and instance to the HUD Framework.")
	EndIf
EndFunction


bool Function Load()
	return WidgetLoad(HUD, Widget)
EndFunction


bool Function Unload()
	return WidgetUnload(HUD, Widget)
EndFunction


Function PositionModify(Point aPosition)
	If (IsLoaded)
		HUD.ModWidgetPosition(Widget.ID, aPosition.X, aPosition.Y)
	EndIf
EndFunction

Function ScaleModify(Point aScale)
	If (IsLoaded)
		HUD.ModWidgetScale(Widget.ID, aScale.X, aScale.Y)
	EndIf
EndFunction

Function SetPositionModify(float X, float Y)
	If (IsLoaded)
		HUD.SetWidgetPosition(Widget.ID, X, Y)
	EndIf
EndFunction

Function SetScaleModify(float ModScaleX, float ModScaleY)
	If (IsLoaded)
		HUD.SetWidgetScale(Widget.ID, ModScaleX, ModScaleY)
	EndIf
EndFunction

Function SetOpacityModify(float aValue)
	If (IsLoaded)
		HUD.SetWidgetOpacity(Widget.ID, aValue)
	EndIf
EndFunction

Function SendNumber(int aiCommand, float afArgument)
	If (IsLoaded)
		If (aiCommand != -1)
			HUD.SendMessage(Widget.ID, aiCommand, afArgument)
			WriteLine(Log, "Sent the '"+aiCommand+"' number command with the '"+afArgument+"' argument.")
		Else
			WriteLine(Log, "Cannot send an invalid '-1' number command.")
		EndIf
	EndIf
EndFunction


Function SendText(string asCommand, string asArgument)
	If (IsLoaded)
		If (asCommand)
			HUD.SendMessageString(Widget.ID, asCommand, asArgument)
			WriteLine(Log, "Sent the '"+asCommand+"' text command with the '"+asArgument+"' argument.")
		Else
			WriteLine(Log, "Cannot send a none string command.")
		EndIf
	EndIf
EndFunction


Function SendCustom(Message akMessage)
	If (IsLoaded)
		If (akMessage)
			HUD.SendCustomMessage(akMessage)
			WriteLine(Log, "Sent the '"+akMessage+"' custom message form.")
		Else
			WriteLine(Log, "Cannot send a none Message form.")
		EndIf
	EndIf
EndFunction


Function AS3(string asExpression)
	If (IsReady)
		If (StringIsNoneOrEmpty(asExpression))
			HUD.Eval(asExpression)
			WriteLine(Log, "Sent the AS3 expression '"+asExpression+"' to the HUD.")
		Else
			WriteLine(Log, "Cannot evaluate a none or empty AS3 expression.")
		EndIf
	EndIf
EndFunction


; Globals
;---------------------------------------------

bool Function WidgetRegister(HudFramework aFramework, WidgetData aWidget, HUDWidget aHUDWidget) Global
	If (aFramework)
		aFramework.RegisterWidget(aHUDWidget, aWidget.ID, aWidget.X, aWidget.Y, aWidget.LoadNow, aWidget.AutoLoad)
		If (aFramework.IsWidgetRegistered(aWidget.ID))
			return true
		Else
			Write("HUD", "HUD Framework could not register the '"+aWidget.ID+"' widget.")
			return false
		EndIf
	Else
		Write("HUD", "HUD Framework is none, cannot register the '"+aWidget.ID+"' widget.")
		return false
	EndIf
EndFunction


bool Function WidgetUnregister(HudFramework aFramework, WidgetData aWidget) Global
	If (aFramework)
		aFramework.UnregisterWidget(aWidget.ID)
		If !(aFramework.IsWidgetRegistered(aWidget.ID))
			return true
		Else
			Write("HUD", "HUD Framework could not unregister the '"+aWidget.ID+"' widget.")
			return false
		EndIf
	Else
		Write("HUD", "HUD Framework is none, cannot unregister the '"+aWidget.ID+"' widget.")
		return false
	EndIf
EndFunction


bool Function WidgetLoad(HudFramework aFramework, WidgetData aWidget) Global
	If (aFramework)
		If (aFramework.IsWidgetRegistered(aWidget.ID))
			aFramework.LoadWidget(aWidget.ID)
			If (aFramework.IsWidgetLoaded(aWidget.ID))
				return true
			Else
				Write("HUD", "HUD Framework could not load the '"+aWidget.ID+"' widget.")
				return false
			EndIf
		Else
			Write("HUD", "HUD Framework cannot load the '"+aWidget.ID+"' widget without registering first.")
			return false
		EndIf
	Else
		Write("HUD", "HUD Framework is none, cannot load the '"+aWidget.ID+"' widget.")
		return false
	EndIf
EndFunction


bool Function WidgetUnload(HudFramework aFramework, WidgetData aWidget) Global
	If (aFramework)
		If (aFramework.IsWidgetRegistered(aWidget.ID))
			aFramework.UnloadWidget(aWidget.ID)
			If !(aFramework.IsWidgetLoaded(aWidget.ID))
				return true
			Else
				Write("HUD", "HUD Framework could not unload the '"+aWidget.ID+"' widget.")
				return false
			EndIf
		Else
			Write("HUD", "HUD Framework cannot unload the '"+aWidget.ID+"' widget without registering first.")
			return false
		EndIf
	Else
		Write("HUD", "HUD Framework is none, cannot unload the '"+aWidget.ID+"' widget.")
		return false
	EndIf
EndFunction


string Function WidgetToString(WidgetData value) Global
	string sPosition = "X:"+value.X+"|"+value.ScaleX+", "+"Y:"+value.Y+"|"+value.ScaleY
	string sOpacity = "%"+value.Opacity
	return value.ID+" ["+sPosition+", "+sOpacity+"]"
EndFunction


; Virtual
;---------------------------------------------

WidgetData Function Create()
	{VIRTUAL}
	WriteLine(Log, "The widget has not implemented the virtual 'Create' method.")
	return new WidgetData
EndFunction


; Properties
;---------------------------------------------

Group Context
	Metro:Context Property Context Auto Const Mandatory
EndGroup


Group Widget
	bool Property IsReady Hidden
		bool Function Get()
			If (HUD)
				If (HUD.IsWidgetRegistered(Widget.ID))
					return true
				Else
					WriteLine(Log, "The '"+Widget.ID+"' widget is not ready, must register with HUD Framework.")
					return false
				EndIf
			Else
				WriteLine(Log, "The '"+Widget.ID+"' widget is not ready, HUD Framework is none.")
				return false
			EndIf
		EndFunction
	EndProperty


	bool Property IsLoaded Hidden
		bool Function Get()
			If (IsReady)
				If (Hud.IsWidgetLoaded(Widget.ID))
					return true
				Else
					WriteLine(Log, "The widget '"+Widget.ID+"' is not loaded right now.")
					return false
				EndIf
			Else
				WriteLine(Log, "The '"+Widget.ID+"' widget is not loaded, HUD Framework is none.")
				return false
			EndIf
		EndFunction
	EndProperty


	Point Property Position Hidden
		Point Function Get()
			float[] array = HUD.GetWidgetPosition(Widget.ID)
			Point value = new Point
			value.X = array[0]
			value.Y = array[1]
			return value
		EndFunction
		Function Set(Point aValue)
			HUD.SetWidgetPosition(Widget.ID, aValue.X, aValue.Y)
		EndFunction
	EndProperty


	Point Property Scale Hidden
		Point Function Get()
			float[] array = HUD.GetWidgetScale(Widget.ID)
			Point value = new Point
			value.X = array[0]
			value.Y = array[1]
			return value
		EndFunction
		Function Set(Point aValue)
			HUD.SetWidgetScale(Widget.ID, aValue.X, aValue.Y)
		EndFunction
	EndProperty


	float Property Opacity Hidden
		float Function Get()
			return HUD.GetWidgetOpacity(Widget.ID)
		EndFunction
		Function Set(float aValue)
			HUD.SetWidgetOpacity(Widget.ID, aValue)
		EndFunction
	EndProperty
EndGroup
