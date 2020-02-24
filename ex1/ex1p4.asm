include io.asm

stack segment stack
	dw 128 dup (?)
stack ends

data segment
	P dw ?
	Q dw ?
	S1 db 'Пучкин Данила, 112 группа, задача 1.4', '$'
	AS1 dw S1
	S2 db 'Введите дробь в формате P/Q', '$'
	AS2 dw S2
	S3 db 'Введите P', '$'
	AS3 dw S3
	S4 db 'Введите Q', '$'
	AS4 dw S4
	S5 db 'Число в десятичной дроби: ', '$'
	AS5 dw S5
data ends

code segment 'code'
	assume ss:stack, ds:data, cs:code

start:
	mov ax,data
	mov ds,ax
	
	mov DX, AS1 
	outstr
	newline
	
	mov DX, AS2
	outstr
	newline
	
	mov DX, AS3
	outstr
	newline
	
	inint P
	
	mov DX, AS4
	outstr
	newline
	
	inint Q
	
	mov AX, P; поиск целой части 
	mov DX, 0
	mov BX, Q
	
	div BX
	
	outword AX
	
	outch '.'
	
	mov SI, 10
	
	mov CX, 5
	L:	mov AX, DX; поиск очередной десятичной цифры дробной части
	    mul SI
		div BX
		outword AX
		loop L
			
	newline
	mov AH, 8; удерживание
	int 21h;   ответа
	finish
code ends
    end start
	