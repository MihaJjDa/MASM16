include io.asm

stack segment stack
	dw 128 dup (?)
stack ends

data segment
	S1 db 'Пучкин Данила, 112 группа, дополнительная задача 2.2', '$'
	S2 db 'Введите длинные числа (не более 10 чисел с не более чем 10-ью цифрами):', '$'
	S3 db 'Ошибка ввода! Прерывание работы'
	
	D dd 10 dup(?)
	BUF dd 0
	ANS db 10 dup(?), '$'

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
	mov CX, 10
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
		sub BP, 10
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
	sub BP, 10
	neg BP
	add BP, BP
	add BP, BP
		
	mov AX, word ptr BUF; загружаем в массив очередное длинное число
	mov word ptr D[BP], AX
	mov AX, word ptr BUF + 2
	mov word ptr D[BP] + 2, AX
	dec CX; уменьшаем на 1 регистр для дальнейшнего вывода

	; ВЫВОД
	mov BP, 10; делитель
	mov SI, -1; счетчик фактического адреса массива
	
	sub CX, 10; подготавливаем количество шагов цикла в зависимости от количества введенных чисел
	neg CX
	O:	push CX
		
		inc SI; переход к следующей ячейке
		mov BX, SI; формирование модификатора
		add BX, BX
		add BX, BX
		
		mov AX, word ptr D[BX]; число в буфер
		mov word ptr BUF, AX
		mov AX, word ptr D[BX] + 2
		mov word ptr BUF + 2, AX
		
		mov CX, 10
	    O1:	mov DX, 0; поиск очередной цифры через деление
			mov AX, word ptr BUF + 2
			div BP
			mov word ptr BUF + 2, AX
			mov AX, word ptr BUF
			div BP
			mov word ptr BUF, AX
			
			mov BX, CX; формирование модификатора
			add DL, '0'; формирование символа цифры
			mov ANS[BX-1], DL; запись очередной цифры
			cmp word ptr BUF, 0; проверка на незначащие нули 1
			jNE O2
			cmp word ptr BUF + 2, 0; проверка на незначащие нули 2
		O2:	loopNE O1
		
		lea DX, ANS[BX-1]
		outstr
		newline
		
		pop CX
		loop O

	jmp short ex
err:lea DX, S3
	outstr
	
ex:	mov AH, 8; удерживать
	int 21h;   ответ
	finish
code ends
    end start 
