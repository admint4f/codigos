#include "protheus.ch"

/*/
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
北谀哪哪哪哪穆哪哪哪哪哪哪履哪哪哪履哪哪哪哪哪哪哪哪哪哪哪履哪哪穆哪哪哪哪哪勘�
北矲un噭o    � AF010Taxa  � Autor � Wagner Xavier         � Data � 20.01.93 潮�
北媚哪哪哪哪呐哪哪哪哪哪哪聊哪哪哪聊哪哪哪哪哪哪哪哪哪哪哪聊哪哪牧哪哪哪哪哪幢�
北矰escri噭o � Preenche Taxa deprecia噭o para todas das moedas.             潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢�
北砋so       � ATFA010                                                      潮�
北滥哪哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪俦�
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌�
*/
User Function T4F010Taxa(lGrupo)
Static lZeraDepr      

STATIC lMultMoed := FindFunction("AtfMoedas")
Local aAreaSx3 := SX3->(GetArea())
Local nTaxa := 0, ny, aAreaSx3, uRet

Local aPosTaxa	:= {}
Local alMoeda	:= {}
Local nX

Local lOk := .T.
Local aEntidade := {}
Local aHelpPor  := {}
Local aHelpSpa  := {}
Local aHelpEng  := {}
Local lRet := .T.
Local nPosSNG := 0

//********************************
// Controle de multiplas moedas  *
//********************************
Local __nQuantas := If(lMultMoed,AtfMoedas(),5)

//********************************
// Controle da moeda Fiscal/PTG  *
//********************************
Local cMoedaFisc := AllTrim(GetMV("MV_ATFMOEDA"))
Local cNomeTFSN3 := Subs("N3_TXDEPRn",1,10-len(cMoedaFisc) ) +cMoedaFisc
Local cNomeTFSNG := Subs("NG_TXDEPRn",1,10-len(cMoedaFisc) ) +cMoedaFisc
Local nTxMoedaGF := 0
Local nTxMoedaC  := 0
Local nPos       := 0
Local cNestaCOL  := ""
Local nInc		 := 0

DEFAULT lGrupo := .F.

//********************************
// Controle de multiplas moedas  *
//********************************
aAdd( alMoeda , nil )
For nX:= 2 to __nQuantas
	aAdd( alMoeda , Empty(GETMV("MV_MOEDA" + ALLTRIM(Str(nX)))) )
Next

//Valida玢o para verificar se o grupo contabil � igual da tabela SN3 quando for altera玢o
//N鉶 se aplica quando for Classifica玢o de Compras
If lGrupo .And. !Empty(M->N1_GRUPO) .And. ALTERA
	// Cria array com os nomes dos campos do SNG (Cadastro de grupos)
	SX3->( DbSetOrder(1) )
	SX3->(MsSeek("SNG"))             
	SX3->(DbEval( { || Aadd(aEntidade, SX3->X3_CAMPO ) }, , { || SX3->X3_ARQUIVO == "SNG" } ) )
	dbSelectArea("SN3")
	dbSeek(xFilial("SN3") + M->(N1_CBASE+N1_ITEM))
	dbSelectArea("SNG")
	dbSeek(xFilial("SNG") + M->N1_GRUPO)
	For nY := 1 To Len(aEntidade)
		If SN3->(FieldPos("N3_" + Subs(aEntidade[nY], 4))) <> 0 .And. aEntidade[nY] != "NG_FILIAL"
			lRet:= .T.
//			If SN3->&("N3_" + Subs(aEntidade[nY], 4)) != &("SNG->NG_" + Subs(aEntidade[nY], 4)) .And. lRet
//				Help(" ",1,"AF010GRP")
//				Return .F.
//			EndIf
		Endif
	Next
EndIf

If lGrupo .And. (Empty(M->N1_GRUPO) .Or. !ALTERA)
	lOk := .F.
Endif

