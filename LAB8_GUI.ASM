TITLE STRMENU (EXE)
 .MODEL SMALL
 .STACK 64
 .DATA
;-------------------------------------------------------------------------
TOPROW EQU 08 ;Верхній рядок меню
BOTROW EQU 12 ;Нижній рядок меню
BOTROWSYNTH     EQU    15
LEFCOL EQU 26 ;Лівий стовпчик меню
ATTRIB DB ? ; Атрибути екрану
ROW DB 00 ;Рядок екрану
SHADOW DB 19 DUP(0DBH);
MENU DB 0C9H, 17 DUP(0CDH), 0BBH
 DB 0BAH, ' Print report    ',0BAH
 DB 0BAH, ' Synthesizer     ',0BAH
 DB 0BAH, ' Play music      ',0BAH
 DB 0C8H, 19 DUP(0CDH), 0BCH
PROMPT DB 'To select an item, use <Up/Down Arrow>'
 DB ' and press <Enter>.'
 DB 13, 10, 'Press <Esc> to exit.'

 REPORT DB 13, 10, '8th lab Vaskevych, Snizhok', 10, 13, '$'

 SHADOWSYNTH     DB     29 DUP(0FFH);
 SYNTHESIZER     DB     0DAh, 0C4h, 0C2h, 0C4h, 0C4h, 0C4h, 0C2h, 0C4h, 0C4h, 0C4h, 0C2h, 0C4h, 0C2h, 0C4h, 0C2h, 0C4h, 0C4h, 0C4h, 0C2h, 0C4h, 0C4h, 0C4h, 0C2h, 0C4h, 0C4h, 0C4h, 0C2h, 0C4h, 0BFh
            DB     0B3h,  ' ', 0B3h,  ' ',  ' ',  ' ', 0B3h,  ' ',  ' ',  ' ', 0B3h,  ' ', 0B3h,  ' ', 0B3h,  ' ',  ' ',  ' ', 0B3h,  ' ',  ' ',  ' ', 0B3h,  ' ',  ' ',  ' ', 0B3h,  ' ', 0B3h
            DB     0B3h,  ' ', 0B3h,  ' ',  ' ',  ' ', 0B3h,  ' ',  ' ',  ' ', 0B3h,  ' ', 0B3h,  ' ', 0B3h,  ' ',  ' ',  ' ', 0B3h,  ' ',  ' ',  ' ', 0B3h,  ' ',  ' ',  ' ', 0B3h,  ' ', 0B3h
            DB     0B3h,  ' ', 0B3h,  ' ', 057h,  ' ', 0B3h,  ' ', 045h,  ' ', 0B3h,  ' ', 0B3h,  ' ', 0B3h,  ' ', 054h,  ' ', 0B3h,  ' ', 059h,  ' ', 0B3h,  ' ', 055h,  ' ', 0B3h,  ' ', 0B3h
            DB     0B3h,  ' ', 0C0h, 0C4h, 0C2h, 0C4h, 0C1h, 0C4h, 0C2h, 0C4h, 0D9h,  ' ', 0B3h,  ' ', 0C0h, 0C4h, 0C2h, 0C4h, 0C1h, 0C4h, 0C2h, 0C4h, 0C1h, 0C4h, 0C2h, 0C4h, 0D9h,  ' ', 0B3h
            DB     0B3h,  ' ',  ' ',  ' ', 0B3h,  ' ',  ' ',  ' ', 0B3h,  ' ',  ' ',  ' ', 0B3h,  ' ',  ' ',  ' ', 0B3h,  ' ',  ' ',  ' ', 0B3h,  ' ',  ' ',  ' ', 0B3h,  ' ',  ' ',  ' ', 0B3h
            DB     0B3h,  ' ', 041h,  ' ', 0B3h,  ' ', 053h,  ' ', 0B3h,  ' ', 044h,  ' ', 0B3h,  ' ', 046h,  ' ', 0B3h,  ' ', 047h,  ' ', 0B3h,  ' ', 048h,  ' ', 0B3h,  ' ', 04Ah,  ' ', 0B3h
            DB     0C0h, 0C4h, 0C4h, 0C4h, 0C1h, 0C4h, 0C4h, 0C4h, 0C1h, 0C4h, 0C4h, 0C4h, 0C1h, 0C4h, 0C4h, 0C4h, 0C1h, 0C4h, 0C4h, 0C4h, 0C1h, 0C4h, 0C4h, 0C4h, 0C1h, 0C4h, 0C4h, 0C4h, 0D9h

 ;------Константи для функції звуку
 NUMBER_CYCLES EQU 2000
 FREQUENCY EQU 600
 PORT_B EQU 61H
 COMMAND_REG EQU 43H
 CHANNEL_2 EQU 42H
 SYNTHPROMPT DB     'To play sound press assigned key.'
             DB     13, 10, 'Press <Esc> to return to menu.'
