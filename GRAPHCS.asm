;------------------------------------------
; PURPOSE : Test number 1 
; SYSTEM  : Turbo Assembler Ideal Mode  
; AUTHOR  : Omri Hulaty and Aylon Moyal
;------------------------------------------

		IDEAL
		
		MODEL small

		STACK 256

		DATASEG

                tile equ 16 ; 16 * 16
                spacing equ 4 
                step equ 16 ; number of pixels the palyer moves
                color db 0fh 
                pos_x dw 0 ; player's x value
                pos_y dw 0 ; player's y value
                player_print db 1
                maze db 1111B, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, "n" ; (1,2)
                     db 0,     0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, "n"
                     db 1110B, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, "n"
                     db 0,     0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, "n"
                     db 1100B, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, "n"
                     db 0,     0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, "n"
                     db 1000B, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, "n"
                     db 0,     0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, "n"
                     db 0,     0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, "n"
                     db 0,     0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, "n"
                     db 0,     0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, "n"
                     db 0,     0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, "n"
                ; [maze + 24]
                ; 0000b = 0 = 0000 = 0b
                    
                ; 1'st - up, 2'nd - right, 3'rd - down, 4'th - left 
                ; 1111 all borders
                ; 0000 no borders
                ; 0101 borders left and right 
		CODESEG

proc GetInput
    ; mov cx, [pos_x]
    ; mov dx, [pos_y]
    ; call GetIndex
    ; mov bx, ax

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
    ; mov bx, [bx]
    ; and bx, 1000b
    ; cmp bx, 1000b
    ; je next_k
    cmp [pos_y], 10
    jl next_k ; jl = jmp less
	sub [word pos_y], step
        ret
    down_pressed:
    ;; mov bx, [bx]
    ;; and bx, 0010b
    ;; cmp bx, 0010b
    ;; je next_k
    cmp [pos_y], 192 - step - tile ; 320(x) * 200(y) but 200 / 16 = 12.5
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



proc DrawTile ; get x cord in ax and dx in y cord
        push bp
        mov bp, sp 
        push dx ; bp - 2
        push ax ; bp - 4 
        push cx ; bp - 6
        push bx ; bp - 8
        cmp [player_print], 1 ; temp
        je TilePrint ; temp
        shl dx, spacing
        shl ax, spacing
        ;------
    TilePrint:
        add dx, tile ; y
        add ax, tile ; x
        mov cx, tile 

        Y:
            push cx ; bp - 10
            mov cx, tile
             
            X:
                push cx ; bp - 12
                mov cx, ax
                dec cx
                dec dx
                ;turn 1 - 16 to 0 - 15
                Dborder:
                and bx, 0010b ; bx = 1111, 1111 and 0010 = 0010 
                cmp bx, 0010b
                jne Lborder
                cmp [word bp - 10], tile
                je PrintPix

                Lborder:
                mov bx, [bp - 8]
                and bx, 0001b
                cmp bx, 0001b
                jne Uborder
                cmp [word bp - 12], 1
                je PrintPix

                Uborder:
                mov bx, [bp - 8]
                and bx, 1000b
                cmp bx, 1000b
                jne Rborder
                cmp [word bp - 10], 1
                je PrintPix

                Rborder:
                mov bx, [bp - 8]
                and bx, 0100b
                cmp bx, 0100b
                jne NoPrintingArea
                cmp [word bp - 12], tile
                je PrintPix
                jmp NoPrintingArea

                PrintPix:
                    call DrawPix

                NoPrintingArea:
                    inc dx
                    pop cx
                    dec ax
                loop X
            dec dx
            add ax, tile
            pop cx
            loop Y
        pop bx
        pop cx
        pop ax
        pop dx
        pop bp
        ret
endp DrawTile

proc GetIndex ; get x in cx and y in dx and returns the index for this cell in maze,
        mov al, 21
        push dx
        mul dx
        pop dx
        add ax, cx
        add ax, offset maze
        ret
endp GetIndex

proc DrawMaze
        push cx
        push dx
        push ax 
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
                    call GetIndex
                    mov bx, ax
                    mov ax, cx
                    cmp [byte bx], 0
                    je DontFillSpace
                    mov [player_print], 0
                    push bx
                    mov bx, [word bx] ; 0001
                    call DrawTile
                    pop bx
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
		
        mov ax, 0a000h
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
        mov bx, 1111b
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