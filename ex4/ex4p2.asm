include io.asm

stack segment stack
	dw 128 dup (?)
stack ends

data segment
	HELLO db 'Пучкин Данила, 112 группа, задача 4.2', '$'
	WEL db 'Введите формулу с точкой в конце:', '$'
	GB db 'Результат: ', '$'

data ends

code segment 'code'
	assume ss:stack, ds:data, cs:code

start:
	mov ax,data
	mov ds,ax
	
	lea DX, HELLO
	outstr
	newline
	
	lea DX, WEL
	outstr
	newline
	
	xor DX, DX
	push DX; на случай

L:	inch DL
	cmp DL, '.'; ищем конец
	jNE L1; если не конец - работаем дальше
	jmp ex; иначе на выход

L1:	cmp DL, '('; пропускаем открывающие скобки
	jE L
	
	cmp DL, ','; пропускаем запятые
	jE L

	cmp DL, ')'; ищем конец очередного выражения
	jNE L2; если не конец - обрабатываем попавшийся знак или цифру
	pop CX; иначе извелкаем вторую цифру
	pop BX; первую цифру
	pop AX; знак
	cmp BX, CX; сравниваем
	jAE CM
	xchg BX, CX; большая цифра - на BX
CM:	cmp AX, 'M'; определяем max или min
	jE A; если максимум, то переход
	push CX; иначе минимум в стек
	jmp L; и дальше в цикл
A:	push BX; максимум 
	jmp L; работаем в цикле далее
	
L2:	cmp DL, 'M'; ищем не цифру
	jE P; не цифра - заносим в стек
	cmp DL, 'm'; ищем не цифру
	jE P; не цифра - заносим в стек
	sub DL, '0'; цифра - делаем из символа цифры саму цифру
P:	push DX; и в стек
	jmp L; работаем в цикле
	
ex: 	lea DX, GB
	outstr
	
	pop DX; извлечем результат
	outint DX
	newline
	
	pop DX; уберем 0
	mov AH, 8; удерживать
	int 21h;   ответ
	
    finish
code ends
    end start 
