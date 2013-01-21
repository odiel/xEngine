Strict

Import xengine.basics.vector

Class xLine

Public

	Field Point1:xVector = New xVector()
	Field Point2:xVector = New xVector()
	
	'Constructors
	'------------------------------------------------------
	Method New(x1:Float, y1:Float, x2:float, y2:Float)
		Self.Point1.X = x1
		Self.Point1.Y = y1
		Self.Point2.X = x2
		Self.Point2.Y = y2
	End
	
	Method New(vector1:xVector, vector2:xVector)
		Self.Point1 = vector1
		Self.Point2 = vector2
	End
	
	'Get as String
	'------------------------------------------------------
	Method ToString:String()
		Return Self.Point1.X+","+Self.Point1.Y+";"+Self.Point2.X+","+Self.Point2.Y
	End	
	
	'Clone it
	'------------------------------------------------------
	Method Clone:xCircle()
		Local line:= New xLine(Self.Point1.X, Self.Point1.Y, Self.Point2.X, Self.Point2.Y)
		Return line
	End

End

