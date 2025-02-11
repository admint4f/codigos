#INCLUDE "FINR710.CH"
#Include "PROTHEUS.CH"

Static lFWCodFil := .T.

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o	 � FinR710	� Autor � Wagner Xavier 	    � Data � 05.10.92 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Bordero de Pagamento.									  ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe e � FinR710(void)						  					  ���
�������������������������������������������������������������������������Ĵ��
���Parametros� 															  ���
�������������������������������������������������������������������������Ĵ��
��� Uso		 � Generico 												  ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
User Function xFinR710()

Local oReport
Local aAreaR4	:= GetArea()

If TRepInUse()
	oReport := ReportDef()
	oReport:PrintDialog()
Else
	Return FinR710R3() // Executa vers�o anterior do fonte
Endif

RestArea(aAreaR4)

Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � ReportDef � Autor � Marcio Menon		   � Data �  27/07/06 ���
�������������������������������������������������������������������������͹��
���Descricao � Definicao do objeto do relatorio personalizavel e das      ���
���          � secoes que serao utilizadas.                               ���
�������������������������������������������������������������������������͹��
���Parametros� EXPC1 - Grupo de perguntas do relatorio                    ���
�������������������������������������������������������������������������͹��
���Uso       � 												              ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function ReportDef()

Local oReport
Local oSection1
Local oSection2
Local cReport 	:= "FINR710" 				// Nome do relatorio
Local cDescri 	:= STR0001 + STR0002   		//"Este programa tem a fun��o de emitir os borderos de pagamen-" ### "tos."
Local cTitulo 	:= STR0003 					//"Emiss�o de Borderos de Pagamentos"
Local cPerg		:= "FIN710"					// Nome do grupo de perguntas

//��������������������������������������������������������������Ŀ
//� Verifica as perguntas selecionadas 		   				     �
//����������������������������������������������������������������
pergunte("FIN710",.F.)

//�������������������������������������������������������������Ŀ
//� Vari�veis utilizadas para parametros						�
//� mv_par01				// Do Bordero						�
//� mv_par02				// At� o Bordero					�
//� mv_par03				// Data para d�bito					�
//� mv_par04				// Qual Moeda						�
//� mv_par05				// Outras Moedas					�
//� mv_par06				// Converte por						�
//� mv_par07				// Compoen saldo por				�
//� mv_par08				// Considera Filial					�
//� mv_par09				// Da Filial						�
//� mv_par10				// Ate Filia						�
//���������������������������������������������������������������

//������������������������������������������������������������������������Ŀ
//�Criacao do componente de impressao                                      �
//�                                                                        �
//�TReport():New                                                           �
//�ExpC1 : Nome do relatorio                                               �
//�ExpC2 : Titulo                                                          �
//�ExpC3 : Pergunte                                                        �
//�ExpB4 : Bloco de codigo que sera executado na confirmacao da impressao  �
//�ExpC5 : Descricao                                                       �
//��������������������������������������������������������������������������
oReport := TReport():New(cReport, cTitulo, cPerg, {|oReport| ReportPrint(oReport)}, cDescri)

oReport:HideHeader()	//Oculta o cabecalho do relatorio
oReport:SetPortrait()	//Imprime o relatorio no formato retrato
oReport:HideFooter()	//Oculta o rodape do relatorio

//�                      Definicao das Secoes                              �
//��������������������������������������������������������������������������
//������������������������������������������������������������������������Ŀ
//� Secao 01                                                               �
//��������������������������������������������������������������������������
oSection1 := TRSection():New(oReport, STR0054 , {"SEA"})	//"CABECALHO"

TRCell():New(oSection1, "CABEC", "", STR0054 , "", 80,/*lPixel*/,/*CodeBlock*/)		//"CABECALHO"
oSection1:SetHeaderSection(.F.)	//Nao imprime o cabecalho da secao
oSection1:SetPageBreak(.T.)		//Salta a pagina na quebra da secao

//������������������������������������������������������������������������Ŀ
//� Secao 02                                                               �
//��������������������������������������������������������������������������
oSection2 := TRSection():New(oSection1, STR0041 , {"SEA","SA6","SEF","SA2","SE2"})		//"BORDERO"
TRCell():New(oSection2, "EA_PREFIXO", "SEA", STR0042 , PesqPict("SEA","EA_PREFIXO"), TamSX3("EA_PREFIXO")[1],/*lPixel*/,/*CodeBlock*/)	//"PRF"
TRCell():New(oSection2, "EA_NUM"    , "SEA", STR0043 , PesqPict("SEA","EA_NUM")    , TamSX3("EA_NUM")[1]    ,/*lPixel*/,/*CodeBlock*/)	//"NUMERO"
TRCell():New(oSection2, "EA_PARCELA", "SEA", STR0044 , PesqPict("SEA","EA_PARCELA"), TamSX3("EA_PARCELA")[1],/*lPixel*/,/*CodeBlock*/)	//"PC"
TRCell():New(oSection2, "BENEF"     , ""   , STR0045 , PesqPict("SA2","A2_NOME")   , 33						,/*lPixel*/,/*CodeBlock*/)	//"B E N E F I C I A R I O"
TRCell():New(oSection2, "A6_NREDUZ", "SA6", STR0046 , PesqPict("SA6","A6_NREDUZ") , 15						,/*lPixel*/,/*CodeBlock*/)	//"BANCO"
TRCell():New(oSection2, "EF_NUM"    , "SEF", STR0047 , PesqPict("SEF","EF_NUM")    , TamSX3("EF_NUM")[1]    ,/*lPixel*/,/*CodeBlock*/)	//"HISTORICO"
TRCell():New(oSection2, "A2_BANCO"  , "SA2", STR0048 , PesqPict("SA2","A2_BANCO")  , TamSX3("A2_BANCO")[1]  ,/*lPixel*/,/*CodeBlock*/)	//"BCO"
TRCell():New(oSection2, "A2_AGENCIA", "SA2", STR0049 , PesqPict("SA2","A2_AGENCIA"), TamSX3("A2_AGENCIA")[1],/*lPixel*/,/*CodeBlock*/)	//"AGENC"
TRCell():New(oSection2, "A6_DVAGE"  , "SA6", "DV"    , PesqPict("SA6","A6_DVAGE")  , TamSX3("A6_DVAGE")[1]	,/*lPixel*/,/*CodeBlock*/)
TRCell():New(oSection2, "A2_NUMCON" , "SA2", STR0050 , PesqPict("SA2","A2_NUMCON") , TamSX3("A2_NUMCON")[1] ,/*lPixel*/,/*CodeBlock*/)	//"NUMERO CONTA"
TRCell():New(oSection2, "A6_DVCTA"  , "SA6", "DV"    , PesqPict("SA6","A6_DVCTA")  , TamSX3("A6_DVCTA")[1] 	,/*lPixel*/,/*CodeBlock*/)
TRCell():New(oSection2, "A2_CGC"  	, "SA2", STR0051 , "@R XXXXXXXXXXXXXXXX"       , 20						,/*lPixel*/,/*CodeBlock*/) 	//"CNPJ/CPF"
TRCell():New(oSection2, "E2_VENCREA", "SE2", STR0052 , PesqPict("SE2","E2_VENCREA"), 11						,/*lPixel*/,/*CodeBlock*/)  //"DT.VENC"
TRCell():New(oSection2, "VALORPAGAR", ""   , STR0053 , TM(0,17)					   , 18						,/*lPixel*/,/*CodeBlock*/)										    //"VALOR A PAGAR"

oSection2:Cell("A6_DVAGE"):SetCanPrint( { || !Empty( SA2->A2_AGENCIA ) } )
oSection2:Cell("A6_DVCTA"):SetCanPrint( { || !Empty( SA2->A2_NUMCON  ) } )

oSection2:Cell("VALORPAGAR"):cTitle := PadL(oSection2:Cell("VALORPAGAR"):cTitle,oSection2:Cell("VALORPAGAR"):nSize)

oSection2:SetTotalInLine (.F.) 	//O totalizador da secao sera impresso em coluna
oSection2:SetHeaderBreak(.T.)   //Imprime o cabecalho das celulas apos a quebra

Return oReport

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �ReportPrint �Autor� Marcio Menon       � Data �  27/07/06   ���
�������������������������������������������������������������������������͹��
���Descricao � Imprime o objeto oReport definido na funcao ReportDef.     ���
�������������������������������������������������������������������������͹��
���Parametros� EXPO1 - Objeto TReport do relatorio                        ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       �                                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function ReportPrint(oReport)

Local oSection1 	:= oReport:Section(1)
Local oSection2 	:= oReport:Section(1):Section(1)
Local oBreak1
Local oFunction1
Local cChave      	:= ""
Local cFiltro     	:= ""
Local cAliasSea		:= "SEA"
Local cJoin 		:= ""
Local lBaixa		:= .F.
Local lCheque     	:= .F.
Local lAbatimento 	:= .F.
Local cLoja  		:= ""
Local nVlrPagar		:= 0
Local cModelo   	:= CriaVar("EA_MODELO")
Local cNumConta		:= CriaVar("EA_NUMCON")
Local lSeaEof     	:= .F.
Local cDvCta		:= ""
Local cFilialSEA
Local nLen := 0
Local cFilSA6 := ""

Private nJuros := 0
Private dBaixa := CriaVar("E2_BAIXA")

If oReport:lXlsTable
	ApMsgAlert(STR0055) //"Formato de impress�o Tabela n�o suportado neste relat�rio"
	oReport:CancelPrint()
	Return
Endif

//Valida data de d�bito (mv_par03)
If Empty(mv_par03)
	HELP (" ",1,'DTDEBITO',,"Data de d�bito n?o informada na parametriza�?o do relat�rio.",1,0,,,,,,{"Por favor, informe a data de d�bito nos par�metros do relat�rio (pergunte)."} ) 	//###
	oReport:CancelPrint()
	Return
