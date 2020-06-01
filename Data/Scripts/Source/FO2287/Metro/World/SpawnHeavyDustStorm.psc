Scriptname Metro:World:SpawnHeavyDustStorm extends ActiveMagicEffect

ObjectReference CGNukeShockwave
float X
float Y
float Z
float tX
float tY
float tZ

Event OnEffectStart(Actor akCaster, Actor akTarget)
	CGShockWaveOnDustStorm()
EndEvent

Event OnEffectFinish(Actor akCaster, Actor akTarget)
	CGNukeShockwave.Delete()
EndEvent

Event OnDistanceLessThan(ObjectReference akObj1, ObjectReference akObj2, float afDistance)
	;HeavyDustStorm.ForceActive(false)
EndEvent

Event OnTimer(int aiTimerID)
	CGNukeShockwave.TranslateTo(tX + Utility.RandomFloat(-200, 200), tY + Utility.RandomFloat(-200, 200) , tZ, 0.0, 0.0, 1500.0, afSpeed = 350.0, afMaxRotationSpeed = 33.0)
	Game.GetPlayer().TranslateTo(tX, tY, tZ+100, 180.0, 40.0, 230.0, afSpeed = 350.0, afMaxRotationSpeed = 33.0)
	StartTimer(4.0,1)
EndEvent

Function CGShockWaveOnDustStorm()
	CGNukeShockwave = Game.GetPlayer().PlaceAtMe(CGNukeShockwaveFake)
	CGNukeShockwave.MoveTo(Game.GetPlayer(), 300.0, 300.0, 0, true)
	CGNukeShockwave.SetScale(10.0)
	tX = CGNukeShockwave.GetPositionX()
	tY = CGNukeShockwave.GetPositionX()
	tZ = CGNukeShockwave.GetPositionX()
	CGNukeShockwave.TranslateTo(tX + Utility.RandomFloat(-200, 200), tY + Utility.RandomFloat(-200, 200) , tZ, 0.0, 0.0, 1500.0, afSpeed = 350.0, afMaxRotationSpeed = 33.0)
	;Game.GetPlayer().ForceAddRagdollToWorld()
	Game.GetPlayer().TranslateTo(tX, tY, tZ + 20, 180.0, 40.0, 230.0, afSpeed = 350.0, afMaxRotationSpeed = 33.0)
	StartTimer(4.0,1)
	
	X = Game.GetPlayer().GetPositionX()
	Y = Game.GetPlayer().GetPositionY()
	Z = Game.GetPlayer().GetPositionZ()
	;CGNukeShockwave.MoveTo(Game.GetPlayer())
	;CGNukeShockwave.SplineTranslateTo(X + 2000.0, Y + 2000.0, Z, 0.0, 0.0, 0.0, afTangentMagnitude = 1.0, afSpeed = 66.0, afMaxRotationSpeed = 10.0)
	;CGNukeShockwave.SplineTranslateToRef(Game.GetPlayer(), 10.0, 50.0)
	;CGNukeShockwave.PlayGamebryoAnimation("WaveMoving",true,3.0)
	RegisterForDistanceLessThanEvent(Game.GetPlayer(), CGNukeShockwave, 100)
EndFunction

Form Property CGNukeShockwaveFake Auto Const Mandatory
Weather Property HeavyDustStorm Auto Const Mandatory
