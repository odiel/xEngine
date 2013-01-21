Strict

Import xengine.basics.vector
Import xengine.basics.line
Import xengine.basics.circle
Import xengine.basics.rectangle

Class xCollisionHelper

	'Point vs Polygon
	'------------------------------------------------------
	Function PointVsPoly:Bool(point:xVector, poly:xVector[])
		Return xCollisionHelper.PointVsPoly(point.X, point.Y, poly)
	End
	
	
	Function PointVsPoly:Bool(x:Float, y:float, poly:xVector[])
		Local amount:Int = poly.Length
		
		If amount < 3
			Return False
		End
		
		Local x1:Float = poly[poly.Length-1].X
		Local y1:Float = poly[poly.Length-1].Y
		Local cur_quad:Int = GetQuad(x, y, x1, y1)
		Local next_quad:Int
		Local total:Int
		
		For Local i:Int=0 Until poly.Length
			Local x2:Float = poly[i].X
			Local y2:Float = poly[i].Y
			
			next_quad = GetQuad(x, y, x2, y2)
			
			Local diff:Int = next_quad-cur_quad
			
			Select diff
				Case 2,-2
					If (x2 - ( ((y2 - y) * (x1 - x2)) / (y1 - y2) ) ) < x
						diff = -diff
					Endif
				Case 3
					diff = -1
				Case -3
					diff = 1
			End
			
			total+=diff
			cur_quad=next_quad
			x1=x2
			y1=y2
		Next
		
		If Abs(total) = 4 Then Return True 
		
		Return False
	End
	

	'Get quadrant?
	'------------------------------------------------------
	Function GetQuad:Int(axis_x:Float, axis_y:Float, vert_x:Float, vert_y:Float)
		If vert_x < axis_x
			If vert_y < axis_y
				Return 1
			Else
				Return 4
			End
		Else
			If vert_y < axis_y
				Return 2
			Else
				Return 3
			End
		End
		
		Return 0
	End
	
	'Polygon vs Polygon
	'------------------------------------------------------
	Function PolyVsPoly:Bool(base:xVector[], target:xVector[])
		If base.Length < 3 Or target.Length < 3
			Return False
		End
		
		Local baseX1:Float = base[0].X
		Local baseY1:Float = base[0].Y
		
		For Local i1:Int = 1 To base.Length-1
			Local baseX2:Float = base[i1].X
			Local baseY2:Float = base[i1].Y
			
			Local targetX1:Float = target[0].X
			Local targetY1:Float = target[0].Y
			
			For Local i2:Int = 1 Until target.Length-1
				Local targetX2:Float = target[i2].X
				Local targetY2:Float = target[i2].Y
				
				If xCollisionHelper.LinesCross(baseX1, baseY1, baseX2, baseY2, targetX1, targetY1, targetX2, targetY2)
					Return True
				Endif
				
				targetX1 = targetX2
				targetY1 = targetY2
			Next
			
			baseX1 = baseX2
			baseY1 = baseY2
		Next
		
		Return False
	End
	'------------------------------------------------------
	
	
	'Circle Vs Polygon
	'------------------------------------------------------
	Function CircleToPoly:Bool(circle:xCircle, poly:Float[])
		Return xCollisionHelper.CircleToPoly(circle.Position.X, circle.Position.Y, circle.Radius, poly)
	End
	
	Function CircleToPoly:Bool(x:Float, y:Float, radius:Float, poly:Float[])
		If xy.Length<6 Or (xy.Length&1) Return False
		
		Local x1:Float = poly[0].X
		Local y1:Float = poly[0].Y
		
		For Local i:Int=1 To poly.Length-1
			Local x2:Float = poly[i].X
			Local y2:Float = poly[i].Y
			
			If xCollisionHelper.LineToCircle(x1,y1,x2,y2, x, y, radius) = True
				Return True
			End
			
			x1=x2
			y1=y2
		Next
		
		Return False
	End
	'------------------------------------------------------
	
	'Line vs circle
	'------------------------------------------------------
	Function LineVsCircle:Bool(line:xLine, circle:xCircle)
		Return xCollisionHelper.LineVsCircle(line.Point1.X, line.Point1.Y, line.Point2.X, line.Point2.Y, circle.Position.X, circle.Position.X, circle.Radius)
	End
	
	Function LineVsCircle:Bool(line:xLine, circleX:Float, circleY:Float, radius:Float)
		Return xCollisionHelper.LineVsCircle(line.Point1.X, line.Point1.Y, line.Point2.X, line.Point2.Y, circleX, circleY, radius)
	End
	
	Function LineVsCircle:Bool(x1:Float, y1:Float, x2:Float, y2:Float, circleX:Float, circleY:Float, radius:Float)
		Local sx:Float = x2-x1
		Local sy:Float = y2-y1
		
		Local q:Float = ((circleX-x1) * (x2-x1) + (circleY - y1) * (y2-y1)) / (sx*sx + sy*sy)
		
		If q < 0.0 Then q = 0.0
		If q > 1.0 Then q = 1.0
		
		Local cx:Float=(1-q)*x1 + q*x2
		Local cy:Float=(1-q)*y1 + q*y2
		
		
		If xHelper.Math.PointsDistance(circleX, circleY, cx, cy) < radius
			Return True
		End
		
		Return False
	End
	'------------------------------------------------------
	
	
	'Line vs Line
	'------------------------------------------------------
	Function LinesVsLine:Bool(line1:xLine, line2:xLine)
		Return xCollisionHelper.LinesVsLine(line1.Point1.X, line1.Point1.Y, line1.Point2.X, line1.Point2.Y, line2.Point1.X, line2.Point1.Y, line2.Point2.X, line2.Point2.Y)
	End
	
	Function LinesVsLine:Bool(line1Point1:xVector, line1Point2:xVector, line2Point1:xVector, line2Point2:xVector)
		Return xCollisionHelper.LinesVsLine(line1Point1.X, line1Point1.Y, line1Point2.X, line1Point2.Y, line2Point1.X, line2Point1.Y, line2Point2.X, line2Point2.Y)
	End
	
	Function LinesVsLine:Bool(x0:Float, y0:Float ,x1:Float, y1:Float, x2:Float, y2:Float, x3:Float, y3:Float)
		Local n:Float=(y0-y2)*(x3-x2)-(x0-x2)*(y3-y2)
		Local d:Float=(x1-x0)*(y3-y2)-(y1-y0)*(x3-x2)
		
		If Abs(d) < 0.0001 
			' Lines are parallel!
			Return False
		Else
			' Lines might cross!
			Local Sn:Float=(y0-y2)*(x1-x0)-(x0-x2)*(y1-y0)
	
			Local AB:Float=n/d
			If AB>0.0 And AB<1.0
				Local CD:Float=Sn/d
				If CD > 0.0 And CD < 1.0
					' Intersection Point
					Local X:Float=x0+AB*(x1-x0)
			       	Local Y:Float=y0+AB*(y1-y0)
					Return True
				End
			End
			' Lines didn't cross, because the intersection was beyond the end points of the lines
		End
	
		' Lines do Not cross!
		Return False
	End
	'------------------------------------------------------
	
	
	'Line Vs Polygon
	'------------------------------------------------------
	Function LineVsPoly:Bool(lineX1:Float, lineY1:Float, lineX2:Float, lineY2:Float, poly:xVector[])
		If poly.Length > 2
			Local polyX1:Float = poly[0].X
			Local polyY1:Float = poly[0].Y
			
			For Local i:Int = 1 Until poly.Length-1
				Local polyX2:Float = poly[i].X
				Local polyY2:Float = poly[i].Y
				
				If xCollisionHelper.LineVsLine(lineX1, lineY1, lineX2, lineY2, polyX1, polyY1, polyX2, polyY2) = True
					Return True
				End
				
				polyX1 = polyX2
				polyY1 = polyY2
			Next
		End
		
		Return False
	End
	'------------------------------------------------------
	
	
	Function RectVsRect:Int(rectangle1:xRectangle, rectangle2:xRectangle)
		If (rectangle1.GetWidth() = 0 Or rectangle1.GetHeight() = 0 Or rectangle2.GetWidth() = 0 Or rectangle2.GetHeight() = 0)
			Return False
		End If
		
		If (((rectangle2.GetX() < (rectangle1.GetX() + rectangle1.GetWidth())) And (rectangle1.GetX() < (rectangle2.GetX() + rectangle2.GetWidth()))) And (rectangle2.GetY() < (rectangle1.GetY() + rectangle1.GetHeight())))
 			Return (rectangle1.GetY() < (rectangle2.GetY() + rectangle2.GetHeight()))
		End If
		
		Return False
	End

End