If lOk
	If lGrupo
		SNG->(DbSeek(xFilial("SNG") + M->N1_GRUPO))
	Endif
	If lZeraDepr == Nil
		lZeraDepr := GetNewPar("MV_ZRADEPR",.F.)
	Endif
	
	// Cria array com os nomes dos campos do SNG (Cadastro de grupos)
	IF Len(aEntidade) == 0
		SX3->(MsSeek("SNG"))
		SX3->(DbEval( { || Aadd(aEntidade, SX3->X3_CAMPO ) }, , { || SX3->X3_ARQUIVO == "SNG" } ) )
	ENDIF
	
	For ny:=1 To Len(aHeader)                                                       
	
		If lGrupo .And. "AF010GRUPO" $ Upper(aHeader[ny][11])
		
			If aAreaSx3 = Nil
				aAreaSx3 := SX3->(GetArea())
				SX3->(DbSetOrder(2))                
			Endif
			SX3->(DbSeek(aHeader[ny][2]))                      
			uRet := CriaVar(aHeader[ny][2])                
			If uRet <> Nil                                       
			    //If Empty(aCols[n][ny])
					aCols[n][ny] := uRet 
				//EndIf	
			Endif
			
		ElseIf Trim(aHeader[nY][2]) != "N3_FILIAL" .AND. aHeader[nY][8] == "C" .AND.; // SOMENTE CAMPOS CARACTER
			(nPosSNG := aScan(aEntidade,{|cEntidade| ALLTRIM(SUBSTR(cEntidade,4,10)) == ALLTRIM(SUBSTR(aHeader[nY][2],4,10))})) > 0

			If lGrupo .and. !EMPTY(&("SNG->"+ALLTRIM(aEntidade[nPosSNG]))) //.And. Empty(aCols[n][ny])
				aCols[n][ny] := &("SNG->"+aEntidade[nPosSNG])
			Endif
		EndIf
		
	Next ny
	
	//********************************
	// Controle de multiplas moedas  *
	//********************************
	
	
	aPosTaxa := If(lMultMoed,AtfMultPos(aHeader,"N3_TXDEPR"),;
					{ 	Ascan(aHeader	, {|e| Alltrim(e[2]) == "N3_TXDEPR1" } ),;
						Ascan(aHeader	, {|e| Alltrim(e[2]) == "N3_TXDEPR2" } ),;
						Ascan(aHeader	, {|e| Alltrim(e[2]) == "N3_TXDEPR3" } ),;
						Ascan(aHeader	, {|e| Alltrim(e[2]) == "N3_TXDEPR4" } ),;
						Ascan(aHeader	, {|e| Alltrim(e[2]) == "N3_TXDEPR5" } ) })
	If !lGrupo 
		aCols[n][aPosTaxa[1]] := &(ReadVar())
	Else
		aCols[n][aPosTaxa[1]] := SNG->NG_TXDEPR1
	Endif
	
	If lZeraDepr .and. !lGrupo 
		nTaxa := &(ReadVar())	
	EndIf
	
	//********************************
	// Controle de multiplas moedas  *
	//********************************	
	For nX := 2 to __nQuantas
		If aPosTaxa[nX] <= 0
			Loop
		EndIf
		If alMoeda[nX]	/// Se n鉶 tem a moeda informada no par鈓etro (Moeda em branco)
			If nX > 9
				If SNG->(FieldGet(FieldPos("NG_TXDEP" + Alltrim(Str(nX)) ))) > 0			
					aCols[n][aPosTaxa[nX]] := 0
				Endif	
			Else 
				If SNG->(FieldGet(FieldPos("NG_TXDEPR" + Alltrim(Str(nX)) ))) > 0			
					aCols[n][aPosTaxa[nX]] := 0
				Endif	
			Endif	
		Elseif !lGrupo
			aCols[n][aPosTaxa[nX]] :=&(ReadVar())
		Else
			If nX > 9
			    If SNG->(FieldGet(FieldPos("NG_TXDEP" + Alltrim(Str(nX)) ))) > 0
				  	aCols[n][aPosTaxa[nX]] := SNG->(FieldGet(FieldPos("NG_TXDEP" + Alltrim(Str(nX)) )))
			  	Endif
			Else
			    If SNG->(FieldGet(FieldPos("NG_TXDEPR" + Alltrim(Str(nX)) ))) > 0
				  	aCols[n][aPosTaxa[nX]] := SNG->(FieldGet(FieldPos("NG_TXDEPR" + Alltrim(Str(nX)) )))
			  	Endif
			EndIf
		EndIf
	Next
	
	If aAreaSx3 <> Nil
		SX3->(RestArea(aAreaSx3))
	Endif
	
	If lZeraDepr .and. !lGrupo .And. aCols[n][01] $ "02#05"
		// Assume a ultima taxa para todos os itens
		For nInc := 1 To Len( aCols )
			aEval( aPosTaxa, { |x| aCols[nInc][x] := nTaxa } )
		Next
	Endif	
	
	If (Type('lAtfAuto') == "U" .Or. ! lAtfAuto) .And. Type("__oGet") == "O"
		__oGet:Refresh()
	EndIf

