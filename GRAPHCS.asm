;------------------------------------------
; PURPOSE : Test number 1 
; SYSTEM  : Turbo Assembler Ideal Mode  
; AUTHOR  : Omri Hulaty and Aylon Moyal
;------------------------------------------

; algorithm details from https://en.wikipedia.org/wiki/Maze_generation_algorithm under Randomized depth-first search / Iterative implementation

		IDEAL
		
		MODEL small

		STACK 512

		DATASEG

                tile equ 16 ; 16 * 16
                spacing equ 4 
                step equ 16 ; number of pixels the palyer moves
                color db 0fh 
                pos_x dw 0 ; player's x value
                pos_y dw 0 ; player's y value
                player_print db 1
                maze db 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, "n" 
                     db 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, "n" 
                     db 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, "n" 
                     db 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, "n" 
                     db 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, "n" 
                     db 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, "n" 
                     db 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, "n" 
                     db 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, "n" 
                     db 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, "n" 
                     db 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, "n" 
                     db 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, "n" 
                     db 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, "n" 

                character db 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, "n" 
                          db 00, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 00, "n" 
                          db 00, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 00, "n" 
                          db 00, 15, 00, 00, 00, 15, 15, 15, 15, 15, 00, 00, 00, 15, 15, 00, "n" 
                          db 00, 15, 00, 15, 00, 15, 15, 15, 15, 15, 00, 15, 00, 15, 15, 00, "n" 
                          db 00, 15, 00, 00, 00, 15, 15, 15, 15, 15, 00, 00, 00, 15, 15, 00, "n" 
                          db 00, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 00, "n" 
                          db 00, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 00, "n" 
                          db 00, 15, 15, 00, 00, 00, 00, 00, 00, 00, 00, 00, 15, 15, 15, 00, "n" 
                          db 00, 15, 15, 15, 00, 04, 04, 04, 04, 04, 00, 15, 15, 15, 15, 00, "n" 
                          db 00, 15, 15, 15, 15, 00, 04, 04, 04, 00, 15, 15, 15, 15, 15, 00, "n" 
                          db 00, 15, 15, 15, 15, 15, 00, 00, 00, 15, 15, 15, 15, 15, 15, 00, "n" 
                          db 00, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 00, "n" 
                          db 00, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 00, "n" 
                          db 00, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 00, "n" 
                          db 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, "n" 
                        db "$"

                neighbours db 0
                neighbour_count db 0
                neighbours_indexes db 4 dup(0)
                last_ran db 0
                ; [maze + 24]
                ; 0000b = 0 = 0000 = 0b
                    
                ; 1'st - up, 2'nd - right, 3'rd - down, 4'th - left 
                ; 1111 all borders
                ; 0000 no borders
                ; 0101 borders left and right 
		CODESEG

proc DrawCharacter ; draw a character, offset saved in bx, position in (cx, dx).
	push dx
	push bx
	push ax
	push cx

	;mov bx, offset character
	draw_line_loop:
		mov al, [bx]
		cmp al, '$'
		je end_line_loop
		
		cmp al, 'n'
		jne skip_new_line
		  inc dx
		  pop cx
		  push cx
		  inc bx
		  jmp draw_line_loop

		cmp al, 't'
		jne skip_new_line
		  inc dx
		  pop cx
		  push cx
		  inc bx
		  jmp draw_line_loop

		skip_new_line:
        mov [color], al
		call DrawPix
		;call DrawTile
		
		inc cx
		inc bx
		jmp draw_line_loop
		
	end_line_loop:
		pop cx
		pop ax
		pop bx
		pop dx
		ret
endp DrawCharacter

proc random
        push cx
        push ax
        
        xor ax,ax            ; xor register to itself same as zeroing register
        int 1ah              ; Int 1ah/ah=0 get timer ticks since midnight in CX:DX
        sub ax, cx            ; Use lower 16 bits (in DX) for random value
        add ax, dx
        xor dx,dx               
        div bx               ; Divide dx:ax by bx

        pop ax
        pop cx
        ret
endp random

