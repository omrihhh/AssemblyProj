;------------------------------------------
; Purpose: Random Mazes Game.
; System: Turbo Assembler Ideal Mode.
; Author: Omri Hulaty and Aylon Moyal.
;------------------------------------------

; algorithm details from https://en.wikipedia.org/wiki/Maze_generation_algorithm under randomized depth-first search / Iterative implementation

IDEAL

MODEL small

STACK 512

DATASEG

    tile equ 16 ; 16 * 16.
    spacing equ 4 
    step equ 16 ; number of pixels the palyer moves.
    color db 0fh 
    pos_x dw 0 ; player's x value.
    pos_y dw 0 ; player's y value.
    player_print db 1
            
    maze        db 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, "n" 
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
                db "$"
    ; 15h = 1111b = all borders.
    ; 1'st - up, 2'nd - right, 3'rd - down, 4'th - left.
    ; for example: 0000 - no borders, 1111 - all borders, 0101 - right & left borders.

    character   db 't', 't', 't', 't', 't', 't', 't', 't', 't', 't', 't', 't', 't', 't', 't', 't', "n" 
                db 't', 00h , 00h , 00h , 00h , 00h , 00h , 0Fh , 0Fh , 0Fh , 00h , 00h , 00h , 00h , 00h , 't', "n" 
                db 't', 00h , 00h , 00h , 00h , 00h , 0Fh , 00h , 00h , 00h , 0Fh , 00h , 00h , 00h , 00h , 't', "n" 
                db 't', 00h , 00h , 00h , 00h , 00h , 0Fh , 00h , 00h , 00h , 0Fh , 00h , 00h , 00h , 00h , 't', "n" 
                db 't', 00h , 00h , 00h , 00h , 00h , 00h , 0Fh , 0Fh , 0Fh , 00h , 00h , 00h , 00h , 00h , 't', "n" 
                db 't', 00h , 00h , 00h , 0Fh , 00h , 00h , 00h , 0Fh , 00h , 00h , 00h , 0Fh , 00h , 00h , 't', "n" 
                db 't', 00h , 00h , 00h , 00h , 0Fh , 00h , 00h , 0Fh , 00h , 00h , 0Fh , 00h , 00h , 00h , 't', "n" 
                db 't', 00h , 00h , 00h , 00h , 00h , 0Fh , 0Fh , 0Fh , 0Fh , 0Fh , 00h , 00h , 00h , 00h , 't', "n" 
                db 't', 00h , 00h , 00h , 00h , 00h , 00h , 00h , 0Fh , 00h , 00h , 00h , 00h , 00h , 00h , 't', "n" 
                db 't', 00h , 00h , 00h , 00h , 00h , 00h , 00h , 0Fh , 00h , 00h , 00h , 00h , 00h , 00h , 't', "n" 
                db 't', 00h , 00h , 00h , 00h , 00h , 00h , 00h , 0Fh , 00h , 00h , 00h , 00h , 00h , 00h , 't', "n" 
                db 't', 00h , 00h , 00h , 00h , 00h , 00h , 0Fh , 00h , 0Fh , 00h , 00h , 00h , 00h , 00h , 't', "n" 
                db 't', 00h , 00h , 00h , 00h , 00h , 0Fh , 00h , 00h , 00h , 0Fh , 00h , 00h , 00h , 00h , 't', "n" 
                db 't', 00h , 00h , 00h , 00h , 0Fh , 00h , 00h , 00h , 00h , 00h , 0Fh , 00h , 00h , 00h , 't', "n" 
                db 't', 00h , 00h , 00h , 00h , 00h , 00h , 00h , 00h , 00h , 00h , 00h , 00h , 00h , 00h , 't', "n" 
                db 't', 't', 't', 't', 't', 't', 't', 't', 't', 't', 't', 't', 't', 't', 't', 't', "n" 
                db "$"

    bonus       db 't', 't', 't', 't', 't', 't', 't', 't', 't', 't', 't', 't', 't', 't', 't', 't', "n" 
                db 't', 00h, 00h, 00h, 00h, 06h, 06h, 06h, 06h, 06h, 06h, 00h, 00h, 00h, 00h, 't', "n" 
                db 't', 00h, 00h, 06h, 06h, 2ch, 2ch, 2ch, 2ch, 2ch, 2ch, 06h, 06h, 00h, 00h, 't', "n" 
                db 't', 00h, 06h, 2ch, 2ch, 2ch, 2ch, 2ch, 2ch, 2ch, 2ch, 2ch, 2ch, 06h, 00h, 't', "n" 
                db 't', 00h, 06h, 2ch, 2ch, 2ch, 06h, 06h, 06h, 06h, 2ch, 2ch, 2ch, 06h, 00h, 't', "n" 
                db 't', 06h, 2ch, 2ch, 2ch, 06h, 2ch, 2ch, 2ch, 2ch, 06h, 2ch, 2ch, 2ch, 06h, 't', "n" 
                db 't', 06h, 2ch, 2ch, 06h, 2ch, 2ch, 2ch, 2ch, 2ch, 2ch, 06h, 2ch, 2ch, 06h, 't', "n" 
                db 't', 06h, 2ch, 2ch, 06h, 2ch, 2ch, 2ch, 2ch, 2ch, 2ch, 06h, 2ch, 2ch, 06h, 't', "n" 
                db 't', 06h, 2ch, 2ch, 06h, 2ch, 2ch, 2ch, 2ch, 2ch, 2ch, 06h, 2ch, 2ch, 06h, 't', "n" 
                db 't', 06h, 2ch, 2ch, 06h, 2ch, 2ch, 2ch, 2ch, 2ch, 2ch, 06h, 2ch, 2ch, 06h, 't', "n" 
                db 't', 06h, 2ch, 2ch, 2ch, 06h, 2ch, 2ch, 2ch, 2ch, 06h, 2ch, 2ch, 2ch, 06h, 't', "n" 
                db 't', 00h, 06h, 2ch, 2ch, 2ch, 06h, 06h, 06h, 06h, 2ch, 2ch, 2ch, 06h, 00h, 't', "n" 
                db 't', 00h, 06h, 2ch, 2ch, 2ch, 2ch, 2ch, 2ch, 2ch, 2ch, 2ch, 2ch, 06h, 00h, 't', "n" 
                db 't', 00h, 00h, 06h, 06h, 2ch, 2ch, 2ch, 2ch, 2ch, 2ch, 06h, 06h, 00h, 00h, 't', "n" 
                db 't', 00h, 00h, 00h, 00h, 06h, 06h, 06h, 06h, 06h, 06h, 00h, 00h, 00h, 00h, 't', "n" 
                db 't', 't', 't', 't', 't', 't', 't', 't', 't', 't', 't', 't', 't', 't', 't', 't', "n" 
                db "$"

    neighbours db 0
    neighbour_count db 0
    neighbours_indexes db 4 dup(0)

    time db 25
    last_time db 0
    total_time db 0
    level db 1
    end_message db 'Your time (sec): ', '$'
    time_message db 'time(sec):', '$'
    lvl_message db ' - level: /5', '$'

    XValue dw ?
    YValue dw ?


