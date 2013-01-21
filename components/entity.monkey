Strict

Import mojo
Import xengine.application
Import xengine.globals
Import xengine.components.component
Import xengine.basics.vector
Import xengine.basics.size
Import xengine.basics.list
Import xengine.components.scene
Import xengine.helpers


Class xEntity Extends xComponent Abstract

Public

	Field Scene:xScene
	
	Field _collisionShapes:= New xList<xCollisionShape>
	
	'General methods
	'------------------------------------------------------
	'Update
	Method Update:Void()
		For Local attached:xEntity = eachin Self._attachedEntities
			attached.Update()
		Next
	End
	
	'Render all the stuffs
	'------------------------------------------------------
	Method Render:Void()
		If Self.IsVisible() = True

			PushMatrix()
				Local __x:Float = Self._position.X + Self._anchorPoint.X
				Local __y:Float = Self._position.Y + Self._anchorPoint.Y
				
'				If Self._attachedOn <> null
'					graphics.Translate(-Self._attachedOn.GetX(), -Self._attachedOn.GetY())	
'				End
				
				graphics.Translate(Self._position.X, Self._position.Y) 'Testing
				'graphics.Translate(__x, __y) 'Oficial
				graphics.Rotate(Self._rotation)
				graphics.Scale(Self._scales.X, Self._scales.Y)
				graphics.Translate(-Self._anchorPoint.X, -Self._anchorPoint.Y) 'Testing
				'graphics.Translate(-Self._anchorPoint.X, -Self._anchorPoint.Y) 'Oficial
				
				
				Self.DoInnerStuffs()
				' Added -1 to x and y values, because in browsers(tested until now, i'm using demoversion) the sum show the correct value plus 1
'				Self._matrix = GetMatrix()
'				Self._screenPosition.Set((Self._matrix[0] + Self._matrix[2] + Self._matrix[4]-1)/xGame.ScreenRatioX, (Self._matrix[1] + Self._matrix[3] + Self._matrix[5]-1)/xGame.ScreenRatioY)
'				Self.CalculateRegion()
			
			
			If Self._alignDo = True
				
			PopMatrix()
			
			PushMatrix()
				'Align stuffs
				Self._makeAlign()
				
				graphics.Translate(Self._position.X, Self._position.Y) 'Testing
				'graphics.Translate(__x, __y) 'Original
				graphics.Rotate(Self._rotation)
				graphics.Scale(Self._scales.X, Self._scales.Y)
				graphics.Translate(-Self._anchorPoint.X, -Self._anchorPoint.Y) 'Testing
				'graphics.Translate(-Self._anchorPoint.X, -Self._anchorPoint.Y) 'Original
				
				Self.DoInnerStuffs()
			End	
			
			Local __alphaSetted:Float = graphics.GetAlpha()
			Local __alphaParent:Bool = False
			
			if  __alphaSetted < Self._alpha
				graphics.SetAlpha(__alphaSetted)
				__alphaParent = True
			Else
				graphics.SetAlpha(Self._alpha)
			End
			
			
			Local __colorChanged:Bool = False
			If Self._color.GetRed() <> 255 Or Self._color.GetGreen() <> 255 Or Self._color.GetBlue() <> 255
				graphics.SetColor(Self._color.GetRed(), Self._color.GetGreen(), Self._color.GetBlue())
				__colorChanged = True
			End
			
			Self.RenderAttachs()
			
			If __colorChanged = True
				graphics.SetColor(255, 255, 255)
			End
			
			If __alphaSetted  <> 1
				graphics.SetAlpha(__alphaSetted)
			Else
				graphics.SetAlpha(1)
			End
			
			If Self.IsShowingAnchor() = True
				xHelper.Draw.Anchor(Self._anchorPoint.X, Self._anchorPoint.Y)
			End
				
			PopMatrix()
		End
	End
	
	'AttachRender
	Method RenderAttachs:Void()
		Local __selfRendered:Bool = False
				
		If Self._attachedEntities.Count() > 0
			For Local attached:xEntity = eachin Self._attachedEntities
				If (Self.GetZ() <= attached.GetZ() And __selfRendered = False)
					Self.SelfRender()
					__selfRendered = True
				End
				attached.Render()
			Next
		End
		
		If __selfRendered = False
			Self.SelfRender()
		End
	End

	'Render of self object stuffs
	Method SelfRender:Void() Abstract
	
	Method DoInnerStuffs:Void()
		' Added -1 to x and y values, because in browsers(tested until now, i'm using demoversion) the sum show the correct value plus 1
		Self._matrix = GetMatrix()
		Self._screenPosition.Set( (Self._matrix[0] + Self._matrix[2] + Self._matrix[4] - 1) / xApplication.ScreenRatioX, (Self._matrix[1] + Self._matrix[3] + Self._matrix[5] - 1) / xApplication.ScreenRatioY)
		
		Self.CalculateRegion()
		
		'If Scene
