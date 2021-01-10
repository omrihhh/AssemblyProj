;------------------------------------------
; PURPOSE : Test number 1 
; SYSTEM  : Turbo Assembler Ideal Mode  
; AUTHOR  : Omri Hulaty and Aylon Moyal (and Yuval Rosen)
;------------------------------------------

		IDEAL
		
		MODEL small

		STACK 256

		DATASEG

                tile equ 16
                spacing equ 4
                step equ 16
                color db 0fh
                pos_x dw 0
                pos_y dw 0
                player_print db 1
                maze db 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, "n"
                     db 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, "n"
                     db 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, "n"
                     db 1, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, "n"
                     db 1, 0, 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, "n"
                     db 1, 0, 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, "n"
                     db 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, "n"
                     db 1, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, "n"
                     db 1, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, "n"
                     db 1, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, "n"
                     db 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 1, "n"
                     db 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, "n"
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
    cmp [pos_y], 10
    jl next_k
	sub [word pos_y], step
        ret
    down_pressed:
    cmp [pos_y], 192 - step - tile
    jg next_k
	add [word pos_y], step
    ret
    left_pressed:
    cmp [pos_x], 2
    jl next_k
	sub [word pos_x], step
        ret
    right_pressed:
    cmp [pos_x], 320 - step - tile
    jg next_k
	add [word pos_x], step
        ret
    next_k:
        ret
endp

proc DrawPix ; get x cord in cx and y cord in dx
        push ax
        mov ah, 0ch
        mov al, [color]
        int 10h 
        pop ax
        ret
endp DrawPix



proc DrawTile
        push dx
        push ax
        push cx
        cmp [player_print], 1
        je TilePrint
        shl dx, spacing
        shl ax, spacing
        jmp TilePrint
        ;------
    TilePrint:
        add dx, tile ; y
        add ax, tile ; x
        mov cx, tile 
        Y:
            push cx
            mov cx, tile
            X:
                push cx
                mov cx, ax
                dec cx
                dec dx
                call DrawPix
                inc dx
                pop cx
                dec ax
                loop X
            dec dx
            add ax, tile
            pop cx
            loop Y
        pop cx
        pop ax
        pop dx
        ret
endp DrawTile

proc DrawMaze
        push cx
        push dx
        push ax 
        xor cx, cx
        xor ax, ax
        xor dx, dx
        mov cx, 12
        MazeY:
                push cx
                mov dx, cx
                dec dx
                mov cx, 20
                MazeX:
                    push cx
                    dec cx
                    mov al, 21
                    push dx
                    mul dx
                    pop dx
                    add ax, cx
                    mov bx, ax
                    add bx, offset maze
                    mov ax, cx
                    cmp [byte bx], 1
                    jne DontFillSpace
                    mov [player_print], 0
                    call DrawTile
                    mov [player_print], 1
                    jmp DontFillSpace
                    DontFillSpace:
                    pop cx
                    loop mazeX
                pop cx
                loop MazeY
        pop cx
        pop ax
        pop dx
        ret 
endp DrawMaze    

; proc DrawMaze
;         push bx
;         push cx
;         push dx

;         xor dx, dx
;         xor cx, cx

;         mov [player_print], 0

;         mov bx, offset maze
;     DrawMazeLoop:
;         cmp [byte bx], "$"
;         je FinishMaze
;         cmp [byte bx], "n"
;         je NewLine
;         cmp [byte bx], 0
;         je Not1
        
;         push ax
;         mov ax, cx
;         call DrawTile
;         pop ax
;         inc cx
;         inc bx
;         jmp DrawMazeLoop
;     Not1:
;         inc bx
;         inc cx
;         jmp DrawMazeLoop
;     NewLine:
;         inc dx
;         xor cx, cx
;         inc bx
;         jmp DrawMazeLoop
;     FinishMaze:
;         mov [player_print], 1
;         pop dx
;         pop cx
;         pop bx
;         ret  
; endp DrawMaze

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

        call GetInput

        mov [color], 05h
        call DrawMaze

        mov [color], 0fh
        mov ax, [word pos_x]
        mov dx, [word pos_y]
        call DrawTile

        mov cx, 1
        mov dx, 1000
	    mov ah, 86h
	    int 15h

        mov ax,0600h    ;06 TO SCROLL & 00 FOR FULLJ SCREEN
        mov bh,0h      ;ATTRIBUTE 7 FOR BACKGROUND AND 1 FOR FOREGROUND
        mov cx,0h    ;STARTING COORDINATES
        mov dx,184fh    ;ENDING COORDINATES
        int 10h

        jmp MainLoop

Exit:
        mov ax, 3h
        int 10h 
        mov ax, 4C00h
        int 21h
		END start