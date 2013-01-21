Strict

Import xengine.components.sprite
Import xengine.helpers
Import xengine.events.tilemap


Class xTilemap Extends xEntity

Public

	Field OnMouseMove:xEvent_Tilemap
	
	Field OnMouseEnter:xEvent_Tilemap
	Field OnMouseLeave:xEvent_Tilemap

	Field OnMouseEnterTile:xEvent_Tilemap
	Field OnMouseLeaveTile:xEvent_Tilemap

	Field OnTouch:xEvent_Tilemap
	Field OnDoubleTouch:xEvent_Tilemap
	
	Field OnTouchDown:xEvent_Tilemap
	Field OnTouchPress:xEvent_Tilemap
	Field OnTouchUp:xEvent_Tilemap

	
	'Constructors
	'------------------------------------------------------
	Method New()
		Self.Id = NewId("Tilemap")
		Self.SetDimensions(10, 10)
		Self.Initialize()
	End
	
	Method New(id:String)
		Self.Id = id
		Self.SetDimensions(10, 10)
		Self.Initialize()
	End
	
	Method New(id:String, x:Int, y:int)
		Self.Id = id
		Self.SetDimensions(x, y)
		Self.Initialize()
	End
	
	Method New(id:String, x:Int, y:int, tileWidth:Float, tileHeight:Float)
		Self.Id = id
		Self.SetDimensions(x, y)
		Self.SetTilesSize(tileWidth, tileHeight)
		Self.Initialize()
	End
	'------------------------------------------------------
	
	
	Method Update:Void()
		Super.Update()
		
		If (Self._respectFormation = True)
			For Local __tile:xTile = eachin Self._tiles
				If __tile.Sprite <> Null
					__tile.Sprite.SetPosition( (__tile.X * Self._tileW) + Self._tileOffsetX + __tile.Sprite.GetAnchorX(), (__tile.Y * Self._tileH) + Self._tileOffsetY + __tile.Sprite.GetAnchorY()) 'Added to fix always the tile render position
				End
			Next
		End
		
		If Self._isEnable = True
			Local __collision:Bool = False
			
			Local v:xVector = New xVector(xInput.MouseX()-Self.GetRegion().Point1.X, xInput.MouseY()-Self.GetRegion().Point1.Y)
			v.Add(Self.GetPosition())
			
			Local mouseP:xVector = xHelper.Math.RotateAroundCenter(Self.GetTotalRotation()*-1, New xVector(v.X, v.Y), Self.GetPosition())
			
			'Correcting cursor if scales is negative
			If mouseP.X < Self.GetPosition().X Then mouseP.X = Self.GetPosition().X+(Self.GetPosition().X-mouseP.X)
			If mouseP.Y < Self.GetPosition().Y Then mouseP.Y = Self.GetPosition().Y+(Self.GetPosition().Y-mouseP.Y)
			
			If xHelper.Collision.PointVsPoly(xInput.MouseX(), xInput.MouseY(), Self.GetRegion().Vectors) = True
				Self._tileInX = Ceil((mouseP.X - Self.GetX()) / (Self._tileW*Abs(Self.GetTotalWidthScale()*Self.GetWidthScale())))-1
				Self._tileInY = Ceil((mouseP.Y - Self.GetY()) / (Self._tileH*Abs(Self.GetTotalHeightScale()*Self.GetHeightScale())))-1
				
				If Self._mouseOver = False 
					Self._mouseOver = True
					
					If Self.OnMouseEnter <> null
						Self.OnMouseEnter.Tilemap = Self
						Self.OnMouseEnter.TilePosition.Set(Self._tileInX, Self._tileInY)
						Self.OnMouseEnter.Invoke()
					End
				End
				
			Else
				If Self._mouseOver = True
					Self._mouseOver = False
					
					If Self.OnMouseLeave <> null
						Self.OnMouseLeave.Tilemap = Self
						Self.OnMouseLeave.TilePosition.Set(Self._tileInX, Self._tileInY)
						Self.OnMouseLeave.Invoke()
					End
					
					If Self.OnMouseLeaveTile <> null
						Self.OnMouseLeaveTile.Tilemap = Self
						Self.OnMouseLeaveTile.TilePosition.Set(Self._tileInX, Self._tileInY)
						Self.OnMouseLeaveTile.Invoke()
					End
				End
			End
			
			If Self._mouseOver = True
			
				If Self.OnMouseMove <> null
					If Self._lastMouseX <> xInput.MouseX() Or Self._lastMouseY <> xInput.MouseY()
						Self.OnMouseMove.Tilemap = Self
						Self.OnMouseMove.TilePosition.Set(Self._tileInX, Self._tileInY)
						Self.OnMouseMove.Invoke()
						Self._lastMouseX = xInput.MouseX()
						Self._lastMouseY = xInput.MouseY()
					End
				End
			
				If Self._lastTileInX <> Self._tileInX Or Self._lastTileInY <> Self._tileInY
					
					'Not enter yet
					If Self._lastTileInX <> -1 And Self._lastTileInY <> -1
						If Self.OnMouseLeaveTile <> null
							Self.OnMouseLeaveTile.Tilemap = Self
							Self.OnMouseLeaveTile.TilePosition.Set(Self._tileInX, Self._tileInY)
							Self.OnMouseLeaveTile.Invoke()
						End
					End
					
					If Self.OnMouseEnterTile <> null
						Self.OnMouseEnterTile.Tilemap = Self
						Self.OnMouseEnterTile.TilePosition.Set(Self._tileInX, Self._tileInY)
						Self.OnMouseEnterTile.Invoke()
					End
					
					Self._lastTileInX = Self._tileInX
					Self._lastTileInY = Self._tileInY

				End
				
				
				If Self.OnTouchDown <> null and xInput.IsAnyTouchDown = True
					Self.OnTouchDown.Tilemap = Self
					Self.OnTouchDown.TilePosition.Set(Self._tileInX, Self._tileInY)
					Self.OnTouchDown.Invoke()
				End
				
				If Self.OnTouchPress <> null and xInput.IsAnyTouchPress = True
					Self.OnTouchPress.Tilemap = Self
					Self.OnTouchPress.TilePosition.Set(Self._tileInX, Self._tileInY)
					Self.OnTouchPress.Invoke()
				End
				
				If Self.OnTouchUp <> null and xInput.IsAnyTouchUp = True
					Self.OnTouchUp.Tilemap = Self
					Self.OnTouchUp.TilePosition.Set(Self._tileInX, Self._tileInY)
					Self.OnTouchUp.Invoke()
				End
				
				If Self.OnTouch <> null and xInput.IsAnyTouch = True
					Self.OnTouch.Tilemap = Self
					Self.OnTouch.TilePosition.Set(Self._tileInX, Self._tileInY)
					Self.OnTouch.Invoke()
				End
				
				If Self.OnDoubleTouch <> null and xInput.IsAnyDoubleTouch = True
					Self.OnDoubleTouch.Tilemap = Self
					Self.OnDoubleTouch.TilePosition.Set(Self._tileInX, Self._tileInY)
					Self.OnDoubleTouch.Invoke()
				End
				
			End
		End
	End
	
	'Attachs render
	'------------------------------------------------------
	Method RenderAttachs:Void()
		For Local attached:xEntity = EachIn Self.GetAttachedList()
			attached.Render()
		Next
		
		Self.SelfRender()
	End
	
	'Self render
	'------------------------------------------------------
	Method SelfRender:Void()
		If Self._showGrid = True Or Self._showCellsNumbers = True
		
		
			For Local i:Int = 0 To Self._tilesX-1
				For Local j:Int = 0 To Self._tilesY-1
				
					If Self._showGrid = True
						DrawLine 0, j*Self._tileH, Self._tilesX*Self._tileW, j*Self._tileH
					End
					
					If Self._showCellsNumbers = True
						DrawText i+","+j, i*Self._tileW, j*Self._tileH
					End
				Next
				
				If Self._showGrid = True
					DrawLine i*Self._tileW, 0, i*Self._tileW, Self._tilesY*Self._tileH
				End
			Next
			
			If Self._showGrid = True
				DrawLine Self._tilesX*Self._tileW, 0, Self._tilesX*Self._tileW, Self._tilesY*Self._tileH
				DrawLine 0, Self._tilesY*Self._tileH, Self._tilesX*Self._tileW, Self._tilesY*Self._tileH
			End
		End
	End
	
	'Set the tilemap dimensions
	'------------------------------------------------------
	Method SetDimensions:Void(x:Int, y:Int)
		Self._tilesX = x
		Self._tilesY = y
		Super.SetSize(Self._tilesX*Self._tileW, Self._tilesY*Self._tileH)
		Self.CalculateRegion()
	End
	
	'Set the size of tiles
	'------------------------------------------------------
	Method SetTilesSize:Void(width:Float, height:Float)
		Self._tileW = width
		Self._tileH = height
		Super.SetSize(Self._tilesX*Self._tileW, Self._tilesY*Self._tileH)
		Self.CalculateRegion()
	End
	
	'Set the width of tiles
	'------------------------------------------------------
	Method SetTilesWidth:Void(value:Float)
		Self._tileW = value
		Super.SetWidth(Self._tilesX*Self._tileW)
		Self.CalculateRegion()
	End
	
	'Set the height of tiles
	'------------------------------------------------------
	Method SetTilesHeight:Void(value:Float)
		Self._tileH = value
		Super.SetHeight(Self._tilesX*Self._tileW)
		Self.CalculateRegion()
	End
	
	'Get the size of tiles
	'------------------------------------------------------
	Method GetTileSize:xPoint()
		Return New xPoint(Self._tileW, Self._tileH)
	End
	
	'Get the width of tiles
	'------------------------------------------------------
	Method GetTileWidth:Float()
		Return Self._tileW
	End
	
	'Get the width of tiles
	'------------------------------------------------------
	Method GetTileHeight:Float()
		Return Self._tileH
	End
	
	'Get tilemap dimensions
	'------------------------------------------------------
	Method GetDimentions:xPoint()
		Return New xPoint(Self._tilesX, Self._tilesY)
	End
	
	
	'Render the tilemap grid
	'------------------------------------------------------
	Method ShowGrid:Void(value:Bool = True)
		Self._showGrid = value
	End
	
	'Render the tilemap cells numbers
	'------------------------------------------------------
	Method ShowCellsNumbers:Void(value:Bool = True)
		Self._showCellsNumbers = value
	End
	
	'Set a tile by a xTile object
	'------------------------------------------------------
	Method SetTile:Void(tile:xTile)
		If tile <> Null And tile.Sprite <> Null
			tile.Link = Self._tiles.AddLast(tile)
			Self.AttachEntity(tile.Sprite, False)
		End	
	End
	
	'Set a tile by params
	'------------------------------------------------------
	Method SetTile:Void(x:Int, y:Int, sprite:xSprite, value:String = "", kind:String = "", nature:String = "")
		If sprite <> Null
			Local __tile:xTile = New xTile
			__tile.Sprite = sprite
			__tile.X = x
			__tile.Y = y
			__tile.Value = value
			__tile.Kind = kind
			__tile.Nature = nature
			
			__tile.Link = Self._tiles.AddLast(__tile)
			Self.AttachEntity(__tile.Sprite, False)
		End
	End
	
	
	'Change the entity of a tile
	'------------------------------------------------------
	Method ChangeTileEntity:xTile(x:Int, y:Int, entity:xEntity)
		If entity <> null
			Local __tile:xTile = Self.GetTile(x, y)
			If __tile <> null And __tile.Entity <> null
				Self.DetachEntity(__tile.Entity)
				__tile.Entity = entity
				Self.AttachEntity(entity)
			Else
				Self.SetTile(x, y, entity)
			End
		End
		
		Return __tile
	End
	
	'Change the value of a tile
	'------------------------------------------------------
	Method ChangeTileValue:xTile(x:Int, y:Int, value:String)
		Local __tile:xTile = Self.GetTile(x, y)
		If __tile <> null
			__tile.Value = value
		End
		
		Return __tile
	End
	
	'Change the kind of tile
	'------------------------------------------------------
	Method ChangeTileKind:xTile(x:Int, y:Int, kind:String)
		Local __tile:xTile = Self.GetTile(x, y)
		If __tile <> null
			__tile.Kind = kind
		End
		
		Return __tile
	End
	
	'Change the nature of tile
	'------------------------------------------------------
	Method ChangeTileNature:xTile(x:Int, y:Int, nature:String)
		Local __tile:xTile = Self.GetTile(x, y)
		If __tile <> null
			__tile.Nature = nature
		End
		
		Return __tile
	End
	
	'Get a tile at x,y position
	'------------------------------------------------------
	Method GetTile:xTile(x:Int, y:Int)
		For Local _tile:xTile = eachin Self._tiles 
			If x = _tile.X And y = _tile.Y 
				Return _tile
			End
		End

		Return Null
	End
	
	'Get an entity at x,y position
	'------------------------------------------------------
	Method GetEntityInTile:xSprite(x:Int, y:Int)
		Local _tile:xTile = Self.GetTile(x, y)
		if _tile <> null
			Return _tile.Sprite
		End
		
		Return null
	End
	
	'Destroy a tile
	'Remove the tile, and the entity related
	'------------------------------------------------------
	Method DestroyTile:Void(x:Int, y:Int)
		Local _tile:xTile = Self.GetTile(x, y)
		
		If _tile <> Null
			_tile.Link.Remove()
			Self.DetachEntity(_tile.Entity)
			_tile.Entity = Null
		End
	End
	
	'Remove a tile
	'------------------------------------------------------
	Method RemoveTile:Void(x:Int, y:Int)
		Local _tile:xTile = Self.GetTile(x, y)
		
		If _tile <> Null
			Self.DetachEntity(_tile.Sprite)
			_tile.Link.Remove()
		End
	End
	
	'Remove all tiles
	'------------------------------------------------------
	Method RemoveAllTiles:Void()
		Self._tiles = New xList<xTile>
		Self.DetachAll()
	End
	
	'Get the whole tiles structure
	'------------------------------------------------------
	Method GetTiles:xList<xTile>()
		Return Self._tiles
	End
	
	
	Method SetTileOffset:Void(x:float, y:Float)
		Self._tileOffsetX = x
		Self._tileOffsetY = y
	End
	
	Method IsMouseOver:Bool()
		Return Self._mouseOver
	End
	
	Method GetMouseOverTileX:Int()
		Return Self._tileInX
	End
	
	Method GetMouseOverTileY:Int()
		Return Self._tileInY
	End
	
	
	Method GetDrawAxisOfTile:xVector(x:Int, y:Int)
		Return New xVector(x*Self._tileW, y*Self._tileH)
	End
	
	Method GetDrawXOfTile:Float(x:Int, y:Int)
		Return x*Self._tileW
	End
	
	Method GetDrawYOfTile:Float(x:Int, y:Int)
		Return y*Self._tileH
	End
	
	
	'Enable the actor to make events
	'Actor is Enabled by default
	'------------------------------------------------------
	Method Enable:Void()
		Self._isEnable = True
	End
	
	'Disable the actor to make events
	'------------------------------------------------------
	Method Disable:Void()
		Self._isEnable = False
	End
	
	'Get True if actor is enable
	'------------------------------------------------------
	Method IsEnable:Bool()
		Return Self._isEnable
	End
	
	'Rotate the tilemap structure to the left
	'------------------------------------------------------
	Method RotateMapToLeft:Void()
		If (Self.IsEnable() = True)
			For Local __tile:xTile = Eachin Self._tiles
				__tile.OldX = __tile.X
				__tile.OldY = __tile.Y
				
				__tile.X = __tile.OldY
				__tile.Y = (Self._tilesX-1) - __tile.OldX
			Next
			
			Local __x:Int = Self._tilesX 
			Local __y:Int = Self._tilesY
			Self._tilesX = __y
			Self._tilesY = __x
		End If
	End

