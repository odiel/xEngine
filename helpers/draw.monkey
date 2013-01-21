Strict

Import mojo
Import xengine.components.entity
Import xengine.basics.vector
Import xengine.basics.rectangle
Import xengine.basics.color
Import xengine.game.clock

Class xDrawHelper

Public

	'Draw a vector
	'------------------------------------------------------
	Function Vector:Void(vector:xVector, x:Float, y:Float)
		DrawText "Length:" + vector.Length(), x, y
		DrawText "Direction:" + vector.Direction(), x, y+GetFont().Height()
	End
	
	'Draw an arrow from origin to passed vector
	'------------------------------------------------------
	Function Arrow:Void(x:Float, y:Float, originX:Float = 0, originY:Float = 0, arrowHeadLength:Float = 10, arrowHeadWidth:Float = 5)
		Local __dx:Float = originX - x
		Local __dy:Float = originY - y
		
		DrawLine originX, originY, x, y
		
		Local angle:Int = ATan2(__dx, __dy)
		
		angle+= 180
		DrawLine(x, y, (x + (Sin(angle * -1) * arrowHeadLength)) + (Cos(angle) * arrowHeadWidth), (y - (Cos(angle * -1) * arrowHeadLength)) - (Sin(angle) * arrowHeadWidth))
		DrawLine(x, y, (x + (Sin(angle * -1) * arrowHeadLength)) - (Cos(angle) * arrowHeadWidth), (y - (Cos(angle * -1) * arrowHeadLength)) + (Sin(angle) * arrowHeadWidth))
	End
	
	'Draw entity anchor
	'------------------------------------------------------
	Function Anchor:Void(x:float, y:float)
		If String(x) = "-Infinity" Or String(x) = "Infinity" Or String(y) = "-Infinity" Or String(y) = "Infinity"
			Return
		End
		
		xColor.Green.Apply()
		
		DrawLine(x, y-3, x, y+3)
		DrawLine(x - 3, y, x + 3, y)
		
		xColor.White.Apply()
		
	End
	
	'Draw the clock manager times an values
	'@showOnly can be: all, fps, timesincestart, deltatime, timesincelastframe
	'------------------------------------------------------
	Function ClockManager:Void(x:float, y:float, showOnly:String = "all")
		Local font:Image = GetFont()
		
		If (showOnly = "fps" or showOnly = "all")
			DrawText("FPS:"+xClockManager.GetFPS(), x, y)
		End
		
		If (showOnly = "timesincestart" or showOnly = "all")
			DrawText("Time since start:"+xClockManager.GetTimeSinceStart(), x, y+font.Height())
		End
		
		If (showOnly = "deltatime" or showOnly = "all")
			DrawText("Deltatime:"+xClockManager.GetDeltaTime(), x, y+(2*font.Height()))
		End
		
		If (showOnly = "timesincelastframe" or showOnly = "all")
			DrawText("Time since last frame:"+xClockManager.GetTimeSinceLastFrame(), x, y+(3*font.Height()))
		End 
	End
	
	'Draw a clock with fps and deltatime
	'------------------------------------------------------
	Function Clock:Void(clock:xClock, x:float, y:float)
		Local font:Image = GetFont()
		Local c:Int = 0
		DrawText("FPS:"+clock.GetFPS(), x, y+(c*font.Height()))
		c+=1
		DrawText("Deltatime:"+clock.GetDeltaTime(), x, y+(c*font.Height()))
	End
	
	'Draw a xRectangle
	'------------------------------------------------------
	Function Rectangle:Void(rect:xRectangle, fillIt:Bool = False)
		If Not fillIt
			DrawLine(rect.GetX(), rect.GetY(), rect.GetLeft(), rect.GetY())
			DrawLine(rect.GetX(), rect.GetY(), rect.GetX(), rect.GetBottom())
			DrawLine(rect.GetLeft(), rect.GetY(), rect.GetLeft(), rect.GetBottom())
			DrawLine(rect.GetX(), rect.GetBottom(), rect.GetLeft(), rect.GetBottom())
		Else
			DrawRect(rect.GetX(), rect.GetY(), rect.GetWidth(), rect.GetHeight())
		End
	End
	
	'Draw a xCircle
	'------------------------------------------------------
	Function Circle:Void(circle:xCircle)
		DrawCircle(circle.Position.X, circle.Position.Y, circle.Radius)
	End
	
	'Draw a polygon
	'------------------------------------------------------
	Function Polygon:Void(poly:xVector[])
		Local fvector:xVector = poly[0]
		Local lvector:xVector = poly[0]
		Local vector:xVector
		For local i:Int = 0 To poly.Length - 1
			Local vector:xVector = poly[i]
			DrawLine lvector.X, lvector.Y, vector.X, vector.Y
			lvector = vector
		Next
		DrawLine lvector.X, lvector.Y, fvector.X, fvector.Y
	End
	
	'Draw the entity region
	'------------------------------------------------------
	Function Region:Void(entity:xEntity)
		xHelper.Draw.Polygon(entity.GetRegion().Vectors)
	End
	
	'Draw a color composition
	'------------------------------------------------------
	Function Color:Void(color:xColor, x:Float, y:Float)
		DrawText(color.ToString(), x, y)
	End
	
End
