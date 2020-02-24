; ─ы  ъюЁЁхъЄэюую юЄюсЁрцхэш  Ёєёёъшї сєът шёяюы№чєщЄх
; ъюфшЁютъє 866 (т Notepad++: ьхэ■ ╩юфшЁютъш - ╩юфшЁютъш -
; ╩шЁшыышЎр - OEM 866).
; Если текст, начиная с этой строки, читается нормально,
; то файл в правильной кодировке.

include io.asm ;подключение операций ввода-вывода

stack segment stack
	dw 128 dup (?)
stack ends

data segment
; место для переменных и констант
	N EQU 100
	A DB N DUP(?) 
	B DB 26 DUP(0)

data ends

code segment 'code'
	assume ss:stack, ds:data, cs:code
; место для описания процедур

start:
	mov ax,data
	mov ds,ax
; команды программы должны располагаться здесь
	
	mov BP, 0
L:	inch AH
	mov A[BP], AH
	INC BP
	cmp AH, '.'
	jE ex
	jmp L
ex:	mov BH, 0
	mov BP, 0
L2:	cmp A[BP], '.'
	JE print
	mov BL, A[BP]
	SUB BL, 'a'
	inc B[BX]
	inc BP
	JMP L2
print: 
	mov BP, 0
	mov AH, 0
L3:	mov AL, B[BP]
	inc BP
	outint AX
	cmp bp, 26
	je exit
	jmp L3
exit: newline

	
	
	
	mov AH, 8; удерживать
	int 21h;   ответ
	
    finish
code ends
    end start 