'	Rem
'	bbdoc: Rotate the tilemap structure to the right
'	End Rem
'	Method RotateMapToRight()
'		If (Self.IsEnable() = True)
'			Local __tilesX:Int = Self._tilesY
'			Local __tilesY:Int = Self._tilesX
'			Local __list:TList = Self._entities._list.Copy()
'			Self._entities._list = New TList
'			
'			For Local tile:xTile = EachIn __list
'				Self.setTile((_tilesX - tile.position.y) + 1, tile.position.x, tile.entity)
'			Next
'			
'			Self._tilesY = __tilesY
'			Self._tilesX = __tilesX
'			Self._updParams = True
'		End If
'	End Method

	Method Collide:Int(tileMap:xTilemap, entityLevel:Int = False)
		If (xHelper.Collision.RectVsRect(Self.GetRectangle(), tileMap.GetRectangle()) = True)
		
			For Local __tile:xTile = eachin Self._tiles
				For Local __tile1:xTile = eachin tileMap._tiles
					If (xHelper.Collision.RectVsRect(Self.CalcTileRect(__tile.X, __tile.Y), tileMap.CalcTileRect(__tile1.X, __tile1.Y)) = True)
						Return True
					End
				Next
			Next
			
		End

		Return False
				
				
				
'				For Local stile:xTile = EachIn Self._entities._list
''					If (stile.entity)
''						If(Not entityLevel)
''							sShape = Self.GetRegionOfTileCell(stile.position.x, stile.position.y)
''						End
''						For Local otile:xTile = EachIn tileMap._entities._list
''							If (otile.entity)
''								If (entityLevel = True)
''									Return (xCollisionManager.EntitiesCollide(xImage(stile.entity), xImage(otile.entity), Self._collisionMethod) = True)
''								Else
''									oShape = tileMap.GetRegionOfTileCell(otile.position.x, otile.position.y)
''									Return (xMath.ShapesOverlap(sShape, oShape) = True)
''								End
''							End
''						Next
''					End
''				Next
				
