Scriptname CoU_HolotapeEntriesScript extends Quest

Int Property CoU_Message_Unlock Auto
Message Property CoU_NewEntryUnlocked_Message Auto

Function Increment()
	CoU_Message_Unlock += 1
	CoU_NewEntryUnlocked_Message.Show()
EndFunction
