include io.asm

stack segment stack
	dw 128 dup (?)
stack ends

data segment
	S1 db 'Пучкин Данила, 112 группа, дополнительная задача 2.1', '$'
	S2 db 'Вывод двойных слов:', '$'
	
	D dd 1, 12, 123, 1234, 12345, 123456, 1234567, 12345678, 123456789, 1234567890
	BUF dd ?
	ANS db 10 dup(?), '$'

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
	
	mov BP, 10; делитель
	mov SI, -1; счетчик фактического адреса массива
	
	mov CX, 10
	L:	push CX
		
		inc SI; переход к следующей ячейке
		mov BX, SI; формирование модификатора
		add BX, BX
		add BX, BX
		
		mov AX, word ptr D[BX]; число в буфер
		mov word ptr BUF, AX
		mov AX, word ptr D[BX] + 2
		mov word ptr BUF + 2, AX
		
		mov CX, 10
	    L1:	mov DX, 0; поиск очередной цифры через деление
			mov AX, word ptr BUF + 2
			div BP
			mov word ptr BUF + 2, AX
			mov AX, word ptr BUF
			div BP
			mov word ptr BUF, AX
			
			mov BX, CX; формирование модификатора
			add DL, '0'; формирование символа цифры
			mov ANS[BX-1], DL; запись очередной цифры
			cmp word ptr BUF, 0; проверка на незначащие нули 1
			jNE L2
			cmp word ptr BUF + 2, 0; проверка на незначащие нули 2
		L2:	loopNE L1
		
		lea DX, ANS[BX-1]
		outstr
		newline
		
		pop CX
		loop L
	
	
	mov AH, 8; удерживать
	int 21h;   ответ
	finish
code ends
    end start 
