* Sample
Clear
executeScript("-")
* End Sample

* =================================================================================== *
* Implementation
* =================================================================================== *
Procedure executeScript(tcScript)
	#ifndef ttTable
		#Define ttTable 1
	#Endif
	#ifndef ttDescription
		#Define ttDescription 2
	#Endif
	#ifndef ttFields
		#Define ttFields 3
	#Endif
	#ifndef ttName
		#Define ttName 4
	#Endif
	#ifndef ttType
		#Define ttType 5
	#Endif
	#ifndef ttSize
		#Define ttSize 6
	#Endif
	#ifndef ttPrimaryKey
		#Define ttPrimaryKey 7
	#Endif
	#ifndef ttAllowNull
		#Define ttAllowNull 8
	#Endif
	#ifndef ttChar
		#Define ttChar 9
	#Endif
	#ifndef ttVarchar
		#Define ttVarchar 10
	#Endif
	#ifndef ttDecimal
		#Define ttDecimal 11
	#Endif
	#ifndef ttDate
		#Define ttDate 12
	#Endif
	#ifndef ttDateTime
		#Define ttDateTime 13
	#Endif
	#ifndef ttDouble
		#Define ttDouble 14
	#Endif
	#ifndef ttFloat
		#Define ttFloat 15
	#Endif
	#ifndef ttInt
		#Define ttInt 16
	#Endif
	#ifndef ttBool
		#Define ttBool 17
	#Endif
	#ifndef ttText
		#Define ttText 18
	#Endif
	#ifndef ttVarBinary
		#Define ttVarBinary 19
	#Endif
	#ifndef ttBlob
		#Define ttBlob 20
	#Endif
	#ifndef ttIdent
		#Define ttIdent 21
	#Endif
	#ifndef ttNumber
		#Define ttNumber 22
	#Endif
	#ifndef ttString
		#Define ttString 23
	#Endif
	#ifndef ttEof
		#Define ttEof 24
	#Endif
	#ifndef ttColon
		#Define ttColon 25
	#Endif
	#ifndef ttMinus	
		#Define ttMinus 26
	#Endif
	#ifndef ttAutoIncrement
		#Define ttAutoIncrement 27
	#Endif

	Local loScanner, laTokens
	loScanner = Createobject("Scanner", tcScript)
	laTokens = loScanner.scanTokens()

	For Each loToken In laTokens
		? loToken.toString()
	Endfor
Endproc

