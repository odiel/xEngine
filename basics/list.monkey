Strict

Class xList<T>

Public

	'Add first
	'------------------------------------------------------
	Method AddFirst:xLink<T>(value:T)
		Return New xLink<T>(Self._head, Self._head._next, value, Self)
	End
	
	'Add last
	'------------------------------------------------------
	Method AddLast:xLink<T>(value:T)
		Return New xLink<T>(Self._head._prev, Self._head, value, Self)
	End

	'Get first link
	'------------------------------------------------------
	Method GetFirstLink:xLink<T>()
		Return Self._head._next
	End
	
	'Get last link
	'------------------------------------------------------
	Method GetLastLink:xLink<T>()
		Return Self._head._prev
	End
	
	'Get first link depending on value
	'------------------------------------------------------
	Method GetLink:xLink<T>(value:T)
		Local link:=_head._next
		While link <> Self._head
			If link._data = value 
				Return link
			End
			
			link = link._next
		Wend
		
		Return Null
	End
	
	'Get link at index position
	'------------------------------------------------------
	Method GetLinkAt:xLink<T>(index:Int)
		Local link:=_head._next
		Local c:Int = 0
		While link <> Self._head
			If index = c
				return link
			End
			c+=1
			link = link._next
		Wend
		Return null
	End
	
	'Get first object
	'------------------------------------------------------
	Method First:T()
		Return Self._head._next._data
	End
	
	'Get first object
	'------------------------------------------------------
	Method GetFirst:T()
		Return Self._head._next._data
	End
	
	'Get last object
	'------------------------------------------------------
	Method Last:T()
		Return Self._head._next._data
	End
	
	'Get last object
	'------------------------------------------------------
	Method GetLast:T()
		Return Self._head._prev._data
	End
	
	'Get link object at index position
	'------------------------------------------------------
	Method GetAt:T(index:Int)
		Local link:=_head._next
		Local c:Int = 0
		While link <> Self._head
			If index = c
				return link.GetValue()
			End
			c+=1
			link = link._next
		Wend
		Return null
	End
	
	'Remove the first link depending on valule
	'------------------------------------------------------
	Method Remove:Void(value:T)
		Local link:xLink<T> = Self.GetLink(value)
		if link <> null
			link.Remove()
		End
	End
	
	'Remove each link that contain value
	'------------------------------------------------------
	Method RemoveEach:Void(value:T)
		Local link:=_head._next
		While link <> Self._head
			If link._data = value
				link.Remove()
			End
			link = link._next
		Wend
	End
	
	'Remove the firts link
	'------------------------------------------------------
	Method RemoveFirst:Void()
		_head._next.Remove()
	End
	
	'Remove the last link
	'------------------------------------------------------
	Method RemoveLast:Void()
		_head._prev.Remove()
	End
	
	'Remove link at index position
	'------------------------------------------------------
	Method RemoveAt:Void(index:Int)
		Local link:xLink<T> = Self.GetLinkAt(index)
		if link <> null
			link.Remove()
		End
	End
	
	'Clear all links and recreate a new list
	'------------------------------------------------------
	Method Clear:Void()
		Local link:=_head._next
		While link <> Self._head
			link.Remove()
			link = link._next
		Wend
		
		Self._head = New xLink<T>
	End
	
	'List is empty?
	'------------------------------------------------------
	Method IsEmpty:Bool()
		Return Self._head._next=_head
	End
	
	'Update the internal counter
	'Avoid to use this method, only for internal link mechanism
	'------------------------------------------------------
	Method UpdateCount:Void(value:Int)
		Self._count+=value
	End
	
	'Get the amount of elements in list
	'------------------------------------------------------
	Method Count:Int()
		Return Self._count
	End
	
	'Get the list enumerator to perform For-Each
	'------------------------------------------------------
	Method ObjectEnumerator:xEnumerator<T>()
		Return New xEnumerator<T>(Self)
	End Method
	
	'Get the standart enumerator
	'------------------------------------------------------
	Method GetEnumerator:xEnumerator<T>()
		Return New xEnumerator<T>(Self)
	End Method
	
	'Get the reverse enumerator, the For-Each make from the last element to the first
	'------------------------------------------------------
	Method GetReverseEnumerator:xEnumerator<T>()
		Return New xReverseEnumerator<T>(Self)
	End Method
	
	Method GetHead:xLink<T>()
		Return Self._head
	End
	
	
Private

	Field _head:xLink<T> = New xLink<T>
	Field _count:Int = 0
	Field _cacheOn:Bool = False

End


Class xLink<T>

Public

	'Constructors
	'------------------------------------------------------
	Method New()
		Self._next = Self
		Self._prev = Self
	End
	
	Method New(previous:xLink, _next:xLink, data:T, parentList:xList<T>)
		Self._next = _next
		Self._prev = previous
		_next._prev = Self
		previous._next = Self
		Self._data = data
		Self._list = parentList
		Self._list.UpdateCount(1)
	End
	'------------------------------------------------------
	
	'Get next link
	'------------------------------------------------------
	Method GetNextLink:xLink()
		Return Self._next
	End
	
	'Get previous link
	'------------------------------------------------------
	Method GetPrevLink:xLink()
		Return Self._prev
	End
	
	'Get the next object
	'------------------------------------------------------
	Method GetNext:T()
		Return Self._next._data
	End
	
	'Get the previous object
	'------------------------------------------------------
	Method GetPrev:T()
		Return Self._prev._data
	End
	
	'Get the link value
	'------------------------------------------------------
	Method GetValue:T()
		Return Self._data
	End
	
	'Remove the link
	'------------------------------------------------------
	Method Remove:Void()
		Self._list.UpdateCount(-1)
		Self._next._prev = Self._prev
		Self._prev._next = Self._next
		Self._list = Null
	End
	
	'Set the link data value
	'------------------------------------------------------
	Method SetValue:Void(data:T)
		Self._data = data
	End

Private

	Field _next:xLink
	Field _prev:xLink
	Field _data:T
	Field _list:xList<T>
	
End




Class xEnumerator<T>

Public

	'Constructor
	'------------------------------------------------------
	Method New(list:xList<T>)
		Self._list = list
		Self._current = list._head._next
	End Method

	'Check if has next object
	'------------------------------------------------------
	Method HasNext:Bool()
		Return Self._current <> Self._list._head
	End 
	
	'Get the next link
	'------------------------------------------------------
	Method GetCurrentLink:xLink<T>()
		Return Self._current
	End

	'Get the next object
	'------------------------------------------------------
	Method NextObject:T()
		Local data:T = Self._current._data
		Self._current = Self._current._next
		Return data
	End
	
	'Get the current enumerator to perform For-Each
	'------------------------------------------------------
	Method ObjectEnumerator:xEnumerator<T>()
		Return Self
	End Method

Private
	
	Field _list:xList<T>
	Field _current:xLink<T>

End

Class xReverseEnumerator<T> Extends xEnumerator<T>

Public

	'Constructor
	'------------------------------------------------------
	Method New(list:xList<T>)
		Self._list = list
		Self._current = list._head._prev
	End Method

	'Get the next object
	'------------------------------------------------------
	Method NextObject:T()
		Local data:T = Self._current._data
		Self._current = Self._current._prev
		Return data
	End

End
