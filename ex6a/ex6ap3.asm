include io.asm

stack segment stack
	dw 128 dup (?)
stack ends

data segment
	WELC db 'Данила Пучкин, группа 112, задача 6.3 дополнительная', '$'
	HELLO1 db 'Введите длину строки:', '$'
	HELLO2 db 'Введите строку данной длины:', '$'
	BB db 'Строка без пробелов:', '$'
	LEN equ 256
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
	
	lea DX, HELLO1
	outstr
	newline
	inint CX; ввод длины строки
	mov S, CL; заносим в нулевую ячейку длину строки

	
	lea DX, HELLO2
	outstr
	newline
	jCXZ CXZ1
	cld
	lea DI, S+1; модификатор для ввода
INP:	inch AL; ввод строки
	stosB
	loop INP
	
	; удаление пробелов
	xor CH, CH
	mov CL, S
	lea SI, S+1; настройка модификатора для поиска пробелов
	lea DI, S+1; настройка модификатора для вставки символов
PER:	lodsB; выгружаем очередной символ
	cmp AL, ' '; ищем пробел
	jE PER1; если пробел => на следующий шаг цикла
	stosB; иначе загружаем
	jmp short PER2
PER1:	dec byte ptr S
PER2:	loop PER
	

	; вывод строки
	xor CH, CH
	mov CL, S; максимальное число шагов вывода
	lea SI, S+1; настроиваем модификатор для вывода
	
CXZ1:	lea DX, BB
	outstr
	newline
	jCXZ CXZ2

OU1:	lodsB; выгружаем символ из строки
	outch AL; вывод очередного символа
	loop OU1
	
CXZ2:	mov AH, 8; удержание
	int 21h;   ответа
	newline
    finish
code ends
    end start