'				Local sShape:xShape
'				Local oShape:xShape
'				For Local stile:xTile = EachIn Self._entities._list
'					If (stile.entity)
'						If(Not entityLevel)
'							sShape = Self.GetRegionOfTileCell(stile.position.x, stile.position.y)
'						End
'						For Local otile:xTile = EachIn tileMap._entities._list
'							If (otile.entity)
'								If (entityLevel = True)
'									Return (xCollisionManager.EntitiesCollide(xImage(stile.entity), xImage(otile.entity), Self._collisionMethod) = True)
'								Else
'									oShape = tileMap.GetRegionOfTileCell(otile.position.x, otile.position.y)
'									Return (xMath.ShapesOverlap(sShape, oShape) = True)
'								End
'							End
'						Next
'					End
'				Next
			
	End
	
	Method CalcTileRect:xRectangle(x:Int, y:Int)
		Local __x:Float = Self.GetX() + (x*Self._tileW)
		Local __y:Float = Self.GetY() + (y*Self._tileH)
		Return New xRectangle(__x, __y, Self._tileW, Self._tileH)
	End

	
	Method SetSize:Void(x:Float, y:Float)
	End
	
	Method SetWidth:Void(value:Float)
	End
	
	Method SetHeight:Void(value:Float)
	End
	
	Method GetWidth:Float()
		Local __sceneZoom:Float = 1
		If Self.Scene <> null
			__sceneZoom = Self.GetTotalWidthScale()
		End
		
		Return Self._tileW*Self._tilesX*__sceneZoom*Self.GetWidthScale()
	End

	Method GetHeight:Float()
		Local __sceneZoom:Float = 1
		If Self.Scene <> null
			__sceneZoom = Self.GetTotalWidthScale()
		End
		
		Return Self._tileH*Self._tilesY*__sceneZoom*Self.GetHeightScale()
	End Method
	
	Method GetSize:xVector()
		Local __sceneZoom:Float = 1
		If Self.Scene <> null
			__sceneZoom = Self.GetTotalWidthScale()
		End
		
		Return New xVector(Self._tileW*Self._tilesX*__sceneZoom*xScreenRatioX, Self._tileH*Self._tilesY*__sceneZoom*xScreenRatioY)
	End
	
	Method GetBaseWidth:Float()
		Return Self._tileW*Self._tilesX
	End
	
	Method GetBaseHeight:Float()
		Return Self._tileH*Self._tilesY
	End
	
	Method GetBaseSize:xVector()
		Return New xVector(Self._tileW*Self._tilesX, Self._tileH*Self._tilesY)
	End
	
	Method SetRespectFormation:Void(value:Bool = true)
		Self._respectFormation = value
	End
	
	Method GetRespectFormation:Bool()
		Return Self.__respectFormation
	End
	
	
	
