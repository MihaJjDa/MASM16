include io.asm

stack segment stack
	dw 128 dup (?)
stack ends

data segment
	S1 db 'Данила Пучкин, 112 группа, задача 3.1 дополнительная', '$'
	S2 db 'Введите двоичное число из 16 цифр с пробелом в конце', '$'
	S3 db 'НЕСИММЕТРИЧНО: ', '$'
	S4 db 'СИММЕТРИЧНО:', '$'

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
	xor CL, CL
	
I:	inch DL; ввод простой, позвольте без комментариев
	cmp DL, ' '
	jNE I1
	cmp CX, 3
	jE PR
	inc CL
	jmp I
I1:	sub DL, '0'
	shL AX, 1
	or AL, DL
	jmp I	

PR:	mov CX, 16
L:	RoR AX, 1; формирую перевернутое введенное число
	RcL BX, 1	
	loop L	
	not BX; отражаю
	test AX, BX; и ищу ноль через лог умножение
	jZ S
	
	lea DX, S3; несимметрично
	outstr
	not BX
	and BX, 0000000110000000b; в BX - перевернутое AX, спасаем нужные нам цифры
	and AX, 1111111001111111b; удаляем уже ненужные цифры
	or AX, BX; получаем необходимое число
	jmp OU
	

S:	lea DX, S4
	outstr
	cmp AX, 0; отделим случай, когда число - 0, так как иначе будет зацикливание далее
	jZ OU
	mov CL, 8
	RoR AX, CL; преобразуем число таким образом, чтобы центр числа оказался на его краях
	xor CL, CL
R:	RoR AX, 1; ищем первое вхождение единицы(сколько сдвигов нужно сделать чтобы попасть на 1)
	inc CL; считаем сдивги
	jNC R
	; нашли => сдвинем влево, чтобы нужная единица оказалась по краям
	and AX, 0111111111111111b; обнуляем ее
	RoL AX, CL; сдвигаем два раза так, чтобы вторая единица оказалась на правом бите
	RoL AX, CL; считал и рисовал на бумажке, сложно обосновать алгоритм
	and AX, 1111111111111110b; обнуляем
	RoR AX, CL; возвращаем число в состояние до обработки
	mov CL, 8
	RoL AX, CL; возвращаем число в исходное состояние	
	
OU:	mov CX, 16
	xor BL, BL
M:	RoL AX, 1
	jC O1
	outword 0
	jmp short LM
O1:	outword 1
LM:	inc BL
	cmp BL, 4
	jNE LOM
	xor BL, BL
	outch ' '
LOM:loop M


ex:	newline
	mov AH, 8; удерживаю
	int 21h;   ответ
	finish
code ends
    end start 
