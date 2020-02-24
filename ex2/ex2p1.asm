include io.asm

stack segment stack
	dw 128 dup (?)
stack ends

data segment
	S1 db 'Пучкин Данила, 112 группа, задача 2.1', '$'
	S2 db 'Введите текст из больших латинских букв с точкой в конце', '$'

	LAT db 26 dup(0)

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
	
	mov BH, 0; формируем модификатор, работаем только с BL, т.к. не выйдем за диапазон byte
	L: 	inch BL
		cmp BL, '.'; ищем конец текста
		jE ex; если конец => на выход
		sub BL, 'A'; формируем модификатор для нужной ячейки
		cmp LAT[BX], 1; проверяем вхождение
		jE L; если не первое => на новый шаг цикла
		mov LAT[BX], 1; иначе фиксируем вхождение
		add BL, 'A'; формируем букву
		outch BL
		jmp L		
  
ex:	newline
	mov AH, 8; удерживать
	int 21h;   ответ
	finish
code ends
    end start 
