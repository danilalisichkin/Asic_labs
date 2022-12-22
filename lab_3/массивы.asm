;3rd lab 11 var
data segment
    otst db '  ',0Dh,0Ah,'$'
    start_mes db "  Fill the array!$"     
    EX_INCORRECT_INPUT db "  Invalid input!$"
    EX_BORDER db "  Not valid borders!$" 
    press_key db "  Press any key!$"
    write_left db "  Write left border: $"
    write_right db "  Write right border: $"
    your_massive db "  Your massive:$"
    your_elements db "  Searched elements:$"
    mas dw 11,11 dup (0)
    el dw 1,1 dup (0)    
    left dw 1,1 dup(0)
    right dw 1,1 dup(0)
    tab db "      $"
ends

stack segment
    db 100
ends
               
code segment                    

proc to_string

    push ax
    push bx
    push cx    
    
    mov bx, 10    
    mov ax, [di]
    xor cx, cx 
    xor dx, dx  
    
    test ax, ax
    jne choose_sign
    mov [el], 1
    mov [el+1], 1
    mov [el+2], '0'
    mov [el+3], '$'
    jmp exit 
    
    choose_sign:
    cmp ax, 0
    js negative
    jmp count
    
    negative: 
    mov [el+2], '-'
    neg ax
    mov dx, 1
    
    count:
    push ax
    push dx
    c5:              
        xor dx, dx
        test ax, ax
        je make_string
        inc cx      
        div bx
        add ax, 0
    jmp c5
    
    make_string:
    
    pop dx
    add dx, cx            
    lea si, el
    mov [si], dl
    mov [si+1], dl
    add si, 1
    add si, dx
    mov [si+1], '$' 
    pop ax
     
    c6:
        xor dx, dx 
                   
        div bx     
        xchg ax, dx
        add al, '0'
                   
        mov [si], al
        dec si
        xchg ax, dx
        cmp ax, 0
        je exit
    loop c6   
    
    exit:  
    pop cx
    pop bx
    pop ax
    ret    
endp    

proc output_mas_el
    push ax
    push bx
    push cx
    
    call to_string
    output el
    output tab
    
    pop cx
    pop bx
    pop ax  
    ret
endp    
                   
proc outputmas   
    
    lea di, mas   
    mov cl, [di+2]
    add di, 4
     
    c1: 
        call output_mas_el 
        add di, 2 
    loop c1
    ret    
endp         
 
proc inputmas 
    
    mov [mas], 10 
    mov [mas+2], 10
    lea di, mas
    add di, 4    
    mov cx, [mas + 2]
    lea si, el
    c2:     
        call get_number
        cmp [si+2], '-'
        jne continue
        neg bx
        continue: 
        mov [di], bx
        add di, 2  
    endl
    loop c2
    ret
endp   
                                    
proc get_number  ;number will be in BX
    
    push di
    push si 
    push cx
    
    begin:
    input el
    
    lea di, el
    test di, di
    jz error 
    add di, 2
    
    mov si, 10
           
    xor ax, ax 
    xor bx, bx 
    mov cx, [el+1]
    xor ch, ch 
    
    cmp [di], '+'
    jne skip
    
    skip_letter:
        inc di
        dec cx
    jmp cycle1  
            
    skip:        
    cmp [di], '-'
    je skip_letter
       
    cycle1:         
        cmp [di], ' '
        je end
        mov bx, [di]  
        xor bh, bh
        cmp bx, '0'
        jl error
        cmp bx, '9'
        jg error
        
        sub bx, '0'
        mul si  
        jc error
        add ax, bx
        jc error  
        inc di
    loop cycle1 
    mov bx, ax  
    success:
    pop cx 
    pop si
    pop di
    jmp end
    
    error:
        output EX_INCORRECT_INPUT
        endl
        jmp begin
               
    end:
    ret
endp 

macro input buffer   
    push ax  
    push dx
    
    mov [buffer], 200   
    mov [buffer + 1], 0
    lea dx, buffer
    mov ah, 0ah
    int 21h
    
    mov ax, [buffer + 1]
    add dx, ax
    mov dx, '$'
     
    pop dx
    pop ax   
endm    
    
macro output buffer
    push dx
    push ax 
    
    lea dx, buffer+2                      
    mov ah, 9                  
    int 21h  
    
    pop ax
    pop dx
endm    
    
macro endl         
    output otst
endm                 

proc wait_for_key
    push ax
    
    output press_key
    endl
    mov ah, 1
    int 21h
    
    pop ax 
    ret
endp    
    
proc task
    _task:
    endl 
    output write_left
    call get_number ;left 
    cmp [si+1], '-'
    jne cont1
    neg bx
    cont1:  
    ;call wait_for_key
    push bx
    endl

    output write_right
    call get_number ;right 
    cmp [si+1], '-'
    jne cont2
    neg bx
    cont2:  
    ;call wait_for_key 
    push bx
    endl
    
    lea di, mas
    mov cx, [di+2]
    add di, 4
    pop bx
    pop ax
    
    ;call wait_for_key
    
    cmp ax, 0
    js step1
    jmp step2
    
    step1:
    cmp bx, 0
    jns c
    cmp ax, bx
    jg error2
    jmp go
    
    step2:
    cmp bx, 0
    js error2
    cmp ax, bx
    jg error2
    jmp go
    
    go:
    output your_elements
    endl
    
    c:    
        ;call wait_for_key
        cmp [di], 0
        js step3
        jmp step4 
        
        step3:
        cmp ax, 0
        jns next_step
        cmp [di], ax
        jb next_step
        cmp bx, 0
        jns success2
        cmp [di], bx
        jg next_step
        jmp success2
        
        step4:
        cmp ax, 0
        js step41
        cmp [di], ax
        jb next_step
        cmp [di], bx
        jg next_step
        jmp success2
        
        step41:
        cmp bx, 0
        js next_step
        cmp [di], bx
        jg next_step
        jmp success2
        
        
        success2:
            call output_mas_el          
        next_step: 
            add di, 2   
    loop c
    ret
    error2:
        output EX_BORDER
        endl
        jmp _task
        
    ret    
endp
    
start:

    mov ax, data
    mov ds, ax
    mov es, ax         
     
    output start_mes
    endl
    call inputmas 
    endl
        
    output your_massive
    endl    
    call outputmas     
    
     
    call task
        
    mov ah, 1
    int 21h
    
    mov ax, 4c00h
    int 21h    
ends

end start