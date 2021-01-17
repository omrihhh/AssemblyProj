; -----------------------------------
; Print time to screen
; Author: Omri Hulaty and Aylon Moyal
; -----------------------------------

IDEAL

MODEL small

STACK 100h

DATASEG
	hourtxt db 'Hour: ','$'
	mintxt db 13,10,'Mins: ','$'
	sectxt db 13,10,'Sec: ','$'
	mstxt db 13,10,'Ms:','$'
	savetime dw ?
	divisorTable db 10,1,0

CODESEG
	proc printNumber
		push ax
		push bx
		push dx
		mov bx,offset divisorTable
	nextDigit:
		xor ah,ah
		div [byte ptr bx] ; al = quotient, ah = remainder
		add al,'0'
		call printCharacter ; Display the quotient
		mov al,ah ; ah = remainder
		add bx,1 ; bx = address of next divisor, could it be inc bx?
		cmp [byte ptr bx],0 ; Have all divisors been done?
		jne nextDigit
		pop dx
		pop bx
		pop ax
		ret
	endp printNumber

	proc printCharacter
		push ax
		push dx
		mov ah,2
		mov dl,al
		int 21h
		pop dx
		pop ax
		ret
	endp printCharacter

start:
	mov ax, @data
	mov ds, ax
	mov ah,2ch
	int 21h ; ch- hour, cl- minutes, dh- seconds, dl- hundreths secs
	mov [savetime],dx

	; print hours:
	mov dx,offset hourtxt
	mov ah,9
	int 21h
	xor ax,ax
	mov al,ch
	call printNumber

	; print minutes:
	mov dx,offset mintxt
	mov ah,9
	int 21h
	xor ax,ax
	mov al,cl
	call printNumber

	; print seconds:
	mov dx,offset sectxt
	mov ah,9
	int 21h
	xor ax,ax
	mov dx,[savetime]
	mov al,dh
	call printNumber

	; print 1/100 seconds
	mov dx,offset mstxt
	mov ah,9
	int 21h
	xor ax,ax
	mov dx,[savetime]
	mov al,dl
	call printNumber
	
exit:
	mov ax, 4c00h
	int 21h
END start
