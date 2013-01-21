Strict

Import xengine.components.entity
Import xengine.fx.tween
Import xengine.events.transition
Import xengine.basics.list

Const TRANSITION_POSITION:Int = 15
Const TRANSITION_X:Int = 1
Const TRANSITION_Y:Int = 2
Const TRANSITION_SCALE:Int = 3
Const TRANSITION_SCALE_WIDTH:Int = 4
Const TRANSITION_SCALE_HEIGHT:Int = 5
Const TRANSITION_ROTATION:Int = 6
Const TRANSITION_ALPHA:Int = 7
Const TRANSITION_COLOR:Int = 16
Const TRANSITION_COLOR_RED:Int = 8
Const TRANSITION_COLOR_GREEN:Int = 9
Const TRANSITION_COLOR_BLUE:Int = 10
Const TRANSITION_CAMERA_POSITION:Int = 17
Const TRANSITION_CAMERA_X:Int = 11
Const TRANSITION_CAMERA_Y:Int = 12
Const TRANSITION_CAMERA_ROTATION:Int = 13
Const TRANSITION_CAMERA_ZOOM:Int = 14


Class xTransitionManagerClass

Public

	Method AddTransition:Void(transition:xTransition)
		transition.Link = Self._transitions.AddLast(transition)
	End
	
	Method RemoveTransition:Void(transition:xTransition)
		transition.Link.Remove()
	End
	
	Method RemoveTransition:Void(id:String)
		For Local transition:xTransition = Eachin Self._transitions
			If transition.Id = id
				transition.Link.Remove()
			End
		Next
	End
	
	Method GetTransition:xTransition(id:string)
		For Local transition:xTransition = Eachin Self._transitions
			If transition.Id = id
				Return transition
			End
		Next
		
		Return Null
	End
	
	Method StartTransition:Void(id:String)
		For Local transition:xTransition = Eachin Self._transitions
			If transition.Id = id
				transition.Start()
			End
		Next
	End
	
	Method GetAmount:Int()
		Return Self._transitions.Count()
	End
	
	Method Update:Void()
		For Local transition:xTransition = Eachin Self._transitions
			transition.Update()
		Next
	End
	
Private

	Field _transitions:= New xList<xTransition>

End

Global xTransitionManager:= New xTransitionManagerClass 


Class xTransition

