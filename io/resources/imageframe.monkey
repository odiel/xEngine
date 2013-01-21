Strict

Import xengine.io.resources
Import xengine.basics.point
Import xengine.basics.size

Class xImageFrame Extends xResource

Public

	Field Origin:= New xPoint()
	Field Size:= New xSize()
	Field Texture:Image

	Method New(texture:Image, originX:Int, originY:Int, width:Int, height:Int)
		Self.Texture = texture
		Self.Origin.Set(originX, originY)
		Self.Size.Set(width, height)
	End
	
	Method Draw:Void(x:Float = 0, y:Float = 0)
		If Self.Texture <> Null
			DrawImageRect(Self.Texture, x, y, Self.Origin.X, Self.Origin.Y, Self.Size.Width, Self.Size.Height)
		End
	End
	
	Method Discard:Void()
		Self.Texture = Null
		Self.Origin = Null
		Self.Size = Null
	End
	
End