Strict

Import mojo
Import xengine.events.tween

Const TWEEN_EASE_IN:Int = 1
Const TWEEN_EASE_OUT:Int = 2
Const TWEEN_EASE_INOUT:Int = 3

Const TWEEN_EQUATION_LINEAR:Int = 1
Const TWEEN_EQUATION_SINE:Int = 2
Const TWEEN_EQUATION_BACK:Int = 3
Const TWEEN_EQUATION_ELASTIC:Int = 4
Const TWEEN_EQUATION_BOUNCE:Int = 5
Const TWEEN_EQUATION_CIRC:Int = 6
Const TWEEN_EQUATION_CUBIC:Int = 7
Const TWEEN_EQUATION_EXPO:Int = 8
Const TWEEN_EQUATION_QUAD:Int = 9
Const TWEEN_EQUATION_QUART:Int = 10
Const TWEEN_EQUATION_QUINT:Int = 11

Class xTween

Public

	Field OnStart:xEvent_Tween
	Field OnStop:xEvent_Tween
	Field OnPause:xEvent_Tween
	Field OnResume:xEvent_Tween
	Field OnDone:xEvent_Tween

	'Constructors
	'------------------------------------------------------
	Method New(equation:Int, startValue:Float, finalValue:Float, duration:Int, easeMethod:Int = TWEEN_EASE_IN)
		Self.SetEquation(equation)
		Self.SetDuration(duration)
		Self.SetValues(startValue, finalValue)
		Self.SetEaseMethod(easeMethod)
	End
	
	'Update
	'------------------------------------------------------
	Method Update:Void()
		If Self._isPlaying = True
			Self._lastTime = Self._currentTime
			Local __time:Int = Millisecs() - Self._firstTime
			
			If Self._isPaused = True
				Self._pauseDuration = Millisecs() - Self._pauseStartTime
			Else
				If __time > Self._duration+Self._pauseTotalDuration
					If Self._repeatTimes >= 1 or Self._repeatTimes < 0 or Self._isYoyo
						If Self._isYoyo
							Self._currentTime = Self._duration
							Self._position = Self._initialValue + Self._changeValue
							
							If Self._repeatTimes < 0
								Self.ContinueTo(Self._initialValue, Self._duration)
							Else
								If Self._loopCount > Self._repeatTimes
									Self.Done()
									Self.SetValues(Self._finalValue, Self._initialValue)
								Else
									Self.ContinueTo(Self._initialValue, Self._duration)
								End
							End
							
							Self._loopCount+=0.5
						Else
							Self._loopCount+=1
							
							If Self._repeatTimes < 0
								Self._currentTime = 0
								Self._firstTime = Millisecs()
								Self._lastTime = 0
								Self._pauseStartTime = 0
								Self._pauseDuration = 0
								Self._pauseTotalDuration = 0
								Self._position = 0
							Else
								If Self._loopCount > Self._repeatTimes
									Self.Done()
								Else
									Self._currentTime = 0
									Self._firstTime = Millisecs()
									Self._lastTime = 0
									Self._pauseStartTime = 0
									Self._pauseDuration = 0
									Self._pauseTotalDuration = 0
									Self._position = 0
									Self._updateValue()
								End
							End
						End
					Else
						Self.Done()
					End
				Else If __time < 0
					Self._currentTime = 0
					Self._firstTime = Millisecs()
					Self._updateValue()
				Else
					Self._currentTime = __time - Self._pauseTotalDuration
					Self._updateValue()
				End
			End

		End
	End
	
	'Continue to some value
	'------------------------------------------------------
	Method ContinueTo:Void(finalValue:Float, duration:Int=0)
		Self._pauseStartTime = 0
		Self._pauseDuration = 0
		Self._pauseTotalDuration = 0
		
        Self._initialValue = Self._position
        Self.SetValues(Self._initialValue, finalValue)

        If Self._isPlaying = True
            If duration = 0
                Self._duration = duration - Self._currentTime
            Else
                Self._duration = duration
            End

            Self._firstTime = Millisecs()
            Self._currentTime = 0

            If duration <= 0
                duration = 0
                Self.Stop()
            End
        Else
            If duration > 0 Self.SetDuration(duration)
            Self.Start()
        End
    End
	
	'Make the tween in reverse way
	'------------------------------------------------------
	Method Reverse:Void()
		Self.ContinueTo(Self._initialValue, Self._duration)
		If Self._easeMethod = TWEEN_EASE_IN
			Self._easeMethod = TWEEN_EASE_OUT
		Else If Self._easeMethod = TWEEN_EASE_OUT
			Self._easeMethod = TWEEN_EASE_IN
		End
    End
	
	'Set equation
	'------------------------------------------------------
	Method SetEquation:Void(equation:Int)
		Select equation 
			Case TWEEN_EQUATION_LINEAR
				Self._equation = New xTweenEquationLinear
			Case TWEEN_EQUATION_SINE
				Self._equation = New xTweenEquationSine
			Case TWEEN_EQUATION_BACK
				Self._equation = New xTweenEquationBack
			Case TWEEN_EQUATION_ELASTIC
				Self._equation = New xTweenEquationElastic
			Case TWEEN_EQUATION_BOUNCE
				Self._equation = New xTweenEquationBounce
			Case TWEEN_EQUATION_CIRC
				Self._equation = New xTweenEquationCirc
			Case TWEEN_EQUATION_CUBIC
				Self._equation = New xTweenEquationCubic
			Case TWEEN_EQUATION_EXPO
				Self._equation = New xTweenEquationExpo
			Case TWEEN_EQUATION_QUAD
				Self._equation = New xTweenEquationQuad
			Case TWEEN_EQUATION_QUART
				Self._equation = New xTweenEquationQuart
			Case TWEEN_EQUATION_QUINT
				Self._equation = New xTweenEquationQuint
		End
	End
	
	'Set duration
	'------------------------------------------------------
	Method SetDuration:Void(value:Int)
        Self._duration = value
    End

	'Set initial and final value
	'------------------------------------------------------
    Method SetValues:Void(initialValue:Float, finalValue:Float)
        Self._initialValue = initialValue
		Self._finalValue = finalValue
        Self._changeValue = finalValue - initialValue
    End
	
	'Set ease method
	'------------------------------------------------------
	Method SetEaseMethod:Void(easeMethod:Int = TWEEN_EASE_IN)
		Self._easeMethod = easeMethod
	End
	
	'Set the tween to act like a Yoyo
	'------------------------------------------------------
	Method SetYoyo:Void(value:Bool = true)
		Self._isYoyo = value
	End
	
	'Set the repeat times of tween
	'Set value to -1 to repeat forever
	'------------------------------------------------------
	Method SetRepeatTimes:void(value:Int)
		Self._repeatTimes = value
	End
	
	'Get tween position
	'------------------------------------------------------
	Method GetPosition:Float()
		Return Self._position
	End
	
	'Get true if the tween is playing
	'------------------------------------------------------	
	Method IsPlaying:Bool()
		Return Self._isPlaying
	End
	
	'Get true if the tween is paused
	'------------------------------------------------------	
	Method IsPaused:Bool()
		Return Self._isPaused
	End
	
	'Get true if the tween is acting as Yoyo
	'------------------------------------------------------	
	Method IsYoyo:Bool()
		Return Self._isYoyo
	End
	
	'Get true if the tween has done
	'------------------------------------------------------	
	Method IsDone:Bool()
		Return Self._isDone
	End
	
	'Start tween
	'------------------------------------------------------	
	Method Start:Void()
		Self._isPlaying = True
		Self._isPaused = False
		Self._isDone = False
		Self.Rewind()
		Self._loopCount = 0
			
		If Self.OnStart <> null
			Self.OnStart.Tween = Self
			Self.OnStart.Invoke()
		End
	End
	
	'Pause tween
	'------------------------------------------------------	
	Method Pause:Void()
		If Self._isPaused = False
			Self._pauseStartTime = Millisecs()
			
			If Self.OnPause <> Null
				Self.OnPause.Tween = Self
				Self.OnPause.Invoke()
			End
		End
		
		Self._isPaused = True
	End
	
	'Resume tween
	'------------------------------------------------------	
	Method Resume:Void()
		If Self._isPaused = True
			Self._pauseTotalDuration += Self._pauseDuration
			
			If Self.OnResume <> Null
				Self.OnResume.Tween = Self
				Self.OnResume.Invoke()
			End
		End
		
		Self._isPaused = False
	End
	
	'Stop tween
	'------------------------------------------------------	
	Method Stop:Void()
		Self._isPlaying = False
		Self._isDone = True
		Self._currentTime = Self._duration
		Self._loopCount = 0
		
		If Self.OnStop <> null
			Self.OnStop.Tween = Self
			Self.OnStop.Invoke()
		End
	End
	
	'Done tween
	'------------------------------------------------------	
	Method Done:Void()
		Self._isPlaying = False
		Self._isDone = True
		Self._currentTime = Self._duration
		Self._position = Self._initialValue + Self._changeValue
		Self._loopCount = 0
		
		If Self.OnDone <> null
			Self.OnDone.Tween = Self
			Self.OnDone.Invoke()
		End
	End
	
	'Rewind
	'------------------------------------------------------	
	Method Rewind:Void()
		Self._firstTime = Millisecs()
		Self._currentTime = 0
		Self._lastTime = 0
		Self._pauseStartTime = 0
		Self._pauseDuration = 0
		Self._pauseTotalDuration = 0
		Self._position = 0
		Self._updateValue()
	End
	
	'Fastforward
	'------------------------------------------------------	
	Method FastForward:Void()
		Self._currentTime = Self._duration
		Self._updateValue()
		Self.Stop()
	End

