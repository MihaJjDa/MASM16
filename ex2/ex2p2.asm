include io.asm

stack segment stack
	dw 128 dup (?)
stack ends

data segment
	S1 db '��窨� ������, 112 ��㯯�, ����� 2.2', '$'
	S2 db '������ 楫�� �᫮ �� 2 �� 5', '$'

	z2 db '���', '$'
	z3 db '㤮��', '$'
	z4 db '���', '$'
	z5 db '�⫨筮', '$'
	adr dw z2, z3, z4, z5

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
	
	inint BX
	sub BX, 2; �ନ�㥬 ����䨪���
	add BX, BX; ���ᨢ ᫮�, 㤢������ ����䨪���
	
	mov DX, adr[BX]
	outstr
  
	newline
	mov AH, 8; 㤥ন����
	int 21h;   �⢥�
	finish
code ends
    end start 
