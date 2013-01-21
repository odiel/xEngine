Strict

Import xengine

Class xValueParserHelper

	'Get value as bool
	'------------------------------------------------------
	Function AsBool:Bool(value:String)
		If value = "1"
			Return True
		End
		
		If value.ToLower() = "true"
			Return True
		End
		
		Return False
	End
	
	'Get value as float
	'------------------------------------------------------
	Function AsFloat:Float(value:String)
		Local aValue:String[] = value.Split("~~")
		Local __value:Float
		If aValue.Length = 2
			__value = Rnd(Float(aValue[0]), Float(aValue[1]))
		Else
			__value = Float(aValue[0])
		End
		
		Return __value
	End
	
	'Get value as int
	'------------------------------------------------------
	Function AsInt:Int(value:String)
		Local aValue:String[] = value.Split("~~")
		Local __value:Float
		If aValue.Length = 2
			__value = Rnd(Int(aValue[0]), Int(aValue[1]))
		Else
			__value = Int(aValue[0])
		End
		
		Return __value
	End
	
	'Get value as point
	'------------------------------------------------------
	Function AsPoint:xPoint(value:String)
		Local point:xPoint = New xPoint
		Local __value:String[] = value.Split(",")
		
		If __value.Length = 2
			point.Set(xValueParserHelper.AsFloat(__value[0]), xValueParserHelper.AsFloat(__value[1]))
		End
		
		Return point
	End

End