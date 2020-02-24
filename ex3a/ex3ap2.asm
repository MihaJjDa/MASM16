include io.asm

stack segment stack
	dw 128 dup (?)
stack ends

data segment
	S1 db 'Данила Пучкин, 112 группа, задача 3.2 дополнительная', '$'
	S2 db 'Работа с множеством', '$'
	S3 db 'Введите команду: ', '$'
	S4 db 'Неверная команда!', '$'
	S5 db 'Число не входит в множество', '$'
	S6 db 'Число входит в множество', '$'
	S7 db 'Количество элементов множества: ', '$'
	S8 db 'Элементы множества:', '$'
	
	L equ 5
	R equ 155
	S db (R-L)/8 + 1 dup (0)

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
	
PR:	lea DX, S3
	outstr

	flush
	inch DL
	
	cmp DL, '.'
	jNE PR1
	jmp ex
	
PR1:	cmp DL, '+'
	jNE PR2
	jmp NA
	
PR2:	cmp DL, '-'
	jNE PR3
	jmp NS
	
PR3:cmp DL, '?'
	jNE PR4
	jmp NQ
	
PR4:cmp DL, '='
	jNE PR5
	jmp NR
	
PR5:cmp DL, ':'
	jNE err
	jmp NO
	
err:lea DX, S4
	outstr
	newline
	jmp PR

NA:	inint BX
	cmp BX, L
	jB ENA
	cmp BX, R
	jA ENA
	jmp short NA1
ENA:	jmp err
NA1:	sub BX, L
	mov AX, BX
	
	mov CL, 3
	shR BX, CL; байт числа
	
	and AL, 111b; бит числа
	mov CL, 10000000b; маска добавления
	Xchg AL, CL
	RoR AL, CL
	or S[BX], AL
	jmp PR
	
NS:	inint BX
	cmp BX, L
	jB ENS
	cmp BX, R
	jA ENS
	jmp short NS1
ENS:jmp err

NS1:sub BX, L
	mov AX, BX
	
	mov CL, 3
	shR BX, CL; байт числа
	
	and AL, 111b; бит числа
	mov CL, 01111111b; маска удаления
	Xchg AL, CL
	RoR AL, CL
	and S[BX], AL
	jmp PR
	
NQ:	inint BX
	cmp BX, L
	jB ENQ
	cmp BX, R
	jA ENQ
	jmp short NQ1
ENQ:	jmp err

NQ1:	sub BX, L
	mov AX, BX
	
	mov CL, 3
	shR BX, CL; байт числа
	
	and AL, 111b;бит числа
	mov CL, 10000000b; маска поиска
	Xchg AL, CL
	RoR AL, CL; получаем единицу под интересующим битом
	and AL, S[BX]; умножаем
	jNZ NQY; если не ноль, то число есть

	lea DX, S5; иначе его нет
	outstr
	newline
	jmp PR
NQY:lea DX, S6
	outstr
	newline
	jmp PR	

NR:	mov AL, 0; счетчик
	mov CX,(R-L)/8+1; число байтов множества
B:	mov BX, CX; формируем модификатор
	dec BX
	mov AH, S[BX]; загружаем на регистр текущий байт
	push CX
	mov CX, 8; проверим каждый бит
	Bi:	shL AH, 1; сдвигаем, ищем CF = 1
		jNC LBi; если CF = 0 - на начало цикла
		inc AL; иначе повышаем счетчик
	LBi:loop Bi
	pop CX
	loop B
	lea DX, S7
	outstr
	outword AX
	newline
	jmp PR

NO:	lea DX, S8
	outstr
	mov DX, L-1; счетчик числа для вывода
	mov CX,(R-L)/8+1
F:	mov BX, CX; формируем модификатор
	dec BX
	sub BX, 18; но тепре идем с начала множества
	neg BX
	mov AH, S[BX]
	push CX
	mov CX, 8
	Fi:	inc DX; проверяем следующее число
		shL AH, 1; ищем CF = 1
		jNC LFi
		outword DX, 4; выводим в случае наличия числа в множестве
	LFi:loop Fi
	pop CX
	loop F
	newline
	jmp PR	

ex:	mov AH, 8; удерживаю
	int 21h;   ответ
	finish
code ends
    end start 