'		Self._rectangle.SetPosition(Self.GetPosition().X, Self.GetPosition().Y)
'		Self._rectangle.SetSize(Self.GetBaseWidth(), Self.GetBaseHeight())
'		
'		Self._region.Point1.Set(Self.GetPosition().X, Self.GetPosition().Y)
'		Self._region.Point2.Set(Self.GetPosition().X+Self.GetBaseWidth(), Self.GetPosition().Y)
'		Self._region.Point3.Set(Self.GetPosition().X+Self.GetBaseWidth(), Self.GetPosition().Y+Self.GetBaseHeight())
'		Self._region.Point4.Set(Self.GetPosition().X, Self.GetPosition().Y+Self.GetBaseHeight())
	End

	
	'Anchor methods
	'------------------------------------------------------
	Method SetAnchor:Void(vector:xVector)
		Self._anchorPoint.Set(vector.X, vector.Y)
	End
	
	Method SetAnchor:Void(x:Float, y:Float)
		Self._anchorPoint.Set(x, y)
	End
	
	Method SetAnchorX:Void(value:Float)
		Self._anchorPoint.X = value
	End
	
	Method SetAnchorY:Void(value:Float)
		Self._anchorPoint.Y = value
	End
	
	Method GetAnchor:xVector()
		Return Self._anchorPoint
	End
	
	Method GetAnchorX:Float()
		Return Self._anchorPoint.X
	End
	
	Method GetAnchorY:Float()
		Return Self._anchorPoint.Y
	End
	
	
	'Position method
	'------------------------------------------------------
	Method SetX:Void(value:Float)
		Self._position.X = value
		Self._screenPosition.X = value
	End
	
	Method SetY:Void(value:Float)
		Self._position.Y = value
		Self._screenPosition.Y = value
	End
	
	Method SetPosition:Void(x:Float, y:Float)
		Self._position.Set(x, y)
		Self._screenPosition.Set(x, y)
	End
	
	Method SetPosition:Void(vector:xVector)
		Self._position.Set(vector)
		Self._screenPosition.Set(vector)
	End
	
	Method GetPosition:xVector()
		Return Self._position
	End
	
	Method GetX:Float()
		Return Self._position.X
	End
	
	Method GetY:Float()
		Return Self._position.Y
	End
	
	Method GetAbsolutePosition:xVector()
		Return Self._screenPosition
	End
	
	Method GetAbsoluteX:Float()
		Return Self._screenPosition.X
	End
	
	Method GetAbsoluteY:Float()
		Return Self._screenPosition.Y
	End
	
	Method SetZ:Void(value:Int)
		Self._z = value
		If Self._attachedOn
			Self._attachedOn.SortAttacheds()
		End
	End
	
	Method GetZ:Int()
		Return Self._z
	End
	'------------------------------------------------------
	
	'Rotation related methods
	'------------------------------------------------------
	Method SetRotation:Void(value:Float)
		Self._rotation = value
		
		If Self._rotation > 360
			Self._rotation-=360
		End
		
		If Self._rotation < -360
			Self._rotation+=360
		End
	End
	
	Method GetRotation:Float()
		Return Self._rotation
	End
	'------------------------------------------------------
	
	'Size and Scales related methods
	'------------------------------------------------------
	Method SetSize:Void(width:Float, height:Float)
		Self._size.X = width * xApplication.ScreenRatioX
		Self._size.Y = height * xApplication.ScreenRatioY
		Self._baseSize.X = width
		Self._baseSize.Y = height
	End
	
