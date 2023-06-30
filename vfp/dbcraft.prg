* Sample
Clear
Local lcScript
lcScript = FileToStr("F:\Desarrollo\Mini_ERP\Sical\Conmod.tmg")
If Right(lcScript, 1) != Chr(10)
	lcScript = lcScript + Chr(10)
EndIf
executeScript(lcScript)
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
	#ifndef ttTrue
		#Define ttTrue 27
	#Endif
	#ifndef ttFalse
		#Define ttFalse 28
	#Endif
	#ifndef ttAutoIncrement
		#Define ttAutoIncrement 29
	#Endif
	#ifndef ttNewLine
		#Define ttNewLine 30
	#Endif	
	Local loScanner, laTokens
	loScanner = Createobject("Scanner", tcScript)
	laTokens = loScanner.scanTokens()
	lcFile = "F:\Desarrollo\Mini_ERP\rutinas\tokens.txt"
	If File(lcFile)
		try
			Delete File &lcFile
		Catch
		EndTry
	EndIf
	For Each loToken In laTokens
		lcText = loToken.toString()
		lcText = lcText + Chr(13) + Chr(10)
		=StrToFile(lcText, lcFile, 1)
	EndFor
	Modify File (lcFile)
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
		nCol, ;
		oKeywords

	cSource = ''
	nStart = 0
	nCurrent = 1
	cLetters = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ_'
	nLine = 1
	nCol = 0
	nCapacity = 0
	nLength = 1
	nSourceLen = 0
	nTokenAnt = 0

	Dimension aTokens[1]

	Procedure Init(tcSource)
		This.cSource = tcSource
		This.nSourceLen = Len(tcSource)

		* Create keywords
		This.oKeywords = Createobject("Scripting.Dictionary")
		This.oKeywords.Add('table', ttTable)
		This.oKeywords.Add('description', ttDescription)
		This.oKeywords.Add('fields', ttFields)

		* Fields attributes
		This.oKeywords.Add('name', ttName)
		This.oKeywords.Add('type', ttType)
		This.oKeywords.Add('size', ttSize)
		This.oKeywords.Add('primaryKey', ttPrimaryKey)
		This.oKeywords.Add('allowNull', ttAllowNull)
		This.oKeywords.Add('autoIncrement', ttAutoIncrement)

		* Data Types
		This.oKeywords.Add('true', ttTrue)
		This.oKeywords.Add('false', ttFalse)
		
		* Table data types
		This.oKeywords.Add('char', ttChar)
		This.oKeywords.Add('varchar', ttVarchar)
		This.oKeywords.Add('decimal', ttDecimal)
		This.oKeywords.Add('date', ttDate)
		This.oKeywords.Add('dateTime', ttDateTime)
		This.oKeywords.Add('double', ttDouble)
		This.oKeywords.Add('float', ttFloat)
		This.oKeywords.Add('int', ttInt)
		This.oKeywords.Add('bool', ttBool)
		This.oKeywords.Add('text', ttText)
		This.oKeywords.Add('varBinary', ttVarBinary)
		This.oKeywords.Add('blob', ttBlob)
	Endproc

	Hidden Function advance
		this.nCol = this.nCol + 1
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
		Do While Inlist(This.peek(), Chr(9), Chr(32))
			This.advance()
		Enddo
	Endproc

	Hidden procedure readIdentifier
		Local lcLexeme, lnCol, lnTokenType
		lnCol = this.nCol-1
		lnTokenType = ttIdent
		Do While At(This.peek(), This.cLetters) > 0
			This.advance()
		Enddo
		lcLexeme = Substr(This.cSource, This.nStart, This.nCurrent-This.nStart)
		If This.oKeywords.Exists(lcLexeme)
			lnTokenType = This.oKeywords.Item(lcLexeme)
		Endif
		This.addToken(lnTokenType, lcLexeme, lnCol)
	EndProc

	Hidden procedure readNumber
		Local lcLexeme, llIsNegative, lnCol
		lcLexeme = ''
		llIsNegative = This.peek() == '-'
		lnCol = this.nCol-1
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

		Return This.addToken(ttNumber, lcLexeme, lnCol)
	EndProc

	Hidden procedure readString(tcStopChar)
		Local lcLexeme, ch, lnCol
		lnCol = this.nCol-1
		Do While !this.isAtEnd()
			ch = This.peek()
			This.advance()
			If ch == tcStopChar				
				Exit
			Endif
		Enddo
		lcLexeme = Substr(This.cSource, This.nStart+1, This.nCurrent-This.nStart-2)

		Return This.addToken(ttString, lcLexeme, lnCol)
	EndProc

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
			This.addToken(ttColon, ch)			
		Case ch == '-' And !Isdigit(This.peek())
			This.addToken(ttMinus, ch)
		Case Inlist(ch, '"', "'")
			This.readString(ch)
		Case ch == Chr(13)
			If this.nTokenAnt == 0 or this.nTokenAnt != ttNewLine
				this.addToken(ttNewLine)
			EndIf
			this.advance() && skip chr(10)
			this.nLine = this.nLine + 1
			this.nCol = 1		
		Otherwise
			If Isdigit(ch) Or (ch == '-' And Isdigit(This.peek()))
				This.readNumber()
				Return
			Endif
			If At(ch, This.cLetters) > 0
				This.readIdentifier()
				Return
			Endif
			This.showError(This.nLine, "Unknown character ['" + Transform(ch) + "'], ascii: [" + Transform(Asc(ch)) + "]")
		Endcase
	Endproc

	Hidden Procedure addToken(tnType, tvLiteral, tnCol)
		This.checkCapacity()
		Local loToken,lnCol
		lnCol = Iif(Empty(tnCol), this.nCol, tnCol)
		loToken = Createobject("Token", tnType, "", tvLiteral, This.nLine, lnCol)
		This.aTokens[this.nLength] = loToken
		This.nLength = This.nLength + 1
		this.nTokenAnt = tnType
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
	nCol = 0

	Procedure Init(tnType, tcLexeme, tvLiteral, tnLine, tnCol)
		This.nType = tnType
		This.cLexeme = Iif(Type('tcLexeme') != 'C', '', tcLexeme)
		This.vLiteral = tvLiteral
		This.nLine = Iif(Type('tnLine') != 'N', 0, tnLine)
		this.nCol = Iif(Type('tnCol') != 'N', 0, tnCol)
	Endproc

	Function toString
		Try
			Local lcString
			lcString = "[" + Alltrim(Str(This.nLine)) + ":" + Alltrim(Str(This.nCol)) + "](" + TokenName(This.nType) + ", " + Transform(This.vLiteral) + ")"
		Catch to loEx
			Set Step On
			MessageBox(loEx.message)
		EndTry
		Return lcString
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
		Return "ttTrue"
	Case tnType == 28
		Return "ttFalse"
	Case tnType == 29
		Return "ttAutoIncrement"
	Case tnType == 30
		Return "ttNewLine"
	Otherwise
	EndCase
EndFunc