Endif

SEA->(DbGoTop())
SE2->(DbGoTop())

cChave := SEA->(IndexKey())

#IFDEF TOP

	cAliasSea 		:= GetNextAlias()

	cChave 	:= "%"+SqlOrder(cChave)+"%"

	oSection1:BeginQuery()

	If MV_PAR08 == 1 //Considera Filial?
	  	If lFWCodFil .And. (MsModoFil("SEA")[3]=="E".Or.MsModoFil("SEA")[2]=="E".Or.MsModoFil("SEA")[1]=="E")
			If MsModoFil("SEA")[3] == "E"
				nLen := Len(FwCompany(MV_PAR09))
			EndIf
			If MsModoFil("SEA")[2] == "E"
				nLen += Len(FwUnitBusiness(MV_PAR10))
			EndIf
			If MsModoFil("SEA")[1] == "E"
				nLen += Len(FwFilial(MV_PAR10))
			EndIf
			cFilialSEA := "EA_FILIAL BETWEEN '" + SubStr(MV_PAR09,1,nLen) + "' AND '" + SubStr(MV_PAR10,1,nLen) + "' "
		Else
			cFilialSEA := "EA_FILIAL = '" + xFilial("SEA") + "' "
		EndIf
	Else
		cFilialSEA := "EA_FILIAL = '" + xFilial("SEA") + "' "
	EndIf

	cFilialSEA := "%"+cFilialSEA+"%"

	BeginSql Alias cAliasSea
		SELECT 	SEA.EA_FILIAL, SEA.EA_FILORIG, SEA.EA_NUMBOR, SEA.EA_CART, SEA.EA_PREFIXO, SEA.EA_NUM,
					SEA.EA_PARCELA, SEA.EA_TIPO, SEA.EA_FORNECE, SEA.EA_LOJA, SEA.EA_MODELO ,
					SEA.EA_PORTADO, SEA.EA_AGEDEP,SEA.EA_NUMCON, SEA.EA_DATABOR
		FROM
			%table:SEA% SEA
		WHERE
		    %Exp:cFilialSEA% AND
			SEA.EA_NUMBOR >= %Exp:mv_par01% AND
			SEA.EA_NUMBOR <= %Exp:mv_par02% AND
			SEA.EA_CART = 'P' AND
			SEA.%notDel%



		ORDER BY %Exp:cChave%
	EndSql
	oSection1:EndQuery()
	oSection2:SetParentQuery()

#ELSE

    If MV_PAR08 == 1 //Considera Filial?
		cFiltro := "EA_FILIAL >= '" + MV_PAR09 + "' .AND. EA_FILIAL <= '" + MV_PAR10+ "' .AND."
	Else
		cFiltro := "EA_FILIAL == '" + xFilial("SEA") + "' .And. "
	EndIf

	cFiltro += "EA_NUMBOR >= '" + mv_par01 + "' .And. "
	cFiltro += "EA_NUMBOR <= '" + mv_par02 + "' .And. "
	cFiltro += "EA_CART = 'P'"

	TRPosition():New(oSection2,"SE2",1,{|| If( Empty((cAliasSea)->EA_FILORIG) .AND. !Empty(xFilial("SE2")),;
																xFilial("SE2")+(cAliasSea)->EA_PREFIXO+(cAliasSea)->EA_NUM+(cAliasSea)->EA_PARCELA+(cAliasSea)->EA_TIPO+(cAliasSea)->EA_FORNECE+AllTrim((cAliasSea)->EA_LOJA),;
																(cAliasSea)->EA_FILORIG+(cAliasSea)->EA_PREFIXO+(cAliasSea)->EA_NUM+(cAliasSea)->EA_PARCELA+(cAliasSea)->EA_TIPO+(cAliasSea)->EA_FORNECE+AllTrim((cAliasSea)->EA_LOJA)) } )
	oSection1:SetFilter(cFiltro,cChave)

#ENDIF

oSection1:SetLineCondition( { ||	 FR710Chk(1,cAliasSea) } )
oSection2:SetLineCondition( { ||	 FR710Chk(2,cAliasSea) } )
cFilSA6 := xFilial("SA6", (cAliasSea)->EA_FILIAL)

TRPosition():New(oSection2,"SE2",1,{|| If( Empty((cAliasSea)->EA_FILORIG) .AND. !Empty(xFilial("SE2")),;
															xFilial("SE2")+(cAliasSea)->EA_PREFIXO+(cAliasSea)->EA_NUM+(cAliasSea)->EA_PARCELA+(cAliasSea)->EA_TIPO+(cAliasSea)->EA_FORNECE+AllTrim((cAliasSea)->EA_LOJA),;
															(cAliasSea)->EA_FILORIG+(cAliasSea)->EA_PREFIXO+(cAliasSea)->EA_NUM+(cAliasSea)->EA_PARCELA+(cAliasSea)->EA_TIPO+(cAliasSea)->EA_FORNECE+AllTrim((cAliasSea)->EA_LOJA)) } )

oSection2:OnPrintLine( { || lBaixa := Fr710BxVL(cAliasSea, IIf (Empty((cAliasSea)->EA_LOJA), "", (cAliasSea)->EA_LOJA)), If(!lBaixa, lBaixa := Fr710BxBA(cAliasSea), Nil ),;
									 lCheque := (!Empty(SE5->E5_NUMCHEQ) .And. SEF->(MsSeek(xFilial("SEF")+SE5->E5_BANCO+SE5->E5_AGENCIA+SE5->E5_CONTA+SE5->E5_NUMCHEQ))),;
								    Fr710Config(cAliasSea, oSection2), .T. } )

oReport:OnPageBreak( { || ReportCabec(oReport, cModelo := (cAliasSea)->EA_MODELO, cAliasSea, lBaixa, lSeaEof) } )

oSection2:Cell("BENEF"):SetBlock( { || cDvCta := Posicione( "SA6", 1, cFilSA6 + (cAliasSEA)->(EA_PORTADO+EA_AGEDEP+EA_NUMCON), "A6_DVCTA" ), ;
										cNumConta := RTrim( (cAliasSea)->EA_NUMCON ) + Iif( !Empty(cDvCta),"-","" ) + cDvCta, ;
										Fr710Benef(cAliasSea, lBaixa, lCheque, lAbatimento) } )

oSection2:Cell("A2_CGC"    ):SetBlock( { || Transform(SA2->A2_CGC, IIF(Len(Alltrim(SA2->A2_CGC))>11,"@R 99999999/9999-99","@R 999999999-99")) } )
oSection2:Cell("E2_VENCREA"):SetBlock( { || SE2->E2_VENCREA } )
oSection2:Cell("VALORPAGAR"):SetBlock( { || Fr710VPagar(cAliasSea, lBaixa, lCheque, lAbatimento) } )

oBreak1 := TRBreak():New(oSection1, { || (cAliasSea)->EA_NUMBOR }, STR0007)

oFunction1 := TRFunction():New(oSection2:Cell("VALORPAGAR"),,"SUM", oBreak1,,,,.F.,.F.)

oBreak1:OnPrintTotal( { || ReportTxtAut(oReport, cModelo, cNumConta, oFunction1:GetLastValue()), "" } )

oSection2:SetParentFilter({|cParam| (cAliasSea)->EA_NUMBOR == cParam },{|| (cAliasSea)->EA_NUMBOR } )

oSection2:Cell("A6_DVAGE"  ):SetBlock( { || Posicione( "SA6", 1, cFilSA6 + SA2->( A2_BANCO + A2_AGENCIA + A2_NUMCON ), "A6_DVAGE" ) } )
oSection2:Cell("A6_DVCTA"  ):SetBlock( { || Posicione( "SA6", 1, cFilSA6 + SA2->( A2_BANCO + A2_AGENCIA + A2_NUMCON ), "A6_DVCTA" ) } )
oSection2:Cell("A6_NREDUZ"  ):SetBlock( { || Posicione( "SA6", 1, cFilSA6 + SA2->( A2_BANCO + A2_AGENCIA + A2_NUMCON ), "A6_NREDUZ" ) } )

//��������������������������������������������������������������Ŀ
//� Inicia a impressao.						 								  �
//����������������������������������������������������������������
oSection1:Print()

Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �Fr710BxVL �Autor  � Marcio Menon       � Data �  28/07/06   ���
�������������������������������������������������������������������������͹��
���Desc.     � Verifica se existe movimenta��o bancaria ou baixas que     ���
���          � movimentam banco.                                          ���
�������������������������������������������������������������������������͹��
���Uso       � 	                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function Fr710BxVL(cAliasSea, cLoja, lBaixa)
Local cChvSE2 := ""
Local cChvSE5 := ""
Local aArea := GetArea()

DbSelectArea("SE2")
dbSetOrder(1)
If MsSeek(xFilial("SE2", (cAliasSea)->EA_FILORIG)+(cAliasSea)->(EA_PREFIXO+EA_NUM+EA_PARCELA+EA_TIPO+EA_FORNECE)+cLoja)
	cChvSE2 := xFilial("SE2", (cAliasSea)->EA_FILORIG)+"VL"+(cAliasSea)->(EA_PREFIXO+EA_NUM+EA_PARCELA+EA_TIPO+EA_FORNECE)+cLoja
	dbSelectArea("SE5")
	dbSetOrder(2)
	
	If SE5->(MsSeek(xFilial("SE5", (cAliasSea)->EA_FILORIG)+"VL"+SE2->(E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO)+DTOS(SE2->E2_BAIXA)+SE2->(E2_FORNECE+E2_LOJA)))
		cChvSE5 := SE5->(E5_FILIAL+E5_TIPODOC+E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO)+DTOS(SE5->E5_DATA)+SE5->(E5_CLIFOR+E5_LOJA)
		
		While SE5->(!Eof()) .And. cChvSE2 == cChvSE5
			//Se considera baixas que nao possuem estorno
			If !TemBxCanc(SE5->(E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+E5_CLIFOR+E5_LOJA+E5_SEQ))
				If SubStr( SE5->E5_DOCUMEN,1,6 ) == (cAliasSea)->EA_NUMBOR .And. SE5->E5_MOTBX != "PCC"
					lBaixa := .T.
					Exit
				Endif
			EndIf
			
			SE5->(dbSkip())
			cChvSE5 := SE5->(E5_FILIAL+E5_TIPODOC+E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO)+DTOS(SE5->E5_DATA)+SE5->(E5_CLIFOR+E5_LOJA)
		Enddo

	EndIf
