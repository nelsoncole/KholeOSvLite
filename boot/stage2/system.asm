; "system.asm"
;
; Projecto "Projecto KholeOS. Bootloader" 
; Nelson Sapalo da Silva Cole  (nelsoncole72@gmail.com  +244-948-833-132)
; Lubango 18 de Julho de 2017
;


bits 16
global puts16, gateA20, gdtr,gdt


; Display
puts16:
	pusha	
.next:
	cld 		
	lodsb		
	cmp al,0	
	je  .end	
	mov ah,0x0e
	int 0x10
	jmp .next
.end:
	popa
	ret


; Gate A20

gateA20:
	pusha
	cli
; Desabilita teclado
	call a20_wait1
	mov al,0xAD
	out dx,al

;Ler o status gate a20
	call a20_wait1
	mov al,0xD0	
	out 0x64,al

	call a20_wait0
	in al,0x60	;ler o status lido
	mov cl,al

;Escreve status gate a20
	call a20_wait1
	mov al,0xD1	
	out 0x64,al

; Hablita a gate a20
	call a20_wait1
	mov al,cl
	or al,2		;liga o bit 2
	out 0x60,al	

; Habilita o teclado
	call a20_wait1
	mov al,0xAE
	out 0x64,al

	call a20_wait1	;Espera
	sti		;Habilita interrupcoes
	popa
	ret

a20_wait0:
	in al,0x64
	test al,1
	jz a20_wait0  
	ret




a20_wait1:
	in al,0x64
	test al,2
	jnz a20_wait1
	ret



section .data
gdt:

;0x0 Entrada Nula
	dw 0	; Limit
	dw 0	; Base 15:00
	db 0	; Base 23:16
	db 0	; Flags
	db 0	; Flags e Limit 19:16
	db 0	; Base 31:24

; 0x8 CS LIMIT 0xFFFFF, BASE 0x00000000, DPL=0, G=1, S=1 code ou data
	dw 0xFFFF
	dw 0
	db 0
	db 0x9A
	db 0xCF
	db 0	
	

; 0x10 DS LIMIT 0xFFFFF, BASE 0x00000000, DPL=0, G=1, S=1 code ou data
	dw 0xFFFF
	dw 0
	db 0
	db 0x92
	db 0xCF
	db 0

gdt_end:

gdtr:
	dw gdt_end - gdt -1	; LIMIT
	dd gdt			; BASE

