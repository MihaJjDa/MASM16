include io.asm 

outstrX macro R
	push ds
	push AX
	mov AX, R
	mov ds, AX
	outstr
	pop AX
	pop ds
endm

ls macro
local Q
Q:	lodsB
	stosB
	loop Q
endm


stack segment stack
	dw 128 dup (?)
stack ends

NIL equ 0
heapsize equ 20
lenstr equ 8

node struc
	elem db lenstr dup(?)
	next dw ?
node ends

heap segment
	heapptr  dw ?
		   node heapsize dup(<>)
heap ends	


data segment
	WELC db 'Данила Пучкин, группа 112, задача 7.1 дополнительная', '$'
	SIN db 'Введите текст из слов, разделенных запятой, оканчивающийся точкой (не более 20 слов длиной не более 8):', '$'
	SOU db 'Слова из текста и количество повторений:', '$'
	L dw NIL
	SM db lenstr*heapsize dup(' '); чтобы не добавлять пробелы в конце
data ends



lists segment 'code'
	assume ds:data, ss:stack, es:heap, cs:lists
	
	initheap proc far
		push SI
		push BX
		push CX
		
		mov CX, heap
		mov es, CX
		
		mov CX, heapsize
		mov BX, NIL
		mov SI, (lenstr+2)*heapsize-lenstr
	in1:	mov es:[SI].next, BX
		mov BX, SI
		sub SI, lenstr+2
		loop in1
		mov es:heapptr, BX
		pop CX
		pop BX
		pop SI
		ret
	initheap endp
	
	dispose proc far
		push es:heapptr
		pop es:[DI].next
		mov es:heapptr, DI
		ret
	dispose endp
	
	new proc far
		mov DI, es:heapptr
		cmp DI, NIL
		jE emph
		push es:[DI].next
		pop es:heapptr
		ret
	emph:	lea DX, cs:HERR
		outstrX cs
		newline
		finish
	HERR db 'Ошибка: исчерпание кучи', '$'
	new endp
lists ends

	

