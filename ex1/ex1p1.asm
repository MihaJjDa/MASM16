include io.asm

stack segment stack
	dw 128 dup (?)
stack ends

data segment
	S1 db 'Пучкин Данила, 112 группа, задача 1.1', '$'
	AS1 dw S1
	S2 db 'Введите натуральное число', '$'
	AS2 dw S2
	S3 db 'Степень тройки данного числа (-1 - число не является степенью тройки): ', '$'
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
	
	inint AX; ввод натурального числа
	
	mov DX, AS3
	outstr
	
	mov CL, 0; начальная степень
	mov BX, 3; ввод делителя
  
	L:	cmp AX, 1; N ? 1
		jE OPK; N=1 => вывод степени

		mov DX, 0; формирование делимого
		div BX; N / 3
		cmp DX, 0; N mod 3 ? 0
		jNE KS1; N не кратно 3 => Вывод -1
		inc CX; повысить степень
		jmp L; степень не ясна, на начало цикла
		
	KS1:mov CX, -1; -1 на регистр
		outint CX; вывод -1
	    jmp ex; стоп
	
	OPK:mov CH, 0; формирование ответа
		outword CX; вывод степени
  
ex:	newline
	mov AH, 8; удерживать
	int 21h;   ответ
	finish
code ends
    end start 
