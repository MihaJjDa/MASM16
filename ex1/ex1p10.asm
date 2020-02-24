include io.asm

stack segment stack
	dw 128 dup (?)
stack ends

data segment
	S1 db 'Пучкин Данила, 112 группа, задача 1.10 '$'
	AS1 dw S1
	S2 db 'Таблица умножения однозначных чисел', '$'
	AS2 dw S2
	S3 db '  |  0  1  2  3  4  5  6  7  8  9', '$'
	AS3 dw S3
    S4 db 33 dup('-'), '$'
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
	
	mov DX, AS3
	outstr
	newline
	
	mov DX, AS4
	outstr
	
	mov BX, 0; начальное значение столбцовых множителей (word - для вывода)
	; BH во время выполнения программы всегда 0
	mov CX, 10
	L:	newline
		outnum BX
		outch ' '
		outch '|'
		mov DL, 0; начальное значение строковых множителей
		mov SI, CX
		mov CX, 10
		K: 	mov AL, BL; столбцовый множитель в регистр()
			mul DL; значение для таблицы, AH не нужно обнулять
			outnum AX, 3
			inc DL; следующий строковый множитель
			loop K
		mov CX, SI
		inc BX; следующий столбцовый множитель	
		loop L
	
	newline
	mov AH, 8; удерживание
	int 21h;   ответа
	finish
code ends
    end start
	