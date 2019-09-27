;------------------------------------------------------------------------------
;ЛР №2
;------------------------------------------------------------------------------
; Програмування 3. Системне програмування
; Завдання:Адресація відеопам'яті
; ВУЗ: КНУУ "КПІ"
; Факультет: ФІОТ
; Курс: 2
; Група: IT-81
;------------------------------------------------------------------------------
; Автор: Vaskevych, Snizhok
; Дата: 27.09.2019
;---------------------------------
IDефіь EAL
MODEL SMALL
STACK 512
;-----------------II.МАКРОСИ---------------------------------------
;2.2 Складний макрос для ініціалізації
MACRO M_Init ; Початок макросу
mov ax, @data ; ax <- @data
mov ds, ax ; ds <- ax
mov es, ax ; es <- ax
ENDM M_Init ; Кінець макросу
;--------------------III.ПОЧАТОК СЕГМЕНТУ ДАНИХ
DATASEG
exCode db 0           ;
kolia db "Vaskevych"  ;\
koliaLen=$-kolia      ; \
maks db "Snizhok"     ;  \
maksLen=$-maks        ;   ініціалізація масивів текстових повідомлень
date db "20/09/2019"  ;  |
dateLen=$-date        ; |
msgExit db "EXIT"     ;|
msgExitLen=$-msgExit  ;
CODESEG
Start:
M_Init
mov AX, 0B800h ; 1. Сегментна адреса відеопам’яті
mov ES, AX ; 2. До ES ; Налаштування SI, DI и СХ для
;------------------Drawing frame--------------------
mov SI, 1518
mov [word ES:SI], 0AC9h
mov CX, 18
call DrawLine
add SI, 2
mov [word ES:SI], 0ABBh
mov CX, 8
call DrawVert
add SI, 122
mov [word ES:SI], 0AC8h
mov CX, 18
call DrawLine
add SI, 2
mov [word ES:SI], 0ABCh
;-----------------------Drawing text---------------------
mov DI, 2010
lea SI, [kolia]
mov CX, koliaLen
cld 					    ; DF – вперед пересилаємо
mov AH, 0Ah 			; Attribute for all
call LoadProc
mov DI, 2170
lea SI, [maks]
mov CX, maksLen
cld
mov AH, 0Ah
call LoadProc
mov DI, 2330
lea SI, [date]
mov CX, dateLen
cld
mov AH, 0Ah
call LoadProc
mov DI, 2662
lea SI, [msgExit]
mov CX, msgExitLen
cld
mov AH, 0Ah
call LoadProc
;-----------------------Drawing small frame------------------
mov si, 2498
mov [word es:si], 0AC9h
mov cx, 8
call DrawLine
add si, 2
mov [word es:si], 0AB9h
mov si, 2658
mov cx, 2
lineSmallV:
  mov [word es:si], 0ABAh
  add si, 160
loop lineSmallV
mov [word es:si], 0ACAh
;---------------------------End of program-----------
mov AH, 01h
int 21h
Exit:
mov ah,4ch
mov al,[exCode]
int 21h
DrawVert:
  vertical:
    add SI, 122
    mov [word ES:SI], 0ABAh
    add SI, 38
    mov [word ES:SI], 0ABAh
  loop vertical
  ret
DrawLine:
  line:
    add SI, 2
    mov [word ES:SI], 0ACDh
  loop line
  ret
LoadProc:
  load:
    lodsb					; Symbol to AL
    stosw 					; Symbol + atrib from AX to videomemory
  loop load
  ret
end Start
