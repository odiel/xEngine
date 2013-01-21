Strict

Import mojo
Import xengine.components.base
Import xengine.globals
Import xengine.io.resources.imageframe
Import xengine.components.sprite

Class xAnimation Extends xComponentBase
	
Public

	'Constructors
	'------------------------------------------------------
	Method New()
		Self.Id = NewId("Animation")
	End
	
	Method New(id:String)
		Self.Id = id
	End
	
	'Update
	'------------------------------------------------------
	Method Update:Void(sprite:xSprite)
		If (Self._isPlaying = True)
			Local __time:Int = xClockManager.GetTimeSinceStart() -Self._firstTime
		
			If Self._isPaused = True
				Self._pauseDuration = Millisecs() -Self._pauseStartTime
			Else
				If __time > Self._duration + Self._pauseTotalDuration
					If Self._repeatTimes < 0
						Self._isPlaying = True
						Self._isPaused = False
						Self._firstTime = xClockManager.GetTimeSinceStart()
						Self._pauseTotalDuration = 0
						Self._pauseStartTime = 0
						Self._pauseDuration = 0
					Else
						Self._loopCount+=1
						
						If Self._loopCount >= Self._repeatTimes
							Self.Done()
						Else
							Self._isPlaying = True
							Self._isPaused = False
							Self._firstTime = xClockManager.GetTimeSinceStart()
							Self._pauseTotalDuration = 0
							Self._pauseStartTime = 0
							Self._pauseDuration = 0
						End
					End
				Else If __time < 0
					Self.Done()
				Else
					Self._currentFrameIx = Int( (Self._frames.Length() -1) * (__time - Self._pauseTotalDuration) / Self._duration)
					sprite.SetFrame(Self._frames[Self._currentFrameIx])
				End
			End
		End
	End
	
	'Add a frame definition to the frame list
	'------------------------------------------------------
	Method AddFrame:Void(frame:xImageFrame)
		If (frame <> Null)
			Self._frames = Self._frames.Resize(Self._frames.Length() +1)
			Self._frames[Self._frames.Length() -1] = frame
		End
	End
	
	'Set the animation frame list
	'------------------------------------------------------
	Method SetFrames:Void(frames:xImageFrame[])
		If (frames <> Null)
			Self._frames = frames
		End
	End
	
	'Get a particular frame from frame list
	'------------------------------------------------------
	Method GetFrame:xImageFrame(index:Int)
		If (index < Self._frames.Length)
			Return Self._frames[index]
		End
		
		Return Null
	End
	
	'Play the animation
	'------------------------------------------------------
	Method Play:Void()
		Self._isPlaying = True
		Self._isPaused = False
		Self._isDone = False
		Self._isStopped = False
		Self._firstTime = xClockManager.GetTimeSinceStart()
	End
	
	'Pause the animation
	'------------------------------------------------------
	Method Pause:Void()
		If Self._isPaused = False
			Self._pauseStartTime = xClockManager.GetTimeSinceStart()
		End
		Self._isPaused = True
	End
	
	'Resume the animation
	'------------------------------------------------------
	Method Resume:Void()
		If Self._isPaused = True
			Self._pauseTotalDuration += Self._pauseDuration
		End
		Self._isPaused = False
	End
	
	'Stop the animation
	'------------------------------------------------------
	Method Stop:Void()
		Self._isPlaying = False
		Self._isStopped = True
	End
	
	'Done the animation
	'------------------------------------------------------
	Method Done:Void()
		Self._isPlaying = False
		Self._isDone = True
		Self._currentFrameIx = Self._frames.Length() -1
	End
	
	'To know if the animation is done
	'------------------------------------------------------
	Method IsDone:Bool()
		Return Self._isDone
	End
	
	'To know if the animation is still playing
	'------------------------------------------------------
	Method IsPlaying:Bool()
		Return Self._isPlaying
	End
	
	'To know if the animation has been stoped
	'------------------------------------------------------
	Method IsStopped:Bool()
		Return Self._isStopped
	End
	
	'Set the total duration of the animation
	'------------------------------------------------------
	Method SetDuration:Void(value:Int)
		Self._duration = value
	End
	
	'Get the duration
	'------------------------------------------------------
	Method GetDuration:Int()
		Return Self._duration
	End

	'Get the total amount of frames
	'------------------------------------------------------
	Method GetFramesList:xImageFrame[] ()
		Return Self._frames
	End
	
	'Set the repeat times of animation
	'Set value to -1 to repeat forever
	'------------------------------------------------------
	Method SetRepeatTimes:void(value:Int)
		Self._repeatTimes = value
	End
	


Private

	Field _frames:xImageFrame[] = New xImageFrame[0]
	
	Field _firstTime:Int
	
	Field _duration:Int = 10
	Field _repeatTimes:Int = 0
	Field _loopCount:Int = 0
	Field _currentFrameIx:Int = 0
	Field _currentFrame:Int
	
	
	Field _pauseDuration:Int
	Field _pauseStartTime:Int
	Field _pauseTotalDuration:Int
	
	Field _isPlaying:Bool = False
	Field _isPaused:Bool = False
	Field _isDone:Bool = False
	Field _isStopped:Bool = False

End
