Strict

Import mojo
Import xengine.globals
Import xengine.application

CONST INPUT_STATUS_NONE:Int = 0
CONST INPUT_STATUS_DOWN:Int = 1
CONST INPUT_STATUS_PRESSED:Int = 2
CONST INPUT_STATUS_UP:Int = 3

Global xInput:xInputClass = New xInputClass

Class xInputClass

Public

	Field DoublePushTime:Int = 200

	Field Key_Backspace:xInputButton = New xInputKey(mojo.input.KEY_BACKSPACE)
	Field Key_Tab:xInputButton = New xInputKey(mojo.input.KEY_TAB)
	Field Key_Enter:xInputButton = New xInputKey(mojo.input.KEY_ENTER)
	Field Key_Escape:xInputButton = New xInputKey(mojo.input.KEY_ESCAPE)
	Field Key_Space:xInputButton = New xInputKey(mojo.input.KEY_SPACE)
	Field Key_Shift:xInputButton = New xInputKey(mojo.input.KEY_SHIFT)
	Field Key_Control:xInputButton = New xInputKey(mojo.input.KEY_CONTROL)
	Field Key_PageUp:xInputButton = New xInputKey(mojo.input.KEY_PAGEUP)
	Field Key_PageDown:xInputButton = New xInputKey(mojo.input.KEY_PAGEDOWN)
	Field Key_End:xInputButton = New xInputKey(mojo.input.KEY_END)
	Field Key_Home:xInputButton = New xInputKey(mojo.input.KEY_HOME)
	Field Key_Left:xInputButton = New xInputKey(mojo.input.KEY_LEFT)
	Field Key_Up:xInputButton = New xInputKey(mojo.input.KEY_UP)
	Field Key_Right:xInputButton = New xInputKey(mojo.input.KEY_RIGHT)
	Field Key_Down:xInputButton = New xInputKey(mojo.input.KEY_DOWN)
	Field Key_Insert:xInputButton = New xInputKey(mojo.input.KEY_INSERT)
	Field Key_Delete:xInputButton = New xInputKey(mojo.input.KEY_DELETE)
	Field Key_F1:xInputButton = New xInputKey(mojo.input.KEY_F1)
	Field Key_F2:xInputButton = New xInputKey(mojo.input.KEY_F2)
	Field Key_F3:xInputButton = New xInputKey(mojo.input.KEY_F3)
	Field Key_F4:xInputButton = New xInputKey(mojo.input.KEY_F4)
	Field Key_F5:xInputButton = New xInputKey(mojo.input.KEY_F5)
	Field Key_F6:xInputButton = New xInputKey(mojo.input.KEY_F6)
	Field Key_F7:xInputButton = New xInputKey(mojo.input.KEY_F7)
	Field Key_F8:xInputButton = New xInputKey(mojo.input.KEY_F7)
	Field Key_F9:xInputButton = New xInputKey(mojo.input.KEY_F9)
	Field Key_F10:xInputButton = New xInputKey(mojo.input.KEY_F10)
	Field Key_F11:xInputButton = New xInputKey(mojo.input.KEY_F11)
	Field Key_F12:xInputButton = New xInputKey(mojo.input.KEY_F12)
	Field Key_1:xInputButton = New xInputKey(mojo.input.KEY_1)
	Field Key_2:xInputButton = New xInputKey(mojo.input.KEY_2)
	Field Key_3:xInputButton = New xInputKey(mojo.input.KEY_3)
	Field Key_4:xInputButton = New xInputKey(mojo.input.KEY_4)
	Field Key_5:xInputButton = New xInputKey(mojo.input.KEY_5)
	Field Key_6:xInputButton = New xInputKey(mojo.input.KEY_6)
	Field Key_7:xInputButton = New xInputKey(mojo.input.KEY_7)
	Field Key_8:xInputButton = New xInputKey(mojo.input.KEY_8)
	Field Key_9:xInputButton = New xInputKey(mojo.input.KEY_9)
	Field Key_0:xInputButton = New xInputKey(mojo.input.KEY_0)
	Field Key_A:xInputButton = New xInputKey(mojo.input.KEY_A)
	Field Key_B:xInputButton = New xInputKey(mojo.input.KEY_B)
	Field Key_C:xInputButton = New xInputKey(mojo.input.KEY_C)
	Field Key_D:xInputButton = New xInputKey(mojo.input.KEY_D)
	Field Key_E:xInputButton = New xInputKey(mojo.input.KEY_E)
	Field Key_F:xInputButton = New xInputKey(mojo.input.KEY_F)
	Field Key_G:xInputButton = New xInputKey(mojo.input.KEY_G)
	Field Key_H:xInputButton = New xInputKey(mojo.input.KEY_H)
	Field Key_I:xInputButton = New xInputKey(mojo.input.KEY_I)
	Field Key_J:xInputButton = New xInputKey(mojo.input.KEY_J)
	Field Key_K:xInputButton = New xInputKey(mojo.input.KEY_K)
	Field Key_L:xInputButton = New xInputKey(mojo.input.KEY_L)
	Field Key_M:xInputButton = New xInputKey(mojo.input.KEY_M)
	Field Key_N:xInputButton = New xInputKey(mojo.input.KEY_N)
	Field Key_O:xInputButton = New xInputKey(mojo.input.KEY_O)
	Field Key_P:xInputButton = New xInputKey(mojo.input.KEY_P)
	Field Key_Q:xInputButton = New xInputKey(mojo.input.KEY_Q)
	Field Key_R:xInputButton = New xInputKey(mojo.input.KEY_R)
	Field Key_S:xInputButton = New xInputKey(mojo.input.KEY_S)
	Field Key_T:xInputButton = New xInputKey(mojo.input.KEY_T)
	Field Key_U:xInputButton = New xInputKey(mojo.input.KEY_U)
	Field Key_V:xInputButton = New xInputKey(mojo.input.KEY_V)
	Field Key_W:xInputButton = New xInputKey(mojo.input.KEY_W)
	Field Key_X:xInputButton = New xInputKey(mojo.input.KEY_X)
	Field Key_Y:xInputButton = New xInputKey(mojo.input.KEY_Y)
	Field Key_Z:xInputButton = New xInputKey(mojo.input.KEY_Z)
	Field Key_Tilde:xInputButton = New xInputKey(mojo.input.KEY_TILDE)
	Field Key_Minus:xInputButton = New xInputKey(mojo.input.KEY_MINUS)
	Field Key_Equals:xInputButton = New xInputKey(mojo.input.KEY_EQUALS)
	Field Key_OpenBracket:xInputButton = New xInputKey(mojo.input.KEY_OPENBRACKET)
	Field Key_CloseBracket:xInputButton = New xInputKey(mojo.input.KEY_CLOSEBRACKET)
	Field Key_BackSlash:xInputButton = New xInputKey(mojo.input.KEY_BACKSLASH)
	Field Key_Semicolon:xInputButton = New xInputKey(mojo.input.KEY_SEMICOLON)
	Field Key_Quotes:xInputButton = New xInputKey(mojo.input.KEY_QUOTES)
	Field Key_Comma:xInputButton = New xInputKey(mojo.input.KEY_COMMA)
	Field Key_Period:xInputButton = New xInputKey(mojo.input.KEY_PERIOD)
	Field Key_Slash:xInputButton = New xInputKey(mojo.input.KEY_SLASH)
	
	Field Mouse_Left:xInputButton = New xInputMouse(mojo.input.KEY_LMB)
	Field Mouse_Right:xInputButton = New xInputMouse(mojo.input.KEY_RMB)
	Field Mouse_Middle:xInputButton = New xInputMouse(mojo.input.KEY_MMB)
	
	Field Joy_A:xInputButton = New xInputKey(mojo.input.KEY_JOY0_A)
	Field Joy_B:xInputButton = New xInputKey(mojo.input.KEY_JOY0_B)
	Field Joy_X:xInputButton = New xInputKey(mojo.input.KEY_JOY0_X)
	Field Joy_Y:xInputButton = New xInputKey(mojo.input.KEY_JOY0_Y)
	Field Joy_Lelft:xInputButton = New xInputKey(mojo.input.KEY_JOY0_LEFT)
	Field Joy_Up:xInputButton = New xInputKey(mojo.input.KEY_JOY0_UP)
	Field Joy_Right:xInputButton = New xInputKey(mojo.input.KEY_JOY0_RIGHT)
	Field Joy_Down:xInputButton = New xInputKey(mojo.input.KEY_JOY0_DOWN)
	
	Field Touch_0:xInputButton = New xInputTouch(mojo.input.KEY_TOUCH0, 0)
	Field Touch_1:xInputButton = New xInputTouch(mojo.input.KEY_TOUCH0 + 1, 1)
	Field Touch_2:xInputButton = New xInputTouch(mojo.input.KEY_TOUCH0 + 2, 2)
	Field Touch_3:xInputButton = New xInputTouch(mojo.input.KEY_TOUCH0 + 3, 3)
	Field Touch_4:xInputButton = New xInputTouch(mojo.input.KEY_TOUCH0 + 4, 4)
	
	Field IsAnyTouchDown:Bool = False
	Field IsAnyTouchPress:Bool = False
	Field IsAnyTouchUp:Bool = False
	Field IsAnyTouch:Bool = False
	Field IsAnyDoubleTouch:Bool = False
	Field IsAnyKeyDown:Bool = False
	Field IsAnyKeyPress:Bool = False
	Field IsAnyKeyUp:Bool = False
	Field IsAnyKeyHit:Bool = False
	Field IsAnyKeyDoubleHit:Bool = False
	Field LastTouchPosition:= New xPoint()
	
	Method MouseX:Float()
		Return mojo.MouseX() / xApplication.ScreenRatioX
	End
	
	Method MouseY:Float()
		Return mojo.MouseY() / xApplication.ScreenRatioY
	End

	
	Method Update:Void()
		Self.IsAnyTouchDown = False
		Self.IsAnyTouchPress = False
		Self.IsAnyTouchUp = False
		Self.IsAnyTouch = False
		Self.IsAnyDoubleTouch = False
		Self.IsAnyKeyDown = False
		Self.IsAnyKeyPress = False
		Self.IsAnyKeyUp = False
		Self.IsAnyKeyHit = False
		Self.IsAnyKeyDoubleHit = False
	
		Self.Key_Backspace.Update()
		Self.Key_Tab.Update()
		Self.Key_Enter.Update()
		Self.Key_Escape.Update()
		Self.Key_Space.Update()
		Self.Key_Shift.Update()
		Self.Key_Control.Update()
		Self.Key_PageUp.Update()
		Self.Key_PageDown.Update()
		Self.Key_Home.Update()
		Self.Key_Left.Update()
		Self.Key_Up.Update()
		Self.Key_Right.Update()
		Self.Key_Down.Update()
		Self.Key_Insert.Update()
		Self.Key_Delete.Update()
		Self.Key_F1.Update()
		Self.Key_F2.Update()
		Self.Key_F3.Update()
		Self.Key_F4.Update()
		Self.Key_F5.Update()
		Self.Key_F6.Update()
		Self.Key_F7.Update()
		Self.Key_F8.Update()
		Self.Key_F9.Update()
		Self.Key_F10.Update()
		Self.Key_F11.Update()
		Self.Key_F12.Update()
		Self.Key_1.Update()
		Self.Key_2.Update()
		Self.Key_3.Update()
		Self.Key_4.Update()
		Self.Key_5.Update()
		Self.Key_6.Update()
		Self.Key_7.Update()
		Self.Key_8.Update()
		Self.Key_9.Update()
		Self.Key_0.Update()
		Self.Key_A.Update()
		Self.Key_B.Update()
		Self.Key_C.Update()
		Self.Key_D.Update()
		Self.Key_E.Update()
		Self.Key_F.Update()
		Self.Key_G.Update()
		Self.Key_H.Update()
		Self.Key_I.Update()
		Self.Key_J.Update()
		Self.Key_K.Update()
		Self.Key_L.Update()
		Self.Key_M.Update()
		Self.Key_N.Update()
		Self.Key_O.Update()
		Self.Key_P.Update()
		Self.Key_Q.Update()
		Self.Key_R.Update()
		Self.Key_S.Update()
		Self.Key_T.Update()
		Self.Key_U.Update()
		Self.Key_V.Update()
		Self.Key_W.Update()
		Self.Key_X.Update()
		Self.Key_Y.Update()
		Self.Key_Z.Update()
		Self.Key_Tilde.Update()
		Self.Key_Minus.Update()
		Self.Key_Equals.Update()
		Self.Key_OpenBracket.Update()
		Self.Key_CloseBracket.Update()
		Self.Key_BackSlash.Update()
		Self.Key_Semicolon.Update()
		Self.Key_Quotes.Update()
		Self.Key_Comma.Update()
		Self.Key_Period.Update()
		Self.Key_Slash.Update()	
		
		Self.Mouse_Left.Update()
		Self.Mouse_Right.Update()
		Self.Mouse_Middle.Update()
		
		Self.Joy_A.Update()
		Self.Joy_B.Update()
		Self.Joy_X.Update()
		Self.Joy_Y.Update()
		Self.Joy_Lelft.Update()
		Self.Joy_Up.Update()
		Self.Joy_Right.Update()
		Self.Joy_Down.Update()
		
		Self.Touch_0.Update()
		Self.Touch_1.Update()
		Self.Touch_2.Update()
		Self.Touch_3.Update()
		Self.Touch_4.Update()

	End
