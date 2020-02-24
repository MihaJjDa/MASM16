include io.asm

stack segment stack
	dw 128 dup (?)
stack ends

data segment
	S1 db 'Пучкин Данила, 112 группа, задача 1.9', '$'
	AS1 dw S1
	S2 db 'Введите текст, состоящий из слов, разделенных запятыми, и заканчивающийся точкой', '$'
	AS2 dw S2
	S3 db 'Количество слов, начинающихся и заканчивающихся с одной и той же буквы: ', '$'
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
	
	mov CX, 0; cчетчик
	; текст не пустой, можно не вставлять условия проверки пустого текста
	L:	inch BL; вводим первый символ слова
		mov AL, BL; заносим первый символ в регистр
		M:	mov AH, BL; заносим каждый следующий символ в ругистр...
			inch BL
			cmp BL, '.';... пока не встретим точку...
			jE oi1; нашли точку => на выход
			
			cmp BL, ',';... или запятую
			jNE M; не запятая => на следующий символ
			
			cmp AH, AL; запятая => сравниваем первый и последний символы
			jNE L; не равны => на новое слово
			inc CX; равны => повышаем счетчик...
			jmp L;...и на новое слово
	
	oi1:cmp AL, AH; обработка последнего слова
		jNE oi
		inc CX
	
	oi:	mov DX, AS3
		outstr	
		outnum CX
	
	newline
	mov AH, 8; удерживание
	int 21h;   ответа
	finish
code ends
    end start
	