'	Method GetSize:xVector()
'		Return Self._size
'	End
	
	Method SetWidth:Void(value:Float)
		Self._size.X = value*xGame.ScreenRatioX
		Self._baseSize.X = value
	End
	
	Method GetWidth:Float()
		Local __sceneZoom:Float = 1
		If Self.Scene <> null And Self.Scene <> Self
			__sceneZoom = Self.GetTotalWidthScale()
		End
		Return Self._size.X * Self._scales.X * __sceneZoom / xApplication.ScreenRatioX
	End
	
	Method SetHeight:Void(value:Float)
		Self._size.Y = value*xGame.ScreenRatioY
		Self._baseSize.Y = value
	End
	
	Method GetHeight:Float()
		Local __sceneZoom:Float = 1
		If Self.Scene <> null And Self.Scene <> Self
			__sceneZoom = Self.GetTotalHeightScale()
		End
		Return Self._size.Y * Self._scales.Y * __sceneZoom / xApplication.ScreenRatioY
	End
	
	Method GetBaseWidth:Float()
		Return Self._baseSize.X
	End
	
	Method GetBaseHeight:Float()
		Return Self._baseSize.Y
	End
	
	Method SetWidthScale:Void(value:Float)
		Self._scales.X  = value
	End
	
	Method GetWidthScale:Float()
		Return Self._scales.X
	End
	
	Method SetHeightScale:Void(value:float)
		Self._scales.Y  = value
	End
	
	Method GetHeightScale:Float()
		Return Self._scales.Y
	End
	
	Method SetScales:Void(x:Float, y:Float)
		Self._scales.Set(x, y)
	End
	
	Method GetScales:xVector()
		Return Self._scales
	End
	
	Method SetColor:Void(red:Int = 255, green:Int = 255, blue:Int = 255)
		Self._color.Set(red, green, blue)
	End
	
	Method SetColor:Void(color:xColor)
		Self._color.Set(color.GetRed(), color.GetGreen(), color.GetBlue())
	End
	
	Method GetColor:xColor()
		Return Self._color
	End
	
	Method SetAlpha:Void(value:Float)
		Local __ta:Float = value - Self._alpha
		Self._alpha = value
		
		For Local attached:xEntity = eachin Self._attachedEntities
			attached.SetAlpha(attached.GetAlpha() + __ta)
		Next
	End
	
	Method GetAlpha:Float()
		Return Self._alpha
	End
	'------------------------------------------------------
	
	
	'Incremental methods
	'------------------------------------------------------
	Method Offset:Void(x:Float, y:Float)
		Self._position.Add(x, y)
	End
	
	Method OffsetX:Void(x:Float)
		Self._position.Add(x, 0)
	End
	
	Method OffsetY:Void(y:Float)
		Self._position.Add(0, y)
	End
	
	Method Move:Void(x:Float, y:Float, clock:xClock = null)
		Local __valueX:Float
		Local __valueY:Float
		
		If clock = null
			__valueX = x*xClockManager.GetDeltaTime()
			__valueY = y*xClockManager.GetDeltaTime()
		Else
			__valueX = x*clock.GetDeltaTime()
			__valueY = y*clock.GetDeltaTime()
		End
		
		Self._position.X+=__valueX
		Self._position.Y+=__valueY
	End
	
	Method MoveX:Void(value:Float, clock:xClock = null)
		Local __value:Float
		
		If clock = null
			__value = value*xClockManager.GetDeltaTime()
		Else
			__value = value*clock.GetDeltaTime()
		End
		
		Self._position.X+=__value
	End
	
	Method MoveY:Void(value:Float, clock:xClock = null)
		Local __value:Float
		
		If clock = null
			__value = value*xClockManager.GetDeltaTime()
		Else
			__value = value*clock.GetDeltaTime()
		End
		
		Self._position.Y+=__value
	End
	
	Method Rotate:Void(value:Float, clock:xClock = null)
		Local __value:Float
		
		If clock = null
			__value = value*xClockManager.GetDeltaTime()
		Else
			__value = value*clock.GetDeltaTime()
		End
		
		Self.SetRotation(Self._rotation+__value)
	End
	
	Method Scale:Void(value:Float, clock:xClock = null)
		Local __value:Float
		
		If clock = null
			__value = value*xClockManager.GetDeltaTime()
		Else
			__value = value*clock.GetDeltaTime()
		End
	
		Self._scales.X+=__value
		Self._scales.Y+=__value
	End
	
	Method ScaleWidth:Void(value:Float, clock:xClock = null)
		Local __value:Float
		
		If clock = null
			__value = value*xClockManager.GetDeltaTime()
		Else
			__value = value*clock.GetDeltaTime()
		End
	
		Self._scales.X+=__value
	End
	
	Method ScaleHeight:Void(value:Float, clock:xClock = null)
		Local __value:Float
		
		If clock = null
			__value = value*xClockManager.GetDeltaTime()
		Else
			__value = value*clock.GetDeltaTime()
		End
	
		Self._scales.Y+=__value
	End
	
	Method Fade:Void(value:Float, clock:xClock = null)
		Local __value:Float
		
		If clock = null
			__value = value*xClockManager.GetDeltaTime()
		Else
			__value = value*clock.GetDeltaTime()
		End
		
		Self._alpha+=__value
		
		For Local attached:xEntity = eachin Self._attachedEntities
			ent.Fade(value, clock)
		Next
	End
	
	Method Resize:Void(width:Float, height:Float, clock:xClock = null)
		Local __width:Float
		Local __height:Float
		
		If clock = null
			__width = width*xClockManager.GetDeltaTime()
			__height = height*xClockManager.GetDeltaTime()
		Else
			__width = width*clock.GetDeltaTime()
			__height = height*clock.GetDeltaTime()
		End
		
		Self._baseSize.X+=__width
		Self._baseSize.Y+=__height
		Self._size.X = Self._baseSize.X*xScreenRatioX
		Self._size.Y = Self._baseSize.Y*xScreenRatioY
	End
	
	Method ResizeWidth:Void(value:Float, clock:xClock = null)
		Local __value:Float
		
		If clock = null
			__value = value*xClockManager.GetDeltaTime()
		Else
			__value = value*clock.GetDeltaTime()
		End
		
		Self._baseSize.X+=__value
		Self._size.X = Self._baseSize.X*xScreenRatioX
	End
	
	Method ResizeHeight:Void(value:Float, clock:xClock = null)
		Local __value:Float
		
		If clock = null
			__value = value*xClockManager.GetDeltaTime()
		Else
			__value = value*clock.GetDeltaTime()
		End
		
		Self._baseSize.Y+=__value
		Self._size.Y = Self._baseSize.Y*xScreenRatioY
	End
	'------------------------------------------------------
	
	'Attached entity related methods
	'------------------------------------------------------
	Method AttachEntity:Void(entity:xEntity, sort:Bool = False)
		If entity <> Null
			If xScene(entity) = Null
				If entity._attachedOn <> null
					entity._attachedOn.DetachEntity(entity)
				End
				
				entity._link = Self._attachedEntities.AddLast(entity)
				entity._attachedOn = Self
				
				entity._setSceneToAttacheds(Self.Scene)
				
				If entity._z < Self._lowerZ
					Self._lowerZ = entity._z
				End
				
				If entity._z > Self._higgerZ
					Self._higgerZ = entity._z
				End
				
				If sort = True
					If Self._attachedEntities.Count() > 1
						Self.SortAttacheds()
					End
				End
			End 
		End
	End
	
	Method AttachTo:Void(entity:xEntity)
		entity.AttachEntity(Self)
	End
	
	Method Detach:Void()
		if Self._link <> null
			Self._link.Remove()
			Self._attachedOn = null
			Self._link = null
		End
	End
	
	Method DetachEntity:Void(entity:xEntity)
		If (Self._attachedEntities.Count() > 0)
			entity.Detach()
		End
	End
	
	Method DetachEntity:Void(id:String)
		If Self._attachedEntities.Count() > 0
			Local ent:xEntity = Self.GetEntity(id)
			if ent <> null
				ent.Detach()
			End
		End
	End
	
	Method DetachAll:Void()
		For Local ent:xEntity = Eachin Self._attachedEntities
			ent.Detach()
		Next
	End
	
	Method AttachedOn:xEntity()
		Return Self._attachedOn
	End
	
	Method GetAttachedList:xList<xEntity>()
		Return Self._attachedEntities
	End
	
	Method GetEntity:xEntity(id:String)
		For local ent:xEntity = Eachin Self._attachedEntities
			If ent.Id = id
				Return ent
			End
		End
		
		Return null
	End
	'------------------------------------------------------
	
	'Show anchor methods
	'------------------------------------------------------
	Method IsShowingAnchor:Bool()
		Return Self._showAnchor
	End
	
	Method ShowAnchor:Void()
		Self._showAnchor = True
	End
	
	Method HideAnchor:Void()
		Self._showAnchor = False
	End
	'------------------------------------------------------
	
	
	'Visibility methods
	'------------------------------------------------------
	Method Show:Void()
		Self._visible = True
	End
	
	Method Hide:Void()
		Self._visible = False
	End
	
	Method IsVisible:Bool()
		Return (Self._visible And Self._render)
	End
	'------------------------------------------------------
	
	'Enable methods
	'Enable the actor to make events
	'Actor is Enabled by default
	'------------------------------------------------------
	Method Enable:Void()
		Self._enable = True
	End
	
	'Disable the actor to make events
	'------------------------------------------------------
	Method Disable:Void()
		Self._enable = False
	End
	
	'Get True if actor is enable
	'------------------------------------------------------
	Method IsEnable:Bool()
		If Self._enable = False
			Return False
		Else
			Local __ent:xEntity = Self._attachedOn
			If __ent <> Null
				Return __ent.IsEnable()
			End
		End
		
		Return True
	End
	
	
	'Ordering methods
	'------------------------------------------------------
	Method SortAttacheds:Void()
		Local enum:xEnumerator<xEntity> = Self._attachedEntities.GetEnumerator()
		While enum.HasNext() = True
			Local link:xLink<xEntity> = enum.GetCurrentLink()
			
			Local olink:xLink<xEntity> = link.GetNextLink()
			While olink <> Self._attachedEntities.GetHead()
				
				if link.GetValue().GetZ() < olink.GetValue().GetZ()
					Local tmpdata:xEntity = link.GetValue()
					link.SetValue(olink.GetValue())
					link.GetValue()._link = link
					olink.SetValue(tmpdata)
					olink.GetValue()._link = olink
				End
				
				olink = olink.GetNextLink()
			Wend
			
			enum.NextObject()
		End
	End
	'------------------------------------------------------
	
	'Align methods
	'------------------------------------------------------
	Method AlignAnchor:Void(horizontal:String = xAlign.CENTER, vertical:String = xAlign.MIDDLE)
		Select horizontal
			Case xAlign.LEFT
				Self.SetAnchorX(0)
			Case xAlign.CENTER
				Self.SetAnchorX(Self.GetRectangle().GetWidth()/2)
			Case xAlign.RIGHT
				Self.SetAnchorX(Self.GetRectangle().GetWidth())
		End
	
		Select vertical
			Case xAlign.TOP
				Self.SetAnchorY(0)
			Case xAlign.MIDDLE
				Self.SetAnchorY(Self.GetRectangle().GetHeight()/2)
			Case xAlign.BOTTOM
				Self.SetAnchorY(Self.GetRectangle().GetHeight())
		End
	End
	
	Method Align:Void(horizontal:String = xAlign.CENTER, vertical:String = xAlign.MIDDLE)
		Self._alignDo = True
		Self._alignH = horizontal
		Self._alignV = vertical
		Self._alignM = 1
	End
	
	Method Align:Void(point:xVector, horizontal:String = xAlign.CENTER, vertical:String = xAlign.MIDDLE)
		Self._alignDo = True
		Self._alignPoint.Set(point)
		Self._alignH = horizontal
		Self._alignV = vertical
		Self._alignM = 2
	End
	
	Method Align:Void(x:Float, y:Float, horizontal:String = xAlign.CENTER, vertical:String = xAlign.MIDDLE)
		Self._alignDo = True
		Self._alignPoint.Set(x, y)
		Self._alignH = horizontal
		Self._alignV = vertical
		Self._alignM = 2
	End
	
	Method Align:Void(entity:xEntity, horizontal:String = xAlign.CENTER, vertical:String = xAlign.MIDDLE)
		Self._alignDo = True
		Self._alignEnt = entity
		Self._alignH = horizontal
		Self._alignV = vertical
		Self._alignM = 3
	End
	
	
	'Region methods
	'------------------------------------------------------
	Method GetRegion:xRegion()
		Return Self._region
	End
	
	Method GetRectangle:xRectangle()
		Return Self._rectangle
	End
	
	Method CalculateRegion:Void()
