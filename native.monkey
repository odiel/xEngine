#IF TARGET="android"
	Import "native/mobile.android.java"
#END


Extern


	#IF TARGET = "android"
		
		Function Mobile_GetRotation:Int() = "mobile.getRotation"
		Function Mobile_GetOrientation:String() = "mobile.getOrientation"
		
	#END
	
Public

	#IF TARGET <> "android"	
		
		Function Mobile_GetRotation:Int()
			Return 0
		End
		
		Function Mobile_GetOrientation:String()
			Return "portrait"
		End
		
	#END


