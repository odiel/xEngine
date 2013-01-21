Strict

Import xengine.components.entity
Import xengine.components.animation

Class xSprite Extends xEntity

Public

	'Constructors
	'------------------------------------------------------
	Method New()
		Self.Id = NewId("Sprite")
		Self.Initialize()
	End
	
	Method New(id:String)
		Self.Id = id
		Self.Initialize()
	End
	
	Method New(id:String, position:xVector)
		Self.Id = id
		Self.SetPosition(position)
		Self.Initialize()
	End
	

	'Update
	'------------------------------------------------------
	Method Update:Void()
		Super.Update()
		
		If Self._currentAnimation <> Null
			Self._currentAnimation.Update(Self)
		End
	End
	
	'Self Render
	'------------------------------------------------------
	Method SelfRender:Void()
		If Self._frame <> Null
			Self._frame.Draw()
		End
	End
	
	
	'Add an animation to sprite
	'------------------------------------------------------
	Method AddAnimation:Void(animation:xAnimation)
		If animation <> null
			Self._animations.Insert(animation.Id, animation)
		End
	End
	
	'Remove an animation from sprite by animation object
	'------------------------------------------------------
	Method RemoveAnimation:Void(animation:xAnimation)
		Self._animations.Remove(animation.Id)
	End
	
	'Remove an animation from sprite by animation id
	'------------------------------------------------------
	Method RemoveAnimation:Void(id:String)
		Self._animations.Remove(id)
	End
	
	'Set the current animation by Id
	'------------------------------------------------------
	Method SetAnimation:Void(id:String)
		Self.SetAnimation(Self._animations.Get(id))
	End
	
	'Set the current animation by animation object
	'------------------------------------------------------
	Method SetAnimation:Void(animation:xAnimation)
		Self._currentAnimation = animation
		If (animation <> Null)
			Local frame:xImageFrame = animation.GetFrame(0)
			If (frame <> Null)
				Self.SetSize(frame.Size.Width, frame.Size.Height)
				Self.CalculateRegion()
			End
		End
	End
	
	'Get the current animation
	'------------------------------------------------------
	Method GetCurrentAnimation:xAnimation()
		Return Self._currentAnimation
	End
	
	Method SetFrame:Void(frame:xImageFrame)
		Self._frame = frame
		
		If frame <> Null
			Self.SetSize(frame.Size.Width, frame.Size.Height)
			Self.CalculateRegion()
		End
	End
	
		
	'Set the desired frame to show on current animation
	'------------------------------------------------------
	Method SetFrame:Void(index:Int)
		If Self._currentAnimation <> Null
			Self.SetFrame(Self._currentAnimation.GetFrame(index))
		End	
	End

	
	'Get the desired frame of current animation
	'------------------------------------------------------
	Method GetFrame:Void(index:Int)
		If Self._currentAnimation <> Null
			Return Self._currentAnimation.GetFrame(index)
		End	
	End
	
	'Play the current animation
	'------------------------------------------------------
	Method Play:Void()
		If Self._currentAnimation <> Null
			Self._currentAnimation.Play()
		End
	End
	
	Method Play:Void(repeatTimes:Int)
		If Self._currentAnimation <> Null
			Self._currentAnimation.SetRepeatTimes(repeatTimes)
			Self._currentAnimation.Play()
		End
	End
	
	Method Play:Void(animation:String)
		Self._currentAnimation = Self._animations.Get(animation)
		Self.Play()
	End
	
	Method Play:Void(animation:String, repeatTimes:Int)
		Self._currentAnimation = Self._animations.Get(animation)
		Self.Play(repeatTimes)
	End
	
	'Pause the current animation
	'------------------------------------------------------
	Method Pause:Void()
		If Self._currentAnimation <> Null
			Self._currentAnimation.Pause()
		End
	End
	
	'Resume the current animation
	'------------------------------------------------------
	Method Resume:Void()
		If Self._currentAnimation <> Null
			Self._currentAnimation.Resume()
		End
	End
	
	'Stop the current animation
	'------------------------------------------------------
	Method Stop:Void(at:Int = -1)
		If Self._currentAnimation <> Null
			Self._currentAnimation.Stop()
			If at >= 0
				Self._currentAnimation.SetFrame(at)
			End
		End
	End
	
Private

	Field _frame:xImageFrame

	Field _currentAnimation:xAnimation
	Field _animations:= New StringMap<xAnimation>

End


