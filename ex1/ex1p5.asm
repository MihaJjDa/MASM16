include io.asm

stack segment stack
	dw 128 dup (?)
stack ends

data segment
	S1 db 'Пучкин Данила, 112 группа, задача 1.5', '$'
	AS1 dw S1
	S2 db 'Введите б/зн число', '$'
	AS2 dw S2
	S3 db 'Произведение младшей и старшей цифр: ', '$'
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
	
	inint AX
	 
	mov DX, 0; формируем делимое
	mov BX, 10; и делитель
	
	div BX
	
	mov CL, DL; младшая цифра найдена, ячейки byte достаточно, т.к. DX <= 10
	
	cmp AX, 0; ищем однозначное число
	jNE L; число не однозначное => переход к работе
	mov AL, CL; иначе в AL ту же цифру
	jmp M; на умножение
	
	L:	cmp AX, 10; ищем старшую цифру
		jB M; старшая цифра найдена => на умножение
		
		mov DX, 0; формируем делимое
		div BX
		jmp L; продолжаем делить
	
	M:	mul CL
	
	mov DX, AS3
	outstr
	outint AX
	
	newline
	mov AH, 8; удерживание
	int 21h;   ответа
	finish
code ends
    end start
	