Private

	Field _duration:Int = 0
	Field _initialValue:Float
	Field _finalValue:Float
	Field _changeValue:Float
	Field _position:Float
	
	Field _firstTime:Int
	Field _currentTime:Int
	Field _lastTime:Int
	
	Field _equation:xTweenEquation
	
	Field _isPlaying:Bool = False
	Field _isYoyo:Bool = False
	Field _loopCount:Float
	Field _repeatTimes:Int = 0
	Field _isDone:Bool = False
	Field _isPaused:Bool = False
	
	Field _pauseStartTime:Int
	Field _pauseDuration:Int
	Field _pauseTotalDuration:Int
	
	
	Field _easeMethod:Int = TWEEN_EASE_IN

	Method _updateValue:Void()
		Select _easeMethod
			Case TWEEN_EASE_IN
				Self._position = Self._equation.EaseIn(Self._currentTime, Self._initialValue, Self._changeValue, Self._duration)
			Case TWEEN_EASE_OUT
				Self._position = Self._equation.EaseOut(Self._currentTime, Self._initialValue, Self._changeValue, Self._duration)
			Case TWEEN_EASE_INOUT
				Self._position = Self._equation.EaseInOut(Self._currentTime, Self._initialValue, Self._changeValue, Self._duration)
		End
	End
