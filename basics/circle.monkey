Strict

Import xengine.basics.vector

Class xCircle

Public

	Field Radius:Float
	Field Position:xVector = new xVector()
	
	'Constructors
	'------------------------------------------------------
	Method New(x:Float, y:Float, radius:float)
		Self.Position.X = x
		Self.Position.Y = y
		Self.Radius = radius
	End
	
	'Get as String
	'------------------------------------------------------
	Method ToString:String()
		Return Self.Position.X+","+Self.Position.Y+" r:"+Self.Radius
	End
	
	'Clone it
	'------------------------------------------------------
	Method Clone:xCircle()
		Local circle:= New xCircle(Self.Position.X, Self.Position.Y, Self.Radius)
		Return circle
	End
	
End
