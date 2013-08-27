Strict

Class xLoggerBase Abstract
	Const INFO:String = "INFO"
	Const ALERT:String = "ALERT"
	Const ERROR:String = "ERROR"
	
	Field date:String
	Field time:String
	Field message:String
	Field level:String
	
	Field code:Int
	
	Field section:String
	Field action:String
	
	Method Invoke:Void() Abstract
	
End