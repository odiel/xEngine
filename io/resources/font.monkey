Strict

Import mojo
Import xengine.io.resources.resource
Import xengine.io.resources.imageframe

Class xFont Extends xResource
	
Public
	
	
	'Load a font file created by FontMachine
	'------------------------------------------------------
	Method Load:Bool(fontFile:String)
		Local content:String = LoadString(fontFile)
		
		If (content = "")
			Return False
		End
		
		
		If Not content.StartsWith("P1")
			Return False
		End
		
		Local firstComma:Int = content.Find(",")
		Local header:String = content[ .. firstComma]
		
		Local separator:String
		Select header
			Case "P1"
				separator = "."
			Case "P1.01"
				separator = "_P_"
		End
		
		content = content[firstComma + 1 ..]
		
		Self._characters = New xFontCharacter[65536]
		Self._characters_shadow = New xFontCharacter[65536]
		Self._characters_border = New xFontCharacter[65536]
		Self._textures = New Image[65536]

		Local maxChar:Int = 0
		
		Local prefixName:String = fontFile.ToLower()[ .. -4]
		
		Local charList:string[] = content.Split(";")
		
		For Local chr:String = EachIn charList
			Local chrdata:string[] = chr.Split(",")
			If chrdata.Length() < 2 Then Exit
			
			Local charIndex:Int = Int(chrdata[0])
			If maxChar < charIndex
				maxChar = charIndex
			End
			
			Local textureIndex:Int = Int(chrdata[2])
			
			If (Self._textures[textureIndex] = Null)
				Self._textures[textureIndex] = LoadImage(prefixName + separator + textureIndex + ".png")
			End
			
			If (Self._textures[textureIndex] <> Null)
				Local x:Int = Int(chrdata[3])
				Local y:Int = Int(chrdata[4])
				Local width:Int = Int(chrdata[5])
				Local height:Int = Int(chrdata[6])
				Local offsetX:Int = Int(chrdata[8])
				Local offsetY:Int = Int(chrdata[9])