EndIf
SX3->(RestArea(aAreaSx3))
Return .T.



/* SELECIONA O ARQUIVO */

//Static Function AnexaPDF()
//Local cFile:= 
//cGetFile ( [ cMascara], [ cTitulo], [ nMascpadrao], [ cDirinicial], [ lSalvar], [ nOpcoes], [ lArvore], [ lKeepCase] ) --> cRet

//cGetFile( '*.pdf' , 'Acrobat PDF(PDF)', 1, 'C:\', .F., nOR( GETF_LOCALHARD, GETF_LOCALFLOPPY, GETF_RETDIRECTORY ),.T., .T. )

// Par鈓etros/Elementos
// cMascara - Caracter - Indica o nome do arquivo ou m醩cara. 		
// cTitulo 	- Caracter - Indica o t韙ulo da janela. Caso o par鈓etro n鉶 seja especificado, o t韙ulo padr鉶 ser� apresentado. 		
// nMascpadrao 	- Num閞ico  -	Indica o n鷐ero da m醩cara. 		
// cDirinicial 	Caracter 	Indica o diret髍io inicial. 		
// lSalvar 	L骻ico 	Indica se � um "save dialog" ou um "open dialog". 		
// nOpcoes 	Num閞ico 	Indica a op玢o de funcionamento. Para mais informa珲es das funcionalidades dispon韛eis, consulte a 醨ea Observa珲es. 		
// lArvore 	L骻ico 	Indica se, verdadeiro (.T.), apresenta o 醨vore do servidor; caso contr醨io, falso (.F.). 		
// lKeepCase 	L骻ico 	Indica se, verdadeiro (.T.), mant閙 o case original; caso contr醨io, falso (.F.). 		
// Retorno

//    cRet(caracter)
//    Retorna o nome do item. Caso nenhum item tenha sido selecionado, o retorna ser� uma string vazia.

//Observa珲es

/*
No par鈓etro <nOp珲es>, � poss韛el determinar as seguintes funcionalidades:

Comandos 	Descri玢o
 GETF_MULTISELECT 	Compatibilidade.
 GETF_NOCHANGEDIR 	N鉶 permite mudar o diret髍io inicial.
 GETF_LOCALFLOPPY 	Apresenta a unidade do disquete da m醧uina local.
 GETF_LOCALHARD 	Apresenta a unidade do disco local.
 GETF_NETWORKDRIVE 	Apresenta as unidades da rede (mapeamento).
 GETF_SHAREWARE 	N鉶 implementado.
 GETF_RETDIRECTORY 	Retorna/apresenta um diret髍io.

Exemplos

cGetFile( '*.txt' , 'Textos (TXT)', 1, 'C:\', .F., nOR( GETF_LOCALHARD, GETF_LOCALFLOPPY, GETF_RETDIRECTORY ),.T., .T. )
*/
