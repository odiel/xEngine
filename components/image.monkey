Strict

Import xengine.components.entity


Class xImage Extends xEntity

Public

	'Constructors
	'------------------------------------------------------
	Method New()
		Self.Id = NewId("Image")
		Self.Initialize()
	End
	
	Method New(id:String)
		Self.Id = id
		Super.Initialize()
	End
	
	Method New(id:String, position:xVector)
		Self.SetPosition(position)
		Self.Id = id
		Super.Initialize()
	End
	
	'Self Render
	'------------------------------------------------------
	Method SelfRender:Void()
		If Self._texture <> Null
			DrawImage(Self._texture, 0, 0)
		End
	End
	
	'Set image texture
	'------------------------------------------------------
	Method SetTexture:Void(texture:Image)
		If texture <> Null
			Self._texture = texture
			Self.SetSize(texture.Width(), texture.Height())
			Self.CalculateRegion()
		End
	End
	
	'Get image texture
	'------------------------------------------------------
	Method GetTexture:Image()
		Return Self._texture
	End

Private
	
	Field _texture:Image
	
End