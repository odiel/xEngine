Strict

Import mojo.graphics

Class xColor

Public 
	
	Global Red:xColor = New xColor(255,0,0)
	Global Green:xColor = New xColor(0,255,0)
	Global Blue:xColor = New xColor(0,0,255)
	Global Black:xColor = New xColor(0,0,0)
	Global White:xColor = New xColor(255, 255, 255)
	Global Pink:xColor = New xColor(255, 65, 170)
	
	'Constructors
	'------------------------------------------------------
	Method New(red:Int = 255, green:Int = 255, blue:Int = 255)
		Self.SetRed(red)
		Self.SetGreen(green)
		Self.SetBlue(blue)
	End
	
	'Set color in RGB
	'------------------------------------------------------
	Method Set:Void(red:Int = 255, green:Int = 255, blue:Int = 255)
		Self.SetRed(red)
		Self.SetGreen(green)
		Self.SetBlue(blue)
	End
	
	'Set color by xColor
	'------------------------------------------------------
	Method Set:Void(color:xColor)
		Self.SetRed(color.GetRed())
		Self.SetGreen(color.GetGreen())
		Self.SetBlue(color.GetBlue())
	End
	
	'Set red color
	'------------------------------------------------------
	Method SetRed:Void(value:Int = 255)
		Self._red = value
	End
	
	'Set green color
	'------------------------------------------------------
	Method SetGreen:Void(value:Int = 255)
		Self._green = value
	End
	
	'Set blue color
	'------------------------------------------------------
	Method SetBlue:Void(value:Int = 255)
		Self._blue = value
	End
	
	'Get red color
	'------------------------------------------------------
	Method GetRed:Int()
		Return Self._red
	End
	
	'Get green color
	'------------------------------------------------------
	Method GetGreen:Int()
		Return Self._green
	End
	
	'Get blue color
	'------------------------------------------------------
	Method GetBlue:Int()
		Return Self._blue
	End
	
	'Apply color on render
	'------------------------------------------------------
	Method Apply:Void()
		SetColor(Self._red, Self._green, Self._blue)
	End
	
	'Clear screen
	'------------------------------------------------------
	Method ClearScreen:Void()
		Cls(Self._red, Self._green, Self._blue)
	End

	'Get as String
	'------------------------------------------------------
	Method ToString:String()
		Return Self._red+","+Self._green+","+Self._blue
	End
	
	'Clone it
	'------------------------------------------------------
	Method Clone:xColor()
		Return new xColor(Self._red, Self._green, Self._blue)
	End

Private	

	Field _red:Int = 255
	Field _green:Int = 255
	Field _blue:Int = 255

End
