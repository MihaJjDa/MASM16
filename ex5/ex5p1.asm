include io.asm

stack segment stack
	dw 128 dup (?)
stack ends

data segment
	WELC db 'ИГОРЬ ЛОХ', '$'
	HELLO db 'Введите текст из не более 100 символов с точкой в конце', '$'
	S db 100 dup(?)
	FIR db 'Первая обработка текста', '$'
	SEC db 'Вторая обработка текста', '$'

data ends



code segment 'code'
	assume ss:stack, ds:data, es:data, cs:code
	
	OUTP proc near
		;вход: BX - адрес текста, AX - длина текста
		;выход: вывод текста по адресу BX длины AX
		push CX
		push BX; спасение регистров
		push AX
		
		mov CX, AX; количество шагов вывода есть длина строки, которая в AX
		jCXZ OU2
		dec BX
	OU1:	inc BX; корректируем модификатор
		mov AL, [BX]; на регистр для вывода
		outch AL; вывод очередного символа
		loop OU1
		
	OU2:	pop AX
		pop BX
		pop CX
		ret
	OUTP endp
	
	
	PROP proc near
		;вход: X1 - адрес текста, X2 - длина текста
		;выход: установка ZF
		push BP
		mov BP, SP
		
		push CX
		push BX;
		push AX; спасение регистров
		
		mov BX, [BP+6]; адрес текста
		mov DI, [BP+4]; длина текста
		dec BX
		cmp byte ptr [BX], '0'
		jB NO
		cmp byte ptr [BX], '9'
		jA NO
		cmp byte ptr [BX][DI-1], '0'
		jB NO
		cmp byte ptr [BX][DI-1], '9'
		jA NO
		mov AL, [BX]
		mov AH, [BX][DI-1]		
		xor AL, AH; ZF=1 => одинаковые цифры, ZF=0 => иначе 
		jmp short fin
	NO:	xor AL, AL
		xor AL, 1; ZF = 0
		
	fin:	pop AX
		pop BX
		pop CX
		
		pop BP
		ret 4
	PROP endp
	
	
	PER1 proc near
		;вход: X1 - адрес текста, X2 - длина текста
		;выход: преобразованная строка
		push BP
		mov BP, SP
		
		push AX; спасение регистров
		push BX
		push CX
		push SI
		push DI
		
		cld
		mov SI, [BP+6]; в SI - адрес текста
		mov CX, [BP+4]; в CX - длина текста
		xor BH, BH; настройка модификатора для поиска больших букв
	P11:	lodsB; выгружаем очередной символ
		cmp AL, 'a'; ищем маленькую букву
		jB P12; если не нашли => на следующий шаг цикла
		cmp AL, 'a'
		jA P12; если не нашли => на следующий шаг цикла
		sub AL, 'a'; если нашли => вычисляем номер буквы
		mov BL, AL; формируем модификатор
		mov AL, cs:S1[BX]; загружаем в AL маленькую букву
		mov DI, SI; формируем модификатор для загрузки символа в текст
		dec DI
		mov ds:[DI], AL; загружаем в текст маленькую букву;
	P12:	loop P11
	
		pop DI
		pop SI
		pop CX
		pop BX
		pop AX
	
		pop BP
		ret 4
		S1 db 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'
	PER1 endp
	
	
	PER2 proc near
		;вход: X1 - адрес текста, X2 - длина текста
		;выход: преобразованная строка, AX - новая длина текста
		push BP
		mov BP, SP
		
		; спасение регистров
		push BX
		push CX
		push SI
		push DI
		
		cld
		mov SI, [BP+6]; в SI - адрес текста
		mov CX, [BP+4]; в CX - длина текста
		xor BH, BH; настройка модификатора для поиска больших букв
	P21:	lodsB; выгружаем очередной символ
		cmp AL, 'A'; ищем большую букву
		jB P22; если не нашли => ищем маленькую букву
		cmp AL, 'Z'
		jA P22; если не нашли => ищем маленькую букву
		sub AL, 'A'; если нашли => вычисляем номер буквы
		mov BL, AL; формируем модификатор
		inc byte ptr cs:S2[BX]; увеличиваем счетчик буквы
		jmp short P23
	P22:	cmp AL, 'a'; ищем маленькую букву
		jB P23; если не нашли => на следующий шаг цикла
		cmp AL, 'z'
		jA P23; если не нашли => на следующий шаг цикла
		sub AL, 'a'; если нашли => вычисляем номер буквы
		mov BL, AL; формируем модификатор
		inc byte ptr cs:S2[BX+26]; увеличиваем счетчик букв
	P23:	loop P21
	
	
		xor AH, AH; формируем новую длину строки
		mov SI, [BP+6]; в SI - адрес текста
		mov CX, [BP+4]; в CX - длина текста
		mov DI, [BP+6]
	P24:	lodsB; выгружаем очередной символ
		cmp AL, 'A'; ищем большую букву
		jB P25; если не нашли => ищем маленькую букву
		cmp AL, 'Z'
		jA P25; если не нашли => ищем маленькую букву
		mov BL, AL; формируем модификатор
		sub BL, 'A'
		cmp byte ptr cs:S2[BX], 1; проверяем количество вхождений буквы в текст
		jNE P27; если не 1 => на следующий шаг цикла
		jmp short P26; иначе выводим
	P25:	cmp AL, 'a'; ищем маленькую букву
		jB P27; если не нашли => на следующий шаг цикла
		cmp AL, 'z'
		jA P27; если не нашли => на следующий шаг цикла
		mov BL, AL; формируем модификатор
		sub BL, 'a'
		cmp byte ptr cs:S2[BX+26], 1; проверяем количество вхождений буквы в текст
		jNE P27; если не 1 => на следующий шаг цикла, иначе выводим
	P26:	inc AH; увеличиваем длину текста
		mov ds:[DI], AL; И ЭТО ЖЕ САМОЕ МЕСТО!!!!!
		inc DI
	P27:	loop P24
	
		mov AL, AH; формирование новой длины тексте в формате слова
		xor AH, AH
		
		pop DI
		pop SI
		pop CX
		pop BX
		
		pop BP
		ret 4
		S2 db 26*2 dup(0)
	PER2 endp
	
	

start:
	mov AX, data
	mov DS, AX
	
	lea DX, WELC
	outstr
	newline
	lea DX, HELLO
	outstr
	newline
	
	; ввод текста
	xor BX, BX; подготовка модификатора
	mov CX, 100; максимальная длина текста
IN1:	inch AL; ввод очередного символа
	cmp AL, '.'; ищем конец текста, точку в текст не заношу
	jE IN2; нашли => на выход
	mov S[BX], AL; иначе заносим в массив символ
	inc BL; и корректируем модификатор (в итоге в BX будет храниться длина текста)
	loop IN1
IN2:	mov AX, BX
	lea BX, S


	; проверка свойства
	push BX
	push AX
	call PROP
	jZ PERF2
	
	; первая обработка
	lea DX, FIR 
	outstr
	newline
	push BX
	push AX
	call PER1
	jmp OUT1

PERF2:; вторая обработка
	lea DX, SEC 
	outstr
	newline	
	push BX
	push AX
	call PER2
	
	; вывод текста 
OUT1:	call OUTP
	
EX:	mov AH, 8; удержание
	int 21h;   ответа
	newline
    finish
code ends
    end start
