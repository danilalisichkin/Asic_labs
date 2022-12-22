.code
org 100h  

start: 
    call command_line
    str_to_num number,numberSize  
continue:
    mov getNumber, ax 
        
    cmp ax, max_size     
    ja bad_input     
    cmp ax, 1     
    jl bad_input          
    
newProgram:
    mov ax, cntPrograms
    cmp ax, getNumber  
    jae exit           
      
    mov sp, program_length+100h+200h
    mov ah, 4Ah 
    stack_shift = program_length+100h+200h
    mov bx, stack_shift shr 4+1 
    int 21h  
      
    moj kwlv ax, cs  
    mov word ptr EPB+4, ax 
    mov word ptr EPB+8, ax 
    mov word ptr EPB+0Ch, ax 
    
   mov ax, 4B00h 
   mov dx, offset program_path
   mov bx, offset EPB
   int 21h
    
   inc cntPrograms
   jmp newProgram

exit:   
   int 20h 

command_line proc     
    push cx 
    push si
    push di
    push ax
    
    xor cx, cx 
    mov cl, es:[80h]       
    cmp cl, 0   
    je no_command_line
    
    mov di, 82h            
    mov si, offset number  
read:                      
    mov al, es:[di]        
    cmp al, 20h            
    je bad_input 
    cmp al, 0Dh     
    je param_is_ended
    
    mov [si], al 
    inc di
    inc numberSize
    cmp numberSize,3
    jg no_command_line 
    inc si 
    jmp read     
   
param_is_ended:
    mov [si], 24h   
    pop ax
    pop di 
    pop si 
    pop cx 
    
    ret    
command_line endp 
                                     
no_command_line:                     
    cout [exc_cmd_message]
    jmp   exit   
   
      
cout macro value
    push ax
    push dx                   
    mov ah, 09h  
    lea dx, value
    int 21h
    pop dx
    pop ax     
endm        
 
 
str_to_num macro number, size        
    push cx                
    push dx
    push bx
    push si
    push di
          
    xor ax,ax
    xor dx,dx
    mov dl,[number]
    mov ax,size
                                   
    lea si,number                 
    mov di,10                     
    mov cx,ax                     
    jcxz bad_input                
    xor ax,ax                     
    xor bx,bx     
    xor dx,dx
    mov bl,byte ptr[si]           
    push bx                       
    cmp bl,'-'                    
    jne loop_input                
    jmp bad_input
endm
 

loop_input:                       
    mov bl,[si]                   
    inc si                        
    cmp bl,'0'                    
    jl bad_input                  
    cmp bl,'9'                    
    jg bad_input                  
    sub bl,'0'                    
    mul di                        
    jc bad_input                  
    add ax,bx                     
    jc overflaw                   
    loop loop_input               
    jmp end_input                 

bad_input:                        
    xor ax,ax                     
    cout [exc_cmd_message]        
    jmp exit        

overflaw:
    cout [exc_overflaw_message]
    jmp exit

end_input:
    pop bx                             
    pop di                 
    pop si
    pop bx
    pop dx
    pop cx
    jmp continue   

number       db  9 dup(0)
numberSize   dw  0   
getNumber    dw  ?
max_size     equ 255
cntPrograms  dw 0

program_path db "hi-world.com", 0          
EPB          dw 0000                       
             dw offset commandline,0       
             dw 005Ch,0,006Ch, 0           
commandline  db 125                        
             db " /?"                      
command_text db 122 dup (?)                
program_length equ $-start                    

exc_cmd_message db "Error !!! N must E [1;255].", '$'   
exc_program_path_message db "Program path is not found !!!", '$'
exc_overflaw_message db "OWERFLAW !!!", '$'    
end start 