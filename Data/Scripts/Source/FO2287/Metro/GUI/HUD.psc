Scriptname Metro:GUI:HUD extends Metro:Core:Module Native Const Hidden
import Shared:Log


; Virtual
;---------------------------------------------

Event OnWidgetLoaded()
	{VIRTUAL}
	Write("HUD", "The widget has not implemented the virtual 'OnWidgetLoaded' event.")
EndEvent
