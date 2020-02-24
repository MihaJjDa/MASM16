include io.asm

stack segment stack
	dw 128 dup (?)
stack ends

data segment
	S1 db 'Пучкин Данила, 112 группа, задача 2.3', '$'
	S2 db 'Введите целое число', '$'
	
	N db 5 dup(0), '$'

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
	
	mov BX, 10; формируем делитель
	mov CX, 5; максимальное количество шагов цикла
	mov DH, 0; формируем остаток, в цикле работаем только с DL
	
	inint AX
	cmp AX, 0; проверяем, не отрицательное ли число
	jGE L; если нет => сразу в цикл	
	outch '-'; иначе выводим минус
	neg AX; и работаем с модулем числа
	
	L: 	mov DL, 0;формируем делимое
		div BX; в AX - оставшееся непереведенное число, в DL - цифра десятичной записи числа, в DH - 0
		add DL, '0'; формируем символ соответствующий цифре
		mov BP, CX; формируем модификатор для массива, хранящего число в символьной записи
		mov N[BP-1], DL; заносим в массив очередную цифру
		cmp AX, 0; дополнительная проверка, отслеживаем обнуление делимого
		loopNE L; если делимое ноль => на выход
		
	lea DX, N[BP-1]
	outstr
	
	newline
	mov AH, 8; удерживать
	int 21h;   ответ
	finish
code ends
    end start 