Public

	Field Id:String
	
	Field OnStart:xEvent_Transition
	Field OnStop:xEvent_Transition
	Field OnPause:xEvent_Transition
	Field OnResume:xEvent_Transition
	Field OnDone:xEvent_Transition
	
	Field Link:xLink<xTransition>
	
	'Constructors
	'------------------------------------------------------
	Method New()
		Self.Id = NewId("transition")
		
		xTransitionManager.AddTransition(Self)
	End
	
	Method New(addMe:Bool = True)
		Self.Id = NewId("transition")
		
		If addMe = True
			xTransitionManager.AddTransition(Self)
		End
	End
	
	Method New(id:String, addMe:Bool = True)
		Self.Id = id
		
		If addMe = True
			xTransitionManager.AddTransition(Self)
		End
	End

	
	'Update
	'------------------------------------------------------
	Method Update:Void()
		If Self._target <> null And Self._isDone = False
		
			If Self._isPaused = True
				Local __time:Int = Millisecs() - Self._pauseStartTime
				Self._pauseDuration+=__time
				Self._pauseStartTime = Millisecs()
			End

			Local time:Int = Millisecs() - Self._firstTime
			For Local task:xTransitionTask = eachin Self._tasks
				If time >= task.StartAt+Self._pauseDuration And task.StartIt = 1
					task.Tween.Start()
				task.StartIt = 0
				End
				
				If task.StartIt = 0 And task.IsDoned = False
					task.Tween.Update()
				
					If task.Tween.IsPlaying() = True
						Self._setPosition(task)
					Else
						If task.Tween.IsDone() = True
							Self._counter+=1
							
							If task.IsDoned = False
								task.IsDoned = True
								Self._setPosition(task)
							End
						End
					End
				End
			Next
			
			
			If Self._counter = Self._tasks.Count()
				Self.Done()
			End

		End
	End

	'Set target
	'------------------------------------------------------
	Method SetTarget:Void(target:xEntity)
		Self._target = target
	End
	
	'Add a transition task
	'------------------------------------------------------
	Method AddTask:Void(task:xTransitionTask)
		If task <> null
			Self._tasks.AddLast(task)
		End
	End

	Method AddTask:Void(type:String, initialValue:Float, finalValue:Float, duration:Int, equation:Int = TWEEN_EQUATION_LINEAR, easeMethod:Int = TWEEN_EASE_IN, startAt:Int = 0)
		Local task:xTransitionTask = New xTransitionTask(type, initialValue, finalValue, duration, equation, easeMethod, startAt)
		Self._tasks.AddLast(task)
	End
	
	'Start
	'------------------------------------------------------
	Method Start:Void()
		If Self._tasks.Count() > 0
			Self._isPaused = False
			Self._isDone = False
			
			Self._firstTime = Millisecs()

			Self._donedTasks = 0
	
			Self._pauseStartTime = 0
			Self._pauseDuration = 0
			Self._counter = 0
			
			For Local task:xTransitionTask = eachin Self._tasks
				task.StartIt = 1
				task.IsDoned = False
			Next
			
			If Self.OnStart <> null
				Self.OnStart.Transition = Self
				Self.OnStart.Target = Self._target
				Self.OnStart.Invoke()
			End
		End
	End
	
	'Stop
	'------------------------------------------------------
	Method Stop:Void()
		If Self._tasks.Count() > 0
			For Local task:xTransitionTask = eachin Self._tasks
				task.Tween.Stop()
			Next
			
			If (Self.OnStop <> null)
				Self.OnStop.Transition = Self
				Self.OnStop.Target = Self._target
				Self.OnStop.Invoke()
			End
		End
	End
	
	'Pause
	'------------------------------------------------------
	Method Pause:Void()
		If Self._tasks.Count() > 0
			For Local task:xTransitionTask = eachin Self._tasks
				If task.Tween.IsActive() = True And task.Tween.IsDone() = False
					task.Tween.Pause()
				End
			Next
		End
		
		If Self._isPaused = False
			Self._pauseStartTime = Millisecs()
			
			If (Self.OnPause <> Null)
				Self.OnPause.Transition = Self
				Self.OnPause.Target = Self._target
				Self.OnPause.Invoke()
			End
		End
		
		Self._isPaused = True
	End
	
	'Resume
	'------------------------------------------------------
	Method Resume:Void()
		If Self._isPaused = True
			Self._isPaused = False
			
			If Self._tasks.Count() > 0
				For Local task:xTransitionTask = eachin Self._tasks
					If task.Tween.IsActive() = True And task.Tween.IsDone() = False And task.Tween.IsPaused() = True
						task.Tween.Resume()
					End
				Next
			End
		
			If (Self.OnResume <> Null)
				Self.OnResume.Transition = Self
				Self.OnResume.Target = Self._target
				Self.OnResume.Invoke()
			End
		End
	End
	
	'Done
	'------------------------------------------------------
	Method Done:Void()
		If Self.OnDone <> null
			Self.OnDone.Target = Self._target
			Self.OnDone.Transition = Self
			Self.OnDone.Invoke()
		End
		
		Self._isDone = True
		
		If Self._autoRemove = True
			Self.Link.Remove()
		End
		
		If Self._autoDestroy = True
			Self.Link.Remove()
			Self._target.Detach()
			Self._target = null
		End
	End
	
	
	'Get true if the transition is paused
	'------------------------------------------------------
	Method IsPaused:Bool()
		Return Self._isPaused
	End	
	
	'Get true if the transition has done
	'------------------------------------------------------
	Method IsDone:Bool()
		Return Self._isDone
	End
	
	
	'The transition autoremove itself from transition manager
	'------------------------------------------------------
	Method AutoRemove:Void()
		Self._autoRemove = True
	End
	
	'Get if is in autoremove mode
	'------------------------------------------------------
	Method IsAutoRemovable:Bool()
		Self._autoRemove
	End
	
	
	'The transition autodestroy itself from transition manager and autodestroy the target entity 
	'------------------------------------------------------
	Method AutoDestroy:Void()
		Self._autoDestroy = True
	End
	
	'Get if is in autodestroyable mode
	'------------------------------------------------------
	Method IsAutoDestroyable:Bool()
		Self._autoDestroy
	End
	
