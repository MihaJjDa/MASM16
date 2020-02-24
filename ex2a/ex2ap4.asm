include io.asm

stack segment stack
	dw 128 dup (?)
stack ends

data segment
	S1 db 'Пучкин Данила, 112 группа, дополнительная задача 2.4', '$'
	S2 db 'Введите 2 числа:', '$'
	S3 db 'Ошибка ввода! Прерывание работы'
	S4 db 'Произведение этих чисел:', '$'
	
	D dd 2 dup(?)
	W dd 2 dup(?)
	BUF dd 2 dup (0)
	ANS db 20 dup(0), '$'

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
	
	;ВВОД
	mov SI, 10
	mov BH, 0
	mov CX, 2
	I:	inch BL
		cmp BL, '.'; ищем конец ввода
		jNE K; если не конец => продолжаем работу
		jmp OU; если конец => на подготовку к выводу
		
K:		cmp BL, ','; ищем конец числа
		jNE G; если не конец => продолжаем ввод числа
		jmp I1; если конец => заносим число в массив
			
G:		cmp BL, '0'; проверяем корректность ввода
		jB F
		cmp BL, '9'
		jA F
		jmp short P; корректный ввод => продолжаем формировать число
F:		jmp err 
		
P:		sub BL, '0'; формируем цифру

		mov AX, word ptr BUF; умножение младшей части числа на 10
		mul SI
		mov DI, AX; спасаем результаты первого умножения
		mov BP, DX
		
		mov AX, word ptr BUF + 2; умножение старшей части числа на 10
		mul SI
		
		cmp DX, 0; проверяем переполнение
		jNE E
		add DI, BX; формируем число
		adc BP, AX
		jC E; проверяем переполнение
		jmp short U
E:		jmp err
U:		mov word ptr BUF, DI; сохраняем в буфер текущее число
		mov word ptr BUF + 2, BP
		
		jmp I; продолжаем ввод цифр

	I1: mov BP, CX; формирование модификатора
		sub BP, 2
		neg BP
		add BP, BP
		add BP, BP
		
		mov AX, word ptr BUF; загружаем в массив очередное длинное число
		mov word ptr D[BP], AX
		mov AX, word ptr BUF + 2
		mov word ptr D[BP] + 2, AX
		
		mov word ptr BUF, 0; обнуляем буфер для дальнейшей работы
		mov word ptr BUF + 2, 0
		loop I
	

OU:	; работа с последним введенным числом
	mov BP, CX; формирование модификатора
	sub BP, 2
	neg BP
	add BP, BP
	add BP, BP
		
	mov AX, word ptr BUF; загружаем в массив очередное длинное число
	mov word ptr D[BP], AX
	mov AX, word ptr BUF + 2
	mov word ptr D[BP] + 2, AX
	; УМНОЖЕНИЕ
	mov AX, word ptr D; списал с тетрадки д/з, позвольте без комментариев, схему выучил на зубок
	mul word ptr D[4]
	mov word ptr W, AX
	mov word ptr W[2], DX
	
	mov AX, word ptr D[2]
	mul word ptr D[6]
	mov word ptr W[4], AX
	mov word ptr W[6], DX
	
	mov AX, word ptr D
	mul word ptr D[6]
	add word ptr W[2], AX
	adc word ptr W[4], DX
	adc word ptr W[6], 0
	
	mov AX, word ptr D[2]
	mul word ptr D[4]
	add word ptr W[2], AX
	adc word ptr W[4], DX
	adc word ptr W[6], 0
	
	; ВЫВОД
OT:	lea DX, S4
	outstr
	newline
	
	mov BP, 10; делитель
	
	mov BX, -2
	mov CX, 4
MVB:add BX, 2
	mov AX, word ptr W[BX]; число в буфер
	mov word ptr BUF[BX], AX
	loop MVB
		
	mov CX, 20
    O1:	push CX

			mov CX, 4
			mov BX, 8 
			mov DX, 0; поиск очередной цифры через деление
		O3:	sub BX, 2
			mov AX, word ptr BUF[BX]
			div BP
			mov word ptr BUF[BX], AX
			loop O3
			
		pop CX
		
		mov BX, CX; формирование модификатора
		add DL, '0'; формирование символа цифры
		mov ANS[BX-1], DL; запись очередной цифры
		
		push CX
		
		mov CX, 4
		mov SI, -2
		O4:	add SI, 2
			cmp word ptr BUF[SI], 0; проверка на незначащие нули
			jNE O2
			loop O4
			
	O2:	pop CX
		loopNE O1
	
		lea DX, ANS[BX-1]
		outstr
		newline
		
	jmp short ex
err:lea DX, S3
	outstr
	newline
	
ex:	mov AH, 8; удерживать
	int 21h;   ответ
	finish
code ends
    end start 
	