EndIf

RestArea(aArea)

Return lBaixa

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �Fr710BxBA �Autor  � Marcio Menon       � Data �  28/07/06   ���
�������������������������������������������������������������������������͹��
���Desc.     � Verifica se existe baixa automatica ou baixa que nao tenha ���
���          � movimentacao bancaria.                                     ���
�������������������������������������������������������������������������͹��
���Uso       � 	                                                          ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function Fr710BxBA(cAliasSea, lBaixa)
Local cChvSE2 := ""
Local cChvSE5 := ""
Local aArea := GetArea()
Local nRecNo := 0

DbSelectArea("SE2")
dbSetOrder(1)
If SE2->(MsSeek(xFilial("SE2", (cAliasSea)->EA_FILORIG)+(cAliasSea)->(EA_PREFIXO+EA_NUM+EA_PARCELA+EA_TIPO+EA_FORNECE+EA_LOJA)))
	cChvSE2 := xFilial("SE2", SE2->E2_FILORIG)+"BA"+SE2->(E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO)+DTOS(SE2->E2_BAIXA)+SE2->(E2_FORNECE+E2_LOJA) 
	dbSelectArea("SE5")
	dbSetOrder(2)

	If SE5->(MsSeek(xFilial("SE5", (cAliasSea)->EA_FILORIG)+"BA"+SE2->(E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO)+DTOS(SE2->E2_BAIXA)+SE2->(E2_FORNECE+E2_LOJA)))
		cChvSE5 := SE5->(E5_FILIAL+E5_TIPODOC+E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO)+DTOS(SE5->E5_DATA)+SE5->(E5_CLIFOR+E5_LOJA)  
		nRecNo := SE5->(RecNo())
		
		While SE5->(!Eof()) .And. cChvSE2 == cChvSE5 
			//Se considera baixas que nao possuem estorno
			If !TemBxCanc(SE5->(E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+E5_CLIFOR+E5_LOJA+E5_SEQ))
				nRecNo := SE5->(RecNo())
				
				If SubStr( SE5->E5_DOCUMEN,1,6 ) == (cAliasSea)->EA_NUMBOR .And. SE5->E5_MOTBX != "PCC"
					lBaixa := .T.
					Exit
				Endif
			EndIf
			
			SE5->(dbSkip())
			cChvSE5 := SE5->(E5_FILIAL+E5_TIPODOC+E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO)+DTOS(SE5->E5_DATA)+SE5->(E5_CLIFOR+E5_LOJA)
		EndDo
		
		//Posiciono no primeiro movimento encontrado ou no �ltimo movimento n?o cancelado, � importante manter a SE5 com a chave do t�tulo da SE2
		SE5->(dbGoTo(nRecNo))
	Endif
EndIf

RestArea(aArea)

Return lBaixa

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �Fr710Benef�Autor  �  Marcio Menon      � Data �  28/07/06   ���
�������������������������������������������������������������������������͹��
���Desc.     � Retorna o campo Beneficiario conforme o modelo do          ���
���          � bordero.                                                   ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function Fr710Benef(cAliasSea, lBaixa, lCheque, lAbatimento)

Local cBenef 	:= ""

SE2->(dbSetOrder(1))

If SE2->(DbSeek(xFilial("SE2", (cAliasSea)->EA_FILORIG)+(cAliasSea)->(EA_PREFIXO+EA_NUM+EA_PARCELA+EA_TIPO+EA_FORNECE+EA_LOJA)))
	SA2->(dbSetOrder(1))
	SA2->(MsSeek(xFilial("SA2",SE2->E2_FILORIG)+SE2->E2_FORNECE+SE2->E2_LOJA))
	
	If (cAliasSea)->EA_MODELO $ "CH/02"
		If !lAbatimento
			If lCheque
				cBenef := SEF->EF_BENEF
			ElseIf lBaixa
				cBenef := SE5->E5_BENEF
			Else
				cBenef := SA2->A2_NOME
			Endif
		EndIf
	Else
		cBenef := SA2->A2_NOME
	Endif
EndIf

Return cBenef

/*
�������������������������������������������������������������������������������
�������������������������������������������������������������������������������
���������������������������������������������������������������������������ͻ��
���Programa  �Fr710VPagar �Autor  � Marcio Menon       � Data �  28/07/06   ���
���������������������������������������������������������������������������͹��
���Desc.     � Faz os calculos dos valores a pagar dos titulos.		        ���
���          � 						                                        ���
���������������������������������������������������������������������������͹��
���Uso       � 	                                                            ���
���������������������������������������������������������������������������ͼ��
�������������������������������������������������������������������������������
�������������������������������������������������������������������������������
*/
Static Function Fr710VPagar(cAliasSea, lBaixa, lCheque, lAbatimento)
Local nAbat  	:= 0
Local nVlrPagar	:= 0
Local aArea := GetArea()
Local aAreaSA2 := SA2->(GetArea())
DEFAULT lBaixa 	:= .F. 

SE2->(dbSetOrder(1))
If SE2->(DbSeek(FwxFilial("SE2",(cAliasSea)->EA_FILORIG)+(cAliasSea)->(EA_PREFIXO+EA_NUM+EA_PARCELA+EA_TIPO+EA_FORNECE+EA_LOJA))) 
	If lAbatimento
		nAbat 	:= SE2->E2_SALDO
	Else
		nAbat := SomaAbat(SE2->E2_PREFIXO,SE2->E2_NUM,SE2->E2_PARCELA,"P",SE2->E2_MOEDA,dDataBase,SE2->E2_FORNECE,SE2->E2_LOJA, SE2->E2_FILIAL)
	EndIf

	//Efetua calculo dos juros do titulo posicionado
	fa080Juros(1)	
	
	If ! lAbatimento
		If mv_par07 == 1
			nVlrPagar := Round(NoRound(xMoeda(SE2->E2_SALDO-SE2->E2_SDDECRE+SE2->E2_SDACRES-nAbat+nJuros,SE2->E2_MOEDA,MV_PAR04,Iif(MV_PAR06==1,(cAliasSea)->EA_DATABOR,dDataBase),MsDecimais(1)+1,SE2->E2_TXMOEDA ,SM2->M2_MOEDA2),MsDecimais(1)+1),MsDecimais(1))
	    Else
			nVlrPagar := Round(NoRound(xMoeda(SE2->E2_VALOR-SE2->E2_DECRESC+SE2->E2_ACRESC-nAbat+nJuros,SE2->E2_MOEDA,MV_PAR04,Iif(MV_PAR06==1,(cAliasSea)->EA_DATABOR,dDataBase),MsDecimais(1)+1,SE2->E2_TXMOEDA ,SM2->M2_MOEDA2),MsDecimais(1)+1),MsDecimais(1))
		EndIf
	Endif
	
	RestArea(aAreaSA2)
	RestArea(aArea)
EndIf

Return nVlrPagar

/*
�������������������������������������������������������������������������������
�������������������������������������������������������������������������������
���������������������������������������������������������������������������ͻ��
���Programa  �ReportCabec �Autor  � Marcio Menon       � Data �  28/07/06   ���
���������������������������������������������������������������������������͹��
���Desc.     � Monta o cabecalho do relatorio.				 		        ���
���          � 						                                        ���
���������������������������������������������������������������������������͹��
���Uso       � 	                                                            ���
���������������������������������������������������������������������������ͼ��
�������������������������������������������������������������������������������
�������������������������������������������������������������������������������
*/
Static Function ReportCabec(oReport, cModelo, cAliasSea, lBaixa, lSeaEof)

Local cStartPath	:= GetSrvProfString("Startpath","")
Local cLogo			:= ""
Local cTexto 		:= ""
Local lHlpNoTab 	:= .F.

//Se a quebra de secao for na impressao do texto da autorizacao
//Volta o registro para imprimir o cabecalho
If (cAliasSea)->(EOF())
    lSeaEof := .T.
	(cAliasSea)->(dbSkip(-1))
	cModelo := (cAliasSea)->EA_MODELO
EndIf

If lBaixa
	SA6->(MsSeek(xFilial("SA6", (cAliasSea)->EA_FILIAL)+SE5->(E5_BANCO+E5_AGENCIA+E5_CONTA)))
Else
	SA6->(MsSeek(xFilial("SA6", (cAliasSea)->EA_FILIAL)+(cAliasSea)->(EA_PORTADO+EA_AGEDEP+EA_NUMCON)))
Endif

//�����������������������������������������������Ŀ
//� Verifica o modelo do documento.				  �
//�������������������������������������������������
lHlpNoTab := IIf(Empty(cModelo),.F.,.T.)
If cModelo $ "CH/02"
	cTexto := Tabela("58",@cModelo,lHlpNoTab)
Elseif cModelo $ "CT/30"
	cTexto := Tabela("58",@cModelo,lHlpNoTab)
Elseif cModelo $ "CP/31"
	cTexto := Tabela("58",@cModelo,lHlpNoTab)
ElseIf cModelo $ "CC/01/03/04/05/10/41/43"
	cTexto := Tabela("58",@cModelo,lHlpNoTab)
Else
	cTexto := Tabela("58",@cModelo,lHlpNoTab)
Endif

//�����������������������������������������������Ŀ
//� Define o cabecalho.							  �
//�������������������������������������������������
oReport:ThinLine()

