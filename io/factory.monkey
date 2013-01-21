Strict

Import xengine.io.factories.animation

Global xFactories:= New xFactoryManager

Class xFactoryManager
	
Public

	Field Animation:= New xFactoryAnimation()
	
	
End




'
'	Method SetProperty:Void(_property:String, value:String)
'		Select _property
'			Case "showgrid"
'				If xHelper.ValueParser.AsBool(value) = True
'					Self.ShowGrid()
'				End
'			Case "showcellsnumbers"
'				If xHelper.ValueParser.AsBool(value) = True
'					Self.ShowCellsNumbers()
'				End
'			Case "dimensions"
'				Local __point:xPoint = xHelper.ValueParser.AsPoint(value)
'				Self.SetDimensions(__point.X, __point.Y)
'			Case "tilessize"
'				Local __point:xPoint = xHelper.ValueParser.AsPoint(value)
'				Self.SetTilesSize(__point.X, __point.Y)
'			Case "tileswidth"
'				Self.SetTilesWidth(Float(value))
'			Case "tilesheight"
'				Self.SetTilesHeight(Float(value))
'			Case "tile"
'				'x,y|resourcename|value|kind|nature
'				Local __values:String[] = value.Split("|")
'				If __values.Length >= 2
'					Local __point:xPoint = xHelper.ValueParser.AsPoint(__values[0])
'					
'					Local value:String
'					Local kind:String
'					Local nature:String
'					
'					If __values.Length >= 3
'						value = __values[2].Trim()
'					End
'					
'					If __values.Length >= 4
'						kind = __values[3].Trim()
'					End
'					
'					If __values.Length >= 5
'						nature = __values[4].Trim()
'					End
'					
'					Self.SetTile(__point.X, __point.Y, __values[1].Trim(), value, kind, nature)
'				End
'			Default
'				Super.SetProperty(_property, value)
'		End
'	End