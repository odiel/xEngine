Strict

Class xAlign
	Const TOP:String = "top"
	Const MIDDLE:String = "middle"
	Const BOTTOM:String = "bottom"
	
	Const LEFT:String = "left"
	Const CENTER:String = "center"
	Const RIGHT:String = "right"
	
	Const NONE:String = "none"
End


Global NewIdCounter:Int = 0

Function NewId:String(id:String = "")
	NewIdCounter+=1
	Return id+NewIdCounter
End
