Strict

Import mojo
Import xengine.events.logger
Import xengine.io.resources.resource
Import xengine.io.resources.font
Import xengine.io.resources.imageframe
Import xengine.io.ini
Import xengine.io.logger.base


Global xResources:= New xResourceManager()

Class xResourceManager


	'Load an image from path
	'------------------------------------------------------
	Method LoadImage:Image(id:String, path:String)
		Local img:Image = graphics.LoadImage(path)
		
		If (img <> Null)
			Self.log(xEvent_Logger.INFO, 100, "[" + id + "] from [" + path + "], successfully loaded.", "Loading", "Image")
			
			Self._resources_images.Set(id, img)
			Return img
		Else
			Self.log(xEvent_Logger.ERROR, 150, "[" + id + "] from [" + path + "], unable to load this resource.", "Loading", "Image")
		End
		
		Return Null
	End
	
	'Unload a loaded image
	'------------------------------------------------------
	Method UnloadImage:Bool(id:String)
		Local img:Image = Self._resources_images.Get(id)
		If img <> null
			Self._resources_images.Remove(id)
			img.Discard()
			
			Self.log(xEvent_Logger.INFO, 120, "[" + id + "] successfully unloaded.", "Unload", "Image")
			
			Return True
		End
		
		Self.log(xEvent_Logger.ALERT, 170, "[" + id + "] already unloaded or never loaded.", "Unload", "Image")
		
		Return False
	End
	
	
	'Load an atlas (http://en.wikipedia.org/wiki/Texture_atlas)
	'------------------------------------------------------
	Method LoadAtlas:String[] (path:String)
		Local reader:= New xIniReader(path)
		Local section:xIniSection = reader.GetFirstSection()
		Local elements:String[] =[]
		
		If (section <> Null)
			Local resource_el:xIniElement = section.GetElement("resource")
			Local texture_el:xIniElement = section.GetElement("texture")
			
			If (resource_el <> Null And texture_el <> Null)
				Local image:Image = Self.GetImage(resource_el.Value)
				
				If (image = Null)
					image = Self.LoadImage(resource_el.Value, texture_el.Value)
				End
				
				If (image <> Null)
					For Local element:xIniElement = EachIn section.GetElements()
						If element.Name <> "texture"
							Local parts:String[] = element.Value.Split(" ")
							If (parts.Length() = 4)
								Self.AddImageFrame(element.Name, New xImageFrame(image, Int(parts[0]), Int(parts[1]), Int(parts[2]), Int(parts[3])))
								
								elements = elements.Resize(elements.Length + 1)
								elements[elements.Length - 1] = element.Name
								
								Self.log(xEvent_Logger.INFO, 100, "[" + element.Name + "] from [" + path + "], successfully loaded.", "Loading", "ImageFrame")
							End
						End
					Next
					
					Return elements

				End
			End
			
		End
		
		Self.log(xEvent_Logger.ERROR, 160, "[Atlas] from [" + path + "], unable to load texture or frame section definition for this resource.", "Loading", "Atlas")
		
		Return elements
	End
	
	'Unload a loaded texture
	'------------------------------------------------------
	Method UnLoadImageFrame:Bool(id:String)
		Local frame:xImageFrame = Self._resources_imageframes.Get(id)
		If frame <> Null
			frame.Discard()
			
			Self.log(xEvent_Logger.INFO, 121, "[" + id + "] successfully unloaded.", "Unload", "ImageFrame")
			
			Return True
		End
		
		Self.log(xEvent_Logger.ALERT, 171, "[" + id + "] already unloaded or never loaded.", "Unload", "ImageFrame")
		
		Return False
	End
	
	
	'Load a sound from path
	'------------------------------------------------------
	Method LoadSound:Sound(id:String, path:String)
		Local __sound:Sound = audio.LoadSound(path)
		
		If __sound <> Null
			Self.log(xEvent_Logger.INFO, 200, "[" + id + "] from [" + path + "], successfully loaded.", "Loading", "Sound")
			
			Self._resources_sounds.Set(id, __sound)
			Return __sound
		Else
			Self.log(xEvent_Logger.ERROR, 250, "[" + id + "] from [" + path + "], unable to load this resource.", "Loading", "Sound")
		End
		
		Return Null
	End
	
	'Unload a loaded sound
	'------------------------------------------------------
	Method UnloadSound:Bool(id:String)
		Local snd:Sound = Self._resources_sounds.Get(id)
		If snd <> null
			Self._resources_sounds.Remove(id)
			snd.Discard()
			
			Self.log(xEvent_Logger.INFO, 220, "[" + id + "] successfully unloaded.", "Unload", "Sound")
			
			Return True
		End
		
		Self.log(xEvent_Logger.ALERT, 270, "[" + id + "] already unloaded or never loaded.", "Unload", "Sound")
		
		Return False
	End
	
	
	'Load a string from path
	'------------------------------------------------------
	Method LoadString:String(id:String, path:String)
		Local ___string:String = app.LoadString(path)
		
		If ___string.Length > 0
			Self.log(xEvent_Logger.INFO, 300, "[" + id + "] from [" + path + "], successfully loaded.", "Loading", "String")
			
			Self._resources_strings.Set(id, ___string)
			Return ___string
		Else
			Self.log(xEvent_Logger.ERROR, 350, "[" + id + "] from [" + path + "], unable to load this resource.", "Loading", "String")
		End
		
		Return ""
	End
	
	'Unload a loaded string
	'------------------------------------------------------
	Method UnloadString:Bool(id:String)
		Local str:String = Self._resources_strings.Get(id)
		If str <> ""
			Self._resources_strings.Remove(id)
			
			Self.log(xEvent_Logger.INFO, 320, "[" + id + "] successfully unloaded.", "Unload", "String")
			Return True
		End
		
		Self.log(xEvent_Logger.ALERT, 370, "[" + id + "] already unloaded or never loaded.", "Unload", "String")
		
		Return False
	End
	
	'Load a xFont from path
	'------------------------------------------------------
	Method LoadFont:xFont(id:String, path:String)
		Local _font:xFont = LoadxFont(path)
		
		If _font <> Null
			Self.log(xEvent_Logger.INFO, 400, "[" + id + "] from [" + path + "], successfully loaded.", "Loading", "Font")
			
			Self._resources_fonts.Set(id, _font)
			Return _font
		Else
			Self.log(xEvent_Logger.ERROR, 450, "[" + id + "] from [" + path + "], unable to load this resource.", "Loading", "Font")
		End
		
		Return Null
	End
	
	'Unload a loaded xFont
	'------------------------------------------------------
	Method UnloadFont:Bool(id:String)
		Local font:xFont = Self._resources_fonts.Get(id)
		If font <> Null
			Self._resources_fonts.Remove(id)
			font.Discard()
			
			Self.log(xEvent_Logger.INFO, 320, "[" + id + "] successfully unloaded.", "Unload", "xFont")
			Return True
		End
		
		Self.log(xEvent_Logger.ALERT, 370, "[" + id + "] already unloaded or never loaded.", "Unload", "xFont")
		
		Return False
	End
	
	'Unload a loaded custom resource
	'------------------------------------------------------
	Method UnloadResource:Bool(id:String)
		Local obj:xResource = Self._resources.Get(id)
		If obj <> Null
			Self._resources.Remove(id)
			obj.Discard()
			
			Self.log(xEvent_Logger.INFO, 320, "[" + id + "] successfully unloaded.", "Unload", "xFont")
			Return True
		End
		
		Self.log(xEvent_Logger.ALERT, 370, "[" + id + "] already unloaded or never loaded.", "Unload", "xFont")
		
		Return False
	End
	
	'Add a custom resource
	'------------------------------------------------------
	Method AddResource:Void(id:String, resource:xResource)
		Self._resources.Set(id, resource)
	End
	
	'Add an image resource
	'------------------------------------------------------
	Method AddImage:Void(id:String, resource:Image)
		If resource <> Null
			Self._resources_images.Set(id, resource)
		End
	End
	
	'Add an spriteFrame resource
	'------------------------------------------------------
	Method AddImageFrame:Void(id:String, resource:xImageFrame)
		If resource <> Null
			Self._resources_imageframes.Set(id, resource)
		End
	End
	
	'Add a texture resource
	'------------------------------------------------------
	Method AddTexture:Void(id:String, resource:xTexture)
		If resource <> Null
			Self._resources_textures.Set(id, resource)
		End
	End
	
	'Add a sound resource
	'------------------------------------------------------
	Method AddSound:Void(id:String, resource:Sound)
		If resource <> Null
			Self._resources_sounds.Set(id, resource)
		End
	End
	
	'Add a string resource
	'------------------------------------------------------
	Method AddString:Void(id:String, resource:String)
		If resource <> ""
			Self._resources_strings.Set(id, resource)
		End
	End
	
	'Add a xFont resource
	'------------------------------------------------------
	Method AddFont:Void(id:String, resource:xFont)
		If resource <> Null
			Self._resources_fonts.Set(id, resource)
		End
	End
	
	
	'Get a loaded resource
	'------------------------------------------------------
	Method GetResource:xResource(id:String)
		Return Self._resources.Get(id)
	End
	
	'Get a loaded image
	'------------------------------------------------------
	Method GetImage:Image(id:String)
		Return Self._resources_images.Get(id)
	End
	
	'Get a loaded texture
	'------------------------------------------------------
	Method GetImageFrame:xImageFrame(id:String)
		Return Self._resources_imageframes.Get(id)
	End
	
	'Get a loaded sound
	'------------------------------------------------------
	Method GetSound:Sound(id:String)
		Return Self._resources_sounds.Get(id)
	End
	
	'Get a loaded string
	'------------------------------------------------------
	Method GetString:String(id:String)
		Return Self._resources_strings.Get(id)
	End
	
	'Get a loaded string
	'------------------------------------------------------
	Method GetFont:xFont(id:String)
		Return Self._resources_fonts.Get(id)
	End

	'Invoke the logger event handler
	'------------------------------------------------------
	Method SetLogger:Void(logger:xLoggerBase)
		Self._logger = logger
	End
	

Private

	Field _resources_images:= New StringMap<Image>
	Field _resources_imageframes:= New StringMap<xImageFrame>
	Field _resources_sounds:= New StringMap<Sound>
	Field _resources_strings:= New StringMap<String>
	Field _resources_fonts:= New StringMap<xFont>
	
	Field _resources:= New StringMap<xResource>

	Method log:Void(level:String, code:Int, message:String, section:String = "", action:String = "")
		If (Self._logger <> Null)
			Self._logger.time = "12:00:00"
			Self._logger.date = "2012-12-12"
			Self._logger.message = message
			Self._logger.level = level
			Self._logger.section = section
			Self._logger.action = action
			Self._logger.code = code
			Self._logger.Invoke()
		End	
	End

	Field _logger:xLoggerBase
	
End
