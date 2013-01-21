Strict

Import mojo.app
Import xengine.basics.list

Class xIniReader

Public

	'Constructor
	'------------------------------------------------------
	Method New(path:String)
		Self.Load(path)		
	End
	
	'Load an ini file to parse
	'Return true if was loaded and is valid
	'------------------------------------------------------
	Method Load:Bool(path:String)
		Self._content = app.LoadString(path)
		Return Self._parseContent()
	End
	
	'Load an ini structure from string
	'Return true if was loaded and is valid
	'------------------------------------------------------
	Method LoadFromString:Bool(content:String)
		Self._content = content
		Return Self._parseContent()
	End
	
	'Add a section
	'------------------------------------------------------
	Method AddSection:Void(section:xIniSection)
		If section <> null
			Self._sections.AddLast(section)
		End
	End
	
	'Get a section
	'------------------------------------------------------
	Method GetSection:xIniSection(name:String)
		For Local section:xIniSection = eachin Self._sections
			If section.Name = name
				Return section
			End
		Next
		
		Return Null
	End
	
	'Get the first section in list
	'------------------------------------------------------
	Method GetFirstSection:xIniSection()
		Return Self._sections.GetFirst()
	End
	
	'Get all sections
	'------------------------------------------------------
	Method GetSections:xList<xIniSection>()
		Return Self._sections
	End
	
	'Get a particular element in section
	'------------------------------------------------------
	Method GetElement:xIniElement(section:String, element:String)
		Local __section:xIniSection = Self.GetSection(section)
		If __section <> null
			Return __section.GetElement(element)
		End
		
		Return Null
	End
	
	'Get the value from a particular element in section
	'------------------------------------------------------
	Method GetElementValue:String(section:String, element:String)
		Local __section:xIniSection = Self.GetSection(section)
		If __section <> null
			Local __element:xIniElement = __section.GetElement(element)
			If __element <> null
				Return __element.Value
			End
		End
		
		Return ""
	End
	
	'Get the amount of sections
	'------------------------------------------------------
	Method GetSectionsAmount:Int()
		Return Self._sections.Count()
	End
	
	'Remove a section by his name
	'------------------------------------------------------
	Method RemoveSection:Void(name:String)
		Self.RemoveSection(Self.GetSection(name))
	End
	
	'Remove a section
	'------------------------------------------------------
	Method RemoveSection:Void(section:xIniSecction)
		If __section <> null
			Self._sections.Remove(section)
		End
	End
	
	'Save the structure to a file
	'------------------------------------------------------
	Method Save:Bool(path:String)
		'TODO: latter depending on OS target
	End
	
	'Clear the internal content variable
	'------------------------------------------------------
	Method ClearContent:Void()
		Self._content = ""
	End
	
	'Get the enumerator to use it with iterators
	'------------------------------------------------------
	Method ObjectEnumerator:xEnumerator<xIniSection>()
		Return Self._sections.ObjectEnumerator()
	End
	
	'Get the entire ini structure as String
	'------------------------------------------------------
	Method ToString:String()
		Local __string:String
		
		For Local section:xIniSection = Eachin Self
			__string+=section.ToString()+"~n"
		End
		
		Return __string
	End
	
	Method Discard:Void()
		For Local section:xIniSection = EachIn Self._sections
			section.Discard()
			section = Null
		Next
		
		Self._sections.Clear()
		Self._sections = Null
		Self.ClearContent()
	End