End


Class xInputButton

Public

	Field Status:Int = 0
	Field Key:Int
	Field LastTime:Int
		
	Method IsDown:Bool()
		If Self.Status = INPUT_STATUS_DOWN
			Return True
		End
		
		Return False
	End
	
	Method IsPress:Bool(time:Int = 0)
		If Self.Status = INPUT_STATUS_PRESSED
			If xClockManager.GetTimeSinceStart()-Self.LastTime > time
				Self.LastTime = xClockManager.GetTimeSinceStart()
				Return True
			End
		End
				
		Return False
	End
	
	Method IsUp:Bool()
		If Self.Status = INPUT_STATUS_UP
			Return True
		End
		
		Return False
	End
	
	Method IsPushed:Bool()
		If Self.Status = INPUT_STATUS_UP
			Return true
		End
		
		Return false
	End
	
	Method IsDoublePushed:Bool()
		If Self._pushedTimes = 2
			Return true
		End
		
		Return false
	End
	
	Method Update:Void() Abstract
	
	
Private
	
	Field _pushedTimes:Int = 0
	Field _pushedLastTime:Int = 0
	
End

Class xInputKey Extends xInputButton

	Method New(key:Int)
		Self.Key = key
	End

	Method Update:Void()
		If KeyDown(Self.Key) = True
			Select Self.Status 
				Case INPUT_STATUS_DOWN
					Self.Status = INPUT_STATUS_PRESSED
					xInput.IsAnyKeyPress = True
				Case INPUT_STATUS_NONE
					Self.Status = INPUT_STATUS_DOWN
					Self.LastTime = xClockManager.GetTimeSinceStart()-10000
					xInput.IsAnyKeyDown = True
				Case INPUT_STATUS_PRESSED
					xInput.IsAnyKeyPress = True
			End
		Else
			If Self.Status = INPUT_STATUS_DOWN Or Self.Status = INPUT_STATUS_PRESSED
				Self.Status = INPUT_STATUS_UP
				xInput.IsAnyKeyUp = True
				xInput.IsAnyKeyHit = True
				
				If Self._pushedTimes = 0
					Self._pushedTimes = 1
					Self._pushedLastTime = Millisecs()
				Else If Self._pushedTimes = 1 And Millisecs() - Self._pushedLastTime <= xInput.DoublePushTime
					Self._pushedTimes = 2
					xInput.IsAnyKeyDoubleHit = True
				End
			Else 
				Self.Status = INPUT_STATUS_NONE
				
				If Self._pushedTimes = 2
					Self._pushedTimes = 0
				Else If Self._pushedTimes = 1 And Millisecs() - Self._pushedLastTime > xInput.DoublePushTime
					Self._pushedTimes = 0
				End
			End
		End
	End
	
