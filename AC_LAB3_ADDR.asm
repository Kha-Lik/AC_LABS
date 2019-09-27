IDEAL
MODEL small
STACK 512

DATASEG 
exCode db 0

array db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
	  db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
	  db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
	  db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
	  db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
	  db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
	  db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
	  db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
	  db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
	  db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
	  db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
	  db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
	  db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
	  db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
	  db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
	  db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
		 
		 
CODESEG
Start:
	mov ax, @data
	mov ds, ax
	mov es, ax

;----------------Frame-----------------
	mov DI, 0
	mov [DI], 0DAh
	add DI, 0Fh
	mov [DI], 0BFh
	add DI, 0E1h
	mov [DI], 0C0h
	add DI, 0Fh
	mov [DI], 0D9h
	
	mov cx, 14
	mov si,	0h
	mov bx, 0h
	line1: 
		mov [array+si+bx], 0C4h
		inc si		
	loop line1	
	
	mov cx, 14
	mov si,	0h
	mov bx, 0F0h
	line2: 
		mov [array+si+bx], 0C4h
		inc si		
	loop line2	
	
	mov cx, 14
	mov si,	0h
	mov bx, 0Fh
	line3:
		mov [array+si+bx], 0B3h		
		add bx, 0Fh			
		mov [array+si+bx], 0B3h
		inc bx		
	loop line3	
;-------------------TEXT------------------
	mov bx, 0Fh ; вертикаль 
	mov si, 1h	; горизонталь
	
	mov al, 41h
	mov [array+si+bx], al
	add bx, 10h
	inc si
	mov [array+si+bx], al
	add bx, 10h
	inc si
	mov al, 56h
	mov [array+si+bx], al
	add bx, 10h
	inc si
	mov al, 4dh
	mov [array+si+bx], al
	add bx, 10h
	inc si
	mov al, 56h
	mov [array+si+bx], al
	add bx, 10h
	inc si
	mov al, 49h
	mov [array+si+bx], al
	add bx, 10h
	inc si
	mov al, 56h
	mov [array+si+bx], al
	add bx, 10h
	inc si
	mov [array+si+bx], al
	add bx, 10h
	inc si
	mov al, 47h
	mov [array+si+bx], al
	add bx, 10h
	inc si
	mov al, 54h
	mov [array+si+bx], al
	add	bx, 10h
	inc si
	mov al, 47h
	mov [array+si+bx], al
	add bx, 10h
	inc	si
	mov al, 4fh
	mov [array+si+bx], al
	add bx, 10h
	inc si
	mov al, 47h
	mov [array+si+bx], al
	add bx, 10h
	inc si
	mov al, 41h
	mov [array+si+bx], al

;-----------------------------------------	
	mov ah, 01h
	int 21h

Exit:
	mov ah, 4ch
	mov al, [exCode]
	int 21h
	end Start
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	