End


'Tween equation
'------------------------------------------------------
Class xTweenEquation Abstract
	
	Method EaseIn:Float(currenTime:Float, startValue:float, changeValue:Float, duration:Float)
		Return startValue + changeValue
	End
	
	Method EaseOut:Float(currenTime:Float, startValue:float, changeValue:Float, duration:Float)
		Return startValue + changeValue
	End
	
	Method EaseInOut:Float(currenTime:Float, startValue:float, changeValue:Float, duration:Float)
		Return startValue + changeValue
	End
	
End


'Tween linear equation
'------------------------------------------------------
Class xTweenEquationLinear Extends xTweenEquation

	Method EaseIn:Float(t:Float, b:float, c:Float, d:Float)
		Return c * t / d + b
	End
	
	Method EaseOut:Float(t:Float, b:float, c:Float, d:Float)
		Return c * t / d + b
	End
	
	Method EaseInOut:Float(t:Float, b:float, c:Float, d:Float)
		Return c * t / d + b
	End
	
End

'Tween sine equation
'------------------------------------------------------
Class xTweenEquationSine Extends xTweenEquation

	Method EaseIn:Float(t:Float, b:float, c:Float, d:Float)
		Return -c * Cos( (t / d * (PI / 2)) * 57.2957795) + c + b
	End
	
	Method EaseOut:Float(t:Float, b:float, c:Float, d:Float)
		Return c * Sin((t/d * (PI/2)) * 57.2957795) + b
	End
	
	Method EaseInOut:Float(t:Float, b:float, c:Float, d:Float)
		Return -c/2 * (Cos((PI*t/d) * 57.2957795) - 1) + b
	End
	
End

'Tween back equation
'------------------------------------------------------
Class xTweenEquationBack Extends xTweenEquation
	Field s:Float
	
	Method EaseIn:Float(t:Float, b:float, c:Float, d:Float)
		t /= d
		Return c * t * t * ((2.70158) * t - 1.70158) + b
	End
	
	Method EaseOut:Float(t:Float, b:float, c:Float, d:Float)
		t = t / d - 1
		Return c * (t * t * ((2.70158) * t + 1.70158) + 1) + b
	End
	
	Method EaseInOut:Float(t:Float, b:float, c:Float, d:Float)
		s = 1.70158
        t /= d / 2
        s *= 1.525
		If t < 1
            Return c / 2 * (t * t *((s+1) * t - s)) + b
        End
		t -= 2
		Return c / 2 * (t * t * ((s + 1) * t + s) + 2) + b
	End
