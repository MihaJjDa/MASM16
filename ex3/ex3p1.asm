include io.asm

stack segment stack
	dw 128 dup (?)
stack ends

data segment
	S1 db 'Данила Пучкин, 112 группа, задача 3.1', '$'
	S2 db 'Введите двоичное число с пробелом в конце(не более 16 цифр)', '$'

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
	
	xor AX, AX
	
I:	inch DL; ввод простой, позвольте без комментариев
	cmp DL, ' '
	jNE I1
	jmp OU
	
I1:	sub DL, '0'
	shL AX, 1
	or AL, DL
	jmp I

OU:	mov CX, 16; иной алгоритм, нежели вы рекомендовали. плюсы - использую на регистр меньше, выполняется меньше команд. минусы - код разрастается и не очевиден

OU1:RoL AX, 1; сдвигаю число
	jC O; и ищу первую 1 в CF
	loop OU1; выход по концу цикла => число = 0 
	outword 0; вывели
	jmp ex; и на выход

O:	outword 1; иначе выведем 1
	dec CX; выход из цикла прошел не с loop => уменьшим CX
	jcxz ex; случай, когда однозначное число
OU2:RoL AX, 1; сдвиг => очередная цифра в CF
	jC O1; анализируем и выводим нужное число
	outword 0
	jmp short R
O1:	outword 1
R:	loop OU2

ex:	newline
	mov AH, 8; удерживаю
	int 21h;   ответ
	finish
code ends
    end start 
