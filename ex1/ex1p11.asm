include io.asm

stack segment stack
	dw 128 dup (?)
stack ends

data segment
	S1 db 'Пучкин Данила, 112 группа, задача 1.11', '$'
	AS1 dw S1
data ends

code segment 'code'
	assume ss:stack, ds:data, cs:code

start:
	mov ax,data
	mov ds,ax
	
	mov DX, AS1 
	outstr
	newline
	
	mov BL, 10; делитель
	mov DL, 0; счетчик
	
	mov CX, 102; 102 - первое подходящее число
	L:	mov AX, CX; данное число на работу
		div BL; получаем первую цифру, короткого деления достаточно (т.к. max N div 10 = 99, mod = 9)
		mov BH, AH; первую цифру - на BH
		mov AH, 0; подготавливаем следущее делимое
		div BL; вторая и третья цифры - на AH и AL
		cmp AH, AL; попарные сравнения
		jE L1; = => на следующее число
		
		cmp AH, BH
		jE L1; = => на следующее число
		
		cmp BH, AL
		jE L1; = => на следующее число
		
		outnum CX, 4 
		inc DL; вывели => повысили счетчик
		cmp DL, 18; вывели ли 18 чисел?
		jNE L1; не вывели => на следующее число
		
		mov DL, 0; вывели => обнулим счетчик
		newline; и переведем строку
	L1:	inc CX; получаем следующее число
		cmp CX, 988; 987 - максимальное нужное число
		jE ex; 988 => на выход
		jmp L; не 988 => продолжить работу
			
ex:	mov AH, 8; удерживание
	int 21h;   ответа
	finish; ответ не влезает в экран
code ends
    end start
	