CODESEG


proc CheckCollision
    push cx
    mov cx, [pos_x]
    cmp cx, [XValue]
    jne NotColliding

    mov cx, [pos_y]
    cmp cx, [YValue]
    jne NotColliding
    mov [time], 1

    NotColliding:
        pop cx
        ret
endp CheckCollision


; print a variable to screen: offset saved in bp, dh - row, dl - column, bl - color.
proc MovCrsr
	push ax
	push bx
	push cx

	mov ah, 02h
	mov bh, 0
	int 10h
	
	pop cx
	pop bx
	pop ax
	ret
endp MovCrsr


proc RandomXValue
    mov ah, 00h  ; interrupts to get system time.
   	int 1Ah      ; cx:dx now hold number of clock ticks since midnight.

	mov  ax, dx
	xor  dx, dx
	mov  cx, 16  
	div  cx
    add dx, 4
    shl dx, 4
    mov [XValue], dx
    ret
endp RandomXValue


proc RandomYValue
    mov AH, 00h  ; interrupts to get system time.
   	int 1Ah      ; cx:dx now hold number of clock ticks since midnight.

	mov  ax, dx
	xor  dx, dx
	mov  cx, 8  
	div  cx
    add  dx, 4
    shl dx, 4
    mov [YValue], dx
    ret
endp RandomYValue


; draw a character: offset saved in bx, position in (cx, dx).
proc DrawCharacter
	push dx
	push bx
	push ax
	push cx
    mov bp, cx
    xor ax, ax

	Draw_line_loop:
		mov al, [bx]
		cmp al, '$'
		je End_line_loop

        cmp al, 't'
		jne Newline
          inc cx
		  inc bx
		  jmp Draw_line_loop
		
    Newline:
		cmp al, 'n'
		jne Skip_new_line
          mov cx, bp
          inc dx
		  inc bx
		  jmp Draw_line_loop

    Skip_new_line:
        mov [color], al
		call DrawPix
		inc cx
		inc bx
		jmp Draw_line_loop
		
	End_line_loop:
		pop cx
		pop ax
		pop bx
		pop dx
		ret