Private
	
	Field _pushedTimes:Int = 0
	Field _pushedLastTime:Int = 0
	
End

Class xInputMouse Extends xInputButton

	Field Position:= New xPoint()

	Method New(key:Int)
		Self.Key = key
	End

	Method Update:Void()
		If KeyDown(Self.Key) = True
			Self.Position.Set(MouseX(), MouseY())
		
			Select Self.Status 
				Case INPUT_STATUS_DOWN
					Self.Status = INPUT_STATUS_PRESSED
					xInput.IsAnyTouchPress = True
				Case INPUT_STATUS_NONE
					Self.Status = INPUT_STATUS_DOWN
					Self.LastTime = xClockManager.GetTimeSinceStart()-10000
					xInput.IsAnyTouchDown = True
				Case INPUT_STATUS_PRESSED
					xInput.IsAnyTouchPress = True
			End
		Else
			If Self.Status = INPUT_STATUS_DOWN Or Self.Status = INPUT_STATUS_PRESSED
				Self.Status = INPUT_STATUS_UP
				xInput.IsAnyTouchUp = True
				xInput.IsAnyTouch = True
				
				If Self._pushedTimes = 0
					Self._pushedTimes = 1
					Self._pushedLastTime = Millisecs()
				Else If Self._pushedTimes = 1 And Millisecs() - Self._pushedLastTime <= xInput.DoublePushTime
					Self._pushedTimes = 2
					xInput.IsAnyDoubleTouch = True
				End
			Else 
				Self.Status = INPUT_STATUS_NONE
				
				If Self._pushedTimes = 2
					Self._pushedTimes = 0
				Else If Self._pushedTimes = 1 And Millisecs() - Self._pushedLastTime > xInput.DoublePushTime
					Self._pushedTimes = 0
				End
			End
		End
	End
	
