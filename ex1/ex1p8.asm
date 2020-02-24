include io.asm

stack segment stack
	dw 128 dup (?)
stack ends

data segment
	S1 db 'Пучкин Данила, 112 группа, задача 1.8', '$'
	AS1 dw S1
	S2 db 'Введите сумму вида D1+-D2+-..+-Dk, 0<=Di<=9, k>=1', '$'
	AS2 dw S2
	S3 db 'Результат: ', '$'
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
	
	inch AL
	sub AL, '0'; формируем начальное значение суммы D1
	mov AH, 0; использую полный регистр, ибо неизвестно когличество слагаемых (вдруг 100 слагаемых и все 9)
	
	L: 	inch BL; поиск точки либо знака
		cmp BL, '.'; конец суммы => на выход
		jE oi
		
		inch CL; считываем очередную цифру
		sub CL, '0'; формируем очередное слагаемое
		mov CH, 0
		cmp BL, '+'; определяем знак слагаемого
		jE N; если +, то пропускаем neg
		neg CX
	N:	add AX, CX; формируем сумму
		jmp L; на очередное слагаемое
	
	oi:	mov DX, AS3
		outstr
		outint AX		
		
	newline
	mov AH, 8; удерживание
	int 21h;   ответа
	finish
code ends
    end start
	