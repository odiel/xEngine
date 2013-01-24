Strict

Import xengine

Class Mobile

	Const PORTRAIT:String = "portrait"
	Const LANDSCAPE:String = "landscape"
	
	Function GetRotation:Int()
		Return Mobile_GetRotation()
	End
		
	Function GetOrientation:String()
		Return Mobile_GetOrientation()
	End
	
End