cLogo := cStartPath + "LGRL" + SM0->M0_CODIGO + IIf( lFWCodFil, FWGETCODFILIAL, SM0->M0_CODFIL ) + ".BMP" 	// Empresa+Filial

If !File( cLogo )
	cLogo := cStartPath + "LGRL" + SM0->M0_CODIGO + ".BMP" 						// Empresa
endif

oReport:SkipLine()
oReport:SayBitmap (oReport:Row(),005,cLogo,291,057)
oReport:SkipLine()
oReport:SkipLine()
oReport:SkipLine()
oReport:ThinLine()
oReport:SkipLine()
oReport:SkipLine()
//Texto do tipo de bordero
oReport:PrintText(SM0->M0_NOME + PadC(OemToAnsi(STR0034),100) + OemToAnsi(STR0035)+DtoC(dDataBase))
oReport:PrintText(Space(Len(SM0->M0_NOME)) + PadC(cTexto,100) + OemToAnsi(STR0036) + (cAliasSea)->EA_NUMBOR)
oReport:SkipLine()
oReport:SkipLine()
//Dados do Banco
oReport:PrintText(Pad(OemToAnsi(STR0037) + SA6->A6_NOME,100))
oReport:PrintText(Pad(	OemToAnsi(STR0038) + RTrim(SA6->A6_AGENCIA) + Iif( !Empty(SA6->A6_DVAGE),"-","") + RTrim(SA6->A6_DVAGE) + ;
						OemToAnsi(STR0040) + RTrim(SA6->A6_NUMCON)  + Iif( !Empty(SA6->A6_DVCTA),"-","") + RTrim(SA6->A6_DVCTA),100))
oReport:PrintText(Pad(SA6->A6_END + " "  + SA6->A6_MUN + " " + SA6->A6_EST,100))
oReport:SkipLine()
oReport:SkipLine()
oReport:ThinLine()

If lSeaEof
	(cAliasSea)->(dbSkip())
EndIf

Return ""

/*
�������������������������������������������������������������������������������
�������������������������������������������������������������������������������
���������������������������������������������������������������������������ͻ��
���Programa  �Fr710Config �Autor  � Marcio Menon       � Data �  01/08/06   ���
���������������������������������������������������������������������������͹��
���Desc.     � Exibe ou oculta as colunas do relatorio, conforme o modelo   ���
���          � do bordero.			                                        ���
���������������������������������������������������������������������������͹��
���Uso       � 	                                                            ���
���������������������������������������������������������������������������ͼ��
�������������������������������������������������������������������������������
�������������������������������������������������������������������������������
*/
Static Function Fr710Config(cAliasSea, oSection2)

Do Case

Case	(cAliasSea)->EA_MODELO $ "CH/02"
	oSection2:Cell("EF_NUM"    ):Enable()
	oSection2:Cell("EF_NUM"    ):SetBlock({ || "CH. " + SEF->EF_NUM})
	oSection2:Cell("A2_BANCO"  ):Disable()
	oSection2:Cell("A2_AGENCIA"):Disable()
	oSection2:Cell("A6_DVAGE"  ):Disable()
	oSection2:Cell("A2_NUMCON" ):Disable()
	oSection2:Cell("A6_DVCTA"  ):Disable()
	oSection2:Cell("A2_CGC"    ):Disable()

Case	(cAliasSea)->EA_MODELO $ "CT/30"
	oSection2:Cell("A6_NREDUZ" ):Disable()
	oSection2:Cell("A2_BANCO"  ):Disable()
	oSection2:Cell("A2_AGENCIA"):Disable()
	oSection2:Cell("A6_DVAGE"  ):Disable()
	oSection2:Cell("A2_NUMCON" ):Disable()
	oSection2:Cell("A6_DVCTA"  ):Disable()
	oSection2:Cell("A2_CGC"    ):Disable()
   //Verifica se existe numero de cheque
	If (SEF->(MsSeek(xFilial("SEF") + SE5->E5_BANCO + SE5->E5_AGENCIA + SE5->E5_CONTA + SE5->E5_NUMCHEQ)))
		oSection2:Cell("EF_NUM"    ):SetTitle("NUM. CHEQUE")
		oSection2:Cell("EF_NUM"    ):SetBlock({ || SEF->EF_NUM})
		oSection2:Cell("EF_NUM"    ):Enable()
	Else
		oSection2:Cell("EF_NUM"    ):SetTitle("")
	EndIf

Case	(cAliasSea)->EA_MODELO $ "CT/31"
	oSection2:Cell("A6_NREDUZ" ):Enable()
	oSection2:Cell("A2_BANCO"  ):Disable()
	oSection2:Cell("A2_AGENCIA"):Disable()
	oSection2:Cell("A6_DVAGE"  ):Disable()
	oSection2:Cell("A2_NUMCON" ):Disable()
	oSection2:Cell("A6_DVCTA"  ):Disable()
	oSection2:Cell("A2_CGC"    ):Disable()
   //Verifica se existe numero de cheque
	If (SEF->(MsSeek(xFilial("SEF") + SE5->E5_BANCO + SE5->E5_AGENCIA + SE5->E5_CONTA + SE5->E5_NUMCHEQ)))
		oSection2:Cell("EF_NUM"    ):SetTitle("NUM. CHEQUE")
		oSection2:Cell("EF_NUM"    ):SetBlock({ || SEF->EF_NUM})
		oSection2:Cell("EF_NUM"    ):Enable()
	Else
		oSection2:Cell("EF_NUM"    ):SetTitle("NUM. CHEQUE")
	EndIf

Case	(cAliasSea)->EA_MODELO $ "CC/01/03/04/05/10/41/43"
	oSection2:Cell("A6_NREDUZ" ):Enable()
	oSection2:Cell("A2_BANCO"  ):Enable()
	oSection2:Cell("A2_AGENCIA"):Enable()
	oSection2:Cell("A6_DVAGE"  ):Enable()
	oSection2:Cell("A2_NUMCON" ):Enable()
	oSection2:Cell("A6_DVCTA"  ):Enable()
	oSection2:Cell("A2_CGC"    ):Enable()
	oSection2:Cell("EF_NUM"    ):Disable()
EndCase


Return

/*
�������������������������������������������������������������������������������
�������������������������������������������������������������������������������
���������������������������������������������������������������������������ͻ��
���Programa  �ReportTxtAut�Autor  � Marcio Menon       � Data �  01/08/06   ���
���������������������������������������������������������������������������͹��
���Desc.     � Imprime o Total Geral por extenso e as mensagens de	        ���
���          � autorizacao, conforme o modelo do bordero.                   ���
���������������������������������������������������������������������������͹��
���Uso       � 	                                                            ���
���������������������������������������������������������������������������ͼ��
�������������������������������������������������������������������������������
�������������������������������������������������������������������������������
*/
Static Function ReportTxtAut(oReport, cModelo, cNumConta, nVlrSecao)
Local nCount

oReport:SkipLine()
oReport:PrintText(Extenso(nVlrSecao,.F.,MV_PAR04))
oReport:SkipLine()

If cModelo $ "CH/02"
	//"AUTORIZAMOS V.SAS. A EMITIR OS CHEQUES NOMINATIVOS AOS BENEFICIARIOS EM REFERENCIA,"
	oReport:PrintText(STR0008)
	//"DEBITANDO EM NOSSA CONTA CORRENTE NO DIA "
	oReport:PrintText(STR0009 + DtoC( mv_par03 ))
	//"PELO VALOR ACIMA TOTALIZADO."
	oReport:PrintText(STR0010)

Elseif cModelo $ "CT/30"
	//"AUTORIZAMOS V.SAS. A PAGAR OS TITULOS ACIMA RELACIONADOS EM NOSSA"
	oReport:PrintText(STR0011)
	//"CONTA MOVIMENTO NO DIA "###", PELO VALOR ACIMA TOTALIZADO."
	oReport:PrintText(STR0012 + DtoC( mv_par03 ) + OemToAnsi(STR0013))

Elseif cModelo $ "CP/31"
	//"AUTORIZAMOS V.SAS. A PAGAR OS TITULOS EM REFERENCIA, LEVANDO A DEBITO DE NOSSA"
	oReport:PrintText(STR0014)
	//"CONTA CORRENTE NUM. "###" NO DIA "###" PELO VALOR ACIMA TOTALIZADO."
	oReport:PrintText(STR0015 + cNumConta + OemToAnsi(STR0016) + DtoC( mv_par03 ) + OemToAnsi(STR0017))

Elseif cModelo $ "CC/01/03/04/05/10/41/43"
	//"AUTORIZAMOS V.SAS. A EMITIREM ORDEM DE PAGAMENTO, OU DOC PARA OS BANCOS/CONTAS ACIMA."
	oReport:PrintText(STR0018)
	//"DOS TITULOS RESPECTIVOS DEBITANDO EM NOSSA C/CORRENTE NUM "
	oReport:PrintText(STR0019 + cNumConta)
	//"NO DIA "### " PELO VALOR ACIMA TOTALIZADO."
	oReport:PrintText(STR0020 + dToC( mv_par03 ) + OemToAnsi(STR0021))

Else
	//"AUTORIZAMOS V.SAS. A PAGAR OS TITULOS EM REFERENCIA, LEVANDO A DEBITO DE NOSSA"
	oReport:PrintText(STR0022)
	//"CONTA CORRENTE NUM. "###" NO DIA "###" PELO VALOR ACIMA TOTALIZADO."
	oReport:PrintText(STR0023 + cNumConta + OemToAnsi(STR0016) + DtoC( mv_par03 ) + OemToAnsi(STR0017))
EndIf

For nCount := 1 to 5
	oReport:SkipLine()
Next

oReport:PrintText("-----------------------------------",/*nRow*/,900)
oReport:PrintText(SM0->M0_NOMECOM,/*nRow*/,900)