'				Local drawingSizeX:Int = Int(chrdata[10])
				Local drawingSizeY:Int = Int(chrdata[11])
				Local drawingWidth:Int = Int(chrdata[12])
				'Local width:Int = Int(chrdata[10])
				Local heighta:Int = Int(chrdata[11])
				
				Local char:= New xFontCharacter(charIndex, Self._textures[textureIndex], x, y, width, height, offsetX, offsetY, drawingWidth)
				
				Select chrdata[1]
					Case "F"
						If (charIndex = 32)
							Self._returnHeight = height + offsetY
							Self._spaceWidth = drawingWidth
						End
					
						Self._characters[charIndex] = char
					Case "B"
						Self._characters_border[charIndex] = char
					Case "S"
						Self._characters_shadow[charIndex] = char
				End
			End
			
		Next
		
		Self._characters = Self._characters[ .. maxChar + 1]
		Self._characters_border = Self._characters_border[ .. maxChar + 1]
		Self._characters_shadow = Self._characters_shadow[ .. maxChar + 1]
		Self._textures =[]
		
		Return True
	End
	
	'Draw a text
	'You can use characters like Space(32), Return(13), New line(10) Or Tab(9)
	'------------------------------------------------------
	Method Draw:Void(text:String, x:Float, y:Float)
        Local __character:xFontCharacter
		Local __border_character:xFontCharacter
		Local __shadow_character:xFontCharacter
		Local __x:Float = x
		Local __y:Float = y
		
        For Local i:Int = 0 To text.Length - 1
			Local ascii:Int = text[i]
			
			If ascii = 32
				__x += Self._spaceWidth + Self._kerning.X
				Continue
			End
			
			If ascii = 13 Or ascii = 10
				__y += Self._returnHeight + Self._kerning.Y
				__x = x
				Continue
			End
			
            If ascii = 9
				__x += (Self._spaceWidth * Self._tabsize) + Self._kerning.X
			End
			
			
			__character = Self._characters[ascii]
			
			If (Self._showBorder)
				__border_character = Self._characters_border[ascii]
			End
			
			If (Self._showShadow)
				__shadow_character = Self._characters_shadow[ascii]
			End
			
            If __character <> Null
				If (Self._showShadow)
					__shadow_character.Draw(__x, __y)
				End
				
				If (Self._showBorder)
					__border_character.Draw(__x, __y)
				End
				
				__character.Draw(__x, __y)
				__x += __character.drawingWidth + Self._kerning.X
            End
        End
	End
	
		
	'Draw a single character
	'This method will not render empty characters
	'------------------------------------------------------
	Method DrawChar:Void(char:String, x:Float, y:Float)
		Local __character:xFontCharacter
		Local __border_character:xFontCharacter
		Local __shadow_character:xFontCharacter
			
		Local ascii:Int = char[0]
		
		If ascii > 32
	        __character = Self._characters[ascii]
			
			If (Self._showBorder)
				__border_character = Self._characters_border[ascii]
			End
			
			If (Self._showShadow)
				__shadow_character = Self._characters_shadow[ascii]
			End
				
	        If __character <> Null
				If (Self._showShadow)
					__shadow_character.Draw(x, y)
				End
				
				If (Self._showBorder)
					__border_character.Draw(x, y)
				End
				
				__character.Draw(x, y)
	        End
		End
	End
	
		
	'Get width of passed text
	'------------------------------------------------------	
	Method TextWidth:Float(text:String)
		Local __character:xFontCharacter
		Local __w:Float = 0
		Local width:Float = 0
		
        For Local i:Int = 0 To text.Length - 1
			Local ascii:Int = text[i]
			
			If ascii = 32
				__w += Self._spaceWidth + Self._kerning.X
				Continue
			End
			
			If ascii = 13 Or ascii = 10
				If (width < __w)
					width = __w
				End
				
				__w = 0
				Continue
			End
			
            If ascii = 9
				__w += (Self._spaceWidth * Self._tabsize) + Self._kerning.X
			End
			
			
			__character = Self._characters[ascii]
		
            If __character <> Null
				__w += __character.drawingWidth + Self._kerning.X
            End
        End
		
		If (width < __w)
			width = __w
		End
		
		Return width
	End
	
	'Get height of passed text
	'------------------------------------------------------
	Method TextHeight:Float(text:String)
		Local height:Float = 0
		
		If (text.Length > 0)
			height += Self._returnHeight + Self._kerning.Y
	        
			For Local i:Int = 0 To text.Length - 1
				Local ascii:Int = text[i]
				
				If ascii = 13 Or ascii = 10
					height += Self._returnHeight + Self._kerning.Y
					Continue
				End
	        End
		End
		
		Return height
	End
	
	
	'Discard the xFont
	'------------------------------------------------------
	Method Discard:Void()
		For Local i:Int = 0 To Self._characters.Length() -1
			Local _char:xFontCharacter = Self._characters[i]
			If (_char <> Null)
				_char.Discard()
			End
			
			_char = Self._characters_border[i]
			If (_char <> Null)
				_char.Discard()
			End
			
			_char = Self._characters_shadow[i]
			If (_char <> Null)
				_char.Discard()
			End
		Next
	
		Self._characters =[]
		Self._characters_border =[]
		Self._characters_shadow =[]
	End
	
	Method ShowBorder:Void()
		Self._showBorder = True
	End
	
	Method ShowShadow:Void()
		Self._showShadow = True
	End
	
	Method HideBorder:Void()
		Self._showBorder = False
	End
	
	Method HideShadow:Void()
		Self._showShadow = False
	End
	
	Method SetLettersSpace:Void(value:Float)
		Self._kerning.X = value
	End
	
	Method SetLinesSpace:Void(value:Float)
		Self._kerning.Y = value
	End
	
	Method SetTabSize:Void(size:Int = 4)
		Self._tabsize = size
	End
	
	
Private

	Field _textures:Image[]
	Field _characters:xFontCharacter[]
	Field _characters_shadow:xFontCharacter[]
	Field _characters_border:xFontCharacter[]
	Field _textureName:String
	
	Field _showBorder:Bool = False
	Field _showShadow:Bool = False
	
	Field _kerning:= New xPoint()
	Field _tabsize:Int = 4
	
	Field _returnHeight:Int = 0
	Field _spaceWidth:Int = 0
	
End

Function LoadxFont:xFont(path:String)
	Local font:= New xFont()
	If (font.Load(path))
		Return font
	End
	
	Return Null
End


Class xFontCharacter Extends xImageFrame
	Field ASCII:Int
	Field Offset:= New xPoint()
	Field drawingWidth:Int = 0
	
	Method New(ascii:Int, texture:Image, x:Int, y:Int, width:Int, height:Int, offsetX:Int, offsetY:Int, drawingWidth:Int)
		Self.ASCII = ascii
		Self.drawingWidth = drawingWidth
		
		Self.Texture = texture
		Self.Origin.Set(x, y)
		Self.Size.Set(width, height)
		Self.Offset.Set(offsetX, offsetY)
	End
	
	Method Draw:Void(x:Float = 0, y:Float = 0)
		If Self.Texture <> Null
			DrawImageRect(Self.Texture, x + Self.Offset.X, y + Self.Offset.Y, Self.Origin.X, Self.Origin.Y, Self.Size.Width, Self.Size.Height)
		End
	End
	
	Method toString:String()
		Return String.FromChar(Self.ASCII) + " = " + Self.ASCII
	End
	
	Method Discard:Void()
		Super.Discard()
		Self.Offset = Null
	End
End