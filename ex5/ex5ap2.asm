include io.asm

stack segment stack
	dw 128 dup (?)
stack ends

data segment
	HELLO db 'Пучкин Данила, 112 группа, задача 5.2 дополнительная', '$'
	WEL db 'Введите формулу с точкой в конце(для вычисления максимума или минимума):', '$'
	GB db 'Результат: ', '$'

data ends

code segment 'code'
	assume ss:stack, ds:data, cs:code

	MM proc near
		;вход - с клавиатуры вводится формула
		;результат вычисления - на AL
		push DX
		
		inch DL
		cmp DL, '0'; ищем цифру
		jB MMa; если не цифра - на рекурсивную ветвь
		cmp DL, '9'
		jA MMa; если не цифра - на рекурсивную ветвь
		
		;нерек
		sub DL, '0'	
		mov AL, DL	
		
		pop DX
		ret
		
		;рек
	MMa:	push BX
		push CX
		xor DH, DH
		push DX; знак
		inch DL; (
		call MM
		xor AH, AH
		push AX
		inch DL; ,
		call MM
		xor AH, AH
		push AX
		inch DL; )
		pop CX; извлекаем вторую цифру
		pop BX; первую цифру
		pop AX; знак
		cmp BL, CL; сравниваем
		jAE CM
		xchg BL, CL; большая цифра - на BL
	CM:	cmp AL, 'M'; определяем max или min
		jE A; если максимум, то переход
		mov AL, CL; иначе минимум на AL
		
		pop CX
		pop BX
		pop DX
		ret
		
	A:	mov AL, BL; максимум на AL
		pop CX
		pop BX
		pop DX
		ret
	MM endp
	
start:
	mov ax,data
	mov ds,ax
	
	lea DX, HELLO
	outstr
	newline
	
	lea DX, WEL
	outstr
	newline
	
	call MM
	
	lea DX, GB
	outstr
	
	xor AH, AH
	outint AX
	newline
	
	mov AH, 8; удерживать
	int 21h;   ответ
	
    finish
code ends
    end start 
