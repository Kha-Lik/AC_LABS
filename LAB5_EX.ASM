;------------------------------------------------------------------------------
;ЛР №5
;------------------------------------------------------------------------------
; Програмування 3. Системне програмування
; Завдання:Керування ходом виконанням програми
; ВУЗ: КНУУ "КПІ"
; Факультет: ФІОТ
; Курс: 2
; Група: IT-81
;------------------------------------------------------------------------------
; Автор: Vaskevych, Snizhok
; Дата: 23.10.2019
;---------------------------------
;----------------I.ЗАГОЛОВОК ПРОГРАМИ-----------------
IDEAL
MODEL SMALL
STACK 1024
;-----------------II.МАКРОСИ-------------------------
;2.1 Складний макрос для виходу з програми
MACRO M_Exit ; Початок макросу
; На виході:AL = код завершення програми
; На вході:AH = ознака переривання DOS виходу 04Ch
mov ah, 04Ch
int 21h
ENDM M_Exit ; Кінець макросу
;2.2 Складний макрос для ініціалізації
MACRO M_Init ; Початок макросу
mov ax, @data ; ax <- @data
mov ds, ax ; ds <- ax
mov es, ax ; es <- ax
ENDM M_Init ; Кінець макросу
;--------------------III.ПОЧАТОК СЕГМЕНТУ ДАНИХ
DATASEG
  arr_stack db 100h dup (23h)
  numbers db '1','9','0','5','2','0','0','1'
  numLen = $ - numbers
  exCode db 0
CODESEG
jmp Start

;Функція запису в масив рядка з датою
WriteLine:
  mov cx, 8
  lea di, [numbers]
  cycle:
    mov al, [di]
    mov [si], al
    add si, 1
    add di, 1
  loop cycle
  ret
;Процедура сортування бульбашкою однобайтових масивів
BubbleSort:
  xor	cx,	cx
  j2:	mov	cx,	100h
  	  sub	cx,	01h
  c0:	mov	bx,	cx
  	  mov	al,	[arr_stack+bx]   ;заносимо поточний ел-т масиву в al
  	  mov	ah,	[arr_stack+bx-1]
  	  cmp	al,	[arr_stack+bx-1] ;порівнюємо поточний з попереднім
  	  jg	j1 ;якщо поточний більше, то переходимо на j1
  	  loop	c0 ;якщо ні, то if(cx>0) (cx=cx-1, goto c0)
  	  jmp	j0 ;кінець алгоритму
  ;мітка j1 міняє поточний і попередній ел-т масиву
  j1:	mov	ah,	[arr_stack+bx-1]
  	  mov	[arr_stack+bx],	ah
  	  mov	[arr_stack+bx-1],	al
  	  jmp	j2
  	  jmp	c0
  j0:	ret

;----------------------VI. ПОЧАТОК СЕГМЕНТУ КОДУ
Start:
  M_Init
;Ініціалізація масиву випадковими числами
  lea si, [arr_stack]
  mov cx, 256
  initArr:
    mov ax,dx
    xor dx, dx
    mov bx, 10
    div bx
    add dl, '0'
    mov [si], dl
    add si, 1
  loop initArr
;запис в масив 8 рядків з датою
  lea si, [arr_stack]
  add si, 22h
  call WriteLine
  add si, 8
  call WriteLine
  add si, 8
  call WriteLine
  add si, 8
  call WriteLine
  add si, 8
  call WriteLine
  add si, 8
  call WriteLine
  add si, 8
  call WriteLine
  add si, 8
  call WriteLine

;Вивід вихідного масива
  xor	cx,	cx
	xor	bx,	bx
	mov	cx,	100h
	mov	bx,	0

  c1:
    mov	ah,	02h
	  mov	dl,	[arr_stack+bx]
	  ;add	dl,	030h
	  int	21h
	  inc	bx
  loop	c1
;Сортування
  call BubbleSort
;Вивід відсортованого масива
  xor	cx,	cx
	xor	bx,	bx
	mov	cx,	100h
	mov	bx,	0

  c2:
    mov	ah,	02h
  	mov	dl,	[arr_stack+bx]
  	;add	dl,	030h
  	int	21h
  	inc	bx
  loop	c2

;---------------------------End of program-----------
Exit:
 mov ah,4ch
 mov al,[exCode]
 int 21h
 end Start
