Scriptname Metro:BoxDeleteSelf extends ObjectReference

Event OnClose(ObjectReference akActionRef)
  if (akActionRef == Game.GetPlayer())
	If DeleteBoxMsg.Show() == 0
		self.Delete()
	EndIf
  endIf
endEvent

Message Property DeleteBoxMsg Auto
