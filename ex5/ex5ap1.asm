include io.asm

stack segment stack
	dw 128 dup (?)
stack ends

data segment
	MaxSize equ 1000
	n dw ?
	m dw ?
	X dw MaxSize dup(?)
	
	WELC db 'Данила Пучкин, группа 112, задача 5.1 дополнительная', '$'
	MSTR db 'Введите количество строк матрицы', '$'
	MCOL db 'Введите количество столбцов матрицы', '$'
	ERSC db 'Ошибка ввода размеров!', '$'
	YN db 'Повторить ввод размеров матрицы?(Y/N)', '$'
	MCL db 'Введите матрицу данных размеров', '$'
	MOU db 'Введенная матрица:', '$'
	SND db 'Упорядоченные по неубыванию строки: ', '$'
	SSM db 'Симметричные строки: ', '$'
	ECOL db 'Столбцы с равными элементами: ', '$'
	MDG db 'Главная диагональ: ', '$'
	SDG db 'Побочная диагональ: ', '$'
	NY db 'Продолжить работу программы?(Y/N)', '$'
data ends

pr segment 'code'
	assume ss:stack, cs:pr, ds:data
	
	outm proc far
		;вход: X1 - сегмент матрицы, X2 - адрес матрицы в сегменте, 
		;X3 - количество строк матрицы, X4 - количество столбцов матрицы
		;выход: вывод матрицы
		push BP
		mov BP, SP
		
		push AX
		push BX
		push CX
		push DX
		push ds
		
		mov DX, [BP + 6]
		mov CX, [BP + 8]; на CX - количество строк
		mov BX, [BP + 10]
		mov AX, [BP + 12]
		mov ds, AX		

	OM:	push CX
		mov CX, DX
	OS:	mov AX, ds:[BX]; вывод строки
		outint AX
		outch ' '
		add BX, 2
		loop OS
		newline
		pop CX
		loop OM
		
		pop ds
		pop DX
		pop CX
		pop BX
		pop AX
		
		pop BP
		
		ret 2*4		
	outm endp
	
	nondec proc far
		;вход: X1 - сегмент матрицы, X2 - адрес матрицы в сегменте, 
		;X3 - количество строк матрицы, X4 - количество столбцов матрицы
		;выход: вывод номеров строк, упорядоченных по неубыванию
		push BP
		mov BP, SP
		
		push AX
		push BX
		push CX
		push DX
		push ds
		push DI
		
		mov DX, [BP + 6]
		mov CX, [BP + 8]; на CX - количество строк
		mov BX, [BP + 10]
		mov AX, [BP + 12]
		mov ds, AX	
		
		mov DI, 1
	NDM:	push CX
		mov CX, DX
		dec CX
	NDS:	mov AX, ds:[BX]; проверка строки
		cmp AX, ds:[BX+2]
		jG ND
		add BX, 2
		loop NDS
		outword DI
		outch ' '
	ND:	add BX, 2
		shL CX, 1
		add BX, CX
		inc DI
		pop CX
		loop NDM
		
		pop DI
		pop ds
		pop DX
		pop CX
		pop BX
		pop AX
		
		pop BP
		
		ret 2*4		
	nondec endp
	
	sim proc far
		;вход: X1 - сегмент матрицы, X2 - адрес матрицы в сегменте, 
		;X3 - количество строк матрицы, X4 - количество столбцов матрицы
		;выход: вывод номеров симметричных строк
		push BP
		mov BP, SP
		
		push AX
		push BX
		push CX
		push DX
		push ds
		push DI
		push SI
		
		mov DX, [BP + 6]
		mov CX, [BP + 8]; на CX - количество строк
		mov BX, [BP + 10]
		mov AX, [BP + 12]
		mov ds, AX	
		
		mov DI, 1
	SIMM:	push CX
		mov CX, DX; количество шагов для проверки строки
		shR CX, 1
		mov SI, BX; модификатор от конца строки
		shL DX, 1
		add SI, DX
		sub SI, 2
		shR DX, 1
		push BX
	SIMS:	mov AX, ds:[BX]; проверка строки
		cmp AX, ds:[SI]
		jNE NS
		add BX, 2
		sub SI, 2
		loop SIMS
		outword DI
		outch ' '
	NS:	pop BX; сдвигаем указатель на новую строку
		shL DX, 1
		add BX, DX
		shR DX, 1
		inc DI
		pop CX
		loop SIMM
		
		pop SI
		pop DI
		pop ds
		pop DX
		pop CX
		pop BX
		pop AX
		
		pop BP
		
		ret 2*4		
	sim endp
	
	colE proc far
		;вход: X1 - сегмент матрицы, X2 - адрес матрицы в сегменте, 
		;X3 - количество строк матрицы, X4 - количество столбцов матрицы
		;выход: вывод номеров стобцов с равными элементами
		push BP
		mov BP, SP
		
		push AX
		push BX
		push CX
		push DX
		push ds
		push DI
		push SI
		
		mov DX, [BP + 8]
		mov CX, [BP + 6]; на CX - количество столбцов
		mov BX, [BP + 10]
		mov AX, [BP + 12]
		mov ds, AX	
		
		mov DI, 1
	ECOM:	push CX
		mov CX, DX
		dec CX
		mov AX, ds:[BX]; ожидается сравнение первого элемента столбца с остальными
		mov SI, BX
		add SI, [BP + 6]		
		add SI, [BP + 6]
	ECEM:	cmp AX, ds:[SI]
		jNE NEQ
		add SI, [BP + 6]		
		add SI, [BP + 6]
		loop ECEM
		outword DI
		outch ' '
	NEQ:	add BX, 2
		inc DI
		pop CX
		loop ECOM
		
		pop SI
		pop DI
		pop ds
		pop DX
		pop CX
		pop BX
		pop AX
		
		pop BP
		
		ret 2*4		
	colE endp
	
	MD proc far
		;вход: X1 - сегмент матрицы, X2 - адрес матрицы в сегменте, 
		;X3 - количество строк и столбцов матрицы
		;выход: вывод главной диагоняли
		push BP
		mov BP, SP
		
		push AX
		push BX
		push CX
		push DX
		push ds
		
		mov CX, [BP + 6]; на CX - количество столбцов
		mov BX, [BP + 8]
		mov AX, [BP + 10]
		mov ds, AX	
		
	
		mov DX, CX; для модификации
		shL DX, 1
		add DX, 2
	DM:	mov AX, ds:[BX]
		outint AX
		outch ' '
		add BX, DX
		loop DM
		
		pop ds
		pop DX
		pop CX
		pop BX
		pop AX
		
		pop BP
		
		ret 2*3		
	MD endp
	
	SD proc far
		;вход: X1 - сегмент матрицы, X2 - адрес матрицы в сегменте, 
		;X3 - количество строк и столбцов матрицы
		;выход: вывод побочной диагоняли
		push BP
		mov BP, SP
		
		push AX
		push BX
		push CX
		push DX
		push ds
		
		mov CX, [BP + 6]; на CX - количество столбцов
		mov BX, [BP + 8]
		mov AX, [BP + 10]
		mov ds, AX	
		
		
		mov DX, CX; для модификации
		shL DX, 1
		sub DX, 2
		add BX, DX
	DGS:	mov AX, ds:[BX]
		outint AX
		outch ' '
		add BX, DX
		loop DGS
		
		pop ds
		pop DX
		pop CX
		pop BX
		pop AX
		
		pop BP
		
		ret 2*3		
	SD endp