'		Local __x:Float = Self._position.X - Self._anchorPoint.X*Self.GetWidthScale()
'		Local __y:Float = Self._position.Y - Self._anchorPoint.Y*Self.GetHeightScale()
		
		Local __rotation:Float = Self._getTotalRotation()
		
		Self._region.Point1.Set(Self._screenPosition.X, Self._screenPosition.Y)
		'Self._region.Point1.Set(xHelper.Math.RotateAroundPoint(__rotation, New xVector(__x, __y), Self._position))
		
		Local __w:Float = Self.GetWidth()
		Local __h:Float = Self.GetHeight()
		Self._region.Point2.Set(xHelper.Math.RotateAroundCenter(__rotation, New xVector(Self._region.Point1.X+__w, Self._region.Point1.Y), Self._region.Point1))
		Self._region.Point3.Set(xHelper.Math.RotateAroundCenter(__rotation, New xVector(Self._region.Point1.X+__w, Self._region.Point1.Y+__h), Self._region.Point1))
		Self._region.Point4.Set(xHelper.Math.RotateAroundCenter(__rotation, New xVector(Self._region.Point1.X, Self._region.Point1.Y+__h), Self._region.Point1))
		
		Local __tX1:Float = Abs(Self._region.Point3.X - Self._region.Point1.X)
		Local __tX2:Float = Abs(Self._region.Point2.X - Self._region.Point4.X)
		
		If (__tX1 < __tX2)
			Self._rectangle.SetWidth(__tX2)
			If (Self._region.Point2.X < Self._region.Point4.X)
				Self._rectangle.SetX(Self._region.Point2.X)
			Else
				Self._rectangle.SetX(Self._region.Point4.X)
			End If
		Else
			Self._rectangle.SetWidth(__tX1)
			If (Self._region.Point1.X < Self._region.Point3.X)
				Self._rectangle.SetX(Self._region.Point1.X)
			Else
				Self._rectangle.SetX(Self._region.Point3.X)
			End If
		End If
		
		Local __tY1:Float = Abs(Self._region.Point3.Y - Self._region.Point1.Y)
		Local __tY2:Float = Abs(Self._region.Point2.Y - Self._region.Point4.Y)
		
		If (__tY1 < __tY2)
			Self._rectangle.SetHeight(__tY2)
			If (Self._region.Point2.Y < Self._region.Point4.Y)
				Self._rectangle.SetY(Self._region.Point2.Y)
			Else
				Self._rectangle.SetY(Self._region.Point4.Y)
			End If
		Else
			Self._rectangle.SetHeight(__tY1)
			If (Self._region.Point1.Y < Self._region.Point3.Y)
				Self._rectangle.SetY(Self._region.Point1.Y)
			Else
				Self._rectangle.SetY(Self._region.Point3.Y)
			End If
		End If
	End
	
	
	
	Method GetTotalWidthScale:Float()
		Local ent:xEntity = Self._attachedOn
		Local value:Float = 1
		While ent <> null
			value = value * ent.GetWidthScale()
			ent = ent._attachedOn
		End
		
		Return value
	End
	
	Method GetTotalHeightScale:Float()
		Local ent:xEntity = Self._attachedOn
		Local value:Float = 1
		While ent <> null
			value = value * ent.GetHeightScale()
			ent = ent._attachedOn
		End
		
		Return value
	End
	
	Method GetTotalRotation:Float()
		Return Self._getTotalRotation()
	End
	

