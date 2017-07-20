/* Arquivo "boot.h"
	"Projecto KholeOS. Bootloader!"
	
	Nelson Sapalo da Silva Cole (nelsoncole72@gmail.com)
	
	Lubango, 20 de Julho de 2017
*/



#ifndef __BOOT_H__
#define __BOOT_H__

#define inb(p)({\
	unsigned char val;\
	__asm__ __volatile__(\
		"inb %%dx,%%al":"=a"(val):"dN"(p));\
	val; })

#define outb(p,val)__asm__ __volatile__(\
		"outb %%al,%%dx"::"a"(val),"dN"(p))



typedef unsigned char BYTE;
typedef	unsigned short WORD;
typedef	unsigned long DWORD;
typedef	unsigned long long QWORD;



void update_cursor();
void set_cursor(int x, int y);
void set_color(const char cor);
void putch (char c);
void puts(char *string);












#endif
