Scriptname Metro:Gear:DetectInteriors extends Metro:Core:Optional
import Metro
import Metro:Gear
import Shared:Log

CustomEvent OnEnterInterior
CustomEvent OnExitInterior

UserLog Log

;-- Variables ---------------------------------------

float fTimer = 1.0
int iTimerID = 1
int iRadius = 520

; Events
;---------------------------------------------

Event OnInitialize()
	Log = new UserLog
	Log.Caller = self
	Log.FileName = "Environmental VFX"
EndEvent

Event OnEnable()
	WriteLine(Log, "Detect Interiors Initialized.")
	StartTimer(fTimer, iTimerID)
EndEvent


Event OnDisable()
	WriteLine(Log, "Detect Interiors Disabled.")
	CancelTimer(iTimerID)
EndEvent

;-- Functions ---------------------------------------

State ActiveState

	Event OnTimer(int aiTimerID)
		If (aiTimerID == iTimerID)
			If (Search())
				If(IsInFakeInterior == false)
					IsInFakeInterior = true
					SendCustomEvent("OnEnterInterior")
					WriteLine(Log, "Entered Fake Interior...")
				EndIf
			Else
				If(IsInFakeInterior)
					IsInFakeInterior = false
					SendCustomEvent("OnExitInterior")
					WriteLine(Log, "Exited Fake Interior...")
				EndIf
			EndIf
			StartTimer(fTimer, iTimerID)
		EndIf
	EndEvent
	
EndState

bool Function Search()
	ObjectReference[] FakeIntList
	FakeIntList = Player.FindAllReferencesOfType(GasMask_FakeInteriors as Form, iRadius as float)
	If (FakeIntList.length)
		return True
	Else
		return False
	EndIf
EndFunction
	
;-- Properties --------------------------------------
bool Property IsInFakeInterior Auto
FormList Property GasMask_FakeInteriors Auto Const

