;------------------------------------------
; PURPOSE : Test number 1 
; SYSTEM  : Turbo Assembler Ideal Mode  
; AUTHOR  : Omri Hulaty and Aylon Moyal
;------------------------------------------

		IDEAL
		
		MODEL small

		STACK 256

		DATASEG

                cell_size equ 16
                color equ 07h
                pos_x dw 0
                pos_y db 0
		
		CODESEG
proc GetInput
    mov ah, 1
    int 16h
    jz next_k
    ; get value:
    mov ah, 0
    int 16h

    ; parse the input:
    cmp ah, 1 ; esc
	je esc_pressed
	
    cmp ah, 1bh ; esc
	je esc_pressed
	
    cmp ah, 48h ; up arrow
	je up_pressed
	
    cmp ah, 50h ; down arrow
	je down_pressed
	
    cmp ah, 4bh ; left arrow
	je left_pressed
	
    cmp ah, 4dh ; right arrow
	je right_pressed
	
    ret
    ; load the command codes:
    esc_pressed:
        jmp Exit
        ret
    up_pressed:
	sub [byte pos_y], 5
        ret
    down_pressed:
	add [byte pos_y], 5
        ret
    left_pressed:
	sub [word pos_x], 5
        ret
    right_pressed: 
	add [word pos_x], 5
        ret
    next_k:
        ret
endp

proc DrawPix
        push bp
        mov bp, sp
        push ax
        push cx
        push dx
        mov ah,0ch;
        mov al, color
        mov cx, [bp + 6] ; x co-ordinate
        mov dx, [bp + 4] ; y co-ordinate
        push bx
        mov bh,1    ; page no - critical while animating
        pop bx
        int 10h 
        pop dx
        pop cx
        pop ax
        pop bp
        ret 4
endp DrawPix

proc DrawCell
        ; shl dx, 1
        ; shl bx, 1
        ;------
        add dx, cell_size 
        add bx, cell_size  
        mov cx, cell_size
        Y:
        push cx
        mov cx, cell_size 
        X:
        push dx
        push bx
        call DrawPix
        dec dx
        loop X
        dec bx
        add dx, cell_size 
        pop cx
        loop Y
        ret 
endp DrawCell

Start:
        mov ax, @data
        mov ds, ax
		
        mov ax, 0A000h
        mov es, ax      ; ES - Extra Segment now points to the VGA location

                        ; Don't forget to view memory map to recollect that address.
                        ; We are now in 320x200x256
        
        mov ah, 00h     ; Set video mode
        mov al, 13h     ; Mode 13h
        int 10h  

        push ax
        push bx
        ; change keyboard refresh rate to match delay between frames.
        mov ah, 03h 
        mov al, 05h
        mov bh, 00h
        mov bl, 08h
        int 16h

        pop bx
        pop ax
        
MainLoop:

        mov ax, color
        mov dx, [pos_x]
        mov bx, [word pos_y]
        call DrawCell

        mov cx, 1
        mov dx, 0
	    mov ah, 86h
	    int 15h

        mov ax, 013h
	    int 10h

        call GetInput

        jmp MainLoop

Exit:
        mov ax, 3h
        int 10h 
        mov ax, 4C00h
        int 21h
		END start