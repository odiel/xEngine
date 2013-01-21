Strict

Class xVector

Public

	Field X:Float
	Field Y:Float 

	Const Zero:Vector = New Vector()
	
	'Constructors
	'------------------------------------------------------
	Method New(x:Float = 0, y:Float = 0)
		Self.X = x
		Self.Y = y
	End
	
	Method New(vector:xVector)
		Self.X = vector.X
		Self.Y = vector.Y
	End
	
	
	'Get current Length of vector
	'------------------------------------------------------
	Method Length:Float() Property 
		Return Sqrt(Self.X*Self.X + Self.Y*Self.Y)
	End
	
	'Set length
	'------------------------------------------------------
	Method Length:Void(length:Float) Property
		'If we want to set vector to zero 
		If length = 0
			Self.X = 0
			Self.Y = 0
			Return
		Endif

		If Self.X = 0 And Self.Y = 0
			Self.X = length
		Endif
		
		Self.Normalize()
		Self.Multiply(length)
	End
	
	'Get direction
	'
	'Calculates the current direction in degrees in the 0 To < 360 range
	'------------------------------------------------------
	Method Direction:Float() Property
		Local angle:Float = ATan2(-Self.Y , Self.X)
		'If angle < 0 Then angle =+ 360
		Return angle
	End
	
	'Set direction
	'
	'Set the angle of this vector without changing the length, has no effect if vector length is 0 uses a single sqr operation
	'------------------------------------------------------
	Method Direction:Void(direction:Float) Property
		Self.MakeField(direction, Self.Length)
	End Method
	
	'Set vector values by x,y values
	'------------------------------------------------------
	Method Set:xVector(x:Float = 0, y:Float = 0)
		Self.X = x
		Self.Y = y
		Return Self	
	End
	
	'Set vector values by x,y values
	'------------------------------------------------------
	Method Set:xVector(vector:xVector)
		Self.X = vector.X
		Self.Y = vector.Y
		Return Self	
	End
	
	'Add values to vector
	'------------------------------------------------------
	Method Add:xVector(vector:xVector)
		Self.X += vector.X
		Self.Y += vector.Y 
		Return Self	
	End
	
	Method Add:xVector(x:Float, y:Float)
		Self.X+=x
		Self.Y+=y
		Return Self	
	End
	
	'Subtract values from vector
	'------------------------------------------------------
	Method Subtract:xVector(vector:xVector)
		Self.X-=vector.X
		Self.Y-=vector.Y
		Return Self	
	End
	
	Method Substract:xVector(x:Float, y:Float)
		Self.X-=x
		Self.Y-=y
		Return Self	
	End
	
	'Dot product
	'This is X*X2 + Y*Y2
	'------------------------------------------------------
	Method Dot:Float(vector:xVector)
		Return (Self.X * vector.X + Self.Y * vector.Y)
	End
	
	'Multiply vector
	'------------------------------------------------------
	Method Multiply:xVector(value:Float)
		Self.X*=value
		Self.Y*=value
		Return Self	
	End
	
	'Mirror
	'
	'if the mirrorImage vector is a unit-vector this will make this vector flip 180 degrees around it.
	'So that this vector now points in the exact opposite direction To the mirrorImage vector Returns Self, which will be opposite to mirrorImage.
	'------------------------------------------------------
	Method Mirror:xVector(mirrorImage:Vector)
		Local dotprod:Float = -Self.X * mirrorImage.X - Y * mirrorImage.Y
		Self.X=Self.X+2 * mirrorImage.X * dotprod
		Self.Y=Self.Y+2 * mirrorImage.Y * dotprod
		Return Self
	End
	
	'Set the vector to a direction and a length x,y Returns Self, which is now pointing the direction provided, with the length provided
	'------------------------------------------------------
	Method MakeField:xVector(direction:Float, length:Float)
		Self.X = Cos(-direction)*length
		Self.Y = Sin(-direction)*length
		Return Self
	End
	
	'Set to left normal
	'
	'Make this a perpendicular vector Same as rotating it 90 degrees counter clockwise
	'------------------------------------------------------
	Method LeftNormal:xVector()
		Local tempX:Float = Self.Y
		Self.Y = -Self.X
		Self.X = tempX
		Return Self
	End

	'Set to right normal
	'
	'Make this a Perpendicular Vector
	'Same as rotating it 90 degrees clockWise
	'------------------------------------------------------
	Method RightNormal:xVector( )
		Local tempY:Float = Self.Y
		Self.Y = Self.X
		Self.X = -tempY
		Return Self
	End
	
	'Normalize
	'
	'Sets vector length to One but keeps it's direction		
	'Returns Self as a UnitVector
	'------------------------------------------------------
	Method Normalize:xVector()
		Local length:Float = Self.Length()
		If length = 0 
			Return Self ' Don't divide by zero, 
			'we do not normalize a zero-vector 
			'since this vector's direction is in
			' mathematical terms all directions!
		End
		Return Self.Set(Self.X / length, Self.Y / length) 'Make length = 1
	End
	
	'Reduce length
	'------------------------------------------------------
	Method ReduceLength:xVector(amount:Float)
		Local currentAngle:Float = Self.Direction
		Local currentLength:Float = Self.Length
		Local newLength:Float = currentLength - amount
		If newLength > 0
			Self.MakeField(currentAngle, currentLength - amount)
		Else 
			Self.Set()
		Endif
		Return Self	
	End
	
	'Distance
	'
	'The Distance between two vectors
	'This is NOT related to the vectors Length#
	'------------------------------------------------------
	Method DistanceTo:Float(vector:xVector)
		Return Self.DistanceTo(vector.X, vector.Y)
	End
	
	Method DistanceTo:Float(x:Float, y:Float) 
		Local dx:Float = x - X 
		Local dy:Float = y - Y 
		Return Sqrt(dx * dx + dy * dy)
	End
		
	'Get angle between
	'
	'If you have two vectors that start at the same position the angle-distance between two vectors Result is from 0 to 180 degrees, 
	'because two vectors can not be more than 180 degrees apart, check AngleClockwise & AngleAntiClockwise to get a 0-360 result instead
	'even tough it is counted as they are on the same position, that is not a requirement at all for this to be correct
	'------------------------------------------------------
	Method AngleTo:Float(target:xVector)
		Local dot:Float = Self.Dot(target)
		
		Local combinedLength:Float = Self.Length * target.Length
		If combinedLength = 0 Then Return 0
		
		Local quaski:Float = dot/combinedLength
		
		Local angle:Float = ACos(quaski)
		Return angle
	End
	
	
	'If you have two vectors so they both start at the same position 
	'Returns the angle from this vector to target vector (in degrees) if you where to go Clockwise to it, result is 0 to 360
	'------------------------------------------------------
	Method AngleToClockwise:Float(target:xVector)
		Local angle:Float = ATan2(-Self.Y , Self.X)  - ATan2(-target.Y , target.X)
		If angle < 0 Then angle += 360
		If angle >= 360 Then angle -= 360
		Return angle		
	End
	
	'If you have two vectors so they both start at the same position 
	'Returns the angle fromt this vector to target vector (in degrees) if you where to go AntiClockwise to it, result is 0 to 360
	'------------------------------------------------------
	Method AngleToAntiClockwise:Float(target:Vector)
		Local angle:Float =  Self.AngleToClockwise(target)-360
		Return -angle
	End	
	
	'Vector between
	'
	'Change the vector into a vector from Position1 to Position2
	'Return Self, as a vector that goes from first parameter's position to the second
	'------------------------------------------------------
	Method MakeBetween:Vector(positionFrom:Vector , positionTo:Vector)
		If positionFrom = Null Or positionTo = Null Then Return Self
		Self.X = (positionTo.X - positionFrom.X)
		Self.Y = (positionTo.Y - positionFrom.Y)
		Return Self
	End
	
	
	'Get as String
	'------------------------------------------------------
	Method ToString:String()
		Return Self.X + "," + Self.Y
	End
	
	'Clone it
	'------------------------------------------------------
	Method Clone:xVector()
		Return New xVector(Self.X, Self.Y)
	End

End