Private

	Field _target:xEntity
	Field _tasks:= New xList<xTransitionTask>
	Field _donedTasks:Int = 0
	
	Field _firstTime:int
	
	Field _isPaused:Bool = False
	Field _isDone:Bool = False
	
	Field _pauseStartTime:Int
	Field _pauseDuration:Int
	
	Field _autoRemove:Bool = False
	Field _autoDestroy:Bool = False
	
	Field _counter:Int = 0

		
	Method _setPosition:Void(task:xTransitionTask)
		Local __value:Float = task.Tween.GetPosition()
		Select task.Type 
			Case TRANSITION_POSITION
				Self._target.SetPosition(__value, __value)
			Case TRANSITION_X
				Self._target.SetX(__value)
			Case TRANSITION_Y
				Self._target.SetY(__value)
			Case TRANSITION_SCALE
				Self._target.SetScales(__value, __value)
			Case TRANSITION_SCALE_WIDTH
				Self._target.SetWidthScale(__value)
			Case TRANSITION_SCALE_HEIGHT
				Self._target.SetHeightScale(__value)
			Case TRANSITION_ROTATION
				Self._target.SetRotation(__value)
			Case TRANSITION_ALPHA
				Self._target.SetAlpha(__value)
			Case TRANSITION_COLOR
				Self._target.SetColor(__value, __value, __value)
			Case TRANSITION_COLOR_RED
				Self._target.GetColor().SetRed(__value)
			Case TRANSITION_COLOR_GREEN
				Self._target.GetColor().SetGreen(__value)
			Case TRANSITION_COLOR_BLUE
				Self._target.GetColor().SetBlue(__value)
			Case TRANSITION_CAMERA_POSITION
				Local scene:xScene = xScene(Self._target)
				if scene <> null
					scene.SetCameraPosition(__value, __value)
				End
			Case TRANSITION_CAMERA_X
				Local scene:xScene = xScene(Self._target)
				if scene <> null
					scene.SetCameraX(__value)
				End
			Case TRANSITION_CAMERA_Y
				Local scene:xScene = xScene(Self._target)
				if scene <> null
					scene.SetCameraY(__value)
				End
			Case TRANSITION_CAMERA_ROTATION
				Local scene:xScene = xScene(Self._target)
				if scene <> null
					scene.SetCameraRotation(__value)
				End
			Case TRANSITION_CAMERA_ZOOM
				Local scene:xScene = xScene(Self._target)
				if scene <> null
					scene.SetCameraZoom(__value)
				End
		End
	End
	
End


Class xTransitionTask

	Field Id:String
	Field Type:String
	Field Tween:xTween
	Field StartAt:Int= 0 
	Field IsDoned:Bool = False
	Field StartIt:Int = -1
	
	'Constructors
	'------------------------------------------------------
	Method New(type:String, initialValue:Float, finalValue:Float, duration:Int, equation:Int = TWEEN_EQUATION_LINEAR, easeMethod:Int = TWEEN_EASE_IN, startAt:Int = 0)
		Self.Type = type
		Self.Tween = New xTween(equation, initialValue, finalValue, duration, easeMethod)
		Self.StartAt = startAt
		Self.Id = NewId("TransitionTask")
	End

End
