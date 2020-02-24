include io.asm

stack segment stack
	dw 128 dup (?)
stack ends

data segment
	S1 db 'Данила Пучкин, 112 группа, задача 3.2', '$'
	S2 db 'Введите шестнадцатеричное число с пробелом в конце(не более 4 цифр)', '$'
	
	HEX db '0123456789ABCDEF'

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
	
	xor AX, AX
	mov CL, 4
	
I:	inch BL; ввод простой, позвольте без комментариев
	cmp BL, ' '
	jNE I1
	jmp OU
	
I1:	sub BL, '0'
	cmp BL, 10
	jB A
	add BL, '0'-'A'+10
A:	shL AX, CL
	or AL, BL
	jmp I

OU:	mov CX, 4;
	
L:	RoL AX, 1; вывод тоже
	RoL AX, 1
	RoL AX, 1
	RoL AX, 1
	mov BX, AX
	and BX, 0Fh
	outch HEX[BX]
	loop L

ex:	newline
	mov AH, 8; удерживаю
	int 21h;   ответ
	finish
code ends
    end start 