.386 ;-------------------------------------------------------------------
 .CODE

DELAY MACRO time ;delay in ms
  local outer
  push cx
  mov cx, time
  outer:
   push cx
   mov cx, 01999h
   loop $
   pop cx
  loop outer
  pop cx
 ENDM

A10MAIN PROC FAR
 MOV AX,@data
 MOV DS,AX
 MOV ES,AX
A10:
 CALL Q10CLEAR ; Очистка екрану
 MOV ROW,BOTROW+4
A20:
 CALL B10MENU ;Вивід меню
 MOV ROW,TOPROW+1 ;Вибір верхнього пункту меню
 ; у якості початкового значення
 MOV ATTRIB,16H ;Переключення зображення в інв..
 CALL D10DISPLY ;Відображення
 CALL C10INPUT ;Вибір з меню
 JMP A20 ;
A10MAIN ENDP
;-------------------------------------------------------------------------
; Вивід рамки, меню і запрошення…
;-------------------------------------------------------------------------
B10MENU PROC NEAR
 PUSHA ;
 MOV AX,1301H ;
 MOV BX,0060H ;
 LEA BP,SHADOW ;
 MOV CX,19 ;
 MOV DH,TOPROW+1 ;
 MOV DL,LEFCOL+1 ;
B20: INT 10H
 ;;;;;
 INC DH ;Наступний рядок
 CMP DH,BOTROW+2 ;
 JNE B20 ;
 MOV ATTRIB,71H ;
 MOV AX,1300H ;
 MOVZX BX,ATTRIB ;
 LEA BP,MENU ;
 MOV CX,19
 MOV DH,TOPROW ;Рядок
 MOV DL,LEFCOL ;Стовпчик
B30:
 INT 10H
 ADD BP,19 ;
 INC DH ;
 CMP DH,BOTROW+1 ;
 JNE B30 ;
 MOV AX,1301H ;
 MOVZX BX,ATTRIB ;
 LEA BP,PROMPT ;
 MOV CX,79 ;
 MOV DH,BOTROW+4 ;
 MOV DL,00 ;
 INT 10H
 POPA ;‚
 RET
B10MENU ENDP
;-------------------------------------------------------------------------
; Натискування клавиш, управління через клавиші і ENTER
; для вибору пункту меню і клавіші ESC для виходу
;-------------------------------------------------------------------------
C10INPUT PROC NEAR
 PUSHA
C20:
 MOV AH,10H ;Запитати один символ з кл.
 INT 16H ;
 CMP AH,50H ;Стрілка до низу
 JE C30
 CMP AH,48H ;Стрілка до гори ?
 JE C40
 CMP AL,0DH ;Натистнено ENTER?
 JE C90
 CMP AL,1BH ;Натиснено ESCAPE?
 JE C80 ; Вихід
 JMP C20 ;Жодна не натиснена, повторення
C30:
 MOV ATTRIB,71H ;Колiр символів
 CALL D10DISPLY ;
 INC ROW ;
 CMP ROW,BOTROW-1 ;
 JBE C50 ;
 MOV ROW,TOPROW+1 ;
 JMP C50
C40:
 MOV ATTRIB,71H ;Кольор символів і екрану
 CALL D10DISPLY ;
 ;
 DEC ROW
 CMP ROW,TOPROW+1 ;
 JAE C50 ;
 MOV ROW,BOTROW-1 ;
C50:
 MOV ATTRIB,17H ;Кольор символів
 CALL D10DISPLY ;
 JMP C20
C80:
 CALL CLS
 MOV AX,4C00H
 INT 21H
C90:
 CMP ROW, TOPROW+1
 JE C100
 CMP ROW, TOPROW+3
 JE C110
 CMP ROW, TOPROW+2
 JE C120
C100:
 CALL PrintReport
 JMP C999
C110:
 CALL PlayMusic
 JMP C999
C120:
  CALL SynthFunc
  JMP C999
C999:
 POPA
 RET
C10INPUT ENDP
;-------------------------------------------------------------------------
; Забарвлення виділеного рядка
;-------------------------------------------------------------------------
D10DISPLY PROC NEAR
 PUSHA
 MOVZX AX,ROW
 SUB AX,TOPROW
 IMUL AX,19
 LEA SI,MENU+1
 ADD SI,AX
 MOV AX,1300H
 MOVZX BX,ATTRIB
 MOV BP,SI
 MOV CX,17
 MOV DH,ROW
 MOV DL,LEFCOL+1
 INT 10H
 POPA
 RET
D10DISPLY ENDP
;------------------------------------------------------------------------
; Очищення екрану
;------------------------------------------------------------------------
Q10CLEAR PROC NEAR
 PUSHA
 MOV AX,0600H
 MOV BH,61H
 MOV CX,00
 MOV DX,184FH
 INT 10H
 POPA
 RET
