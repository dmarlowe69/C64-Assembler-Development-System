;*********************************;;       DOS 5.1 DISK WEDGE;;      VERSION V5.1/071382;      BY BOB FAIRBAIRN;        COPYRIGHT 1982;  COMMODORE BUSINESS MACHINES;;  DOCUMENTED BY DENTON MARLOWE;;*********************************; C-64 SYSTEM EQUATES;*********************************; BASIC TEXT AREA POINTERS;*********************************TXTTAB=$2B ;START OF BASIC TEXTVARTAB=$2D ;START OF BASIC STORAGE;*********************************; CHRGET ADDRESSES;*********************************CHRGET=$73 ;BASIC INPUT PROCESSORCHRGOT=$79 ;GET CURRENT CHARACTERTXTPTR=$7A ;CHRGET POINTERPOINTB=$7C ;CHRGET PATCH POINTSPCCHK=$80 ;CHRGET SPACE CHECKCHREXT=$8A ;CHRGET EXIT;*********************************; TEMPORARY STORAGE;*********************************OFFSET=$A5 ;OFFSET INTO COMMANDSSAVA  =$A6 ;ACCUMULATE STORAGESAVX  =$A7 ;X INDEX REG STORAGETEMP  =$C3 ;COUNTER;*********************************; DISK I/O ADDRESS;*********************************STATUS=$90 ;KERNAL I/O STATUSEAL   =$AE ;END OF LOAD ADDRESSFNLEN =$B7 ;LENGHT OF FILENAMESA    =$B9 ;SECONDARY ADDRESSFA    =$BA ;DEVICE NUMBERFNADR =$BB ;POINTER TO FILENAME;*********************************STACK =$0100 ;6502 PROCESSOR STACK;*********************************; BASIC ROM ADDRESSES;*********************************LNKPRG=$A533 ;RELINK BASIC LINESRUNC  =$A659 ;SETUP BASICSTXPT =$A68E ;SETUP FOR RUNNEWSTT=$A7AE ;RUN BASIC PRGSYNERR=$AF08 ;SYNTAX ERRORLINPRT=$BDCD ;PRINT LINE NUMBERSAVET =$E159 ;SAVE (PARAMS SET)BASSFT=$E386 ;RETURN TO BASICCHRCPY=$E3AB ;ROM COPY OF CHRGETPRT   =$E716 ;PRINT CHARACTERSROPEN=$F3D5 ;OPEN FILEXCLOSE=$F642 ;CLOSE FILE;*********************************; KERNAL JUMP TABLE;*********************************LISTEN=$FFB1 ;SEND LISTENSECOND=$FF93 ;SEND SECONDCIOUT =$FFA8 ;SEND CHAR TO SERIALUNLSN =$FFAE ;SEND UNLISTENTALK  =$FFB4 ;SEND TALKTKSA  =$FF96 ;SEND TALK SECONDACPTR =$FFA5 ;GET CHAR FROM BUSUNTLK =$FFAB ;SEND UNTALKSTOP  =$FFE1 ;CHECK STOP KEYGETIN =$FFE4 ;GET KEYLOAD  =$FFD5 ;LOAD PRGSETMSG=$FF90 ;KERNAL MESSAGES;*********************************; ENTRY POINT;*********************************DOSWDG JMP START ;JMP PAST DATA;*********************************; SYMBOL VECTORS (HIGH BYTE);*********************************HIHVEC .BYTE >VECTR1 ;%.BYTE >VECTR2 ;/.BYTE >VECTR3 ;TOKENED /.BYTE >VECTR4 ;^.BYTE >VECTR5 ;TOKENED ^.BYTE >VECTR6 ;_.BYTE >VECTR7 ;>.BYTE >VECTR8 ;TOKENED >.BYTE >VECTR9 ;@.BYTE >VECTRA ;#.BYTE >VECTRB ;Q;*********************************; SYMBOL VECTORS (LOW BYTE);*********************************LOWVEC .BYTE <VECTR1 ;%.BYTE <VECTR2 ;/.BYTE <VECTR3 ;TOKENED /.BYTE <VECTR4 ;^.BYTE <VECTR5 ;TOKENED ^.BYTE <VECTR6 ;_.BYTE <VECTR7 ;>.BYTE <VECTR8 ;TOKENED >.BYTE <VECTR9 ;@.BYTE <VECTRA ;#.BYTE <VECTRB ;Q;*********************************; COMMAND SYMBOL TABLE;*********************************SYMBOL .BYTE '%' ;MACHINE LOAD.BYTE '/' ;BASIC LOAD.BYTE $AD ;/ (COM Z).BYTE '^' ;BASIC LOAD/RUN.BYTE $AE ;^ (COM S).BYTE '_' ;BASIC SAVE.BYTE '>' ;TOKENED MAIN.BYTE $B1 ;> (COM E)SYMBOC .BYTE '@' ;MAIN COMMAND.BYTE '#' ;FOR DEVICE #.BYTE 'Q' ;QUIT DOS;*********************************.BYTE $00 ;END OF TABLE.BYTE $AA ;FOR EXPANSION.BYTE $AA ;FOR EXPANSION;*********************************; 80 CHARACTER TEXT BUFFER;*********************************BUFFER .BYTE $AA,$AA,$AA.BYTE $AA,$AA,$AA,$AA,$AA,$AA,$AA.BYTE $AA,$AA,$AA,$AA,$AA,$AA,$AA.BYTE $AA,$AA,$AA,$AA,$AA,$AA,$AA.BYTE $AA,$AA,$AA,$AA,$AA,$AA,$AA.BYTE $AA,$AA,$AA,$AA,$AA,$AA,$AA.BYTE $AA,$AA,$AA,$AA,$AA,$AA,$AA.BYTE $AA,$AA,$AA,$AA,$AA,$AA,$AA.BYTE $AA,$AA,$AA,$AA,$AA,$AA,$AA.BYTE $AA,$AA,$AA,$AA,$AA,$AA,$AA.BYTE $AA,$AA,$AA,$AA,$AA,$AA,$AA.BYTE $AA,$AA,$AA,$AA,$AA,$AA,$AA;*********************************; DEVICE NUMBER;*********************************DEVICE .BYTE $AA;*********************************; FILENAME SUFIX;*********************************SUFFIX .WORD $AAAA;*********************************; CURRENT SYMBOL;*********************************CURSYM .BYTE $AA;*********************************; DOS MANAGER MESSAGE;*********************************MANAGE .BYTE $0D,$0D.TEXT '      DOS MANAGER '.TEXT 'V5.1/071382',$0D,$0D.TEXT '         BY  BOB FAIRBAIRN'.BYTE $0D,$0D.TEXT '(C) 1982 COMMODORE BUSINESS '.TEXT 'MACHINES',$0D,$00;*********************************; WEDGE CHRGET PATCH;*********************************PATCH JMP WEDGE;*********************************; WEDGE ACTIVATION ROUTINE;; PATCH INTO CHRGET IN ZEROPAGE,; DEFINE USER'S CURRENT DEVICE; NUMBER, AND PRINT COPYRIGHT;;*********************************START LDX #$02 ;SET COUNTERS1 LDA PATCH,X ;GET WEDGE STA POINTB,X  ;STORE WEDGE DEX           ;COUNT-1 BPL S1        ;LOOP 3 TIMES; LDA FA        ;STORE CURRENT STA DEVICE    ;DEVICE NUMBER JMP PRMESS    ;PRINT MESSAGE;*********************************; NORMAL ENTRY POINT;; SAVE CHARACTER FROM CHRGET,; THEN CHECK CALLING ADDRESS ON; TOP OF STACK FOR VALID DOS CALL;; VALID CALLING ADDRESSES ARE:;; DIRECT  MODE:$A48C+1=$A48D; PROGRAM MODE:$A7E6+1=$A7E7;;*********************************WEDGE STA SAVA ;SAVE CHARACTER STX SAVX      ;SAVE X TSX           ;PUT SP INTO X; LDA STACK+1,X ;CALLING LSB CMP #$E6      ;LOW ADDRESS BEQ W1        ; CMP #$8C      ;LOW ADDRESS BNE COMMON    ;EXIT WEDGE;W1 LDA STACK+2,X ;CALLING MSB CMP #$A7      ; BEQ FIND      ; CMP #$A4      ; BNE COMMON    ;EXIT WEDGE;*********************************; CHECK COMMAND AGAINST TABLE;*********************************FIND LDA SAVA   ;GET CHARACTER LDX #NUMCMD    ;NUMBER OF COMANDS;F1 CMP SYMBOL,X ;CHECK COMMAND BEQ FOUND      ;MATCH? DEX            ;COUNT-1 BPL F1         ;CHECK ALL COMANDS;*********************************; MIMIC CHRGET TEST;*********************************COMMON LDA SAVA ;GET CHARACTER LDX SAVX       ;RESTORE X INDEX CMP #':'       ;CHRGET TEST BCS NOTCOL     ;IF => EXIT; JMP SPCCHK     ;CHECK SPACE;NOTCOL JMP CHREXT ;CHRGET RTS;*********************************; GOT WEDGE COMMAND;*********************************FOUND STX OFFSET ;SAVE X STA CURSYM      ;GET SYMBOL JSR PROCES      ;PROCESS IT;*********************************; SET-UP CURRENT FILENAME AND DEV;; SET FILENAME ADDRESS POINTER; TO THE DOS BUFFER, AND SET THE; DEVICE ADDRESS TO THE DOS DEVICE;;********************************* LDX OFFSET   ;SETUP X LDA #<BUFFER ;LOW BUFFER STA FNADR    ;FILENAME LDA #>BUFFER ;HIGH BUFFER STA FNADR+1  ;FILENAME LDA DEVICE   ;GET DEVICE STA FA       ;SET IT;*********************************; RTS TO ROUTINE WITH STACK TRICK;; PUSH THE COMMAND VECTOR ONTO; THE STACK HIGH BYTE THEN LOW; BYTE. THIS VECTOR IS THE ADDRESS; MINUS ONE. THE RTS POPS THE; ADDRESS AS IF IT WERE A RETURN; ADDRESS AND ADDS ONE TO IT.; THEN X INDEX CONTAINS THE OFFSET; TO THE COMMAND FROM ABOVE.;;*********************************XECUTE LDA HIHVEC,X ;GET HIGH VEC PHA                ;PUSH IT LDA LOWVEC,X       ;GET LOW VEC PHA                ;PUSH RTS                ;STACK JMP;*********************************; DOS WEDGE MAIN COMMAND ROUTINE;; EXECUTE @ COMMANDS;; THIS ROUTINE EXECUTES COMMANDS; WHICH ARE PRECEEDED WITH THE; COMMAND SYMBOL ("@" OR ">");; THESE COMMANDS INCLUDE:;;  @          DISK DRIVE STATUS;  @$         READ DISK DIRECTORY;  @#DEVICE   CHANGE DOS DEVICE;  @<COMMAND> ANY 1541 DOS COMMAND;  @Q         TERMINATE WEDGE;;*********************************COMMD TYA      ;SAVE COMMAND BEQ ERROR     ;IF NULL STATUS; LDX #NUMCMD+1 ;OFFSET TO COMANDSCHKSUB LDA SYMBOL,X ;GET A SYMBOL BEQ DISKCD    ;END OF TABLE? CMP BUFFER    ;CHECK COMMAND BEQ SUBCOM    ;SUB COMAND?; INX           ;NEXT COMANND BPL CHKSUB    ;CHECK ALL;DISKCD LDA BUFFER ;GET COMMAND CMP #'$'      ;DIRECTORY? BEQ DIRECT    ;IF SO BRANCH; JMP SENDCD    ;SEND COMMAND;*********************************; SUB COMMAND;; SET FILENAME ADDRESS POINTER; TO THE DOS SUB-BUFFER, AND; DECREASE THE FILENAME LENGHT BY; ONE TO ACCOUNT FOR THE "@";;*********************************SUBCOM DEC FNLEN ;DEC NAME LEN LDA #<SUBBUF    ;SUB BUFFER STA FNADR       ;FILENAME LDA #>SUBBUF    ;SUB BUFFER STA FNADR+1     ;FILENAME JMP XECUTE      ;GO DO IT;*********************************; SEND COMMAND STRING TO DISK;; COMMAND THE DEVICE TO LISTEN; USING THE COMMAND CHANNEL (15),; DUMP CHARCTERS IN DOS BUFFER; AND THEN UNLISTEN DEVICE;;*********************************SENDCD LDA FA ;GET DEVICE JSR LISTEN   ;GET IT TO LISTEN LDA #$0F+$60 ;SEC ORED WITH $60 STA SA       ;SET SECONDARY ADRS JSR SECOND   ;SEND TO DEVICE; LDY #$00     ;INDEX COUNTERSEND LDA BUFFER,Y ;GET CHARACTER JSR CIOUT    ;SEND TO DEVICE INY          ;COUNT+1 CPY FNLEN    ;ALL CHARACTERS? BCC SEND     ;SEND ALL OF THEM; JSR UNLSN    ;UNLISTEN DEVICE JMP EEXIT    ;EXIT TO CHRGOT;*********************************; READ DISK ERROR STATUS (@);; COMMAND DEVICE TO TALK, USING; THE COMMAND CHANNEL (15),; INPUT BYTES FROM SERIAL BUS; AND PRINT THEM TO THE SCREEN; UNTILL A CARRIDGE RETURN IS; RECEIVED THEN UNTALK DEVICE;;*********************************ERROR LDA FA     ;GET DEVICE JSR TALK        ;TALK DEVICE LDA #$0F+$60    ;SEC+$60 STA SA          ;PLACE SEC JSR TKSA        ;SEND SEC;ERR1 JSR ACPTR   ;GET BYTE CMP #$0D        ;IS IF CR? BEQ ERR2        ;IF SO DONE JSR PRT         ;PRINT CHAR JMP ERR1        ;NEXT BYTE;ERR2 JSR PRT     ;PRINT CR JSR UNTLK       ;UNTALK DEVICEEEXIT JMP CHRGOT ;RETURN;*********************************; LIST DIRECTORY (@$);; COMMAND DEVICE TO TALK, USING; THE LOAD FILE CHANNEL (0),; INPUT BYTES FROM SERIAL BUS; AND PRINT THEM TO THE SCREEN; UNTILL END OF FILE STATUS IS; RECEIVED THEN UNTALK DEVICE.;; THE LISTING OF THE DIRECTORY; TO THE SCREEN MAY BE SUSPENDED; BY PRESSING THE SPACE BAR.; TO RESUME PRESS ANY KEY.; THE LIST MAY BE ABORTED BY; PRESSING THE STOP KEY.;;*********************************DIRECT LDA #$00+$60 ;SEC+$60 STA SA     ;PLACE IT JSR SROPEN ;OPEN DIRECTORY FILE LDA FA     ;GET DEVICE JSR TALK   ;TALK DEVICE LDA SA     ;GET SECONDARY ADDRESS JSR TKSA   ;SEND SECOND LDA #$00   ;ZERO BYTE STA STATUS ;RESET STATUS; LDY #$03   ;SKIP PAST LINK BYTESNEXTLN STY FNLEN  ;SAVE THE COUNT JSR ACPTR  ;INPUT SERIAL BYTE STA TEMP   ;STORE JSR ACPTR  ;INPUT SERIAL BYTE STA TEMP+1 ;STORE LDY STATUS ;CHECK STATUS BNE DIROFF ;QUIT IF <>0; LDY FNLEN  ;GET COUNT DEY        ;COUNT-1 BNE NEXTLN ;SKIP LINKS,GET BLOCKS; LDX TEMP   ;GET BLOCK FREE LDA TEMP+1 ;GET BLOCK FREE JSR LINPRT ;PRINT IT IN DECIMAL; LDA #' '   ;ASCII SPACE JSR PRT    ;PRINT IT;BODY JSR ACPTR  ;GET SERIAL BYTE LDX STATUS ;CHECK STATUS BNE DIROFF ;QUIT IF <>0 CMP #$00   ;WAS BYTE A NULL BEQ FINLIN ;0=END OF LINE; JSR PRT    ;PRINT CHAR; JSR STOP   ;CHECK STOP BEQ DIROFF ;ABORT ON STOP; JSR GETIN  ;GET KEY PRESS BEQ BODY   ;IF NONE CONT; CMP #' '   ;IS IT THE SPACE BNE BODY   ;IF NOT CONT;PAUSE JSR GETIN ;CHECK KEY PRESS BEQ PAUSE  ;IF NONE PAUSE BNE BODY   ;ON KEYPRESS CONTINUE;FINLIN LDA #$0D ;CR AT LINE END JSR PRT        ;PRINT IT LDY #$02       ;COUNT FOR SKIP JMP NEXTLN     ;NEXT LINE;DIROFF JSR XCLOSE ;CLOSE DIR FILE LDA #$0D         ;CR JSR PRT          ;PRINT IT JMP CHRGOT       ;RETURN;*********************************; EXECUTE LOAD (/, % AND ^);; LOAD COMMANDS ARE AS FOLLOWS:;; /FILENAME  RELOCATABLE LOAD INTO;            BASIC TEXT AREA; ^FILENAME  RELOCATABLE LOAD AND;            RUN INTO BASIC AREA; %FILENAME  ABSOLUTE LOAD USING;            SAVED ADDRESS IN FILE;;*********************************LOADER LDX TXTTAB ;GET START OF LDY TXTTAB+1     ;BASIC TEXT; LDA CURSYM ;WHICH TYPE OF LOAD CMP #'%'   ;ABS LOAD BNE RELOAD ;IF NOT REL; LDA #$01   ;1=ABSOLUTE LOAD;.BYTE $2C   ;SKIP NEXT INSTRUCTION;RELOAD LDA #$00 ;0=RELOCATABLE; STA SA      ;SECONDARY ADDRESS LDA #$00    ;0=LOAD JSR LOAD    ;LOAD DISK FILE BCS LERR3   ;LOAD ERROR?; LDA CURSYM  ;WHICH TYPE OF LOAD? CMP #'%'    ;ABSOLUTE LOAD? BEQ LERR1   ;IF SO DONE; LDA EAL+1    ;END OF LOAD+1 STA VARTAB+1 ;SET START OF VAR'S LDA EAL      ;END OF LOAD+1 STA VARTAB   ;START OF VARIABLES; JSR RUNC     ;SETUP BASIC JSR LNKPRG   ;LNKPRG LINES; LDA CURSYM   ;WHICH TYPE OF LOAD? CMP #$AD     ;TOKENED "/" BEQ LERR1    ;IF SO DONE; CMP #'/'     ;DIRECT LOAD BNE LERR2    ;RUN PRG;LERR1 JMP BASSFT ;WARM BASIC;LERR2 LDA #$00 ;ZERO BYTE JSR SETMSG    ;NO KERNAL MESSAGES JSR STXPT     ;SET TXTPTR FOR RUN JMP NEWSTT    ;RUN PROGRAM;LERR3 JMP BASSFT ;WARM BASIC;*********************************; DISABLE WEDGE (@Q);; REMOVE WEDGE FROM CHRGET BY; COPYING OVER THREE BYTE PATCH; WITH CORRECT BYTES FROM ROM;;*********************************QUITER LDX #$02  ;SET COUNTERROM LDA CHRCPY,X ;GET ROM BYTE STA POINTB,X    ;PUT IN CHRGET DEX             ;COUNT-1 BPL ROM         ;MOVE 3 BYTES; JMP BASSFT      ;BACK TO BASIC;*********************************; EXECUTE RELOCATABLE SAVE (_);; THE CURRENT PROGRAM IS THE BASIC; TEXT AREA IS SAVED DISK WITH; USER GIVEN FILENAME. THE FILE; WILL BE A PRG (PROGRAM) TYPE.; THE SAVE COMMAND HAS THE FORM:;; _FILENAME;; THE DRIVE STATUS IS RETURNED; FOLLOWING THE SAVE;;*********************************SAVER JSR SAVET ;CALL SAVE JMP ERROR      ;DISPLAY STATUS;*********************************; SET DEVICE NUMBER (@#N);; RESET CURRENT DEVICE NUMBER; TO THAT ENTERED BY USER; VALID DISK DEVICE NUMBERS ARE:;       8,9,10 AND 11; VALIDITY OF NUMBER NOT VERIFIED;;*********************************NUMBER LDY FNLEN ;LENGHT OF COMAND LDA BUFFER,Y    ;GET 1'S DIGIT AND #$0F        ;MASK HIGH NIBBLE STA DEVICE      ;SET DEVICE NUM DEY             ;NUM CHARS-1 BEQ NEXIT       ;IF NO MORE EXIT; LDA BUFFER,Y    ;GET 10'S DIGIT AND #$0F        ;MASK HIGH NIBBLE TAY             ;USE AS COUNTER BEQ NEXIT       ;IF ITS ZERO EXIT; LDA DEVICE      ;GET DEVICE NUM CLC             ;CLEAR CARRYNUM1 ADC #$0A    ;ADD 10 DEY             ;COUNT-1 BNE NUM1        ;ADD ANOTHER 10?; STA DEVICE      ;RESET DEVICE NUM;NEXIT JMP CHRGOT ;EXIT;*********************************; PROCESS COMMAND INTO DOS BUFFER;; ONCE A VALID DOS WEDGE COMMAND; IS ENTER, PROCESS THE COMMAND; INTO THE DOS BUFFER, CHECKING; SYNTAX AND NUMBER OF CHARACTERS;;*********************************PROCES LDY #$00 ;COUNT=0 JSR CHRGET     ;GET NEXT CHAR TAX            ;SAVE IN X REG BNE DISBLK     ;NULL MARKS END JMP FIXBLK     ;GO AND EXIT;DISBLK LDA #$60 ;RTS INSTRUCTION STA POINTB     ;DISABLE WEDGE LDA TXTPTR     ;GET POINTER PHA            ;SAVE ON STACK LDA TXTPTR+1   ;GET POINTER PHA            ;SAVE ON STACK TXA            ;RETREIVE CHAR;QUOTE1 CMP #'"' ;CHECK FOR QUOTE BEQ NEXCHR     ;PROCESS FILENAME; JSR CHRGET   ;GET NEXT CHAR BNE QUOTE1   ;LOOK FOR NEXT QUOTE; PLA          ;PULL POINTER STA TXTPTR+1 ;RESTORE IT PLA          ;PULL POINTER STA TXTPTR   ;RESTORE IT; JSR CHRGOT   ;GET LAST CHAR LDX #$00     ;ZERO INDEX CMP #'"'     ;IS IT THE QUOTE BEQ NEX      ;CHECK END OF INPUT; LDX #$02     ;HIGH BYTE OF $02XX CPX TXTPTR+1 ;IN DIRECT MODE? BNE PROERR   ;IF NOT ERROR; LDX #$00     ;ZERO INDEX BEQ QUOTE2   ;PROCESS FURTHER;NEXCHR PLA    ;TRASH POINTER PLA          ;TRASH POINTER LDX #$00     ;ZERO INDEX;NEX JSR CHRGET ;GET NEXT CHAR BEQ FIXBLK    ;IF END  EXIT;QUOTE2 CMP #'"' ;ANOTHER QUOTE? BEQ FIXBLK     ;IF SO, END; CMP #'='  ;EQUALS?       BEQ BRKT1 ;IF SO BRANCH; CMP #':'  ;COLON? BNE BRKT2 ;IF NOT BRANCH;BRKT1 LDX #$FF ;SET INDEXBRKT2 CMP #'[' ;LEFT BRACKET? BEQ NEX2      ;IF SO NEXT CHAR;PBUFF STA BUFFER,Y ;RETREIVE CHAR STA SUFFIX+1      ;PUT IN SUFFIX INX               ;INDEX+1 INY               ;COUNT+1 BPL NEX           ;BRANCH ALWALYS;NEX2 JSR CHRGET ;GET NEXT CHAR BEQ PROERR     ;IF NULL ERROR; STA SUFFIX ;STASH IN SUFFIX JSR CHRGET ;GET NEXT CHAR BEQ PROERR ;IF NULL ERROR; CMP #']'   ;RIGHT BRACKET? BNE PROERR ;IF NOT ERROR; CPX #$10     ;MAXIMUM FILE NAME BCS PROERR   ;IF LONGER, ERROR; LDA SUFFIX+1 ;GET SUFFIX CMP #'*'     ;WILD CARD? BNE SP1      ;IF NOT STORE SPACE; DEY        ;COUNT-1 DEX        ;INDEX-1 LDA #'?'   ;WILD CARD SYMBOL;.BYTE $2C   ;SKIP NEXT INSTRUCTION;SP1 LDA #' ' ;ASCII SPACE;SP2 CPX #$0F ;15 CHARACTERS; BCS PRO2    ;IF MORE CHECK SUFFIX; STA BUFFER,Y ;BUFFER CHARACTER INY          ;COUNT+1 INX          ;INDEX+1 BPL SP2      ;BRANCH ALWAYS;PRO2 LDA SUFFIX ;GET SUFFIX BNE PBUFF      ;IF NOT NULL OK;PROERR LDX #$4C ;JMP INSTRUCTION STX POINTB     ;RESTORE WEDGE JMP SYNERR     ;SYNTAX ERROR;FIXBLK STY FNLEN ;COUNT IS LENGTH LDX #$4C        ;JMP INSTRUCTION STX POINTB      ;RESTORE WEDGE JSR CHRGOT      ;GET LAST CHAR BEQ PREXIT      ;IF NULL EXIT;NEX3 JSR CHRGET  ;CLEAR OUT REST BNE NEX3        ;MORE, GET THEM;PREXIT RTS       ;RETURN;*********************************; PRINT DOS MANAGER MESSAGE;; PRINT DOS TITLE, VERSION, AUTHOR; AND COPYRIGHT NOTICE. THEN RTS; BACK TO BASIC FROM SYS(52224);;*********************************PRMESS LDX #$00  ;MANAGE OFFSET;PRM LDA MANAGE,X ;GET CHARACTER BEQ PEXIT       ;QUIT ON NULL JSR PRT         ;PRINT IT INX             ;OFFSET+1 BNE PRM         ;NEXT CHARACTER;PEXIT RTS        ;FROM SYS CALL;*********************************; DOS COMMAND VECTORS;; THESE EQUATES ARE USED IN THE; SPLIT LOW/HIGH BYTE VECTOR; USED BY THE EXECUTE COMMAND; ROUTINE. DEFINING TABLE IN THIS; IS NECESSARY DUE TO NATURE; OF CBM ASSEMBLER64 CONVENTIONS; NOTE THE VECTORS ARE COMMAND; ADDRESSES MINUS ONE.;;*********************************VECTR1= LOADER-1 ;%VECTR2= LOADER-1 ;/VECTR3= LOADER-1 ;TOKENED /VECTR4= LOADER-1 ;^VECTR5= LOADER-1 ;TOKENED ^VECTR6= SAVER-1  ;_VECTR7= COMMD-1  ;>VECTR8= COMMD-1  ;TOKENED >VECTR9= COMMD-1  ;@VECTRA= NUMBER-1 ;@#VECTRB= QUITER-1 ;@Q;*********************************; NUMBER OF PRIMARY COMMANDS;*********************************NUMCMD=SYMBOC-SYMBOL;*********************************; SUB-BUFFER;*********************************SUBBUF=BUFFER+1;*********************************.END