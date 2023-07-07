* Sample
Clear
Local lcScript
lcScript = FileToStr("F:\Desarrollo\Mini_ERP\Sical\Conmod.tmg")
If Right(lcScript, 1) != Chr(10)
	lcScript = lcScript + Chr(13) + Chr(10)
EndIf
executeScript(lcScript)
* End Sample

* =================================================================================== *
* Implementation
* =================================================================================== *
Procedure executeScript(tcScript)
	#ifndef tkIdent
		#Define tkIdent 1
	#Endif
	#ifndef tkPrimary
		#Define tkPrimary 2
	#Endif
	#ifndef tkSymbol
		#Define tkSymbol 3
	#Endif
	#ifndef tkGeneric
		#Define tkGeneric 4
	#endif

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
	* ======================================= *
	* Table data types
	* ======================================= *
	#ifndef ttChar
		#Define ttChar 200
	#Endif
	#ifndef ttVarchar
		#Define ttVarchar 201
	#Endif
	#ifndef ttDecimal
		#Define ttDecimal 202
	#Endif
	#ifndef ttDate
		#Define ttDate 203
	#Endif
	#ifndef ttDateTime
		#Define ttDateTime 204
	#Endif
	#ifndef ttDouble
		#Define ttDouble 205
	#Endif
	#ifndef ttFloat
		#Define ttFloat 206
	#Endif
	#ifndef ttInt
		#Define ttInt 207
	#Endif
	#ifndef ttBool
		#Define ttBool 208
	#Endif
	#ifndef ttText
		#Define ttText 209
	#Endif
	#ifndef ttVarBinary
		#Define ttVarBinary 210
	#Endif
	#ifndef ttBlob
		#Define ttBlob 211
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

	Local loScanner, laTokens, llPrintTokens
	loScanner = Createobject("Scanner", tcScript)
	laTokens = loScanner.scanTokens()
	llPrintTokens = .f.
	If llPrintTokens
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
		return
	EndIf
		
	Local loParser, loStatements
	loParser = CreateObject("Parser", @laTokens)
	loStatements = loParser.parse()
	MessageBox(loStatements)
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
		This.addToken(lnTokenType, tkIdent, lcLexeme, lnCol)
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

		Return This.addToken(ttNumber, tkPrimary, lcLexeme, lnCol)
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

		Return This.addToken(ttString, tkPrimary, lcLexeme, lnCol)
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
			This.addToken(ttColon, tkSymbol, ch)			
		Case ch == '-' And !Isdigit(This.peek())
			This.addToken(ttMinus, tkSymbol, ch)
		Case Inlist(ch, '"', "'")
			This.readString(ch)
		Case ch == Chr(13)
			If this.nTokenAnt == 0 or this.nTokenAnt != ttNewLine
				this.addToken(ttNewLine)
			EndIf
			this.advance() && skip chr(10)
			this.nLine = this.nLine + 1
			this.nCol = 1
		Case ch == Chr(10)
			* skip
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

	Hidden Procedure addToken(tnType, tnKind, tvLiteral, tnCol)
		This.checkCapacity()
		Local loToken,lnCol
		lnCol = Iif(Empty(tnCol), this.nCol, tnCol)
		loToken = Createobject("Token", tnType, "", tvLiteral, This.nLine, lnCol)
		loToken.nKind = Iif(Empty(tnKind), tkGeneric, tnKind)
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
* Parser Class
* =================================================================================== *
Define Class Parser as Custom
	Hidden ;
	oPeek, ;
	oPrevious, ;
	nCurrent
	
	Dimension aTokens[1]
	nCurrent = 1

	Procedure Init(taTokens)
		=Acopy(taTokens, this.aTokens)
	EndProc
	
	Function parse
		Local loStatements
		loStatements = CreateObject("Collection")
		Do while !this.isAtEnd()
			this.match(ttMinus)
			loStatements.Add(this.declaration())
		EndDo
		Return loStatements
	EndFunc
	
	Hidden function declaration
		Local loResult
		loResult = .null.
		Try
			If this.match(ttTable)
				loResult = this.tableDeclaration()
			EndIf
			If IsNull(loResult) and this.match(ttDescription)
				loResult = this.parseAttribute('description', ttString)
			EndIf
			If IsNull(loResult) and this.match(ttFields)
				loResult = this.fieldsAttribute()
			EndIf
			If IsNull(loResult) and this.match(ttName)
				loResult = this.parseAttribute('name', ttIdent, ttString)
			EndIf
			If IsNull(loResult) and this.match(ttType)
				loResult = this.parseType()
			EndIf
			If IsNull(loResult) and this.match(ttSize)
				loResult = this.parseAttribute('size', ttNumber)
			EndIf
			If IsNull(loResult) and this.match(ttPrimaryKey)
				loResult = this.parseAttribute('primaryKey', ttTrue, ttFalse)
			EndIf
			If IsNull(loResult) and this.match(ttAutoIncrement)
				loResult = this.parseAttribute('autoIncrement', ttTrue, ttFalse)
			EndIf
		Catch to loEx
			* TODO(irwin): sinchronyze
		EndTry
		Return loResult
	EndFunc
	
	Hidden function tableDeclaration		
		Local loToken, loAttributes
		loToken = this.oPrevious
		this.consume(ttColon, "Se esperaba el símbolo ':' luego del atributo 'table'")
		this.consume(ttNewLine, "Se esperaba un salto de línea")				
		loAttributes = CreateObject("Collection")

		Do while !this.isAtEnd() and this.oPeek.nKind == tkIdent
			loAttributes.Add(this.declaration())
		EndDo
				
		Return CreateObject("Node", loToken, loAttributes)
	EndFunc
	
	Hidden function fieldsAttribute
		Local loToken, loFieldsList, loAttributes
		loToken = this.oPrevious
		this.consume(ttColon, "Se esperaba el símbolo ':' luego del atributo 'description'")
		this.consume(ttNewLine, "Se esperaba un salto de línea")
		loAttributes = CreateObject("Collection")

		Do while !this.isAtEnd() and this.match(ttMinus)
			Do while this.oPeek.nKind == tkIdent
				loAttributes.Add(this.declaration())
			EndDo
		EndDo
		
		Return CreateObject("Node", loToken, loFieldsList)
	EndFunc

	Hidden function parseAttribute(tcName, tnType1, tnType2)
		Local loToken, lvValue, i, llMatched
		loToken = this.oPrevious
		this.consume(ttColon, "Se esperaba el símbolo ':' luego del atributo '" + tcName + "'")
		llMatched = .f.
		
		For i = 1 to Pcount()-1
			llMatched = this.match(Evaluate('tnType' + Alltrim(Str(i))))
			If llMatched
				exit
			EndIf
		EndFor
		If !llMatched
			* TODO(irwin): mostrar mensaje
			MessageBox("Valor inválido para el atributo '", + tcName + "'", 16)
			Return .null.
		EndIf
			
		lvValue = this.oPrevious.vLiteral
		this.consume(ttNewLine, "Se esperaba un salto de línea")

		Return CreateObject("Node", loToken, lvValue)
	EndFunc
	
	Hidden function parseType
		Local loToken, loTokenType
		loToken = this.oPrevious
		this.consume(ttColon, "Se esperaba el símbolo ':' luego del atributo 'type'")	
		
		If !Between(this.oPeek.nType, 200, 299)
			MessageBox("Se esperaba un tipo de dato pero se obtuvo: " + this.oPeek.cLexeme, 16)
			Return .null.
		EndIf
		loTokenType = this.advance()
		
		this.consume(ttNewLine, "Se esperaba un salto de línea")
		Return CreateObject("Node", loToken, loTokenType)
	EndFunc
	
	Hidden function match(t1, t2, t3)
		Local i		
		For i=1 to Pcount()
			If this.check(Evaluate('t' + Alltrim(Str(i))))
				this.advance()
				Return .t.
			endif
		EndFor
		Return .f.
	EndFunc
	
	Hidden function consume(tnType, tcMessage)
		If this.check(tnType)
			Return this.advance()
		EndIf

		Error tcMessage
	EndFunc
	
	Hidden function check(tnType)
		If this.isAtEnd()
			Return .f.
		EndIf
		Return this.oPeek.nType == tnType
	EndFunc
	
	Hidden function advance
		If !this.isAtEnd()
			this.nCurrent = this.nCurrent + 1
		EndIf
		Return this.oPrevious
	EndFunc
	
	Hidden Function isAtEnd
		Return this.oPeek.nType == ttEOF
	EndFunc
	
	Hidden Function oPeek_Access
		Return this.aTokens[this.nCurrent]
	EndFunc
	
	Hidden function oPrevious_Access
		Return this.aTokens[this.nCurrent-1]
	EndFunc
		
EndDefine

* =================================================================================== *
* Token Class
* =================================================================================== *
Define Class Token As Custom
	nType = 0
	nKind = 0
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
	Case tnType == 200
		Return "ttChar"
	Case tnType == 201
		Return "ttVarchar"
	Case tnType == 202
		Return "ttDecimal"
	Case tnType == 203
		Return "ttDate"
	Case tnType == 204
		Return "ttDateTime"
	Case tnType == 205
		Return "ttDouble"
	Case tnType == 206
		Return "ttFloat"
	Case tnType == 207
		Return "ttInt"
	Case tnType == 208
		Return "ttBool"
	Case tnType == 209
		Return "ttText"
	Case tnType == 210
		Return "ttVarBinary"
	Case tnType == 211
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

* ========================================================================= *
* Node
* ========================================================================= *
Define Class Node as Custom
	oToken = .null.
	vValue = .null.
	
	Procedure init(toToken, tvValue)
		this.oToken = toToken
		this.vValue = tvValue
	endproc
EndDefine
