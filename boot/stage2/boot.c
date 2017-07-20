/* Arquivo "boot.c"
   
	"Projecto KholeOS, Bootloader!"
	
	Nelson Sapalo da Silva Cole (nelsoncole72@gmail.com  +244-948-833-132)

  	Lubango, 18 de Julho de 2017

*/


#include <boot.h>

#define MEMORIA_START 0xB8000
#define MEMORIA_END 0xC0000

	WORD *video=(WORD*)0xb8000;
	BYTE color = 0x0F;
	BYTE cursor_x = 0;
	BYTE cursor_y = 0;
	BYTE coluna = 80;
	


// Drive de video cursor. Nota que iremos programar o driver sem gerar interrupções
void update_cursor(){

	WORD posicao_cursor = cursor_y *coluna + cursor_x;
	
	outb(0x3D4,0xE);	// Comando cursor 15:8
	outb(0x3D5,(BYTE)(posicao_cursor >> 8) &0xFF);
	outb(0x3D4,0xF);	// Comando cursor 7:0
	outb(0x3D5,(BYTE)(posicao_cursor) &0xFF);
}

// Esta função posiciona o cursor na tela

void set_cursor(int x, int y){
	
	if(cursor_x <= 80)cursor_x = x;
	if(cursor_y <= 25)cursor_y = y;
	
	}



// Esta função define a cor do texto
void set_color(const char cor){
	 color = (cor & 0x0F);
 }



// Esta função imprime um caracter na tela
void putch (char c){

	WORD *posicao = video + (cursor_y *coluna + cursor_x);
	WORD atributo = color << 8;
	
	if(MEMORIA_START == MEMORIA_END){
		
		set_cursor(0,0);
		}
	
	if(c == '\b'&&cursor_x){
		cursor_x--;
		putch(' ');
		cursor_x--;
	 }
	 
	else if(c == '\t'){
		cursor_x = (cursor_x + 8) &~(8-1);
		}
		
	else if(c == '\n'){
		cursor_x = 0;
		cursor_y++;
		update_cursor();
	
		}
		
	else if(c >= ' '){
	
		*posicao = c | atributo;
    		cursor_x++;
	}
	
	else if(cursor_x >= 80){
		cursor_x =0;
		cursor_y++;
		}
		
	else if(cursor_y >= 25){
	
		// teremos que programar o scroll();
		
		}
		
	update_cursor();
}


// Esta função Imprime uma String na tela
void puts(char *string){


	int i;

	for(i=0;string[i]!= '\0';i++)putch(string[i]);

}



// Esta função imprime caracteres na tela tendo enconta o format %i, %c, %x, em outras palavras é um print formato

void printboot(const char *s, ...){

















}

