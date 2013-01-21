Strict

Import xengine.components.entity
Import xengine.basics.color

Class xScene Extends xEntity

Public

	'Constructors
	'------------------------------------------------------
	Method New()
		Self.Id = NewId("Scene")
		Self.Scene = Self
		Super.Initialize()
	End
	
	Method New(id:String)
		Self.Id = id
		Self.Scene = Self
		Super.Initialize()
	End
	
	Method New(id:String, width:Float, height:Float)
		Self.Id = id
		Self.SetSize(width, height)
		Self.Scene = Self
		Super.Initialize()
	End
	
	Method New(id:String, width:Float, height:Float, position:xVector)
		Self.Id = id
		Self.SetSize(width, height)
		Self.SetPosition(position)
		Self.Scene = Self
		Super.Initialize()
	End
	'------------------------------------------------------
	
	'Update
	'------------------------------------------------------
	Method Update:Void()
		Super.Update()
		
		If Self._follow = True
			'TODO: descomentar abajo, para hacer el seguimiento de la camara
'			Local __d:xVector = Self.GetAnchor().Clone().Subtract(Self._followingEntity.GetAnchorPosition())
'			__d.X+=Self._cameraPosition.X
'			__d.Y+=Self._cameraPosition.Y
'			Self.MoveCamera(-__d.X, -__d.Y)
		End
		
	End
	
	'Render
	'------------------------------------------------------
	Method Render:Void()
		If Self.IsVisible()= True
			Local scissors:float[] = graphics.GetScissor()
			Local scissorW:Float = Self.GetWidth()
			Local scissorH:Float = 	Self.GetHeight()
			If scissorW <= 0
				scissorW = 0
			End
			If scissorH <= 0
				scissorH = 0
			End
			SetScissor(Self.GetX() * xApplication.ScreenRatioX, Self.GetY() * xApplication.ScreenRatioY, scissorW, scissorH)
			
			If Self._clearScreen = true
				Self._clearScreenColor.ClearScreen()
			End
			
			PushMatrix()
				Local __x:Float = Self.GetPosition().X + Self.GetAnchorX()
				Local __y:Float = Self.GetPosition().Y + Self.GetAnchorY()
				graphics.Translate(__x, __y)
				graphics.Rotate(Self._cameraRotation)
				graphics.Scale(Self._cameraZoom/100, Self._cameraZoom/100)
				graphics.Translate(-Self.GetAnchorX(), -Self.GetAnchorY())
				graphics.Translate(-Self._cameraPosition.X, -Self._cameraPosition.Y)

				Self.DoInnerStuffs()
				
				graphics.SetAlpha(Self.GetAlpha())
				
				Local __colorChanged:Bool = False
				If Self.GetColor().GetRed() <> 255 Or Self.GetColor().GetGreen() <> 255 Or Self.GetColor().GetBlue() <> 255
					graphics.SetColor(Self.GetColor().GetRed(), Self.GetColor().GetGreen(), Self.GetColor().GetBlue())
					__colorChanged = True
				End
				
				If Self.GetAttachedList().Count() > 0
					For Local attached:xEntity = eachin Self.GetAttachedList()
						attached.Render()
					Next
				End
				
				If __colorChanged = True
					graphics.SetColor(255, 255, 255)
				End
			PopMatrix()
			
			Self.SelfRender()
			
			SetScissor(scissors[0], scissors[1], scissors[2], scissors[3])
			
			If (Self.IsShowingAnchor())
				xHelper.Draw.Anchor(Self.GetX()+Self.GetAnchorX(), Self.GetY()+Self.GetAnchorY())
			End
		End
	End
	
	'Self Render
	'------------------------------------------------------
	Method SelfRender:Void()
	End
	
	'Anchor related methods
	'------------------------------------------------------
	Method SetAnchorPoint:Void(vector:xVector)
		Self._anchorPointSetted = True
		Super.SetAnchorPoint(vector)
	End
	
	Method SetAnchorPoint:Void(x:Float, y:Float)
		Self._anchorPointSetted = True
		Super.SetAnchorPoint(x, y)
	End
	
	Method UnsetAnchorPoint:Void()
		Self._anchorPointSetted = False
	End
	'------------------------------------------------------
	
	'Rotation related methods
	'------------------------------------------------------
	Method SetRotation:Void(value:Float)
	End
	'------------------------------------------------------
	
	'Size and Scales related methods
	'------------------------------------------------------
	Method SetSize:Void(width:Float, height:Float)
		Super.SetSize(width,  height)
		
		If Self._anchorPointSetted = False
			Super.SetAnchor(width/2, height/2)
		End 
	End
	
	Method Expand:Void()
		Self.SetSize(xApplication.DeviceWidth, xApplication.DeviceHeight)
	End
	
