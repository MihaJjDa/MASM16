include io.asm

stack segment stack
	dw 128 dup (?)
stack ends

data segment
	S1 db 'Пучкин Данила, 112 группа, задача 1.3', '$'
	AS1 dw S1
	S2 db 'Введите последовательность символов с точкой в конце', '$'
	AS2 dw S2
	S3 db 'Последовательность сбалансирована по скобкам', '$'
	AS3 dw S3
	S4 db 'Последовательность не сбалансирована по скобкам', '$'
	AS4 dw S4

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
	
	mov AH, 0; счетчик
	
	L:	inch AL
	
		cmp AL, '.'; ищем конец последовательности
		jE cp; конец последовательность => на проверку баланса
		
		cmp AL, ')'; работа с закрывающей скобкой
		jNE L1; не закрывающаяся => проверка на открывающую
		sub AH, 1
		cmp AH, 0
		jL NB; знаковое сравнение, если счетчик отрицателен => последовательность не сбалансирована
		jmp L; на новый символ
		
	L1:	cmp AL, '('
		jNE L; не открывающая => на новый символ
		add AH, 1
		jmp L; на новый символ
		
	cp:	cmp AH, 0; проверка счетчика
		jNE NB; счетчик скобок <> 0 => нет баланса скобок
		
		mov DX, AS3
		outstr
		jmp ex
		
	NB:	mov DX, AS4
		outstr
		
	
ex:	newline
	mov AH, 8; удерживание
	int 21h;   ответа
	finish
code ends
    end start 
