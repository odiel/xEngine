Strict

Import mojo.app
Import mojo.graphics
Import xengine.globals


Class xClockManagerClass

Public 
	
	'Update
	'------------------------------------------------------
	Method Update:Void()
		Self._timeSinceStart = Millisecs() - Self._firstTime
		Self._timeSinceLastFrame = Self._timeSinceStart - Self._timeStampLastFrame
		Self._timeStampLastFrame = Self._timeSinceStart
		Self._deltaTime = Self._timeSinceLastFrame * 0.001
		
		Self._fpsTimer+=Self._deltaTime
		Self._fpsCounter+=1
		If (Self._fpsTimer > 1)
			Self._fps = Self._fpsCounter
			Self._fpsCounter = 0
			Self._fpsTimer = 0	
		End
		
		For Local clock:xClock = eachin self._clocks.Values()
			clock.Update()
		Next
	End
	

	'Start
	'------------------------------------------------------
	Method Start:Void()
		Self._firstTime = Millisecs()
	End
	
	'Get the FPS
	'------------------------------------------------------
	Method GetFPS:Int()
		Return Self._fps
	End
	
	'Get the deltatime
	'------------------------------------------------------
	Method GetDeltaTime:Float()
		Return Self._deltaTime
	End
	
	'Get time since another time
	'------------------------------------------------------
	Method GetTimeSince:Int(times:Int)
		Return Self.GetTimeSinceStart() -times
	End
	
	'Get time since start
	'------------------------------------------------------
	Method GetTimeSinceStart:Int()
		Return Millisecs() - Self._firstTime
	End
	
	'Get time elapsed since last frame
	'------------------------------------------------------
	Method GetTimeSinceLastFrame:Int()
		Return Self._timeSinceLastFrame
	End
	
	
	'Add Clock
	'------------------------------------------------------
	Method AddClock:Void(clock:xClock)
		Self._clocks.Insert(clock.GetId(), clock)
	End
	
	'Get Clock
	'------------------------------------------------------
	Method GetClock:xClock(id:String)
		Return Self._clocks.Get(id)
	End
	
	'Remove Clock
	'------------------------------------------------------
	Method RemoveClock:Void(id:String)
		Self._clocks.Remove(id)
	End
	
Private
	Field _timeSinceStart:Int
	Field _firstTime:Int
	Field _timeSinceLastFrame:Int 
	Field _timeStampLastFrame:Int

	Field _fps:Int = 0
	Field _deltaTime:Float
	Field _fpsTimer:Float
	Field _fpsCounter:Int
	
	Field _clocks:= New StringMap<xClock>
End

Global xClockManager:xClockManagerClass = New xClockManagerClass


Class xClock 
	
Public 

	Method New()
		Self._id = NewId("Clock")
		xClockManager.AddClock(Self)
	End

	Method New(fps:Int)
		Self._fps = fps
		Self._id = NewId("Clock")
		xClockManager.AddClock(Self)
	End
	
	Method New(id:String, fps:Int)
		Self._fps = fps
		Self._id = id
		xClockManager.AddClock(Self)
	End
	
	Method GetId:String()
		Return Self._id
	End
	
	Method Start:Void()
		Self._lasttime = Millisecs()
	End
	
	Method SetFPS:Void(fps:Int)
		Self._fps = fps
	End
	
	Method GetFPS:Int()
		Return Self._fps
	End
	
	Method GetDeltaTime:float()
		Return Self._deltatime
	End
	
	Method Update:Void()
		Self._currenttime = Millisecs()
		Self._frametime = Self._currenttime - Self._lasttime
		Self._deltatime = (Self._frametime / (1000.0 / Self._fps) * 0.01)
		Self._lasttime = Self._currenttime
	End
	
Private

	Field _id:String

	Field _lasttime:Int
	Field _currenttime:Int
	Field _frametime:Float

	Field _fps:Int = 60
	Field _deltatime:Float
End