endp DrawCharacter


proc Random
        push cx
        push ax
        
        xor ax,ax
        int 1ah     ; int 1ah/ah=0 get timer ticks since midnight in cx:dx.
        sub ax, cx  ; use lower 16 bits (in dx) for random value.
        add ax, dx
        xor dx,dx               
        div bx

        pop ax
        pop cx
        ret
endp Random


proc GenerateMaze
    call EraseMaze
    push dx

    mov bx, 12
    call Random
    mov al, 21
    mul dx
    mov bx, 20
    call Random
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
        call GetNeighbours
        cmp [neighbour_count], 0
        jne HasNeighbours
        jmp GeneretionLoop

    EndGeneretionLoop1:
        jmp EndGeneretionLoop

    HasNeighbours:
        push cx
        xor bx, bx
        mov bl, [neighbour_count]
        call Random
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


proc GetNeighbours
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
endp GetNeighbours


proc GetInput
    mov cx, [pos_x]
    mov dx, [pos_y]
    shr cx, 4
    shr dx, 4
    
    push dx
    push cx
    mov [color], 0h
    mov ax, [word pos_x]
    mov dx, [word pos_y]
    call EraseChar
    pop cx
    pop dx

    call GetIndex
    mov bx, ax

    xor ax, ax
    mov ah, 1
    int 16h
    jz Next_k
    
    ; get value:
    mov ah, 0
    int 16h
    
    ; parse the input:
    cmp ah, 1 ; esc
	je Esc_pressed
	
    cmp ah, 1bh ; esc
	je Esc_pressed
	
    cmp ah, 48h ; up arrow
	je Up_pressed
	
    cmp ah, 50h ; down arrow
	je Down_pressed
	
    cmp ah, 4bh ; left arrow
	je Left_pressed
	
    cmp ah, 4dh ; right arrow
	je Right_pressed
	
    ret
    
    Next_k:
        ret
    
    ; load the command codes:
    Esc_pressed:
        jmp Exit
        ret

    Up_pressed:
        mov bx, [bx]
        and bx, 1000B
        cmp bx, 1000B
        je Border
        cmp [pos_y], 10
        jl Next_k
	    sub [word pos_y], step
            ret

    Down_pressed:
        mov bx, [bx]
        and bx, 0010B
        cmp bx, 0010B
        je Border
        cmp [pos_y], 192 - step - tile ; 320(x) * 200(y) but 200 / 16 = 12.5.
        jg Next_k
	    add [word pos_y], step
        ret

    Left_pressed:
        mov bx, [bx]
        and bx, 0001B
        cmp bx, 0001B
        je Border
        cmp [pos_x], 2
        jl Next_k
	    sub [word pos_x], step
            ret

    Right_pressed:
        mov bx, [bx]
        and bx, 0100B
        cmp bx, 0100B
        je Border
        cmp [pos_x], 320 - step - tile
        jg Next_k
	    add [word pos_x], step
            ret

    Border:
        ret
endp GetInput


; get x cord in cx and y cord in dx.
proc DrawPix
    push ax
    mov ah, 0ch
    mov al, [color]
    int 10h 
    pop ax
    ret
endp DrawPix


; get x cord in ax and dx in y cord.
proc DrawTile
    push bp
    mov bp, sp 
    push dx ; bp - 2.
    push ax ; bp - 4.
    push cx ; bp - 6.
    push bx ; bp - 8.
    cmp [player_print], 1 ; temp.
    je TilePrint ; temp.
    shl dx, spacing
    shl ax, spacing

    TilePrint:
        add dx, tile ; y.
        add ax, tile ; x.
        mov cx, tile 

        Y:
            push cx ; bp - 10.
            mov cx, tile

            X:
                push cx ; bp - 12.
                mov cx, ax
                dec cx
                dec dx ; turn 1 - 16 to 0 - 15.

                Dborder:

                and bx, 0010b
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