code segment 'code'
	assume ss:stack, ds:data, cs:code, es:heap
	
	readstr proc near
		;вход: X1:X2 - адрес, куда записывается строка
		;выход: запись строки на X1:X2 длины lenstr, AL - символ выхода(. или ,)
		push BP
		mov BP, SP
		
		push BX
		push CX
		push DX
		push ds
		
		mov BX, [BP+4]
		mov CX, [BP+6]
		mov ds, CX		
		
		xor CX, CX
	inpc:	inch AL
		cmp AL, '.'
		jE fl
		cmp AL, ','
		jE fl
		jmp short fa
	fl:	cmp CL, 0
		jNE endi
	erri:	lea DX, cs:IERR
		outstrX cs
		newline
		finish
		
	fa:	cmp AL, 'A'
		jB erri
		cmp AL, 'Z'
		jA erri
		inc CL
		cmp CL, 8
		jA erri
		mov ds:[BX], AL
		inc BX
		jmp inpc
		
	endi:	pop ds
		pop DX
		pop CX
		pop BX
	
		pop BP
		
		ret 2*2
	IERR db 'Ошибка ввода!', '$'
	readstr endp
	
	strtol proc near
		;вход: X1 - адрес слова
		;выход - в список заносится слово в алфавитном порядке, в случае изменения порядка списка - меняется указатель X2
		push BP
		mov BP, SP
		
		push AX
		push BX
		push CX
		push DI
		push SI		
		
		mov BX, [BP+4]; проверка списка на пустоту
		cmp ds:[BX], word ptr NIL
		jE J1; если пустой - вставляем слово в начало списка
		;на BX - адрес указптеля
		mov SI, [BP+6]; сравнение слов
		mov DI, ds:[BX]
		mov CX, lenstr
	rep	cmpsB
		jBE J1; если слово меньше либо равное - вставляем слово в начало списка
		; на BX - адрес указателя
		mov BX, ds:[BX]
		cmp es:[BX].next, word ptr NIL; если слово единственное - вставляем в конец списка
		jE J2
		;на BX - указатель
		jmp short j01
	j00:	mov BX, es:[BX].next; на BX - указатель на следующее слово
	j01:	mov SI, [BP+6]; сравнение со следующим словом после текущего
		mov DI, es:[BX].next		
		mov CX, lenstr
	rep	cmpsB
		
		jBE J3; если слово меньше либо равное - вставляем слово после текущего
		;на BX - указатель
		mov SI, es:[BX].next
		cmp es:[SI].next, NIL; если следующее слово после текущего - последнее, то вставляем в конец списка
		jE J4
		
		jmp J00; иначе адрес текущего указателя меняется на адрес следующего
		
	J1:	
		call new
		push DI
		mov SI, [BP+6]
		mov CX, lenstr
		LS
		pop DI
		mov BX, ds:[BX]
		mov es:[DI].next, BX
		mov BX, [BP+4]
		mov ds:[BX], DI
		jmp exp
		
	J2:	call new
		push DI
		mov BX, [BP+4]
		mov BX, ds:[BX]
		mov SI, [BP+6]
		mov CX, lenstr
		LS
		pop DI
		mov es:[BX].next, DI
		mov es:[DI].next, NIL
		jmp exp
		
	J3:	call new
		push DI
		mov BX, es:[BX].next
		mov SI, [BP+6]
		mov CX, lenstr
		LS
		pop DI
		push es:[BX].next
		pop es:[DI].next
		mov es:[BX].next, DI
		jmp exp
		
	J4:	call new
		mov BX, es:[BX].next
		mov es:[BX].next, DI
		push DI
		mov SI, [BP+6]
		mov CX, lenstr
		LS
		pop DI
		mov es:[DI].next, word ptr nil
	

		
	exp:	pop SI
		pop DI
		pop CX
		pop BX
		pop AX
		
		pop BP
		
		ret 2*1
		
	strtol endp

start:
	mov AX, data
	mov ds, AX

	lea DX, WELC
	outstr
	newline
	
	lea DX, SIN
	outstr
	newline
	
	call initheap
	
	mov CL, 3
	xor BX, BX
rt:	mov AX, seg SM
	push AX
	mov AX, offset SM
	add AX, BX
	push AX
	call readstr
	add BX, lenstr
	shR BX, CL
	cmp BX, heapsize
	jBE nex
	jmp ex
nex:	shL BX, CL
	cmp AL, '.'
	jNE rt
	
	shR BX, CL; количество слов
	mov DX, BX
	
	cld
	mov CX, DX
	xor BX, BX
ttol:	mov AX, offset SM
	add AX, BX
	push AX
	lea AX, L
	push AX
	call strtol
	add BX, lenstr
	loop ttol
	
;ou:	mov BX, L;выводит весь список 
;	mov CX, DX
;D:	push CX
;	mov CX, lenstr
;	push BX
;F:	outch es:[BX]
;	inc BX
;	loop F
;	pop BX
;	mov BX, es:[BX].next
;	pop CX
;	loop D
;	newline
	push DX
	lea DX, SOU
	outstr
	newline
	pop DX
	mov BX, L
	mov CX, DX
	xor AH, AH
D2:	inc AH
	push CX
	mov CX, lenstr
	push BX
	mov BP, es:[BX].next
	dec BX
	dec BP
F2:	inc BX
	inc BP
	mov AL, es:[BX]
	cmp AL, es:[BP]
	loopE F2
	pop BX
	jCXZ NS
	push BX
	mov CX, lenstr
G:	outch es:[BX]
	inc BX
	loop G
	pop BX
	outch ' '
	mov AL, AH
	xor AH, AH
	outword AX
	newline
NS:	pop CX
	mov BX, es:[BX].next
	loop D2
	
	


ex:	mov AH, 8; удержание
	int 21h;   ответа
	finish
code ends
    end start 
