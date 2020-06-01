Scriptname CoU_IncrementActivationScript extends Objectreference
{Used to call Increment on CoU_HolotapeEntriesScript to make new holotape entries available.}

CoU_HolotapeEntriesScript Property CoU_HolotapeEntriesScript Auto

Event OnActivate(Objectreference akObjRef)
	CoU_QuestScript.Increment()
EndEvent