Q10CLEAR ENDP

PrintReport PROC
 mov ah, 09H
 mov dx, offset REPORT
 int 21H
 RET
ENDP PrintReport

CLS PROC
 pusha
 mov ah, 00h
 mov al, 03h  ; text mode 80x25 16 colours
 int 10h
 popa
 ret
ENDP CLS

playSound PROC
 ;----input----
 ;dx = note
 ;bx = delay, ms

 ;----------Встановлення частоти 440 гц--------------
     ;--- дозвіл каналу 2 встановлення порту  В мікросхеми 8255
   IN   AL,PORT_B     ;Читання
   OR   AL,3	         ;Встановлення двох молодших бітів
   OUT  PORT_B,AL     ;пересилка байта в порт B мікросхеми 8255

     ;--- встановлення регістрів порту вводу-виводу
   MOV  AL,10110110B	 ;біти для каналу 2
   OUT  COMMAND_REG,AL  ;байт в порт командний регістр

     ;--- встановлення лічильника



   MOV  AX, dx	     ;лічильник = 1190000/440
   OUT  CHANNEL_2,AL    ;відправка AL
   MOV  AL,AH	     ;відправка старшого байту в AL
   OUT  CHANNEL_2,AL    ;відправка старшого байту

     ;--- виклик преривання з клавіатури для зупинки
   delay bx
     ;--- виключення звуку
   IN   AL,PORT_B     ;отримуємо байт з порту В
   AND  AL,11111100B  ;скидання двох молодших бітів
   OUT  PORT_B,AL     ;пересилка байтів в зворотному напрямку

     ret
ENDP playSound

PlayMusic PROC
 mov cx, 5

 ;3-------------
 mov dx, 2705
 mov bx, 0256
 call playSound
 delay cx

 mov dx, 3036
 mov bx, 0103
 call playSound
 delay cx

 mov dx, 2705
 mov bx, 0716
 call playSound
 delay cx

 mov dx, 2705
 mov bx, 0103
 call playSound
 delay cx

 mov dx, 2705
 mov bx, 0103
 call playSound
 delay cx

 mov dx, 2705
 mov bx, 0103
 call playSound
 delay cx

 mov dx, 2705
 mov bx, 0103
 call playSound
 delay cx
 ;4-------------
 mov dx, 2705
 mov bx, 0180
 call playSound
 delay cx

 mov dx, 3606
 mov bx, 0065
 call playSound
 delay cx

 mov dx, 3606
 mov bx, 0065
 call playSound
 delay cx

 mov dx, 3606
 mov bx, 0180
 call playSound
 delay cx

 mov dx, 3606
 mov bx, 0065
 call playSound
 delay cx

 mov dx, 3606
 mov bx, 0065
 call playSound
 delay cx

 mov dx, 3606
 mov bx, 0180
 call playSound
 delay cx

 mov dx, 3606
 mov bx, 0065
 call playSound
 delay cx

 mov dx, 3606
 mov bx, 0065
 call playSound
 delay cx

 mov dx, 3606
 mov bx, 0180
 call playSound
 delay cx

 mov dx, 3606
 mov bx, 0180
 call playSound
 delay cx
 ;2-1---------------------
 mov dx, 2705
 mov bx, 0410
 call playSound
 delay cx

 mov dx, 3606
 mov bx, 0640
 call playSound
 delay cx

 mov dx, 2705
 mov bx, 0180
 call playSound
 delay cx

 mov dx, 2705
 mov bx, 0065
 call playSound
 delay cx

 mov dx, 2409
 mov bx, 0065
 call playSound
 delay cx

 mov dx, 2148
 mov bx, 0065
 call playSound
 delay cx

 mov dx, 2027
 mov bx, 0065
 call playSound
 delay cx
 ;2-2---------------------
 mov dx, 1806
 mov bx, 0870
 call playSound
 delay cx

 mov dx, 1806
 mov bx, 0180
 call playSound
 delay cx

 mov dx, 1806
 mov bx, 0103
 call playSound
 delay cx

 mov dx, 1705
 mov bx, 0103
 call playSound
 delay cx

 mov dx, 1518
 mov bx, 0103
 call playSound
 delay cx
 ;2-3---------------------
 mov dx, 1352
 mov bx, 0870
 call playSound
 delay cx

 mov dx, 1352
 mov bx, 0180
 call playSound
 delay cx

 mov dx, 1352
 mov bx, 0103
 call playSound
 delay cx

 mov dx, 1518
 mov bx, 0103
 call playSound
 delay cx

 mov dx, 1705
 mov bx, 0103
 call playSound
 delay cx

 ;2-4---------------------
 mov dx, 1518
 mov bx, 0640
 call playSound
 delay cx

 mov dx, 1705
 mov bx, 0065
 call playSound
 delay cx

 mov dx, 1806
 mov bx, 0870
 call playSound
 delay cx

 mov dx, 1806
 mov bx, 0410
 call playSound
 delay cx
 ;2-5---------------------
 mov dx, 2027
 mov bx, 0180
 call playSound
 delay cx

 mov dx, 2027
 mov bx, 0065
 call playSound
 delay cx

 mov dx, 1806
 mov bx, 0065
 call playSound
 delay cx

 mov dx, 1705
 mov bx, 0870
 call playSound
 delay cx

 mov dx, 1806
 mov bx, 0180
 call playSound
 delay cx

 mov dx, 2027
 mov bx, 0180
 call playSound
 delay cx
 RET
