org 100h
start:

mov ah, 0
mov al, 3
int 10h
 
mov ax, 0       
mov es, ax

mov al, 23h
mov bl, 4h    
mul bl          
mov bx, ax 

mov si, offset [new23] 
mov es:[bx], si
add bx, 2		
   
mov ax, cs      
mov es:[bx], ax
    
int 23h   
  
mov si,offset bufer[0] 
l1:
cmp [si],0
je exit
  
mov ah,2h             
mov dl,[si]            
int 21h
inc si
  
mov al,0               
mov ah,01h
int 16h
cmp al,0  
je noRead
 
mov ah,00h        
int 16h
cmp al,3h		
je exit
noRead:     
jmp l1
  
exit:
int 20h 

new23:  
	   pusha

       push cs
       pop ds

     
       mov     ax, 0b800h
       mov     es, ax
             
       mov dx,offset f_name 
       mov ah,3Dh    
       mov al,02h    
       int 21h  

       mov handle,ax 
       mov    cx,0   
       mov    dx,0        
       mov    bx,handle   
       mov    ax,4200h    
       int    21h  
       
       mov ah, 3fh        
       lea dx, bufer
       mov cx,es 
       int 21h   
       
       mov ah,3Eh         
       int 21h 
stop:
       popa               
       iret  			
 
f_name db 'myfile.txt',0  
handle     dw  0
bufer db 250 dup(0) 