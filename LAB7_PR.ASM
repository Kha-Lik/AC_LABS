;-------------------------------------------------------------------------------
;ЛР №7
;-------------------------------------------------------------------------------
; Програмування 3. Системне програмування
; Завдання:Виклик процедур та управління периферією
; ВУЗ: КНУУ "КПІ"
; Факультет: ФІОТ
; Курс: 2
; Група: IT-81
;-------------------------------------------------------------------------------
; Автор: Vaskevych, Snizhok
; Дата: 11.12.2019
;-------------------------------------------------------------------------------
 IDEAL
 MODEL small
 STACK 256
DATASEG
  string db 254
  str_len db 0
  db 254 dup ('*') ; Буфер заповнюється '*' для кращого налаштування
  ;----- Змінні для виводу системних команд
  system_message_1 DB "Input command and press enter: " ,'$'
  system_message_2 DB "Program end" ,'$'
  ;----- Змінні для виводу команд під час управління програмою
  display_message_0 DB "------------programm for lab 7 is running-----------", 13, 10, '$'
  display_message_1 DB "c - for count", 13, 10, '$'
  display_message_2 DB "m - for music", 13, 10, '$'
  display_message_3 DB "e - for exit", 13, 10, '$'
  display_message_4 DB "------------programm for lab is END-----------------", 13, 10, '$'
  display_message_5 DB "Press any key for beep --------------", 13, 10, '$'
  display_message_6 DB "Press any key -----------------------", 13, 10, '$'
  ;------Константи для функції звуку
  NUMBER_CYCLES EQU 2000
  FREQUENCY EQU 600
  PORT_B EQU 61H
  COMMAND_REG EQU 43H
  CHANNEL_2 EQU 42H
CODESEG

 MACRO DELAY time ;delay in ms
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

 Start:
  mov ax, @data ;
  mov ds, ax
  MainLoop:
  ;----------------------------------------------
  call DisplayMenu
  ;-----------------------------------------------
  mov ah, 0ah
  mov dx, offset string
  int 21h
  xor ax, ax
  mov bx, offset string
  mov ax, [bx+1]
  shr ax, 8
  cmp ax, 63h
  je Count
  cmp ax, 6dh
  je Music
  cmp ax, 65h
  je Exit
  jmp MainLoop
  ;---------------------------------------------------------
  Count:
   mov dx, offset display_message_6
   call OutputMsg
   call Counting
   jmp MainLoop
  ;---------------------------------------------------------
  Music:
   mov dx, offset display_message_5
   call OutputMsg
   call PlayMusic
   jmp MainLoop
  ;---------------------------------------------------------
  Exit:
   mov dx, offset display_message_4
   call OutputMsg
   mov ah,04Ch
   int 21h
  ;------------SUB-1 DisplayMenu------------------
 PROC DisplayMenu
   mov ah, 0
   mov al, 3
   int 10h
   mov dx, offset display_message_0
   call OutputMsg
   mov dx, offset display_message_1
   call OutputMsg
   mov dx, offset display_message_2
   call OutputMsg
   mov dx, offset display_message_3
   call OutputMsg
   mov dx, offset system_message_1
   call OutputMsg
   ret
 ENDP DisplayMenu
  ;-------------SUB-2 OutputMsg---------------------
 PROC OutputMsg
   mov ah,9
   int 21h
   xor dx, dx
   ret
 ENDP OutputMsg
  ;-------------SUB-3 MakeSound---------------------
 PROC  PlaySound
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
   ENDP PlaySound

  PROC Counting
   mov al, -1
   mov ah, 1
   sub al, ah
   mov ah, 1
   mul ah
   mov ah, 2
   mul ah
   mov ah, 3
   mul ah

   cmp al, 0
   jl lNeg
   lPrint:
    xor ah, ah
    aam
    add ax, '00'
    xchg al, ah
    mov  dx, ax
    mov  ah, 02h
    int  21h
    mov  dl, dh
    int  21h
    mov ah, 8h
    int 21h
    ret
   lNeg:
    neg al
    call PrintMinus
    jmp lPrint
  ENDP Counting

  PROC PrintMinus
   push ax
   mov dl, '-'
   mov ah, 02h
   int 21h
   pop ax
   ret
  ENDP PrintMinus

PROC PlayMusic
 mov cx, 5

 mov dx, 2705
 mov bx, 1276
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
;2---------------------
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
;2-6---------------------
mov dx, 2275
mov bx, 0180
call playSound
delay cx

mov dx, 2275
mov bx, 0065
call playSound
delay cx

mov dx, 2027
mov bx, 0065
call playSound
delay cx

mov dx, 1806
mov bx, 0870
call playSound
delay cx

mov dx, 2027
mov bx, 0180
call playSound
delay cx

mov dx, 2275
mov bx, 0180
call playSound
delay cx
;2-7---------------------
mov dx, 2409
mov bx, 0180
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

mov dx, 1913
mov bx, 0870
call playSound
delay cx

mov dx, 1608
mov bx, 0410
call playSound
delay cx
;2-8---------------------
mov dx, 1806
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
;2-9--------------------
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
;2-10--------------------
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
;2-11--------------------
mov dx, 1352
mov bx, 1380
call playSound
delay cx

mov dx, 1137
mov bx, 0406
call playSound
delay cx
;2-12--------------------
mov dx, 1204
mov bx, 0410
call playSound
delay cx

mov dx, 1432
mov bx, 0870
call playSound
delay cx

mov dx, 1806
mov bx, 0410
call playSound
delay cx
;2-13--------------------
mov dx, 1608
mov bx, 1380
call playSound
delay cx

mov dx, 1352
mov bx, 0410
call playSound
delay cx
;2-14--------------------
mov dx, 1432
mov bx, 0410
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
;2-15--------------------
mov dx, 1608
mov bx, 1380
call playSound
delay cx

mov dx, 1352
mov bx, 0410
call playSound
delay cx
;2-16--------------------
mov dx, 1432
mov bx, 0410
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
;2-17--------------------
mov dx, 2027
mov bx, 1380
call playSound
delay cx

mov dx, 1705
mov bx, 0410
call playSound
delay cx
;2-18--------------------
mov dx, 1806
mov bx, 0410
call playSound
delay cx

mov dx, 1275
mov bx, 0870
call playSound
delay cx

mov dx, 2705
mov bx, 0410
call playSound
delay cx
;2-19--------------------
mov dx, 2409
mov bx, 0180
call playSound
delay cx

mov dx, 2409
mov bx, 0065
call playSound
delay cx

mov dx, 2275
mov bx, 0065
call playSound
delay cx

mov dx, 2027
mov bx, 0870
call playSound
delay cx

mov dx, 1705
mov bx, 0410
call playSound
delay cx
;2-20--------------------
mov dx, 1806
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

  ret
ENDP PlayMusic

 END Start
