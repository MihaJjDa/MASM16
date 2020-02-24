include io.asm

stack segment stack
	dw 128 dup (?)
stack ends

data segment
	N dw ?
	S1 db 'Пучкин Данила, 112 группа, задача 1.2', '$'
	AS1 dw S1
	S2 db 'Введите натуральное число, большее 1', '$'
	AS2 dw S2
	S3 db 'Данное число - составное', '$'
	AS3 dw S3
	S4 db 'Данное число - простое', '$'
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
	
	inint N; ввод натурального числа
	
	mov AX, N;
    cmp AX, 2; особый случай N = 2, т.к. первое деление будет без остатка и программа решит,
	jE PR; что 2 - составное. заводить счетчик считаю худшим вариантов, нежели одно сравнение
	
	mov BX, 2; формирование первого делителя
	mov DX, 0; формирование максимального делителя
	div BX;
	mov CX, AX; N div 2 -> CX
	
	L:	mov AX, N; формирование делимого
		mov DX, 0
		
		div BX; деление N на текущий делитель, ищем остаток
		
		cmp DX, 0; сравнение остатка с 0
		jE NPR; N mod BX = 0 => N - составное => выход из цикла
		
		cmp BX, CX; сравнение делителя с максимальным
		jAE PR; текущий делитель больше либо равен максимальному => выход из цикла, число простое
			; больше - отдельный случай для двойки (2 div 2 = 1 <> BX = 2, а нужно выходить из цикла сразу)
		inc BX; формируем следующий делитель
		jmp L; на начало цикла
		
	NPR:mov DX, AS3
		outstr
		jmp ex
		
	PR:mov DX, AS4
		outstr
	
ex:	newline
	mov AH, 8; удерживать
	int 21h;   ответ
	finish
code ends
    end start 
