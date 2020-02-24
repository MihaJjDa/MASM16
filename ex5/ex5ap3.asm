include io.asm

stack segment stack
	dw 128 dup (?)
stack ends

data segment
	HELLO db 'Пучкин Данила, 112 группа, задача 5.3 дополнительная', '$'
	WEL db 'Введите формулы для сравнения(через =):', '$'
	DA db 'ДА', '$'
	NET db 'НЕТ', '$'

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
		
		;рек(входим с '(' )
	MMa:	push BX
		push CX
		call MM
		xor AH, AH
		push AX
		inch DL; знак
		xor DH, DH
		push DX
		call MM
		xor AH, AH
		push AX
		inch DL; )
		pop CX; извлекаем вторую цифру
		pop BX; знак
		pop AX; первую цифру
	CM:	cmp BL, '+'; определяем знак
		jE A; если +, то переход
		sub AL, CL; иначе -
		
		pop CX
		pop BX
		pop DX
		ret
		
	A:	add AL, CL; +
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
	cbw
	push AX
	inch DL
	call MM
	pop BX
	
	cmp AL, BL
	jE D
	lea DX, NET
	jmp short exi
	
D:	lea DX, DA
	
	
exi:	outstr
	newline
	mov AH, 8; удерживать
	int 21h;   ответ
	
    finish
code ends
    end start 