; get x cord in ax and dx in y cord.
proc EraseChar
    push dx
    push ax 
    push cx
    push bx

    Erase:
        add dx, tile ; y.
        add ax, tile ; x.
        mov cx, tile 
        sub dx, 2
        sub ax, 2
        sub cx, 2

        EY:
            push cx ;
            mov cx, tile
            sub cx, 2
             
            EX:
                push cx 
                mov cx, ax
                call DrawPix
                pop cx
                dec ax
                loop EX

            add ax, tile
            dec dx
            sub ax, 2
            pop cx
            loop EY

        pop bx
        pop cx
        pop ax
        pop dx
        ret
endp EraseChar


proc EraseMaze 
    push bx
    mov bx, offset maze
    add bx, 251

    EraseMazeLoop:
        cmp [byte bx], 'n'
        je Move
        mov [byte bx], 15

    Move:
        dec bx
        cmp bx , offset maze - 1
        jne EraseMazeLoop
        
    pop bx
    ret
endp EraseMaze


; get x in cx and y in dx and returns the index for this cell in maze.
proc GetIndex
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
        mov bx, [word bx]
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


proc Print
    ; initilize count:
    mov cx,0
    mov dx,0

    Label1:
        ; if ax is zero:
        cmp ax,0
        je Print1
        
        ; initilize bx to 10:
        mov bx,10
        
        ; extract the last digit:
        div bx
        
        ; push it in the stack:
        push dx
        
        ; increment the count:
        inc cx
        
        ; set dx to 0:
        xor dx,dx
        jmp Label1

    Print1:
        ; check if count:

        ; is greater than zero:
        cmp cx,0
        je Endprint
        
        ; pop the top of stack:
        pop dx

        ; add 48 so that it represents the ASCII value of digits:
        add dx, '0' 
        
        ; interuppt to print a character:
        mov ah,02h
        int 21h
        
        ; decrease the count:
        dec cx
        jmp Print1
    
    Endprint:
        ret
endp print

proc PrintInfo
    push bx 
    mov dl, 8
    mov dh, 24
    call MovCrsr

    lea dx, [time_message]  
    mov ah,09h 
    int 21h          

    xor ax, ax
    mov al, [total_time]
    call Print

    mov bl, [level]
    add bl, "0"

    mov [lvl_message + 9], bl
    lea dx, [lvl_message]  
    mov ah,09h 
    int 21h          
    pop bx
    ret
endp PrintInfo

Start:
    mov ax, @data
    mov ds, ax
		
    mov ax, 0a000h
    mov es, ax  ; ES - Extra Segment now points to the VGA location.
                ; Don't forget to view memory map to recollect that address.
                ; We are now in 320x200x256.
        
    mov ah, 00h ; Set video mode.
    mov al, 13h ; Mode 13h.
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

    xor ax, ax
    call GenerateMaze

    push [word color]
    mov [color], 15 ; maze color.
    call DrawMaze
    pop [word color]

        
    call RandomXValue
    call RandomYValue
    mov cx, [XValue]
    mov dx, [YValue]
    mov bx, offset bonus
    call DrawCharacter

MainLoop:
    mov ah,2ch
	int 21h
    cmp dh, [last_time]
    je Run
    mov [last_time], dh
    dec [time]
    inc [total_time]
        
    call PrintInfo

    ; print a variable to screen: offset saved in bp, dh - row, dl - column, bl - color. cx - text length.
    cmp [time], 0
    jne Run

    inc [level]
    cmp [level], 6
    je Exit
    mov [time], 25

    mov ax, 0600h    ; 06 to scroll & 00 for full screen.
    mov bh, 0h       ; attribute 7 for background and 1 for foreground.
    mov cx, 0h       ; starting coordinates.
    mov dx, 184fh    ; ending coordinates.
    int 10h

    mov [pos_x], 0
    mov [pos_y], 0
    xor ax, ax
    call GenerateMaze

    mov [color], 15    ; maze color.
    call DrawMaze
    
    call RandomXValue
    call RandomYValue
    mov cx, [XValue]
    mov dx, [YValue]
    mov bx, offset bonus
    call DrawCharacter

    Run:
        call GetInput
        call CheckCollision

        mov cx, [word pos_x]
        mov dx, [word pos_y]
        mov bx, offset character
        call DrawCharacter

        mov cx, 1
        mov dx, 1000
	    mov ah, 86h
	    int 15h

        jmp MainLoop

Exit:
    mov ax, 3h
    int 10h
    lea dx, [end_message]  
    mov ah,09h 
    int 21h  
    xor ax, ax
    mov al, [total_time]
    call Print
    mov cx, 1000h
    mov dx, 1000h
	mov ah, 86h
	int 15h
    mov ax, 4C00h
    int 21h

	END start