Strict

Import mojo
Import xengine.game.clock
Import xengine.fx.transition

Global xApplication:xApplicationClass


Class xApplicationClass Extends App

Public

	Const DEFAULT_UPDATE_RATE:Int = 60
	
	Field DeviceWidth:Int
	Field DeviceHeight:Int
	Field ScreenWidth:Int
	Field ScreenHeight:Int
	Field ScreenRatioX:Float
	Field ScreenRatioY:Float

	' Add code here to be executed when you intialize the Application
	Method Initialize:Void() Abstract
			
	' Add code here to be executed every update call
	Method Update:Void() Abstract
	
	' Add code here to be executed every render call
	Method Render:Void() Abstract
	
	' Add code here to be executed when the application is still loading
	Method Loading:Void()
	End
	
	' Add code here to be executed when the application get suspended
	Method Suspend:Void()
	End
	
	' Add code here to be executed when the application get resumed
	Method Resume:Void()
	End
	
	' Set the Update rate
	Method SetUpdateRate:Void(rate:Int)
		Self._updateRate = rate
		mojo.SetUpdateRate(rate)
	End
	
	' Get the update rate
	Method GetUpdateRate:Int()
		Return Self._updateRate
	End
	
	Method SetVirtualResolution:Void(width:Int, height:Int)
		Self.ScreenWidth = width
		Self.ScreenHeight = height
		Self.ScreenRatioX = Float(Self.DeviceWidth) / Float(Self.ScreenWidth)
		Self.ScreenRatioY = Float(Self.DeviceHeight) / Float(Self.ScreenHeight)

		If Self.ScreenRatioX <> 1 Or Self.ScreenRatioY <> 1
			Self._virtualResolution = True
		Else
			Self._virtualResolution = False
		End
	End
	
	
Private
	
	Method OnCreate:Int()
		xApplication = Self
		
		Self.DeviceWidth = graphics.DeviceWidth()
		Self.DeviceHeight = graphics.DeviceHeight()
		
		Seed = Millisecs()
		
		Self.SetVirtualResolution(Self.DeviceWidth, Self.DeviceHeight)
		
		Self.SetUpdateRate(DEFAULT_UPDATE_RATE)
		xClockManager.Start()
		
		Self.Initialize()
		Return 0
	End
	
	Method OnLoading:Int()
		Self.Loading()
		Return 0
	End
	
	Method OnUpdate:Int()
		xClockManager.Update()
		xTransitionManager.Update()
		xInput.Update()
		
		Self.Update()
		Return 0
	End
	
	Method OnSuspend:Int()
		Self.Suspend()
		Return 0
	End
	
	Method OnResume:Int()
		Self.Resume()
		Return 0
	End
	
	' See monkey help for details
	Method OnRender:Int()
		If Self._virtualResolution
			PushMatrix()
			
				graphics.Scale(Self.ScreenRatioX, Self.ScreenRatioY)
				
				Self.Render()
				
			PopMatrix()
		Else
			Self.Render()  
		End
		
		Return 0	
	End

	Field _virtualResolution:Bool = False
	Field _updateRate:Int = 0
		
End