Strict

Import xengine

Class xConfiguratorHelper

	Function EntityByIniSection:Void(entity:xEntity, section:xIniSection, inireader:xIniReader = Null)
		If section <> Null And entity <> Null
			For local element:xIniElement = Eachin section.GetElements()
				Local __property:String = element.Name.ToLower().Trim()
				Local __value:String = element.Value.Trim()
				
				Select __property
					Case "ximage"
						If inireader <> null
							Local __image:xImage = New xImage(__value)
							Local __section:xIniSection = inireader.GetSection(__value)
							xConfiguratorHelper.EntityByIniSection(__image, __section, inireader)
							entity.AttachEntity(__image)
						End
					Case "xsprite"
						If inireader <> null
							Local __sprite:xSprite = New xSprite(__value)
							Local __section:xIniSection = inireader.GetSection(__value)
							xConfiguratorHelper.EntityByIniSection(__sprite, __section, inireader)
							entity.AttachEntity(__sprite)
						End
					Default
						entity.SetProperty(__property, __value)
				End
			Next
		End
	End
	
	Function AnimationByIniSection:Void(animation:xAnimation, section:xIniSection, inireader:xIniReader = Null)
		If section <> Null And animation <> Null
			For local element:xIniElement = Eachin section.GetElements()
				animation.SetProperty(element.Name.ToLower().Trim(), element.Value.Trim())
			Next
		End
	End
	
End