* =================================================================================== *
* Scanner Class
* =================================================================================== *
Define Class Scanner As Custom
	Hidden ;
		cSource, ;
		nStart, ;
		nCurrent, ;
		nCapacity, ;
		nLength, ;
		nSourceLen, ;
		cLetters, ;
		nLine, ;
		oKeywords

	cSource = ''
	nStart = 0
	nCurrent = 1
	cLetters = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ_'
	nLine = 1
	nCapacity = 0
	nLength = 1
	nSourceLen = 0

	Dimension aTokens[1]

	Procedure Init(tcSource)
		This.cSource = tcSource
		This.nSourceLen = Len(tcSource)

		* Create keywords
		This.oKeywords = Createobject("Scripting.Dictionary")
		This.oKeywords.Add('table', Createobject("Token", ttTable))
		This.oKeywords.Add('description', Createobject("Token", ttDescription))
		This.oKeywords.Add('fields', Createobject("Token", ttFields))

		* Fields attributes
		This.oKeywords.Add('name', Createobject("Token", ttName))
		This.oKeywords.Add('type', Createobject("Token", ttType))
		This.oKeywords.Add('size', Createobject("Token", ttSize))
		This.oKeywords.Add('primaryKey', Createobject("Token", ttPrimaryKey))
		This.oKeywords.Add('allowNull', Createobject("Token", ttAllowNull))

		* Table data types
		This.oKeywords.Add('char', Createobject("Token", ttChar))
		This.oKeywords.Add('varchar', Createobject("Token", ttVarchar))
		This.oKeywords.Add('decimal', Createobject("Token", ttDecimal))
		This.oKeywords.Add('date', Createobject("Token", ttDate))
		This.oKeywords.Add('dateTime', Createobject("Token", ttDateTime))
		This.oKeywords.Add('double', Createobject("Token", ttDouble))
		This.oKeywords.Add('float', Createobject("Token", ttFloat))
		This.oKeywords.Add('int', Createobject("Token", ttInt))
		This.oKeywords.Add('bool', Createobject("Token", ttBool))
		This.oKeywords.Add('text', Createobject("Token", ttText))
		This.oKeywords.Add('varBinary', Createobject("Token", ttVarBinary))
		This.oKeywords.Add('blob', Createobject("Token", ttBlob))
	Endproc

	Hidden Function advance
		This.nCurrent = This.nCurrent + 1
		Return Substr(This.cSource, This.nCurrent-1, 1)
	Endfunc

	Hidden Function peek
		If This.isAtEnd()
			Return 'ÿ'
		Endif
		Return Substr(This.cSource, This.nCurrent, 1)
	Endfunc

	Hidden Function peekNext
		If (This.nCurrent + 1) > This.nSourceLen
			Return 'ÿ'
		Endif
		Return Substr(This.cSource, This.nCurrent+1, 1)
	Endfunc

	Hidden Procedure skipWhitespace
		Local ch
		Do While Inlist(This.peek(), Chr(9), Chr(10), Chr(13), Chr(32))
			ch = This.advance()
			If ch == Chr(10)
				This.nLine = This.nLine + 1
			Endif
		Enddo
	Endproc

	Hidden Function readIdentifier
		Local lcLexeme
		Do While At(This.peek(), This.cLetters) > 0
			This.advance()
		Enddo

		lcLexeme = Substr(This.cSource, This.nStart, This.nCurrent-This.nStart)
		If This.oKeywords.Exists(lcLexeme)
			Return This.oKeywords.Item(lcLexeme)
		Endif

		Return This.addToken(ttIdent, lcLexeme)
	Endfunc

	Hidden Function readNumber
		Local lcLexeme, llIsNegative
		lcLexeme = ''
		llIsNegative = This.peek() == '-'
		If llIsNegative
			This.advance()
		Endif

		Do While Isdigit(This.peek())
			This.advance()
		Enddo

		If This.peek() == '.' And Isdigit(This.peekNext())
			This.advance()
			Do While Isdigit(This.peek())
				This.advance()
			Enddo
		Endif

		lcLexeme = Substr(This.cSource, This.nStart, This.nCurrent-This.nStart)

		Return This.addToken(ttNumber, lcLexeme)
	Endfunc

	Hidden Function readString(tcStopChar)
		Local lcLexeme, ch
		Do While !This.isAtEnd()
			ch = This.peek()
			If ch == tcStopChar
				This.advance()
				Exit
			Endif
		Enddo
		lcLexeme = Substr(This.cSource, This.nStart+1, This.nCurrent-This.nStart-2)

		Return This.addToken(ttString, lcLexeme)
	Endfunc

	Function scanTokens
		Dimension This.aTokens[1]

		Do While !This.isAtEnd()
			This.skipWhitespace()
			This.nStart = This.nCurrent
			This.scanToken()
		Enddo
		This.addToken(ttEof)
		This.nCapacity = This.nLength-1

		* Shrink the array
		Dimension This.aTokens[this.nCapacity]

		Return @This.aTokens
	Endfunc

	Hidden Procedure scanToken
		Local ch
		ch = This.advance()
		Do Case
		Case ch == ':'
			Return This.addToken(ttColon, ch)

		Case ch == '-' And !Isdigit(This.peek())
			Return This.addToken(ttMinus, ch)

		Case Inlist(ch, '"', "'")
			Return This.readString(ch)

		Otherwise
			If Isdigit(ch) Or (ch == '-' And Isdigit(This.peek()))
				Return This.readNumber()
			Endif
			If At(ch, This.cLetters) > 0
				Return This.readIdentifier()
			Endif
			This.showError(This.nLine, "Unknown character ['" + Transform(ch) + "'], ascii: [" + Transform(Asc(ch)) + "]")
		Endcase
	Endproc

	Hidden Procedure addToken(tnType, tvLiteral)
		This.checkCapacity()
		Local loToken
		loToken = Createobject("Token", tnType, "", tvLiteral, This.nLine)
		This.aTokens[this.nLength] = loToken
		This.nLength = This.nLength + 1
	Endproc

	Hidden Procedure checkCapacity
		If This.nCapacity < This.nLength + 1
			If Empty(This.nCapacity)
				This.nCapacity = 8
			Else
				This.nCapacity = This.nCapacity * 2
			Endif
			Dimension This.aTokens[this.nCapacity]
		Endif
	Endproc

	Hidden Procedure showError(tnLine, tcMessage)
		Error "SYNTAX ERROR: (" + Transform(tnLine) + ":" + Transform(This.nCurrent) + ")" + tcMessage
	Endproc

	Hidden Function isAtEnd
		Return This.nCurrent > This.nSourceLen
	Endfunc

Enddefine

* =================================================================================== *
* Token Class
* =================================================================================== *
Define Class Token As Custom
	nType = 0
	cLexeme = ''
	vLiteral = .Null.
	nLine = 0

	Procedure Init(tnType, tcLexeme, tvLiteral, tnLine)
		This.nType = tnType
		This.cLexeme = Iif(Type('tcLexeme') != 'C', '', tcLexeme)
		This.vLiteral = tvLiteral
		This.nLine = Iif(Type('tnLine') != 'N', 0, tnLine)
	Endproc

	Function toString
		Return "Token(" + TokenName(This.nType) + ", '" + This.cLexeme + "') at Line(" + Alltrim(Str(This.nLine)) + ")"
	Endfunc
Enddefine

* =================================================================================== *
* TokenName
* =================================================================================== *
Function tokenName(tnType)
	DO CASE
	Case tnType == 1
		Return "ttTable"
	Case tnType == 2
		Return "ttDescription"
	Case tnType == 3
		Return "ttFields"
	Case tnType == 4
		Return "ttName"
	Case tnType == 5
		Return "ttType"
	Case tnType == 6
		Return "ttSize"
	Case tnType == 7
		Return "ttPrimaryKey"
	Case tnType == 8
		Return "ttAllowNull"
	Case tnType == 9
		Return "ttChar"
	Case tnType == 10
		Return "ttVarchar"
	Case tnType == 11
		Return "ttDecimal"
	Case tnType == 12
		Return "ttDate"
	Case tnType == 13
		Return "ttDateTime"
	Case tnType == 14
		Return "ttDouble"
	Case tnType == 15
		Return "ttFloat"
	Case tnType == 16
		Return "ttInt"
	Case tnType == 17
		Return "ttBool"
	Case tnType == 18
		Return "ttText"
	Case tnType == 19
		Return "ttVarBinary"
	Case tnType == 20
		Return "ttBlob"
	Case tnType == 21
		Return "ttIdent"
	Case tnType == 22
		Return "ttNumber"
	Case tnType == 23
		Return "ttString"
	Case tnType == 24
		Return "ttEof"
	Case tnType == 25
		Return "ttColon"
	Case tnType == 26
		Return "ttMinus"
	Case tnType == 27
		Return "ttAutoIncrement"
	OTHERWISE
	ENDCASE
EndFunc
