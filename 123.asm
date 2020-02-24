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
	Y db ?
data ends

code segment 'code'
	assume ss:stack, ds:data, cs:code
; место для описания процедур

start:
	mov ax,data
	mov ds,ax
; команды программы должны располагаться здесь
	mov AL, '!'
	mov BX, offset Y
	mov ds:[BX], AL
	outch ds:[BX]

    finish
code ends
    end start 
