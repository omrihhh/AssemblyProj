

xor ax,ax            ; xor register to itself same as zeroing register
int 1ah              ; Int 1ah/ah=0 get timer ticks since midnight in CX:DX
sub ax, cx            ; Use lower 16 bits (in DX) for random value
add ax, dx
xor dx,dx               
div 20
; x value is now in dx

xor ax,ax            ; xor register to itself same as zeroing register
int 1ah              ; Int 1ah/ah=0 get timer ticks since midnight in CX:DX
sub ax, cx            ; Use lower 16 bits (in DX) for random value
add ax, dx
xor dx,dx               
div 12
; y value is now in dx