Return ""

/*
---------------------------------------------- Release 3 ---------------------------------------------------------
*/
/*/
�������������������������������������������������������������������������������
�������������������������������������������������������������������������������
���������������������������������������������������������������������������Ŀ��
���Fun��o	 � FinR710	� Autor � Wagner Xavier 		  � Data � 05.10.92 ���
���������������������������������������������������������������������������Ĵ��
���Descri��o � Bordero de Pagamento.								   	    ���
���������������������������������������������������������������������������Ĵ��
���Sintaxe e � FinR710(void)											    ���
���������������������������������������������������������������������������Ĵ��
���Parametros� 																���
���������������������������������������������������������������������������Ĵ��
��� Uso		 � Generico 													���
����������������������������������������������������������������������������ٱ�
�������������������������������������������������������������������������������
�������������������������������������������������������������������������������
/*/
Static Function FinR710R3( )
//��������������������������������������������������������������Ŀ
//� Define Variaveis 										     �
//����������������������������������������������������������������
Local wnrel
Local cDesc1 := STR0001  //"Este programa tem a fun��o de emitir os borderos de pagamen-"
Local cDesc2 := STR0002  //"tos."
Local cDesc3 :=""
Local Tamanho:="M"
Local cString:="SEA"

Private titulo	:= STR0003 //"Emiss�o de Borderos de Pagamentos"
Private cabec1	:= ""
Private cabec2	:= ""
Private aReturn	:= { OemToAnsi(STR0004), 1,OemToAnsi(STR0005), 1, 2, 1, "",1 }  //"Zebrado"###"Administracao"
Private nomeprog:="FINR710"
Private aLinha	:= { },nLastKey := 0
Private cPerg	:="FIN710"

//��������������������������������������������������������������Ŀ
//� Verifica as perguntas selecionadas 						     �
//����������������������������������������������������������������
pergunte("FIN710",.F.)

//�������������������������������������������������������������Ŀ
//� Vari�veis utilizadas para parametros						�
//� mv_par01				// Do Bordero						�
//� mv_par02				// At� o Bordero					�
//� mv_par03				// Data para d�bito					�
//� mv_par04				// Qual Moeda						�
//� mv_par05				// Outras Moedas					�
//� mv_par06				// Converte por						�
//���������������������������������������������������������������

//��������������������������������������������������������������Ŀ
//� Envia controle para a funcao SETPRINT 						 �
//����������������������������������������������������������������
wnrel := "FINR710"            //Nome Default do relatorio em Disco
wnrel := SetPrint(cString,wnrel,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,"",,Tamanho)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
	Return
Endif

RptStatus({|lEnd| Fa710Imp(@lEnd,wnRel,cString,Tamanho)},titulo)

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o	 � fa710Imp � Autor � Wagner Xavier 		� Data � 05.10.92 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Bordero de Pagamento.									  ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe e � fa710imp 												  ���
�������������������������������������������������������������������������Ĵ��
��� Uso		 � Generico 												  ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function FA710Imp(lEnd,wnRel,cString, Tamanho)

Local CbCont,CbTxt
Local cModelo
Local nTotValor		:= 0
Local lCheque		:= .f.
Local lBaixa		:= .f.
Local nTipo
Local nColunaTotal
Local cNumConta		:= CriaVar("EA_NUMCON")
Local lNew			:= .F.
Local cNumBor
Local lAbatimento 	:= .F.
Local nAbat 		:= 0
Local lFirst 		:= .T.
Local cChave
Local aArea			:= {}
Local sFilial
Local cFilOrig
Local cFilDe
Local cFilAte
Local aSM0		:= AdmAbreSM0()
Local nInc
Local aFilProc	:= {}
Local cFilAux
Local nRecNoSE5 := 0

Private nJuros 		:= 0
Private dBaixa 		:= CriaVar("E2_BAIXA")

//��������������������������������������������������������������Ŀ
//� Vari�veis utilizadas para Impress�o do Cabe�alho e Rodap�	  �
//����������������������������������������������������������������
cbtxt 	:= SPACE(10)
cbcont	:= 0
li 		:= 80
m_pag 	:= 1

nTipo := aReturn[4]
nContador := 0

//Valida data de d�bito (mv_par03)
If Empty(mv_par03)
	HELP (" ",1,'DTDEBITO',,"Data de d�bito n?o informada na parametriza�?o do relat�rio.",1,0,,,,,,{"Por favor, informe a data de d�bito nos par�metros do relat�rio (pergunte)."} ) 	//###
	Return
Endif

SetRegua(RecCount())
lNew := .T.

//�����������������������������������������������������������Ŀ
//� Atribui valores as variaveis ref a filiais                �
//�������������������������������������������������������������
If mv_par08 == 2
	cFilDe  := IIf( lFWCodFil, FWGETCODFILIAL, SM0->M0_CODFIL )
	cFilAte := IIf( lFWCodFil, FWGETCODFILIAL, SM0->M0_CODFIL )
 Else
	cFilDe := mv_par09	// Todas as filiais
	cFilAte:= mv_par10
Endif

cFilAux := cFilAnt

