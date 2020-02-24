include io.asm

stack segment stack
	dw 128 dup (?)
stack ends

data segment
	S1 db 'Пучкин Данила, 112 группа, задача 1.7', '$'
	AS1 dw S1
	S2 db 'Введите б/зн число', '$'
	AS2 dw S2
	S3 db 'Ближайшее число к данному, кратное 7: ', '$'
	AS3 dw S3
data ends

code segment 'code'
	assume ss:stack, ds:data, cs:code

start:
	mov ax,data
	mov ds,ax
	
	mov DX, AS1 
	outstr
	newline
	
	mov DX, AS2
	outstr
	newline
	
	inint AX
	mov CX, AX; сохраняем данное число
	
	mov BX, 7; формируем делитель
	
    mov DX, AS3
	outstr
	
	mov DX, 0; формируем делимое
	div BX
	; поиск необходимого остатка
	cmp DX, 0 
	jE on1
	cmp DX, 1
	jE on2
	cmp DX, 2
	jE on2
	cmp DX, 3
	jE on2
	; остальные остатки (4, 5, 6) необходимо обработать: 7 - N mod 7, эту разность прибавить к данному числу
		add DX, -7
	on2:sub CX, DX; остатки 1, 2, 3 достаточно прибавить к данному числу
	on1:outnum CX;
		jmp ex
	
ex:	newline
	mov AH, 8; удерживание
	int 21h;   ответа
	finish
code ends
    end start
	