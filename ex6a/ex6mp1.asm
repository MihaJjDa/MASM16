;9.5 Описать полную  программу,  которая вводит три числа H, M и S и проверяет, удовлетворяют ли они следующим условиям: 0?H?23, 0?M,S?59. 
;Если нет, программа должна выдать сообщение об ошибке, а иначе, трактуя эти числа как час (H), минута (M) и секунда (S) некоторого момента суток, 
;должна напечатать время суток, на 1 секунду большее  (с учетом смены суток).
;Определить и использовать в этой программе два макроса, один из которых проверяет условие a?X?b, а другой - увеличивает X на 1 и, если X>b, обнуляет X.




include io.asm

GL macro a, X, b, L; на вход - число, регистр, число, метка для перехода на сообщение об ошибке
local next, N
	cmp X, a
	jB next
	cmp X, b
	jA next
	jmp short N
next:	jmp L
N:
endm

IM60 macro X, b; на вход - регистр и число
local next
	inc X
	cmp X, b
	jBE next
	mov X, 0
next:	
endm

stack segment stack
	dw 128 dup (?)
stack ends

data segment
	WELC db 'Данила Пучкин, группа 112, задача 6.4 дополнительная макросы', '$'
	HELLO db 'Введите три числа', '$'
	ER db 'Ошибка ввода!', '$'

data ends

code segment 'code'
	assume ss:stack, ds:data, es:data, cs:code

start:
	mov AX, data
	mov ds, AX
	
	lea DX, WELC
	outstr
	newline
	lea DX, HELLO
	outstr
	newline
	
	inint AX
	inint BX
	inint CX
	
	GL 0, AX, 23, err
	GL 0, BX, 59, err
	GL 0, CX, 59, err
	
	IM60 CX, 59
	cmp CX, 0
	jE N1
	jmp short outp
N1:	IM60 BX, 59
	cmp BX, 0
	jE N2
	jmp short outp
N2:	IM60 AX, 23
outp:	outword AX
	outch ':'
	outword BX
	outch ':'
	outword CX
	
	jmp short ex
err:	lea DX, er
	outstr
	newline
ex:	
	mov AH, 8; удержание
	int 21h;   ответа
	newline
    finish
code ends
    end start