Private
	
	Field _pushedTimes:Int = 0
	Field _pushedLastTime:Int = 0
	
End


Class xInputTouch Extends xInputButton

	Field Position:= New xPoint()
	Field Index:Int = 0

	Method New(key:Int, index:Int)
		Self.Key = key
		Self.Index = index
	End

	Method Update:Void()
		If KeyDown(Self.Key) = True
			Self.Position.Set(TouchX(Self.Index), TouchY(Self.Index))
			xInput.LastTouchPosition.Set(Self.Position)
		
			Select Self.Status
				Case INPUT_STATUS_DOWN
					Self.Status = INPUT_STATUS_PRESSED
					xInput.IsAnyTouchPress = True
				Case INPUT_STATUS_NONE
					Self.Status = INPUT_STATUS_DOWN
					Self.LastTime = xClockManager.GetTimeSinceStart()-10000
					xInput.IsAnyTouchDown = True
				Case INPUT_STATUS_PRESSED
					xInput.IsAnyTouchPress = True
			End
		Else
			If Self.Status = INPUT_STATUS_DOWN Or Self.Status = INPUT_STATUS_PRESSED
				Self.Status = INPUT_STATUS_UP
				xInput.IsAnyTouchUp = True
				xInput.IsAnyTouch = True
				
				If Self._pushedTimes = 0
					Self._pushedTimes = 1
					Self._pushedLastTime = Millisecs()
				Else If Self._pushedTimes = 1 And Millisecs() - Self._pushedLastTime <= xInput.DoublePushTime
					Self._pushedTimes = 2
					xInput.IsAnyDoubleTouch = True
				End
			Else 
				Self.Status = INPUT_STATUS_NONE
				
				If Self._pushedTimes = 2
					Self._pushedTimes = 0
				Else If Self._pushedTimes = 1 And Millisecs() - Self._pushedLastTime > xInput.DoublePushTime
					Self._pushedTimes = 0
				End
			End
		End
	End
	
Private
	
	Field _pushedTimes:Int = 0
	Field _pushedLastTime:Int = 0
	
End