For nInc := 1 To Len( aSM0 )

  cFilAnt := aSM0[nInc][2]
  c_Empant:= aSM0[nInc][1]

  If aSM0[nInc][1] == cEmpAnt .AND. (aSM0[nInc][2] >= cFilDe .and. aSM0[nInc][2] <= cFilAte) .and.  AScan( aFilProc, c_Empant+xFilial("SEA") ) == 0


	 dbSelectArea("SEA")
	 dbSetOrder( 1 )
	 dbSeek(cFilial+mv_par01,.T.)


	While !Eof() .And. cFilial == EA_FILIAL .And. EA_NUMBOR <= mv_par02

		cNumBor := SEA->EA_NUMBOR

		IF lEnd
			@Prow()+1,001 PSAY OemToAnsi(STR0006)  //"CANCELADO PELO OPERADOR"
			Exit
		EndIF

		IncRegua()

		IF Empty(EA_NUMBOR)
			dbSkip( )
			Loop
		Endif

		IF SEA->EA_CART != "P"
			dbSkip( )
			Loop
		Endif

		lCheque := .f.
		lBaixa  := .f.
		cModelo := SEA->EA_MODELO
		dbSelectArea( "SE2" )
		cLoja := Iif ( Empty(SEA->EA_LOJA) , "" , SEA->EA_LOJA )

		dbSelectArea( "SA2" )
		SE2->(DbSeek(FwxFilial("SE2",SEA->EA_FILORIG)+SEA->(EA_PREFIXO+EA_NUM+EA_PARCELA+EA_TIPO+EA_FORNECE+EA_LOJA)))

		// Borderos gerados em versao anterior
		IF Empty(SEA->EA_FILORIG) .AND. !Empty(xFilial("SE2"))
			cChave		:= xFilial("SE2")+SEA->EA_PREFIXO+SEA->EA_NUM+SEA->EA_PARCELA+SEA->EA_TIPO+SEA->EA_FORNECE+cLoja
			cFilOrig	:= xFilial("SE2")
		Else //Borderos gerados a partir da versao 7.10
			cChave 		:= FwxFilial("SE2",SEA->EA_FILORIG)+SEA->(EA_PREFIXO+EA_NUM+EA_PARCELA+EA_TIPO+EA_FORNECE+EA_LOJA)
			//cChave 		:= xFilial("SE2")+SEA->EA_PREFIXO+SEA->EA_NUM+SEA->EA_PARCELA+SEA->EA_TIPO+SEA->EA_FORNECE+cLoja
			cFilOrig	:= SEA->EA_FILORIG
		Endif

		aArea:=GetArea()
		DbSelectArea("SE2")
		dbSetOrder( 1 )
		dbSeek(cChave)
		//RestArea(aArea)

		IF MV_PAR05 == 2 .And. SE2->E2_MOEDA <> MV_PAR04
		   	dbSelectArea("SEA")
			dbSkip( )
			Loop
		Endif

		MsSeek( cChave )
		dbSelectArea( "SE5" )
		dbSetOrder( 2 )
		dbSeek( cFilOrig+"VL"+SE2->E2_FILORIG+SE2->E2_PREFIXO+SE2->E2_NUM+SE2->E2_PARCELA+SE2->E2_TIPO+DtoS(SE2->E2_BAIXA)+SE2->E2_FORNECE+SE2->E2_LOJA )

		While !Eof() .and. ;
			E5_FILIAL	== cFilOrig			.and. ;
			E5_TIPODOC	== "VL"            	.and. ;
			E5_PREFIXO	== SE2->E2_PREFIXO 	.and. ;
			E5_NUMERO	== SE2->E2_NUM 	 	.and. ;
			E5_PARCELA	== SE2->E2_PARCELA 	.and. ;
			E5_TIPO		== SE2->E2_TIPO	 	.and. ;
			E5_DATA		== SE2->E2_BAIXA	.and. ;
			E5_CLIFOR	== SE2->E2_FORNECE 	.and. ;
			E5_LOJA		== cLoja
			//�����������������������������������������������Ŀ
			//� S� considera baixas que nao possuem estorno   �
			//�������������������������������������������������
			If !TemBxCanc(E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+E5_CLIFOR+E5_LOJA+E5_SEQ)
				If SubStr( E5_DOCUMEN,1,6 ) == cNumBor .And. E5_MOTBX != "PCC"
					lBaixa := .t.
					Exit
				Endif
			EndIf
			dbSkip( )
		Enddo
		If !lBaixa
			If ( !Empty( xFilial("SE2") ) .and. !Empty( xFilial("SE5") )) .or. (Empty( xFilial("SE2") ) .and. !Empty( xFilial("SE5") ))
				sFilial := SE2->E2_FILIAL
			Else
				sFilial := xFilial("SE5")
			EndIf
			If (dbSeek( sFilial+"BA"+SE2->E2_PREFIXO+SE2->E2_NUM+SE2->E2_PARCELA+SE2->E2_TIPO+DtoS(SE2->E2_BAIXA)+SE2->E2_FORNECE+SE2->E2_LOJA))
				nRecNoSE5 := SE5->( RecNo() )
				While !Eof() .and. ;
					E5_FILIAL	== sFilial 			.and. ;
					E5_TIPODOC	== "BA"            	.and. ;
					E5_PREFIXO	== SE2->E2_PREFIXO 	.and. ;
					E5_NUMERO	== SE2->E2_NUM 	 	.and. ;
					E5_PARCELA	== SE2->E2_PARCELA 	.and. ;
					E5_TIPO		== SE2->E2_TIPO	 	.and. ;
					E5_DATA		== SE2->E2_BAIXA	.and. ;
					E5_CLIFOR	== SE2->E2_FORNECE 	.and. ;
					E5_LOJA		== SE2->E2_LOJA

					//�����������������������������������������������Ŀ
					//� S� considera baixas que nao possuem estorno   �
					//�������������������������������������������������
					If !TemBxCanc(E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+E5_CLIFOR+E5_LOJA+E5_SEQ)
						nRecNoSE5 := SE5->( RecNo() )
						If SubStr( E5_DOCUMEN,1,6 ) == cNumBor .And. E5_MOTBX != "PCC"
							lBaixa := .t.
							Exit
						Endif
					EndIf
					dbSkip( )
				Enddo

				//Posiciono no primeiro movimento encontrado ou no �ltimo movimento n�o cancelado, � importante manter a SE5 com a chave do t�tulo da SE2
				SE5->( dbGoTo( nRecNoSE5 ) )
			Endif
		Endif
		dbSelectArea( "SEF" )
		If (!Empty(SE5->E5_NUMCHEQ) .And. dbSeek( cFilial+SE5->E5_BANCO+SE5->E5_AGENCIA+SE5->E5_CONTA+SE5->E5_NUMCHEQ))
			lCheque := .t.
		Endif

		// Localiza o fornecedor do titulo que esta no bordero
		dbSelectArea( "SA2" )
		SE2->(DbSeek(FwxFilial("SE2",SEA->EA_FILORIG)+SEA->(EA_PREFIXO+EA_NUM+EA_PARCELA+EA_TIPO+EA_FORNECE+EA_LOJA)))

		// Borderos gerados em versao anterior
		IF Empty(SEA->EA_FILORIG) .AND. !Empty(xFilial("SA2"))
			cChave := xFilial("SA2")+SE2->E2_FORNECE+SE2->E2_LOJA
		Else //Borderos gerados a partir da versao 7.10
			If !Empty(SEA->EA_FILORIG) .AND. !Empty(xFilial("SA2"))
				cChave := FwxFilial("SA2")+SE2->E2_FORNECE+SE2->E2_LOJA
			Else
				cChave := xFilial("SA2")+SE2->E2_FORNECE+SE2->E2_LOJA
			Endif
		Endif
		MsSeek( cChave )

		dbSelectArea( "SEA" )

		IF li > 55 .Or. lNew
			fr710Cabec( SEA->EA_MODELO, nTipo, Tamanho, @lFirst)
			m_pag++
			lNew := .F.
		Endif

		lAbatimento := SEA->EA_TIPO $ MV_CPNEG .or. SEA->EA_TIPO $ MVABATIM
		If lAbatimento
			nAbat 	:= SE2->E2_SALDO
		Else
			nAbat := SomaAbat(SE2->E2_PREFIXO,SE2->E2_NUM,SE2->E2_PARCELA,"P",SE2->E2_MOEDA,dDataBase,SE2->E2_FORNECE,SE2->E2_LOJA, SE2->E2_FILIAL)
		EndIf

		If ! lAbatimento
			li++
			@li, 0 PSAY SEA->EA_PREFIXO
			@li, 4 PSAY SEA->EA_NUM
			@li,17 PSAY SEA->EA_PARCELA
		EndIf

		SA6->( dbSetOrder( 1 ) )
		SA6->( dbSeek( xFilial("SA6")+SEA->(EA_PORTADO+EA_AGEDEP+EA_NUMCON)) )

		cNumConta := RTrim(SEA->EA_NUMCON) + Iif( !Empty(SA6->A6_DVCTA), "-", "" ) + SA6->A6_DVCTA


		//������������������������������������������������Ŀ
		//� Efetua calculo dos juros do titulo posicionado �
		//��������������������������������������������������
		fa080Juros(1)

		dbSelectArea( "SA2" )
		dbSeek( xFilial("SA2")+SEA->(EA_FORNECE+EA_LOJA))
		Fr710Benef("SEA", lBaixa, lCheque, lAbatimento)	
		If SEA->EA_MODELO $ "CH/02"
			dbSelectArea( "SEA" )
			If ! lAbatimento
				If lCheque
					@li,20 PSAY SubStr(SEF->EF_BENEF,1, 33)
				Elseif lBaixa
					@li,20 PSAY SubStr(SE5->E5_BENEF,1, 33)
				Else
					@li,20 PSAY SubStr(SA2->A2_NOME,1, 33)
				Endif
			EndIf

			dbSelectArea( "SA6" )
	        DbSeek(FwxFilial("SA6",SEA->EA_FILORIG)+SEA->(EA_PORTADO+EA_AGEDEP+EA_NUMCON))

			If lBaixa
				dbSeek( xFilial("SA6")+SE5->(E5_BANCO+E5_AGENCIA+E5_CONTA))
			Else
				dbSeek( xFilial("SA6")+SEA->(EA_PORTADO+EA_AGEDEP+EA_NUMCON))
			Endif
			dbSelectArea( "SEA" )
			If ! lAbatimento
				@li,55 PSAY Left(SA6->A6_NREDUZ,15)
				@li,71 PSAY SE2->E2_VENCREA
				If lCheque
					@li,82 PSAY "CH. " + SEF->EF_NUM
				Endif
			EndIf
			nColunaTotal := 102
		Elseif SEA->EA_MODELO $ "CT/30"
			If ! lAbatimento
				@li,20 PSAY SubStr(SA2->A2_NOME,1, 33)
				@li,55 PSAY SE2->E2_VENCREA
				If lCheque
					@li,78 PSAY SEF->EF_NUM
				Endif
			EndIf
			nColunaTotal := 94
		Elseif SEA->EA_MODELO $ "CP/31"
			If ! lAbatimento
				@li,20 PSAY SubStr(SA2->A2_NOME,1, 33)
			EndIf
			dbSelectArea( "SA6" )
			dbSeek( xFilial("SA6")+SEA->(EA_PORTADO+EA_AGEDEP+EA_NUMCON))
			dbSelectArea( "SEA" )
			If ! lAbatimento
				@li,55 PSAY Left(SA6->A6_NREDUZ,15)
				@li,71 PSAY SE2->E2_VENCREA
				@li,83 PSAY SE2->E2_NUMBCO
			EndIf
			nColunaTotal := 99
		Elseif SEA->EA_MODELO $ "CC/01/03/04/05/10/41/43"
			dbSelectArea( "SA6" )
			If SEA->(EA_PORTADO+EA_AGEDEP+EA_NUMCON) <> SA2->(A2_BANCO+A2_AGENCIA+A2_NUMCON) .And. !Empty(SA2->(A2_BANCO+A2_AGENCIA+A2_NUMCON))
				dbSeek( xFilial("SA6")+SA2->(A2_BANCO+A2_AGENCIA+A2_NUMCON))
			Else
				dbSeek( xFilial("SA6")+SEA->(EA_PORTADO+EA_AGEDEP+EA_NUMCON))
			EndIf
			If ! lAbatimento
				@li,20  PSAY Left(SA6->A6_NREDUZ,15)
				@li,36  PSAY 	SA2->A2_BANCO + " " + ;
								RTrim(SA2->A2_AGENCIA) + Iif( !Empty(SA2->A2_AGENCIA), Iif( !Empty(SA6->A6_DVAGE), "-", "") + SA6->A6_DVAGE, "" ) + " " + ;
								RTrim(SA2->A2_NUMCON)  + Iif( !Empty(SA2->A2_NUMCON) , Iif( !Empty(SA6->A6_DVCTA), "-", "") + SA6->A6_DVCTA, "" )
				@li,60  PSAY SubStr(SA2->A2_NOME, 1, 25 )
				@li,86  PSAY SA2->A2_CGC Picture IIF(Len(Alltrim(SA2->A2_CGC))>11,"@R 99999999/9999-99","@R 999999999-99")
				@li,104 PSAY SE2->E2_VENCREA
			EndIf
			nColunaTotal := 115
		Else
			If ! lAbatimento
				@li,20 PSAY SubStr(SA2->A2_NOME,1, 33)
			EndIf
			dbSelectArea( "SA6" )
			dbSeek( xFilial("SA6")+SEA->(EA_PORTADO+EA_AGEDEP+EA_NUMCON))
			dbSelectArea( "SEA" )
			If ! lAbatimento
				@li,55 PSAY Left(SA6->A6_NREDUZ,15)
				@li,71 PSAY SE2->E2_VENCREA
				@li,84 PSAY SE2->E2_NUMBCO
			EndIf
			nColunaTotal := 100
		Endif

		dbSelectArea( "SA2" )
		dbSeek( xFilial("SA2")+SE2->(E2_FORNECE+E2_LOJA))

		If ! lAbatimento
			If mv_par07 == 1
				@li,nColunaTotal PSAY Round(NoRound(xMoeda(SE2->E2_SALDO-SE2->E2_SDDECRE+SE2->E2_SDACRES-nAbat+nJuros,SE2->E2_MOEDA,MV_PAR04,Iif(MV_PAR06==1,SEA->EA_DATABOR,dDataBase),MsDecimais(1)+1,SE2->E2_TXMOEDA ,SM2->M2_MOEDA2),MsDecimais(1)+1),MsDecimais(1)) Picture "@E 999,999,999.99"
	    	Else
				@li,nColunaTotal PSAY Round(NoRound(xMoeda(SE2->E2_VALOR-SE2->E2_SDDECRE+SE2->E2_SDACRES-nAbat+nJuros,SE2->E2_MOEDA,MV_PAR04,Iif(MV_PAR06==1,SEA->EA_DATABOR,dDataBase),MsDecimais(1)+1,SE2->E2_TXMOEDA ,SM2->M2_MOEDA2),MsDecimais(1)+1),MsDecimais(1)) Picture "@E 999,999,999.99"
			EndIf
		EndIf
		
		If lAbatimento
			nTotValor -= Round(NoRound(xMoeda(SE2->E2_SALDO+nJuros,SE2->E2_MOEDA,MV_PAR04,Iif(MV_PAR06==1,SEA->EA_DATABOR,dDataBase),MsDecimais(1)+1,SE2->E2_TXMOEDA ,SM2->M2_MOEDA2),MsDecimais(1)+1),MsDecimais(1))
		Else
			nTotValor += Round(NoRound(xMoeda(Iif(mv_par07==1,SE2->E2_SALDO,SE2->E2_VALOR)-SE2->E2_SDDECRE+SE2->E2_SDACRES-nAbat+nJuros,SE2->E2_MOEDA,MV_PAR04,Iif(MV_PAR06==1,SEA->EA_DATABOR,dDataBase),MsDecimais(1)+1,SE2->E2_TXMOEDA ,SM2->M2_MOEDA2),MsDecimais(1)+1),MsDecimais(1))
		Endif

		dbSelectArea( "SEA" )
		dbSkip( )

		//����������������������������������������������������������Ŀ
		//� Verifica se n�o h� mais registros v�lidos a analisar.    �
		//������������������������������������������������������������
		DO WHILE !Eof() .And. cFilial == EA_FILIAL .And. EA_NUMBOR <= mv_par02 ;
					.and. (Empty(EA_NUMBOR) .or. SEA->EA_CART != "P")
			dbSkip( )
	 	ENDDO

		If cNumBor != SEA->EA_NUMBOR
			lNew := .T. 							// Novo bordero a ser impresso
			If li != 80
				li+=2
				@li,	00 PSAY __PrtThinLine()
				li++
				@li, 75 PSAY OemToAnsi(STR0007)  //"TOTAL GERAL ..... "
				@li,nColunaTotal PSAY nTotValor	Picture "@E 999,999,999.99"
				cExtenso := Extenso( nTotValor, .F., MV_PAR04 )
				li+=2
				@li,	1 PSAY Trim(SubStr(cExtenso,1,100))
				If Len(Trim(cExtenso)) > 100
					li++
					@li, 0 PSAY SubStr(cExtenso,101,Len(Trim(cExtenso))-100)
				Endif
				li+=2
				If cModelo $ "CH/02"
					@li, 0 PSAY OemToAnsi(STR0008)  //"AUTORIZAMOS V.SAS. A EMITIR OS CHEQUES NOMINATIVOS AOS BENEFICIARIOS EM REFERENCIA,"
					li++
					@li, 0 PSAY OemToAnsi(STR0009) + DtoC( mv_par03 )  //"DEBITANDO EM NOSSA CONTA CORRENTE NO DIA "
					li++
					@li, 0 PSAY OemToAnsi(STR0010)  //"PELO VALOR ACIMA TOTALIZADO."
				Elseif cModelo $ "CT/30"
					@li, 0 PSAY OemToAnsi(STR0011)  //"AUTORIZAMOS V.SAS. A PAGAR OS TITULOS ACIMA RELACIONADOS EM NOSSA"
					li++
					@li, 0 PSAY OemToAnsi(STR0012)   + DtoC( mv_par03 ) + OemToAnsi(STR0013)  //"CONTA MOVIMENTO NO DIA "###", PELO VALOR ACIMA TOTALIZADO."
				Elseif cModelo $ "CP/31"
					@li, 0 PSAY OemToAnsi(STR0014)  //"AUTORIZAMOS V.SAS. A PAGAR OS TITULOS EM REFERENCIA, LEVANDO A DEBITO DE NOSSA"
					li++
					@li, 0 PSAY OemToAnsi(STR0015) + cNumConta + OemToAnsi(STR0016)+ DtoC( mv_par03 ) +OemToAnsi(STR0017)  //"CONTA CORRENTE NUM. "###" NO DIA "###" PELO VALOR ACIMA TOTALIZADO."
				Elseif cModelo $ "CC/01/03/04/05/10/41/43"
					@li, 0 PSAY OemToAnsi(STR0018)  //"AUTORIZAMOS V.SAS. A EMITIREM ORDEM DE PAGAMENTO, OU DOC PARA OS BANCOS/CONTAS ACIMA."
					li++
					@li, 0 PSAY OemToAnsi(STR0019)   + cNumConta  //"DOS TITULOS RESPECTIVOS DEBITANDO EM NOSSA C/CORRENTE NUM "
					li++
					@li, 0 PSAY OemToAnsi(STR0020) + dToC( mv_par03 ) +OemToAnsi(STR0021)  //"NO DIA "### " PELO VALOR ACIMA TOTALIZADO."
				Else
					@li, 0 PSAY OemToAnsi(STR0022)  //"AUTORIZAMOS V.SAS. A PAGAR OS TITULOS EM REFERENCIA, LEVANDO A DEBITO DE NOSSA"
					li++
					@li, 0 PSAY OemToAnsi(STR0023) + cNumConta + OemToAnsi(STR0016) + DtoC( mv_par03 ) +OemToAnsi(STR0017)  //"CONTA CORRENTE NUM. "###" NO DIA "###" PELO VALOR ACIMA TOTALIZADO."
				Endif
				li+=3
				@li,60 PSAY "----------------------------"
				li++
				@li,60 PSAY SM0->M0_NOMECOM
				li++
				@li, 0 PSAY " "
				nTotValor := 0
			Endif
		EndIf
		dbSelectArea("SEA")
	Enddo

