include io.asm

stack segment stack
	dw 128 dup (?)
stack ends

data segment
	S1 db '������ ��窨�, 112 ��㯯�, ����� 3.1', '$'
	S2 db '������ ����筮� �᫮ � �஡���� � ����(�� ����� 16 ���)', '$'

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
	
I:	inch DL; ���� ���⮩, �������� ��� �������ਥ�
	cmp DL, ' '
	jNE I1
	jmp OU
	
I1:	sub DL, '0'
	shL AX, 1
	or AL, DL
	jmp I

OU:	mov CX, 16; ���� ������, ������ �� ४����������. ����� - �ᯮ���� �� ॣ���� �����, �믮������ ����� ������. ������ - ��� ࠧ��⠥��� � �� �祢����

OU1:RoL AX, 1; ᤢ���� �᫮
	jC O; � ��� ����� 1 � CF
	loop OU1; ��室 �� ����� 横�� => �᫮ = 0 
	outword 0; �뢥��
	jmp ex; � �� ��室

O:	outword 1; ���� �뢥��� 1
	dec CX; ��室 �� 横�� ��襫 �� � loop => 㬥��訬 CX
	jcxz ex; ��砩, ����� �������筮� �᫮
OU2:RoL AX, 1; ᤢ�� => ��।��� ��� � CF
	jC O1; ��������㥬 � �뢮��� �㦭�� �᫮
	outword 0
	jmp short R
O1:	outword 1
R:	loop OU2

ex:	newline
	mov AH, 8; 㤥ন���
	int 21h;   �⢥�
	finish
code ends
    end start 
