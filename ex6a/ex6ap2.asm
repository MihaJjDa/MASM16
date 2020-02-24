include io.asm

stack segment stack
	dw 128 dup (?)
stack ends

data segment
	WELC db 'Данила Пучкин, группа 112, задача 6.2 дополнительная', '$'
	HELLO1 db 'Введите длину строки:', '$'
	HELLO2 db 'Введите строку данной длины:', '$'
	BB db 'Строка с заменой больших букв:', '$'
	LEN equ 256
	S db LEN dup(?)
	S1 db 'abcdefghijklmnopqrstuvwxyz'; вспомогательная строка


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
	
	; замена больших букв на маленькие
	xor BH, BH; настройка модификатора
	xor CH, CH; в CX - длигу строки
	mov CL, S
	lea SI, S+1; настройка модификатора для поиска больших букв
PER:	lodsB; выгружаем лчередной символ
	cmp AL, 'A'; ищем большю букву
	jB PER1; если не нашли => на следующий шаг цикла
	cmp AL, 'Z'
	jA PER1; если не нашли => на следующий шаг цикла
	sub AL, 'A'; если нашли => вычисляем номер буквы
	mov BL, AL; формируем модификатор
	mov AL, S1[BX]; загружаем в AL маленькую букву
	mov DI, SI; формируем модификатор для загрузки символа в строку
	dec DI
	stosB; загружаем в строку маленькую букву
PER1:	loop PER
	

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