Endif
        If Empty(xFilial("SEA")) .AND. aSM0[nInc][1] == cEmpAnt
			Exit
		Endif
  AAdd( aFilProc, c_Empant+xFilial("SEA"))
Next

cFilAnt := cFilAux

Set Device To Screen
dbSelectArea("SE5")
dbSetOrder( 1 )
dbSelectArea("SE2")
dbSetOrder(1)
Set Filter To
If aReturn[5] = 1
	Set Printer To
	dbCommit( )
	Ourspool(wnrel)
Endif
MS_FLUSH()

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o	 �fr710cabec� Autor � Wagner Xavier 		� Data � 24.05.93 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Cabe�alho do Bordero 									  ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe e �fr710cabec() 												  ���
�������������������������������������������������������������������������Ĵ��
���Parametros� 															  ���
�������������������������������������������������������������������������Ĵ��
��� Uso		 � Generico 												  ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function fr710cabec( cModelo, nTipo, Tamanho, lFirst)
Local cCabecalho
Local cTexto

If cModelo $ "CH/02" // Tabela("58",cModelo)
	cTexto := Tabela("58",@cModelo)
	cCabecalho := OemToAnsi(STR0025)  //"PRF NUMERO PC B E N E F I C I A R I O                  BANCO           DT.VENC  HISTORICO               VALOR A PAGAR"
Elseif cModelo $ "CT/30"
	cTexto := Tabela("58",@cModelo)
	cCabecalho := OemToAnsi(STR0027)  //"PRF NUMERO PC B E N E F I C I A R I O                   DT.VENC BCO AGENCIA NUM CHEQUE         VALOR A PAGAR"
Elseif cModelo $ "CP/31"
	cTexto := Tabela("58",@cModelo)
	cCabecalho := OemToAnsi(STR0029)  //"PRF NUMERO PC B E N E F I C I A R I O                  BANCO           DT.VENC  NUM.CHEQUE        VALOR  A PAGAR"
ElseIf cModelo $ "CC/01/03/04/05/10/41/43"
	cTexto := Tabela("58",@cModelo)
	cCabecalho := OemToAnsi(STR0031)  //"PRF NUMERO       PC B A N C O       BCO AGENC NUMERO CONTA  BENEFICIARIO              CNPJ/CPF        DT.VENC       VALOR A PAGAR"
Else
	cTexto := Tabela("58",@cModelo)
	cCabecalho := OemToAnsi(STR0033)  //"PRF NUMERO PC B E N E F I C I A R I O                  BANCO           DT.VENC  NUM.CHEQUE        VALOR  A PAGAR"
Endif

dbSelectArea( "SA6" )
dbSeek( cFilial+SEA->EA_PORTADO+SEA->EA_AGEDEP+SEA->EA_NUMCON )
aCabec := {Sm0->M0_nome,;
			PadC(OemToAnsi(STR0034),97),;
			OemToAnsi(STR0035)+DtoC(dDataBase),;
			PadC(cTexto,97),;
			OemToAnsi(STR0036)+SEA->EA_NUMBOR,;
			Pad(OemToAnsi(STR0037) + SA6->A6_NOME,130),;
			Pad(OemToAnsi(STR0038) + RTrim(SA6->A6_AGENCIA) + Iif( !Empty(SA6->A6_DVAGE),"-","") + SA6->A6_DVAGE +;
			OemToAnsi(STR0040) + RTrim(SA6->A6_NUMCON) + Iif( !Empty(SA6->A6_DVCTA),"-","") + SA6->A6_DVCTA, 130),; //" - C/C "
			Pad(SA6->A6_END + " "  + SA6->A6_MUN + " " + SA6->A6_EST,130)}

Cabec1 := cCabecalho
li := Cabec710(Titulo,Cabec1,NomeProg,tamanho,Iif(aReturn[4]==1,GetMv("MV_COMP"),;
      	GetMv("MV_NORM")), aCabec, @lFirst)

