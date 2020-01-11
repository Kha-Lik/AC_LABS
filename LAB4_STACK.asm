IDEAL
MODEL small
STACK 512

DATASEG
	arr_stack dw 3 dup (100h)
	arrStLen = $ - arr_stack
	
	arr_stack2 dw 5 dup (100h)
	arrSt2Len = $ - arr_stack2
	exCode db 0

CODESEG
Start:
	mov ax, @data
	mov ds, ax
	mov es, ax
	
;------------------------------------
	
	lea si, [arr_stack]
	mov cx, [arrStLen]
initArr:
	mov ax,dx
	xor dx, dx
	mov bx, 10
	div bx
	add dl, '0'
	mov [si], dx
	add si, 2
	loop initArr

	lea si, [arr_stack2]
	mov cx, [arrSt2Len]
initArr2:
	mov ax,dx
	xor dx, dx
	mov bx, 10
	div bx
	add dl, '0'
	mov [si], dx
	add si, 2
	loop initArr2
;----------------------------------	
	
	lea si, [arr_stack]
	mov ax, [arrStLen]
	mov cx, ax
stack1:
	mov ax, [si]
	add si, 2
	push ax
	loop stack1

	mov bp, 0010h
	mov [word bp], "91"
	add bp, 2
	mov [word bp], "50"
	add bp, 2
	mov [word bp], "02"
	add bp, 2
	mov [word bp], "10"
	add bp, 2
	mov [word bp], "41"
	add bp, 2
	mov [word bp], "30"
	add bp, 2
	mov [word bp], "02"
	add bp, 2
	mov [word bp], "10"

;------------------------------------
;***Функція виділення памяті. Вхідні параметри***
	mov ah, 048h ; Ознака переривання
	mov bx, 02h ; Розмір нової ділянки у параграфі
;***Parameters for output***
; CF = 0 if ok
; AX Адреса нового сегменту памяті
; CF = 1 Ознака помилки виконання перенивання
; AX = 7 Ознака помилки
; AX = 8 Ознака малого обсягу памяті
; BX розмір нової ділянки
	int 21h

;------------------------------------
	mov es, ax
	xor di, di
	mov cx, 100h
	
stack2:
	pop ax
	mov [es:di], ax
	add di, 2
	loop stack2

;------------------------------------
;**Звілнення памяті. Вхідні параметри***
	mov ah, 049h ; command mark
; ES адреса блоку, що звільняєтся
;***Вихідні параметри***
; CF = 0 ok
; CF = 1, AX = 7 if memory blocks is destroyed
; CF = 1, AX = 9 Некоректна адреса
	int 21h	
	
;------------------------------------

Exit:
	mov ah, 4ch
	mov al, [exCode]
	int 21h
	end Start