Private

	Field _content:String
	Field _sections:xList<xIniSection> = New xList<xIniSection>
	
	'Parse the content to generate each section with his elements
	Method _parseContent:Bool()
		If Self._content.Length > 0
		
			Local __section:xIniSection
			
			Local __firstBraket:Int = 0
			Local __lastElementPos:Int = 0
			
			Local __posibleSectionAt:Int
			
			Local __previousReturn:Bool = False
			Local __lines:Int = 1
			
			Local __addedSections:Int
			
			Local __elementName:String
			Local __elementLine:Int
			Local __elementValueAt:Int
			Local __elementFound:Bool = False
			
			For local i:Int = 0 To Self._content.Length-1
				Local char:String = String.FromChar(Self._content[i])
				
				If (Self._content[i] = 10 Or Self._content[i] = 13) Or i = Self._content.Length-1
					Local __i:Int = i
					
					If i = Self._content.Length-1
						__i = Self._content.Length
					End
					
					If __elementFound = True
						Local __element:= New xIniElement
						__element.Name = __elementName
						__element.Line = __elementLine
						__element.Value = Self._content[__lastElementPos .. __i].Trim()
						
						If __section = Null
							__section = New xIniSection("default")
							Self.AddSection(__section)
							__addedSections += 1
						End
						
						__section.AddElement(__element)
						
						__elementFound = False
					End
					
					__lastElementPos = i
				End

				
				If (Self._content[i] = 10 Or Self._content[i] = 13) And __previousReturn = False
					__previousReturn = True
					__lines+=1
				Else
					__previousReturn = False
				End
				
				
				If char = "["
					__firstBraket = i+1
					__posibleSectionAt = __lines
					
					If __section <> Null
						Self.AddSection(__section)
						__addedSections+=1
					End
					
					__section = Null
				End

				If __firstBraket > -1 And char = "]"
					__section = New xIniSection
					__section.Name = Self._content[__firstBraket..i].Trim()
					__section.Line = __posibleSectionAt
					__firstBraket = -1
				End
				
				If char = "="
					__elementName = Self._content[__lastElementPos .. i].Trim()
					__elementLine = __lines
					__lastElementPos = i+1
					__elementFound = True
				End
				
			End
			
			If __section <> Null
				Self.AddSection(__section)
				__addedSections+=1
			End
			
			'No one session founded, so this is not valid Ini file
			If __addedSections = 0
				Return False
			End
			
			Self.ClearContent()
			
			Return True
		End 
		
		Return False
	End
End


Class xIniSection

Public
	
	Field Name:String
	Field Line:Int
	
	'Constructor
	'------------------------------------------------------
	Method New(name:String, line:Int = 0)
		Self.Name = name
		Self.Line = line
	End
	
	'Add an element
	'------------------------------------------------------
	Method AddElement:Void(element:xIniElement)
		If (element <> null)
			Self._elements.AddLast(element)
		End
	End

	'Get an element
	'------------------------------------------------------
	Method GetElement:xIniElement(name:String)
		For local element:xIniElement = eachin Self._elements
			If element.Name = name
				Return element
			End
		Next
		
		Return null
	End
	
	'Get the first element
	'------------------------------------------------------
	Method GetFirstElement:xIniElement()
		Return Self._elements.First()
	End
	
	'Get all the elements that have the passed @name
	'------------------------------------------------------
	Method GetElements:xList<xIniElement>(name:String)
		Local __list:xList<xIniElement> = New xList<xIniElement>
		For local element:xIniElement = eachin Self._elements
			If element.Name = name
				__list.AddLast(element)
			End
		Next
		
		Return __list
	End
	
	'Get all the elements
	'------------------------------------------------------
	Method GetElements:xList<xIniElement>()
		Return Self._elements
	End

	'Get an element value
	'------------------------------------------------------
	Method GetElementValue:String(name:String)
		Local __element:xIniElement = Self.GetElement(name)
		if __element <> null
			Return __element.Value.Trim()
		End
		
		Return ""
	End
	
	'Get the amount of elements
	'------------------------------------------------------
	Method GetElementsAmount:Int(name:String = "")
		Local amount:Int = Self._elements.Count()
		
		if (name <> "")
			amount = 0
			For Local element:xIniElement = eachin Self._elements
				If element.Name = name
					amount+=1
				End
			Next
		End
		
		Return amount
	End
	
	'Remove an element by his name
	'------------------------------------------------------
	Method RemoveElement:Void(name:String)
		Self.RemoveElement(Self.GetElement(name))
	End
	
	'Remove an element
	'------------------------------------------------------
	Method RemoveElement:Void(element:xIniElement)
		If (element <> null)
			Self._elements.Remove(element)
		End
	End
	
	'Get the enumerator to use it with iterators
	'------------------------------------------------------
	Method ObjectEnumerator:xEnumerator<xIniElement>()
		Return Self._elements.ObjectEnumerator()	
	End
	
	'Convert the entire section structure to String
	'------------------------------------------------------
	Method ToString:String()
		Local __content:String = "["+Self.Name+"]~n"
		
		For Local element:xIniElement = eachin Self._elements
			__content+=element.ToString()+"~n"
		Next
		
		Return __content
	End
	
	
	Method Discard:Void()
		For Local element:xIniElement = EachIn Self._elements
			element = Null
		Next
		
		Self._elements.Clear()
		Self._elements = Null
	End

Private

	Field _elements:xList<xIniElement> = New xList<xIniElement>
	
End


Class xIniElement

Public
	
	Field Name:String
	Field Value:String
	Field Line:Int
	
	'Constructor
	'------------------------------------------------------
	Method New(name:String, value:String, line:Int = 0)
		Self.Name = name
		Self.Value = value
		Self.Line = line
	End
	
	'Convert to string
	'------------------------------------------------------
	Method ToString:String()
		Return Self.Name+"="+Self.Value
	End
	
End