'	Method GetWidth:Float()
'		Return Self.GetBaseWidth()*xGame.ScreenRatioX
'	End
'	
'	Method GetHeight:Float()
'		Return Self.GetBaseHeight()*xGame.ScreenRatioY
'	End
	
'	Method SetWidthScale:Void(value:Float)
'		Super.SetWidthScale(value)
'
'		If Self._anchorPointSetted = False
'			Super.GetAnchor().X = value/2
'		End 
'	End
'	
'	Method SetHeightScale:Void(value:float)
'		Super.SetHeightScale(value)
'		
'		If (Self._anchorPointSetted = False)
'			Super.GetAnchor().Y = value/2
'		End 
'	End
'	
'	Method SetScales:Void(x:Float, y:Float)
'		Super.SetScales(x, y)
'		
'		If (Self._anchorPointSetted = False)
'			Super.SetAnchor(x/2, y/2)
'		End 
'	End
	'------------------------------------------------------
	
	'Incremental methods
	'------------------------------------------------------
	Method Rotate:Void(value:Float, clock:xClock = null)
	End
	
	Method Scale:Void(value:Float, clock:xClock = null)
		Super.Scale(value, clock)
		Super.SetAnchor(Self.GetWidth()/2, Self.GetHeight()/2)
	End
	
	Method ScaleWidth:Void(value:Float, clock:xClock = null)
		Super.ScaleWidth(value, clock)
		Super.SetAnchor(Self.GetWidth()/2, Self.GetHeight()/2)
	End
	
	Method ScaleHeight:Void(value:Float, clock:xClock = null)
		Super.ScaleHeight(value, clock)
		Super.SetAnchor(Self.GetWidth()/2, Self.GetHeight()/2)
	End
	'------------------------------------------------------
	
	'Camera methods
	'------------------------------------------------------
	Method SetCameraPosition:Void(x:Float, y:Float)
		Self._cameraPosition.Set(x, y)
	End
	
	Method SetCameraPosition:Void(vector:xVector)
		Self._cameraPosition.Set(vector.X, vector.Y)
	End
	
	Method SetCameraX:Void(value:Float)
		Self._cameraPosition.X = value
	End
	
	Method SetCameraY:Void(value:Float)
		Self._cameraPosition.Y = value
	End
	
	Method GetCameraPosition:xVector()
		Return Self._cameraPosition
	End
	
	Method SetCameraRotation:Void(value:Float)
		Self._cameraRotation = value
		If (Self._cameraRotation > 360)
			Self._cameraRotation-=360
		End
		
		If (Self._cameraRotation < -360)
			Self._cameraRotation+=360
		End
	End
	
	Method GetCameraRotation:Float()
		Return Self._cameraRotation
	End
	
	Method SetCameraZoom:Void(value:float)
		Self._cameraZoom = value
	End
	
	Method GetCameraZoom:Float()
		Return Self._cameraZoom
	End
	
	Method SetClearScreen:Void(value:Bool = True)
		Self._clearScreen = value
	End
	
	Method SetClearScreen:Void(value:Bool = True, color:xColor)
		Self._clearScreen = value
		If (color <> Null)
			Self.SetClearScreenColor(color)
		End
	End
	
	Method SetClearScreenColor:Void(color:xColor, clear:Bool = True)
		Self._clearScreenColor = color
		Self.SetClearScreen(clear)
	End
	
	Method SetClearScreenColor:Void(red:Int, green:Int, blue:Int, clear:Bool = True)
		Self._clearScreenColor.Set(red, green, blue)
		Self.SetClearScreen(clear)
	End
	'------------------------------------------------------
	
	'Incremental camera methods
	'------------------------------------------------------
 	Method MoveCamera:Void(x:Float, y:Float, clock:xClock = null)
		Local __x:Float
		Local __y:Float
		
		If (clock = null)
			__x = x*xClockManager.GetDeltaTime()
			__y = y*xClockManager.GetDeltaTime()
		Else
			__x = x*clock.GetDeltaTime()
			__y = y*clock.GetDeltaTime()
		End
	
		Self._cameraPosition.X+=__x
		Self._cameraPosition.Y+=__y
	End
	
	Method MoveCameraX:Void(value:Float, clock:xClock = null)
		Local __value:Float
		
		If (clock = null)
			__value = value*xClockManager.GetDeltaTime()
		Else
			__value = value*clock.GetDeltaTime()
		End
		
		Self._cameraPosition.X+=__value
	End
	
	Method MoveCameraY:Void(value:Float, clock:xClock = null)
		Local __value:Float
		
		If (clock = null)
			__value = value*xClockManager.GetDeltaTime()
		Else
			__value = value*clock.GetDeltaTime()
		End
		
		Self._cameraPosition.Y+=__value
	End
	
	Method RotateCamera:Void(value:Float, clock:xClock = null)
		Local __value:Float
		
		If (clock = null)
			__value = value*xClockManager.GetDeltaTime()
		Else
			__value = value*clock.GetDeltaTime()
		End
		
		Self.SetCameraRotation(Self.GetCameraRotation()+__value)
	End
	
	Method ZoomCamera:Void(value:Float, clock:xClock = null)
		Local __value:Float
		
		If (clock = null)
			__value = value*xClockManager.GetDeltaTime()
		Else
			__value = value*clock.GetDeltaTime()
		End
	
		Self._cameraZoom+=__value
	End
	'------------------------------------------------------
	
	'Extended camera methods
	'------------------------------------------------------
	Method FollowEntity:Void(entity:xEntity)
		Self._followingEntity = entity
	End
	
	Method StartFollow:Void()
		Self._follow = True
	End
	
	Method StopFollow:Void()
		Self._follow = False
	End
	
	Method ToggleFollow:Void()
		Self._follow = Not Self._follow
	End
	
	Method IsFollowing:Bool()
		Return Self._follow
	End 
	'------------------------------------------------------
	
	
	'Set the CheckZ system status
	'To get what actor have great Z in the scene, to perform events on that actor and not the others
	'------------------------------------------------------
	Method SetCheckZ:Void(value:Bool = True)
		Self._checkZ = value
	End
	
	Method GetCheckZ:Bool()
		Return Self._checkZ
	End
	
	'Overwrited methods
	'------------------------------------------------------
	Method GetGlobalPosition:xVector()
		Return Self.GetPosition()
	End
	
	Method RegisterEntity:Void(ent:xEntity)
		Self._registeredEntities.AddLast(ent)
	End
	
	Method GetWidthScale:Float()
		Return Self._cameraZoom/100
	End
	
	Method GetHeightScale:Float()
		Return Self._cameraZoom/100
	End
	
Private
	
	Field _cameraPosition:xVector = new xVector()
	Field _cameraRotation:Float = 0
	Field _cameraZoom:Float = 100
	
	Field _followingEntity:xEntity
	Field _follow:Bool = False
	
	Field _anchorPointSetted:Bool = False
	
	Field _clearScreen:Bool = False
	Field _clearScreenColor:xColor = New xColor(0,0,0)
	
	Field _checkZ:Bool = False
	
	Method _getTotalRotation:Float()
		Return Self._cameraRotation
	End

End
