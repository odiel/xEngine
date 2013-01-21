Strict

Class xSize

Public

	Field Width:Float
	Field Height:Float
	
	'Constructors
	'------------------------------------------------------
	Method New(width:Float, height:Float)
		Self.Width = width
		Self.Height = height
	End
	
	Method New(size:xSize)
		Self.Width = size.Width
		Self.Height = size.Height
	End
	
	
	Method Set:Void(width:Float, height:Float)
		Self.Width = width
		Self.Height = height
	End
	
	Method Set:Void(size:xSize)
		Self.Width = size.Width
		Self.Height = size.Height
	End
	
	'Get as String
	'------------------------------------------------------
	Method ToString:String()
		Return Self.Width + ", " + Self.Height
	End
	
	'Clone it
	'------------------------------------------------------
	Method Clone:xSize()
		Return New xSize(Self.Width, Self.Height)
	End
	
End