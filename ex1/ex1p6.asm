include io.asm

stack segment stack
	dw 128 dup (?)
stack ends

data segment
	S1 db 'Пучкин Данила, 112 группа, задача 1.6', '$'
	AS1 dw S1
	S2 db 'Введите число в пятеричной системе счсления', '$'
	AS2 dw S2
	S3 db 'Запись числа в десятичной системе счисления: ', '$'
	AS3 dw S3
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
	
	mov BX, 5; 5 - требуемая система счисления
	
	mov AX, 0; подготавливаем регистры
	mov CH, 0; необходим для сложения CL с AX, в цикле не меняется
	L: 	inch CL
		cmp CL, ' '; ждем конца числа
		jE on; конец числа => на вывод
		
		sub CL, '0'; вычисление цифры
		mul BX; схема
		add AX, CX; Горнера
		jmp L; продолжить ввод цифр
	
	on:	mov DX, AS3
		outstr
		outnum AX
	
	newline
	mov AH, 8; удерживание
	int 21h;   ответа
	finish
code ends
    end start
	