End

'Tween elastic equation
'------------------------------------------------------
Class xTweenEquationElastic Extends xTweenEquation
	
	Field p:Float
    Field a:Float
    Field s:Float
	
	Method EaseIn:Float(t:Float, b:float, c:Float, d:Float)
		If t = 0 Return b
		t /= d
        If t = 1 Return b+c
        p = d *  0.3
		a = c
        s = p / 4
        t -= 1
		Return -(a * Pow(2,10 * (t)) * Sin(((t * d - s) * (2 * PI) / p) * 57.2957795)) + b
	End
	
	Method EaseOut:Float(t:Float, b:float, c:Float, d:Float)
		If t = 0 Return b
		t /= d
        If t = 1 Return b+c
        p = d * 0.3
		a = c
        s = p / 4
		Return (a * Pow(2,-10 * t) * Sin(((t * d - s) * (2 * PI) / p) * 57.2957795) + c + b)
	End
	
	Method EaseInOut:Float(t:Float, b:float, c:Float, d:Float)
		If t = 0 Return b
		t /= d / 2
        If t = 2 Return b+c
        p = d * (0.3 * 1.5)
		a = c
        s = p / 4
		If t < 1
            t -= 1
            Return -0.5 * (a * Pow(2,10 * t) * Sin(((t * d - s) * (2 * PI) / p) * 57.2957795)) + b
        End
        t -= 1
		Return a * Pow(2,-10 * t) * Sin(((t * d - s) * (2 * PI) / p) * 57.2957795) * 0.5 + c + b
	End
	
End

'Tween bounce equation
'------------------------------------------------------
Class xTweenEquationBounce Extends xTweenEquation

	Method EaseIn:Float(t:Float, b:float, c:Float, d:Float)
		t = (d-t) / d
		If t < 0.3636363
			Return c - (c * (7.5625 * t * t)) + b
		Else If t < 0.7272727
            t -= 0.5454545
			Return c - (c * (7.5625 * t * t + 0.75)) + b
		Else If t < 0.9090909
            t -= 0.8181818
			Return c - (c * (7.5625 * t * t + 0.9375)) + b
		Else
            t -= 0.9636363
			Return c - (c * (7.5625 * t * t + 0.984375)) + b
        End
		
		Return b+c
	End
	
	Method EaseOut:Float(t:Float, b:float, c:Float, d:Float)
		t /= d
		If t < 0.3636363
			Return c *(7.5625 * t * t) + b
		Else If t < 0.7272727
            t -= 0.5454545
			Return c * (7.5625 * t * t + 0.75) + b
		Else If t < 0.9090909
            t -= 0.8181818
			Return c * (7.5625 * t * t + 0.9375) + b
		Else
            t -= 0.9636363
			Return c * (7.5625 * t * t + 0.984375) + b
        End
		
		Return b+c
	End
	
	Method EaseInOut:Float(t:Float, b:float, c:Float, d:Float)
		If t < d/2
            t = (d - t * 2) / d
    		If t < 0.3636363
    			Return (c - (c * (7.5625 * t * t))) * 0.5 + b
    		Else If t < 0.7272727
                t -= 0.5454545
    			Return (c - (c * (7.5625 * t * t + 0.75))) * 0.5 + b
    		Else If t < 0.9090909
                t -= 0.8181818
    			Return (c - (c * (7.5625 * t * t + 0.9375))) * 0.5 + b
    		Else
                t -= 0.9636363
    			Return (c - (c * (7.5625 * t * t + 0.984375))) * 0.5 + b
            End
        Else
            t = (t * 2 - d) / d
    		If t < 0.3636363
    			Return (c *(7.5625 * t * t)) * 0.5 + c * 0.5 + b
    		Else If t < 0.7272727
                t -= 0.5454545
    			Return (c * (7.5625 * t * t + 0.75)) * 0.5 + c * 0.5 + b
    		Else If t < 0.9090909
                t -= 0.8181818
    			Return (c * (7.5625 * t * t + 0.9375)) * 0.5 + c * 0.5 + b
    		Else
                t -= 0.9636363
    			Return (c * (7.5625 * t * t + 0.984375)) * 0.5 + c * 0.5 + b
            End
        End
		
		Return b+c
	End
	
