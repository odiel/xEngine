Strict

Import xengine.io.factories.base
Import xengine.components.animation
Import xengine.io.ini
Import xengine.io.resources

Class xFactoryAnimation Extends xFactory
	
Public

	Method ByIniString:xAnimation(content:String)
		Local reader:= New xIniReader()
		reader.LoadFromString(content)
		
		Local section:xIniSection = reader.GetFirstSection()
		
		If (section <> Null)
			Local animation:= New xAnimation(section.Name)
		
			Local resource_el:xIniElement = section.GetElement("resource")
			
			If (resource_el <> Null)
				Local image:Image = xResources.GetImage(resource_el.Value)
				
				Local frames:xList<xIniElement> = section.GetElements("frame")
				
				If (frames.Count() > 0)
					For Local element:xIniElement = EachIn frames
						Local values:String[] = element.Value.Split(",")
						
						If (values.Length = 4 Or values.Length = 5)
							Local frame:= New xImageFrame()
							frame.Texture = image
							frame.Origin.X = Float(values[0])
							frame.Origin.Y = Float(values[1])
							frame.Size.Width = Float(values[2])
							frame.Size.Height = Float(values[3])
							
							animation.AddFrame(frame)
						End
					Next
				Else
				
				End
				
				
			End
			
			Return animation
		End
		
		Return Null
	End
	
	
	
'	
'	'Add more frames to frames composition by start frame and end frame
'	'------------------------------------------------------
'	Method AddFrames:Void(startFrame:Int, endFrame:Int)
'		Local __frames:Int[Abs(startFrame - endFrame) + 1]
'		Local c:Int = 0
'			
'		If (startFrame < endFrame)
'			For Local i:Int = startFrame To endFrame
'				__frames[c] = i
'				c+=1
'			Next
'		Else If (startFrame > endFrame)
'			For Local i:Int = startFrame To endFrame Step -1
'				__frames[c] = i
'				c+=1
'			Next
'		Else
'			__frames[0] = startFrame
'		End
'		
'		Self.AddFrames(__frames)
'	End
	
End