Return


/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o	 �fa710DtDeb� Autor � Mauricio Pequim Jr.	� Data � 12.01.98 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Validacao da data de d�bito para o bordero	  			  ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe e �fa710DtDeb() 												  ���
�������������������������������������������������������������������������Ĵ��
��� Uso		 � Generico 												  ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function fa710DtDeb()

Local lRet := .T.
lRet := IIf (mv_par03 < dDataBase, .F. , .T. )
Return lRet

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o	 �Cabec170  � Autor � Mauricio Pequim Jr.	� Data � 14.07.01 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Validacao da data de d�bito para o bordero				  ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe e �Cabec170()	 											  ���
�������������������������������������������������������������������������Ĵ��
��� Uso		 � Generico 												  ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function cabec710(cTitulo,cCabec1,cNomPrg,nTamanho,nChar,aCustomText,lFirst)

Local cAlias,nLargura,nLin:=0, aDriver := ReadDriver(),nCont:= 0, cVar,uVar,cPicture
Local lWin := .f.
Local nRow, nCol

// Par�metro que se passado suprime o texto padrao desta fun��o por outro customizado
Default aCustomText := Nil

#DEFINE INIFIELD    Chr(27)+Chr(02)+Chr(01)
#DEFINE FIMFIELD    Chr(27)+Chr(02)+Chr(02)
#DEFINE INIPARAM    Chr(27)+Chr(04)+Chr(01)
#DEFINE FIMPARAM    Chr(27)+Chr(04)+Chr(02)

lPerg := If(GetMv("MV_IMPSX1") == "S" ,.T.,.F.)

cNomPrg := Alltrim(cNomPrg)

Private cSuf:=""

DEFAULT lFirst := .t.

If TYPE("__DRIVER") == "C"
	If "DEFAULT"$__DRIVER
		lWin := .t.
	EndIf
EndIf

nLargura:=132

IF aReturn[5] == 1  // imprime em disco
   lWin := .f.    	// Se eh disco , nao eh windows
Endif

If lFirst
	nRow := PRow()
	nCol := PCol()
	SetPrc(0,0)
	If aReturn[5] <> 2 // Se nao for via Windows manda os caracteres para setar a impressora
		If nChar == NIL .and. !lWin .and. __cInternet == Nil
			@ 0,0 PSAY &(If(aReturn[4]=1,aDriver[3],aDriver[4]))
		ElseIf !lWin .and. __cInternet == Nil
			If nChar == 15
				@ 0,0 PSAY &(If(aReturn[4]=1,aDriver[3],aDriver[4]))
			Else
				@ 0,0 PSAY &(aDriver[4])
			EndIf
		EndIf
	EndIF
	If GetMV("MV_CANSALT",,.T.) // Saltar uma p�gina na impress�o
		If GetMv("MV_SALTPAG",,"S") != "N"
			Setprc(nRow,nCol)
		EndIf
	Endif
Endif

// Impress�o da lista de parametros quando solicitada
//Cabecalho.
FinCgcCabec(Titulo, Cabec1, cabec2, nomeprog, nChar, mv_par03, aCustomText)

@ 05,00 PSAY __PrtLeft(aCustomText[1])		// Empresa
@ 05,00 PSAY __PrtCenter(aCustomText[2])	// Titulo do relatorio
@ 05,00 PSAY __PrtRight(aCustomText[3])		// Data Emiss�o
@ 06,00 PSAY __PrtCenter(aCustomText[4])	// Descri��o do tipo de bordero
@ 06,00 PSAY __PrtRight(aCustomText[5])		// Nro do bordero
@ 09,00 PSAY __PrtLeft(aCustomText[6])		// Ao Banco
@ 10,00 PSAY __PrtLeft(aCustomText[7])		// Agencia - Conta Corrente
@ 11,00 PSAY __PrtLeft(aCustomText[8])		// Endereco Banco

If LEN(Trim(cCabec1)) != 0
	@ 12,00  PSAY __PrtThinLine()
	@ 13,00  PSAY cCabec1
	@ 14,00  PSAY __PrtThinLine()
EndIf
nLin :=15
m_pag++
lFirst := .f.
If Subs(__cLogSiga,4,1) == "S"
	__LogPages()
EndIf

Return nLin

/*/
������������������������������������������������������������������������������
������������������������������������������������������������������������������
��������������������������������������������������������������������������Ŀ��
��� Fun��o    �		     � Autor � Adilson H Yamaguchi  �  Data � 13/12/01 ���
��������������������������������������������������������������������������Ĵ��
��� Descri��o �Monta Cabecalho do relatorio                                ���
��������������������������������������������������������������������������Ĵ��
��� Sintaxe   �ConCGCCabec(Titulo, Cabec1, Cabec2, NomeProg, nTam,         ���
���			  |			   dDataRef, aCustomText, lFirst)                  ���
��������������������������������������������������������������������������Ĵ��
��� Retorno   � Nenhum                                                     ���
��������������������������������������������������������������������������Ĵ��
��� Uso       � SIGAFIN                                                    ���
��������������������������������������������������������������������������Ĵ��
���Parametros �ExpC1 = Conteudo da cabec1               		           ���
���           �ExpC2 = Conteudo da cabec2               				   ���
���           �ExpC3 = Titulo                           				   ���
���           �ExpC4 = Nome da Rotina                   				   ���
���           �ExpN1 = Tamanho                          				   ���
���           �ExpD1 = Data de Referencia              				       ���
���           �ExpL1 = Tamanho                          				   ���
���������������������������������������������������������������������������ٱ�
������������������������������������������������������������������������������
������������������������������������������������������������������������������
/*/
Static Function FinCgcCabec(Titulo, Cabec1, cabec2, nomeprog, nTam, dDataRef, aCustomText, lFirst)
Local Tamanho := "M"
Local aCabec

nTam 	 := 130
dDataRef := If(dDataRef = Nil, mv_par01, dDataBase)

aCabec :=	{"","__LOGOEMP__"}

cabec(Titulo,"","","",tamanho,	nTam, aCabec)

Return .T.

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �FR170Chk  �Autor  �Pedro Pereira Lima  � Data �  14/06/10   ���
�������������������������������������������������������������������������͹��
���Desc.     �Verifica quais titulos tem amarracao com o bordero e faz as ���
���          �devidas validacoes.                                         ���
�������������������������������������������������������������������������͹��
���Uso       �FINR710                                                     ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function FR710Chk(nValid,cAliasQuery)
Local aArea    := GetArea()
Local aAreaQry := (cAliasQuery)->(GetArea())
Local lRetorno := .T.

If !Empty((cAliasQuery)->EA_FILORIG)//Se possui EA_FILORIG, utilizo esse campo na chave de busca

	dbSelectArea("SE2")
	SE2->(dbSetOrder(1))
	SE2->(dbSeek((cAliasQuery)->(EA_FILORIG+EA_PREFIXO+EA_NUM+EA_PARCELA+EA_TIPO+EA_FORNECE+EA_LOJA)))

	While !SE2->(Eof()) .And. (cAliasQuery)->(EA_FILORIG+EA_PREFIXO+EA_NUM+EA_PARCELA+EA_TIPO+EA_FORNECE+EA_LOJA) ==;
	 								  SE2->(E2_FILIAL+E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO+E2_FORNECE+E2_LOJA)
		If nValid == 1 //oSection1
			lRetorno :=	(MV_PAR05 == 1 .Or. SE2->E2_NUMBOR == (cAliasQuery)->EA_NUMBOR)
		Else //oSection2
			lRetorno :=	(MV_PAR05 == 1 .Or. SE2->E2_MOEDA == MV_PAR04)
		EndIf
	 SE2->(dbSkip())
	EndDo
Else//Valida��o anterior, caso o EA_FILORIG esteja em branco
	dbSelectArea("SE2")
	SE2->(dbSetOrder(1))
	SE2->(dbSeek(xFilial("SE2")+(cAliasQuery)->(EA_PREFIXO+EA_NUM+EA_PARCELA+EA_TIPO+EA_FORNECE+EA_LOJA)))

	While !SE2->(Eof()) .And. xFilial("SE2")+(cAliasQuery)->(EA_PREFIXO+EA_NUM+EA_PARCELA+EA_TIPO+EA_FORNECE+EA_LOJA) ==;
	 								  SE2->(E2_FILIAL+E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO+E2_FORNECE+E2_LOJA)
		If nValid == 1 //oSection1
			lRetorno :=	(MV_PAR05 == 1 .Or. SE2->E2_NUMBOR == (cAliasQuery)->EA_NUMBOR)
		Else //oSection2
			lRetorno :=	(MV_PAR05 == 1 .Or. SE2->E2_MOEDA == MV_PAR04)
		EndIf

	SE2->(dbSkip())

	EndDo
EndIf

RestArea(aAreaQry)
RestArea(aArea)

Return lRetorno


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � MsModoFil � Autor  � Jose Lucas       � Data �17.06.2011   ���
�������������������������������������������������������������������������͹��
���Desc.     � Retornar o modo de compartilhamento de cada tabela.        ���
�������������������������������������������������������������������������͹��
���Sintaxe   � ExpA1 := MsModoFil(ExpC1)                                  ���
�������������������������������������������������������������������������͹��
���Parametros� ExpC1 := Alias da tabela a pesquisar.                      ���
�������������������������������������������������������������������������͹��
���Uso       � FINR170                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function MsModoFil(cAlias)
Local aSavArea := GetArea()
Local aModo := {"","",""}

SX2->(dbSetOrder(1))
If SX2->(dbSeek(cAlias))
   aModo[1] := SX2->X2_MODO
   aModo[2] := SX2->X2_MODOUN
   aModo[3] := SX2->X2_MODOEMP
EndIf
RestArea(aSavArea)
Return aModo
