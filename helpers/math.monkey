Strict

Import mojo
Import xengine.basics.vector
Import xengine.basics.point

Class xMathHelper

Public

	'Radians to Degrees
	'------------------------------------------------------
	Function RadiansToDegrees:Float(radians:Float)
		Return radians * (180.0 / PI)
	End
	
	'Degrees to Radians
	'------------------------------------------------------
	Function DegreesToRadians:Float(degrees:Float)
		Return degrees * (PI / 180.0)
	End
	
	'Rotate a vector around another vector
	'------------------------------------------------------
	Function RotateAroundCenter:xVector(angle:Float, vector:xVector, center:xVector)
		Local x:Float = vector.X - center.X
		Local y:Float = vector.Y - center.Y
		
		Local _x:Float = x * Cos(angle) + y * Sin(angle)
		Local _y:Float = -x * Sin(angle) + y * Cos(angle)
		
		x = _x + center.X
		y = _y + center.Y
		
		Return New xVector(x, y)
	End
	
	'Rotate a point around another point
	'------------------------------------------------------
	Function RotateAroundCenter:xPoint(angle:Float, point:xPoint, center:xPoint)
		Local x:Float = point.X - center.X
		Local y:Float = point.Y - center.Y
		
		Local _x:Float = x * Cos(angle) + y * Sin(angle)
		Local _y:Float = -x * Sin(angle) + y * Cos(angle)
		
		x = _x + center.X
		y = _y + center.Y
		
		Return New xPoint(x, y)
	End
	
	'Distance between two points
	'------------------------------------------------------
	Function Distance:Float(x1:Float, y1:Float, x2:Float, y2:Float)
		Local dx:Float = x1-x2
		Local dy:Float = y1-y2
		
		Return Sqrt(dx*dx + dy*dy)
	End
	
	Function Distance:Float(vector1:xVector, vector2:xVector)
		Local dx:Float = vector1.X-vector2.X
		Local dy:Float = vector1.Y-vector2.Y
		
		Return Sqrt(dx*dx + dy*dy)
	End
	
	Function Distance:Float(point1:xPoint, point2:xPoint)
		Local dx:Float = point1.X-point2.X
		Local dy:Float = point1.Y-point2.Y
		
		Return Sqrt(dx*dx + dy*dy)
	End

End