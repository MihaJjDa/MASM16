;9.5 ������ ������  �ணࠬ��,  ����� ������ �� �᫠ H, M � S � �஢����, 㤮���⢮���� �� ��� ᫥���騬 �᫮���: 0?H?23, 0?M,S?59. 
;�᫨ ���, �ணࠬ�� ������ �뤠�� ᮮ�饭�� �� �訡��, � ����, �ࠪ��� �� �᫠ ��� �� (H), ����� (M) � ᥪ㭤� (S) �����ண� ������ ��⮪, 
;������ �������� �६� ��⮪, �� 1 ᥪ㭤� ����襥  (� ��⮬ ᬥ�� ��⮪).
;��।����� � �ᯮ�짮���� � �⮩ �ணࠬ�� ��� �����, ���� �� ������ �஢���� �᫮��� a?X?b, � ��㣮� - 㢥��稢��� X �� 1 �, �᫨ X>b, ������ X.




include io.asm

GL macro a, X, b, L; �� �室 - �᫮, ॣ����, �᫮, ��⪠ ��� ���室� �� ᮮ�饭�� �� �訡��
local next, N
	cmp X, a
	jB next
	cmp X, b
	jA next
	jmp short N
next:	jmp L
N:
endm

IM60 macro X, b; �� �室 - ॣ���� � �᫮
local next
	inc X
	cmp X, b
	jBE next
	mov X, 0
next:	
endm

stack segment stack
	dw 128 dup (?)
stack ends

data segment
	WELC db '������ ��窨�, ��㯯� 112, ����� 6.4 �������⥫쭠� ������', '$'
	HELLO db '������ �� �᫠', '$'
	ER db '�訡�� �����!', '$'

data ends

code segment 'code'
	assume ss:stack, ds:data, es:data, cs:code

start:
	mov AX, data
	mov ds, AX
	
	lea DX, WELC
	outstr
	newline
	lea DX, HELLO
	outstr
	newline
	
	inint AX
	inint BX
	inint CX
	
	GL 0, AX, 23, err
	GL 0, BX, 59, err
	GL 0, CX, 59, err
	
	IM60 CX, 59
	cmp CX, 0
	jE N1
	jmp short outp
N1:	IM60 BX, 59
	cmp BX, 0
	jE N2
	jmp short outp
N2:	IM60 AX, 23
outp:	outword AX
	outch ':'
	outword BX
	outch ':'
	outword CX
	
	jmp short ex
err:	lea DX, er
	outstr
	newline
ex:	
	mov AH, 8; 㤥ঠ���
	int 21h;   �⢥�
	newline
    finish
code ends
    end start