Private

	Field _position:xVector = New xVector
	Field _size:xVector = New xVector
	Field _baseSize:xVector = New xVector
	Field _anchorPoint:xVector = New xVector
	Field _screenPosition:xVector = New xVector
	
	Field _z:Int = 0
	Field _lowerZ:Int = 0
	Field _higgerZ:Int = 0
	
	Field _rotation:Float = 0
	
	Field _scales:xVector = New xVector(1,1)
	Field _zoom:Float = 100
	
	Field _attachedEntities:xList<xEntity> = New xList<xEntity>
	Field _attachedOn:xEntity
	
	Field _color:xColor = New xColor()
	Field _alpha:float = 1

	Field _visible:Bool = True
	Field _render:Bool = True
	Field _enable:Bool = True
	
	Field _showAnchor:Bool = False
	Field _showRegion:Bool = False
	Field _showShape:Bool = False
	
	Field _region:xRegion = New xRegion()
	Field _rectangle:xRectangle = New xRectangle()
	
	Field _link:xLink<xEntity>
	
	Field _matrix:Float[6]
	
	Method _setSceneToAttacheds:Void(scene:xScene)
		If (scene <> null)
			Self.Scene = scene
			For Local attached:xEntity = Eachin Self._attachedEntities
				attached._setSceneToAttacheds(scene)
			Next
		End
	End
	
	Method _getTotalX:Float()
		Local ent:xEntity = Self._attachedOn
		Local value:Float = 0
		While ent <> null
			value = value + ent.GetX()
			ent = ent._attachedOn
		End
		
		Return value
	End
	
	Method _getTotalY:Float()
		Local ent:xEntity = Self._attachedOn
		Local value:Float = 0
		While ent <> null
			value = value + ent.GetY()
			ent = ent._attachedOn
		End
		
		Return value
	End
	
	Method _getTotalRotation:Float()
		Local __rot:Float
		If Self._attachedOn <> null
			__rot = Self._attachedOn._getTotalRotation()
		End
		
		Return Self._rotation+__rot
	End
	
	
	Field _alignV:String = xAlign.MIDDLE
	Field _alignH:String = xAlign.CENTER
	Field _alignM:Int	'1=screen, 2=point, 3=entity
	Field _alignDo:Bool = False
	Field _alignPoint:= New xVector
	Field _alignEnt:xEntity
	
	Method _makeAlign:Void()
		If Self._alignDo = True
			Local __dx:Float = xHelper.Math.Distance(Self._rectangle.GetX(), 0, Self._position.X, 0)
			Local __dy:Float = xHelper.Math.Distance(Self._rectangle.GetY(), 0, Self._position.Y, 0)
			
			Local __adx:Float
			Local __ady:Float 
			
			
			Select Self._alignM
				Case 1 'Screen
					Select Self._alignH
						Case xAlign.LEFT
							Self.SetX(__dx)
						Case xAlign.CENTER
							Self.SetX(xApplication.ScreenWidth / 2 + __dx - Self._rectangle.GetWidth() / 2)
						Case xAlign.RIGHT
							Self.SetX(xApplication.ScreenWidth + __dx - Self._rectangle.GetWidth())
					End
			
					Select Self._alignV
						Case xAlign.TOP
							Self.SetY(__dy)
						Case xAlign.MIDDLE
							Self.SetY(xApplication.ScreenHeight / 2 + __dy - Self._rectangle.GetHeight() / 2)
						Case xAlign.BOTTOM
							Self.SetY(xApplication.ScreenHeight + __dy - Self._rectangle.GetHeight())
					End
				
				Case 2 'point
					Select Self._alignH
						Case xAlign.LEFT
							Self.SetX(Self._alignPoint.X+__dx)
						Case xAlign.CENTER
							Self.SetX(Self._alignPoint.X+__dx-Self._rectangle.GetWidth()/2)
						Case xAlign.RIGHT
							Self.SetX(Self._alignPoint.X+__dx-Self._rectangle.GetWidth())
					End
			
					Select Self._alignV
						Case xAlign.TOP
							Self.SetY(Self._alignPoint.Y+__dy)
						Case xAlign.MIDDLE
							Self.SetY(Self._alignPoint.Y+__dy-Self._rectangle.GetHeight()/2)
						Case xAlign.BOTTOM
							Self.SetY(Self._alignPoint.Y+__dy-Self._rectangle.GetHeight())
					End
					
				Case 3 'entity
					If Self._alignEnt <> Null
						Select Self._alignH
							Case xAlign.LEFT
								Self.SetX(Self._alignEnt._rectangle.GetX()+__dx)
							Case xAlign.CENTER
								Self.SetX(Self._alignEnt._rectangle.GetX()+Self._alignEnt._rectangle.GetWidth()/2+__dx-Self._rectangle.GetWidth()/2)
							Case xAlign.RIGHT
								Self.SetX(Self._alignEnt._rectangle.GetX()+Self._alignEnt._rectangle.GetWidth()+__dx-Self._rectangle.GetWidth())
						End
						
						Select Self._alignV
							Case xAlign.TOP
								Self.SetY(Self._alignEnt._rectangle.GetY()+__dy)
							Case xAlign.MIDDLE
								Self.SetY(Self._alignEnt._rectangle.GetY()+Self._alignEnt._rectangle.GetHeight()/2+__dy-Self._rectangle.GetHeight()/2)
							Case xAlign.BOTTOM
								Self.SetY(Self._alignEnt._rectangle.GetY()+Self._alignEnt._rectangle.GetHeight()+__dy-Self._rectangle.GetHeight())
						End
					End
			End
		End
	
		Self._alignDo = False
	End
	
	
	
End


Class xRegion

Public

	Field Vectors:xVector[4]

	Field Point1:xVector = new xVector()
	Field Point2:xVector = new xVector()
	Field Point3:xVector = new xVector()
	Field Point4:xVector = new xVector()

	Method New()
		Self.Vectors[0] = Self.Point1
		Self.Vectors[1] = Self.Point2
		Self.Vectors[2] = Self.Point3
		Self.Vectors[3] = Self.Point4
	End
	
	Method ToString:String()
		Return Self.Point1+"; "+Self.Point2+"; "+Self.Point3+"; "+Self.Point4
	End

End