Private

	Field _tiles:= New xList<xTile>
	
	Field _tilesX:Int = 10
	Field _tilesY:Int = 10
	Field _tileW:Float = 32
	Field _tileH:Float = 32
	Field _tileOffsetX:Float = 0
	Field _tileOffsetY:Float = 0
	
	Field _showGrid:Bool = False
	Field _showCellsNumbers:Bool = False
	
	Field _isEnable:Bool = True
	
	Field _mouseOver:Bool = False
	
	Field _tileInX:Int
	Field _tileInY:Int
	Field _lastTileInX:Int = -1
	Field _lastTileInY:Int = -1
	Field _lastMouseX:Float
	Field _lastMouseY:Float
	
	Field _respectFormation:Bool = True
	
	
'	Method _tileArray:xTile[][](x:Int, y:Int)
'		Self.DetachAll() 
'		
'		Local __tiles:xTile[x][]
'		
'		For Local i:Int = 0 Until x
'		   __tiles[i] = New xTile[y]
'		Next
'		
'		Return __tiles
'	End

End

Class xTile
	Field X:Int
	Field Y:Int
	Field Sprite:xSprite
	Field Value:String
	Field Kind:String
	Field Nature:String
	Field Link:xLink<xTile>
	Field OldX:Int
	Field OldY:Int
End