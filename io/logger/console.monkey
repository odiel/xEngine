Strict

Import xengine.io.logger.base

Class xLoggerConsole Extends xLoggerBase
	
	Method Invoke:Void()
		Print Self.date + " " + Self.time + " | " + Self.level + " | " + Self.section + " -> " + Self.action + " | " + Self.message
	End
	
End