ENDP PlayMusic

SynthFunc    PROC   FAR
           CALL   Q10CLEAR          ; Очистка екрану
           CALL   DrawSynth            ;Вивід меню
           MOV    ATTRIB,16H         ;Переключення зображення в інв..
           CALL   SynthInput           ;Вибір з меню
           RET              ;
SynthFunc    ENDP

DrawSynth    PROC   NEAR
           CALL CLS
           PUSHA                     ;
           MOV    AX,1301H           ;
           MOV    BX,0040H           ;
           LEA    BP,SHADOWSYNTH          ;
           MOV    CX,29            ;
           MOV    DH,TOPROW+1        ;
           MOV    DL,LEFCOL+1        ;
SB20:       INT    10H
     ;;;;;
           INC    DH                 ;Наступний рядок
           CMP    DH,BOTROWSYNTH+2        ;
           JNE    SB20                ;
           MOV    ATTRIB,71H         ;
           MOV    AX,1300H           ;
           MOVZX  BX,ATTRIB          ;
           LEA    BP,SYNTHESIZER            ;
           MOV    CX,29
           MOV    DH,TOPROW          ;Рядок
           MOV    DL,LEFCOL          ;Стовпчик
SB30:
           INT    10H
           ADD    BP,29           ;
           INC    DH                 ;
           CMP    DH,BOTROWSYNTH+1        ;
           JNE    SB30                ;
           MOV    AX,1301H           ;
           MOVZX  BX,ATTRIB          ;
           LEA    BP,SYNTHPROMPT          ;
           MOV    CX,65              ;
           MOV    DH,BOTROWSYNTH+4        ;
           MOV    DL,00              ;
           INT    10H
           POPA                      ;‚
           RET
DrawSynth    ENDP

SynthInput   PROC    NEAR
           PUSHA                  ;
CMAIN:     MOV     AH,10H            ;Запитати один символ з кл.
           INT     16H               ;

           CMP     AH,1Eh
           JE      C1
		       CMP     AH,11H
           JE      C2
           CMP     AH,1FH
           JE      C3
		       CMP     AH,12H
           JE      C4
           CMP     AH,20H
           JE      C5
		       CMP     AH,21H
           JE      C6
           CMP     AH,14H
           JE      C7
		       CMP     AH,22H
           JE      C8
           CMP     AH,15H
           JE      C9
		       CMP     AH,23H
           JE      C10
           CMP     AH,16H
           JE      C11
		       CMP     AH,24H
           JE      C12

           CMP     AL,1BH            ;Натиснено  ESCAPE?
           JE      CEX               ;Вихід
           JMP     CMAIN             ;Жодна не натиснена, повторення

C1:
		   mov dx, 4542
		   mov bx, 0100
		   call playSound
		   jmp CMAIN

C2:
		   mov dx, 4296
		   mov bx, 0100
		   call playSound
		   jmp CMAIN
C3:
		   mov dx, 4048
		   mov bx, 0100
		   call playSound
		   jmp CMAIN
C4:
		   mov dx, 3826
		   mov bx, 0100
		   call playSound
		   jmp CMAIN
C5:
		   mov dx, 3606
		   mov bx, 0100
		   call playSound
		   jmp CMAIN
C6:
		   mov dx, 3410
		   mov bx, 0100
		   call playSound
		   jmp CMAIN
C7:
		   mov dx, 3216
		   mov bx, 0100
		   call playSound
		   jmp CMAIN
C8:
		   mov dx, 3036
		   mov bx, 0100
		   call playSound
		   jmp CMAIN
C9:
		   mov dx, 2867
		   mov bx, 0100
		   call playSound
		   jmp CMAIN
C10:
		   mov dx, 2705
		   mov bx, 0100
		   call playSound
		   jmp CMAIN
C11:
		   mov dx, 2554
		   mov bx, 0100
		   call playSound
		   jmp CMAIN
C12:
		   mov dx, 2409
		   mov bx, 0100
		   call playSound
		   jmp CMAIN
CEX:
       POPA
       JMP A10
       RET
SynthInput    ENDP

 END A10MAIN
