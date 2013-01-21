Strict

Import xengine.basics.vector

Class xRectangle

Public

	'Constructors
	'------------------------------------------------------
	Method New(width:Float, height:Float)
		Self._size.Set(width, height)
	End
	
	Method New(x:Float, y:Float, width:Float, height:Float)
		Self._position.Set(x, y)
		Self._size.Set(width, height)
	End
	
	Method New(position:xVector, size:xVector)
		Self._position.Set(position.X, position.Y)
		Self._size.Set(size.X, size.Y)
	End
		
	'Position related methods
	'------------------------------------------------------
	Method SetX:Void(value:Float)
		Self._position.X = value
	End
	
	Method SetY:Void(value:Float)
		Self._position.Y = value
	End
	
	Method SetPosition:Void(x:Float, y:float)
		Self._position.Set(x, y)
	End
	
	Method GetX:Float()
		Return Self._position.X
	End
	
	Method GetY:Float()
		Return Self._position.Y
	End
	
	Method GetPosition:xVector()
		Return Self._position
	End
	
	Method GetLeft:Float()
		Return Self._position.X+Self._size.X
	End
	
	Method GetBottom:Float()
		Return Self._position.Y+Self._size.Y
	End
	'------------------------------------------------------
	
	'Size related methods
	'------------------------------------------------------
	Method SetWidth:Void(value:Float)
		Self._size.X = value
	End
	
	Method SetHeight:Void(value:Float)
		Self._size.Y = value
	End
	
	Method SetSize:Void(width:Float, height:Float)
		Self._size.Set(width, height)
	End
	
	Method GetWidth:Float()
		Return Self._size.X
	End
	
	Method GetHeight:Float()
		Return Self._size.Y
	End
	
	Method GetSize:xVector()
		Return Self._size
	End
	'------------------------------------------------------
	
	
	'Others
	'------------------------------------------------------
	Method ToString:String()
		Return Self._position.X+","+Self._position.Y+";"+Self._size.X+","+Self._size.Y
	End
	
	'Clone it
	'------------------------------------------------------
	Method Clone:xRectangle()
		Return  New xRectangle(Self._position.X, Self._position.Y, Self._size.X, Self._size.Y)
	End
	

Private

	Field _position:xVector = new xVector
	Field _size:xVector = new xVector
	
End