End

'Tween circ equation
'------------------------------------------------------
Class xTweenEquationCirc Extends xTweenEquation
	
	Method EaseIn:Float(t:Float, b:float, c:Float, d:Float)
		t /= d
        Return -c * (Sqrt(1 - t * t) - 1) + b
	End
	
	Method EaseOut:Float(t:Float, b:float, c:Float, d:Float)
		t = t / d - 1
        Return c * Sqrt(1 - t*t) + b
	End
	
	Method EaseInOut:Float(t:Float, b:float, c:Float, d:Float)
		t /= d / 2
		If t < 1 Return -c / 2 * (Sqrt(1 - t * t) - 1) + b
		t -= 2
		Return c / 2 * (Sqrt(1 - t * t) + 1) + b
	End
	
End

'Tween cube equation
'------------------------------------------------------
Class xTweenEquationCubic Extends xTweenEquation

	Method EaseIn:Float(t:Float, b:float, c:Float, d:Float)
		t /= d
        Return c * t * t * t + b
	End
	
	Method EaseOut:Float(t:Float, b:float, c:Float, d:Float)
		t = t / d - 1
        Return c * (t * t * t + 1) + b
	End
	
	Method EaseInOut:Float(t:Float, b:float, c:Float, d:Float)
		t /= d / 2
		If t < 1 Return c / 2 * t * t * t + b
		t -= 2
		Return c / 2 *(t * t * t + 2) + b
	End
	
End

'Tween expo equation
'------------------------------------------------------
Class xTweenEquationExpo Extends xTweenEquation
	
	Method EaseIn:Float(t:Float, b:float, c:Float, d:Float)
		If t = 0 Return b
        Return c * Pow(2,10 * (t / d - 1)) + b
	End
	
	Method EaseOut:Float(t:Float, b:float, c:Float, d:Float)
		If t = d Return b + c
        Return c * (-Pow(2,-10 * t / d) + 1) + b
	End
	
	Method EaseInOut:Float(t:Float, b:float, c:Float, d:Float)
		If t = 0 Return b
		If t = d Return b + c
		t /= d / 2
		If t < 1 Return c / 2 * Pow(2, 10 * (t - 1)) + b
		t -= 1
		Return c / 2 * (-Pow(2, -10 * t) + 2) + b
	End
	
End

'Tween quad equation
'------------------------------------------------------
Class xTweenEquationQuad Extends xTweenEquation
	
	Method EaseIn:Float(t:Float, b:float, c:Float, d:Float)
		t /= d
        Return c * t * t + b
	End
	
	Method EaseOut:Float(t:Float, b:float, c:Float, d:Float)
		t /= d
        Return -c * t * (t - 2) + b
	End
	
	Method EaseInOut:Float(t:Float, b:float, c:Float, d:Float)
		t /= d / 2
		If t < 1 Return c / 2 * t * t + b
		t -= 1
		Return -c / 2 * (t * (t - 2) - 1) + b
	End
	
End

'Tween quart equation
'------------------------------------------------------
Class xTweenEquationQuart Extends xTweenEquation
	
	Method EaseIn:Float(t:Float, b:float, c:Float, d:Float)
		t /= d
        Return c * t * t * t * t + b
	End
	
	Method EaseOut:Float(t:Float, b:float, c:Float, d:Float)
		t = t / d-1
        Return -c * (t * t * t * t - 1) + b
	End
	
	Method EaseInOut:Float(t:Float, b:float, c:Float, d:Float)
		t /= d / 2
		If t < 1 Return c / 2 * t * t * t * t + b
        t -= 2
		Return -c / 2 * (t * t * t * t - 2) + b
	End
	
End

'Tween quint equation
'------------------------------------------------------
Class xTweenEquationQuint Extends xTweenEquation
	
	Method EaseIn:Float(t:Float, b:float, c:Float, d:Float)
		t /= d
        Return c * t * t * t * t * t + b
	End
	
	Method EaseOut:Float(t:Float, b:float, c:Float, d:Float)
		t = t / d - 1
        Return c * (t * t * t * t * t + 1) + b
	End
	
	Method EaseInOut:Float(t:Float, b:float, c:Float, d:Float)
		t /= d / 2
		If t < 1 Return c / 2 * t * t * t * t * t + b
        t -= 2
		Return c / 2 * (t * t * t * t * t + 2) + b
	End
	
End