proc GenerateMaze
    push dx

    mov bx, 12
    call random
    mov al, 21
    mul dx
    mov bx, 20
    call random
    add ax, dx
    mov bx, ax

    mov bp, sp
    push bx
    or [maze + bx], 10000B
    GeneretionLoop:

        mov cx, 0
        mov dx, 1
	    mov ah, 86h
	    int 15h

        cmp bp, sp
        je EndGeneretionLoop1
        pop cx
        call getNeighbours
        cmp [neighbour_count], 0
        jne HasNeighbours
        jmp GeneretionLoop
        EndGeneretionLoop1:
            jmp EndGeneretionLoop
        HasNeighbours:
            push cx
            xor bx, bx
            mov bl, [neighbour_count]
            call random
            ; mov dx, 0
            xor ax, ax
            mov al, [neighbours]
            xor bx, bx
            dec bx
            NIUp:
                and ax, 1000B
                cmp ax, 1000B
                jne NIRight
                inc bx
                mov [neighbours_indexes + bx], cl
                sub [neighbours_indexes + bx], 21
            NIRight:
                xor ax, ax
                mov al, [neighbours]
                and ax, 0100B
                cmp ax, 0100B
                jne NIDown
                inc bx
                mov [neighbours_indexes + bx], cl
                inc [neighbours_indexes + bx]
            NIDown:
                xor ax, ax
                mov al, [neighbours]
                and ax, 0010B
                cmp ax, 0010B
                jne NILeft
                inc bx
                mov [neighbours_indexes + bx], cl
                add [neighbours_indexes + bx], 21
            NILeft:
                xor ax, ax
                mov al, [byte neighbours]
                and ax, 0001B       
                cmp ax, 0001B
                jne EndIndexChosing
                inc bx
                mov [neighbours_indexes + bx], cl
                dec [neighbours_indexes + bx]
            EndIndexChosing:
                mov bx, dx
                mov dl, [byte neighbours_indexes + bx]
                NBUp:
                    mov ax, cx
                    sub ax, 21
                    cmp dx, ax
                    jne NBRight
                    mov bx, cx
                    and [maze + bx], 10111B
                    mov bx, dx
                    and [maze + bx], 11101B
                NBRight:
                    mov ax, cx
                    inc ax
                    cmp dx, ax
                    jne NBDown
                    mov bx, cx
                    and [maze + bx], 11011B
                    mov bx, dx
                    and [maze + bx], 11110B
                NBDown:
                    mov ax, cx
                    add ax, 21
                    cmp dx, ax
                    jne NBLeft
                    mov bx, cx
                    and [maze + bx], 11101B
                    mov bx, dx
                    and [maze + bx], 10111B
                NBLeft:
                    mov ax, cx
                    dec ax
                    cmp dx, ax
                    jne EndBorderRemoving
                    mov bx, cx
                    and [maze + bx], 11110B
                    mov bx, dx
                    and [maze + bx], 11011B
                EndBorderRemoving:
                    xor ax, ax
                    mov bx, dx
                    add [maze + bx], 10000B
                    mov bl, [maze + bx]
                    push dx
                    jmp GeneretionLoop

    EndGeneretionLoop:
        pop dx
        ret 
endp GenerateMaze

proc getNeighbours ; get cell in cx, returns 
        push cx
        push dx
        push ax
        push bx
        xor dx, dx
        mov [neighbour_count], 0
        mov [neighbours], 0000B
        mov ax, cx
        NUp:
            cmp ax, 21
            jl NRight
            mov bx, cx
            sub bx, 21
            add bx, offset maze
            mov bx, [bx]
            and bx, 10000B
            cmp bx, 10000B
            je NRight
            inc [neighbour_count]
            or [neighbours], 1000B
        NRight:
            push ax
            mov bx, 21
            div bx
            pop ax
            cmp dx, 19
            je NDown
            mov bx, cx 
            mov bx, cx
            inc bx
            add bx, offset maze
            mov bx, [bx]
            and bx, 10000B
            cmp bx, 10000B
            je NDown
            inc [neighbour_count]
            or [neighbours], 0100B
        NDown:
            cmp ax, 230
            jg NLeft
            mov bx, cx
            add bx, 21
            add bx, offset maze
            mov bx, [bx]
            and bx, 10000B
            cmp bx, 10000B
            je NLeft
            inc [neighbour_count]
            or [neighbours], 0010B
        NLeft:
            push ax
            mov bx, 21
            div bx
            pop ax
            cmp dx, 0
            je EndNeighbourSearch
            mov bx, cx
            dec bx
            add bx, offset maze
            mov bx, [bx]
            and bx, 10000B
            cmp bx, 10000B
            je EndNeighbourSearch
            inc [neighbour_count]
            or [neighbours], 0001B
        EndNeighbourSearch:
            pop bx
            pop ax
            pop dx
            pop cx
        ret
endp getNeighbours


proc GetInput
    mov cx, [pos_x]
    mov dx, [pos_y]
    shr cx, 4
    shr dx, 4
    call GetIndex
    mov bx, ax

    xor ax, ax
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
    next_k:
        ret
    ; load the command codes:
    esc_pressed:
        jmp Exit
        ret
    up_pressed:
    mov bx, [bx]
    and bx, 1000B
    cmp bx, 1000B
    je border
    cmp [pos_y], 10
    jl next_k ; jl = jmp less
	sub [word pos_y], step
        ret
    down_pressed:
    mov bx, [bx]
    and bx, 0010B
    cmp bx, 0010B
    je border
    cmp [pos_y], 192 - step - tile ; 320(x) * 200(y) but 200 / 16 = 12.5
    jg next_k
	add [word pos_y], step
    ret
    left_pressed:
    mov bx, [bx]
    and bx, 0001B
    cmp bx, 0001B
    je border
    cmp [pos_x], 2
    jl next_k
	sub [word pos_x], step
        ret
    right_pressed:
    mov bx, [bx]
    and bx, 0100B
    cmp bx, 0100B
    je border
    cmp [pos_x], 320 - step - tile
    jg next_k
	add [word pos_x], step
        ret
    border:
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
        xor ax, ax
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

        mov [color], 0fh

        call GenerateMaze

MainLoop:
        
        call GetInput

        ; mov [color], 0fh
        mov cx, [word pos_x]
        mov dx, [word pos_y]
        mov bx, offset character
        call DrawCharacter

        push [word color]
        mov [color], 04h ; maze colour 
        call DrawMaze
        pop [word color]

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