Strict

Import vector

Class xPoint

Public

	Field X:Float
	Field Y:Float 
	
	'Constructors
	'------------------------------------------------------
	Method New(x:Float, y:Float)
		Self.X = x
		Self.Y = y
	End
	
	Method New(point:xPoint)
		Self.X = point.X
		Self.Y = point.Y
	End
	
	'Set X,Y Values
	'------------------------------------------------------
	Method Set:Void(x:Float, y:Float)
		Self.X = x
		Self.Y = y
	End
	
	Method Set:Void(point:xPoint)
		Self.X = point.X
		Self.Y = point.Y
	End
	
	Method Set:Void(vector:xVector)
		Self.X = vector.X
		Self.Y = vector.Y
	End
	
	'Get as String
	'------------------------------------------------------
	Method ToString:String()
		Return Self.X+", "+Self.Y
	End
	
	'Clone it
	'------------------------------------------------------
	Method Clone:xPoint()
		Return New xPoint(Self.X, Self.Y)
	End
	
End