include io.asm

stack segment stack
	dw 128 dup (?)
stack ends

data segment
	S1 db 'Пучкин Данила, 112 группа, задача 2.2', '$'
	S2 db 'Введите целое число от 2 до 5', '$'

	z2 db 'неуд', '$'
	z3 db 'удовл', '$'
	z4 db 'хорошо', '$'
	z5 db 'отлично', '$'
	adr dw z2, z3, z4, z5

data ends

code segment 'code'
	assume ss:stack, ds:data, cs:code

start:
	mov ax,data
	mov ds,ax
	
	lea DX, S1 
	outstr
	newline
	
	lea DX, S2
	outstr
	newline
	
	inint BX
	sub BX, 2; формируем модификатор
	add BX, BX; массив слов, удваиваем модификатор
	
	mov DX, adr[BX]
	outstr
  
	newline
	mov AH, 8; удерживать
	int 21h;   ответ
	finish
code ends
    end start 
