include io.asm

stack segment stack
	dw 128 dup (?)
stack ends

data segment
	WELC db 'Данила Пучкин, группа 112, задача 6.1 дополнительная', '$'
	HELLO db 'Введите строку из 10 символов', '$'
	BB db 'Строка без цифр:', '$'
	LEN equ 10
	S db LEN dup(?)


data ends

code segment 'code'
	assume ss:stack, ds:data, es:data, cs:code

start:
	mov AX, data
	mov ds, AX
	mov AX, data
	mov es, AX
	
	lea DX, WELC
	outstr
	newline
	lea DX, HELLO
	outstr
	newline
	
	; ввод строки
	cld; корректровка направления
	lea DI, S; подготовка модификатора
	mov CX, LEN; максимальная длина текста
INP:	inch AL; ввод очередного символа
	stosB; AL в строку
	loop INP

	; удаление чисел
	lea SI, S; по SI - чтение очередного символа из строки
	lea DI, S; по DI - заполнение строки с удалением цифр
	mov CX, LEN; длина строки
PER:	lodsB; выгружаем очередной символ
	cmp AL, '0'; ищем цифру
	jB PER1; если цифра - на следующий шаг цикла
	cmp AL, '9'
	jA PER1; если цифра - на следующий шаг цикла
	jmp short PER2
PER1:	stosB	
PER2:	loop PER
	;заполнение пробелами
	mov CX, SI; количество пробелов = SI - DI
	sub CX, DI
	mov AL, ' '
rep	stosB

	; вывод строки
	lea DX, BB
	outstr
	newline
	mov CX, LEN; максимальное число шагов вывода
	lea SI, S; настроиваем модификатор для вывода
OU1:	lodsB; выгружаем символ из строки
	outch AL; вывод очередного символа
	loop OU1
	
	mov AH, 8; удержание
	int 21h;   ответа
	newline
    finish
code ends
    end start
