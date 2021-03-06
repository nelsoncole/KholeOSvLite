; "stage1.asm"
;
; Projecto "Projecto KholeOS. Bootloader" 
; Nelson Sapalo da Silva Cole (nelsoncole72@gmail.com  +244-948-833-132)
; Lubango 16 de Julho de 2017
;


bits 16			; diz ao nosso nasm que usaremos endereçamento de 16 -bits
org 0x7c00		; nosso offset
jmp short start		; pula para o início do programa

mensagem1 db "Erro no sector de boot",0

dap:
	db 0x10		; tamnho da DAP 16 bytes 
	db 0		; Reservado
	dw 16		; Numero de sotor a ler
	dw 0x8000	; Offset
	dw 0x0000	; Segmento
	dd 1		; sector start
	dd 0		; sector starting 

dap_end:



start:
	cli		; desabilita interrupções
	xor ax,ax	; zera ax
	mov ds,ax	; ds igual a 0
	mov es,ax	; es igual a 0
	mov ss,ax	; ss igual a 0
	mov sp,0x200	; 512 Bytes de pilha
	sti		; habilita interrupções


; Define o modo de vídeo, modo texto color
	mov ax,3
	int 0x10
	
; empura na pilha ax, si e ds
	push ax
	push si
	push ds
	
	mov si,dap	; entrada de parametros da DAP
	mov dl,0x80	; selecciona o disco 
	mov ah,0x42	; função da BIOSes read sector 
	int 0x13	; interrupção de disco

	jc erro		; se CF = 1 erro


; desempilha ds, si, ax
	pop ds
	pop si
	pop ax

	push dx			; empura dl na pilha
	jmp 0x0000:0x8000	; Executa o segundo estágio
	
	

erro:
; desempilha ds, si, ax
	pop ds
	pop si
	pop ax

	mov si,mensagem1
	call puts

	xor ax,ax
	int 0x16
	int 0x19	; reboot



; Função imprime string na tela

puts:
	pusha		; empilha todos os registradores de uso geral
.next:
	cld 		; flag de direcção
	lodsb		; a cada loop carrega si p --> al, actualizando si
	cmp al,0	; compara al com o 0
	je  .end	; se al for 0 pula para o final do programa	
	mov ah,0x0e	; função TTY da BIOS imprime caracter na tela
	int 0x10	; interrupção de vídeo
	jmp .next	; próximo caracter
.end:
	popa	; desempilha todos os registradores de uso geral
	ret	; retorna


times 512-2 - ($-$$) db 0		; esta rotina fará com que o código tenha 512 Bytes - os 2 últimos Bytes da assinatura 
dw 0xaa55	; Assinatura de boot