pr ends	
	
	
code segment 'code'
	assume ss:stack, ds:data, cs:code


start:
	mov ax,data
	mov ds,ax
	
	lea DX, WELC
	outstr
	newline
	
insc:	lea DX, MSTR; запрос количества строк
	outstr
	newline
	inint AX
	mov N, AX
	
	lea DX, MCOL; запрос количества стоблцов
	outstr
	newline
	inint AX
	mov M, AX
	
	mov AX, N; проверка корректности размерности матрицы
	mov BX, M
	mul BX
	cmp AX, MaxSize; считаю, что произведение не станет двойным словом
	jBE inm; если корректно - далее
	
	lea DX, ersc; иначе сообщаем об ошибке
	outstr
	newline
	lea DX, YN; и предлагаем ввести размеры заново
	outstr
	newline
	inch DL
	cmp DL, 'Y'
	jE insc
	jmp ex
	
inm:	lea DX, MCL; ввод матрицы
	outstr
	newline
	mov CX, AX; количество ячеек матрицы на счетчик
	xor BX, BX
inp:	inint AX
	mov X[BX], AX
	add BX, 2
	loop inp
	flush
	
	lea DX, MOU
	outstr
	newline
	mov AX, seg X
	push AX
	mov AX, offset X
	push AX
	push N
	push M
	call outM; выводим матрицу
	
	lea DX, SND
	outstr
	mov AX, seg X
	push AX
	mov AX, offset X
	push AX
	push N
	push M
	call nondec; выводим 1
	newline
	
	lea DX, SSM
	outstr
	mov AX, seg X
	push AX
	mov AX, offset X
	push AX
	push N
	push M
	call sim; выводим 2
	newline
	
	lea DX, ECOL
	outstr
	mov AX, seg X
	push AX
	mov AX, offset X
	push AX
	push N
	push M
	call colE; выводим 3
	newline
	
	mov AX, N
	cmp AX, M
	jNE NYL
	
	lea DX, MDG
	outstr
	mov AX, seg X
	push AX
	mov AX, offset X
	push AX
	push N
	call MD
	newline
	
	lea DX, SDG
	outstr
	mov AX, seg X
	push AX
	mov AX, offset X
	push AX
	push N
	call SD
	newline
	
NYL:	lea DX, NY; и предлагаем ввести размеры заново
	outstr
	newline
	inch DL
	cmp DL, 'Y'
	jNE ex
	jmp insc
	
ex:	mov AH, 8; удержание
	int 21h;   ответа
	finish
code ends
    end start 
