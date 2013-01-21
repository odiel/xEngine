Strict

Import xengine.helpers.draw
Import xengine.helpers.collisions
Import xengine.helpers.math
Import xengine.helpers.configurator
Import xengine.helpers.valueparser

Class xBaseHelper

Public

	Field Draw:xDrawHelper = new xDrawHelper
	Field Collision:xCollisionHelper = new xCollisionHelper
	Field Math:xMathHelper = new xMathHelper
	Field ValueParser:xValueParserHelper = New xValueParserHelper
	Field Configurator:xConfiguratorHelper = New xConfiguratorHelper
	
End

Global xHelper:xBaseHelper = new xBaseHelper