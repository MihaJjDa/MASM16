include io.asm

stack segment stack
	dw 128 dup (?)
stack ends

data segment
	S1 db '��窨� ������, 112 ��㯯�, ����� 1.7', '$'
	AS1 dw S1
	S2 db '������ �/�� �᫮', '$'
	AS2 dw S2
	S3 db '������襥 �᫮ � �������, ��⭮� 7: ', '$'
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
	newline
	
	inint AX
	mov CX, AX; ��࠭塞 ������ �᫮
	
	mov BX, 7; �ନ�㥬 ����⥫�
	
    mov DX, AS3
	outstr
	
	mov DX, 0; �ନ�㥬 �������
	div BX
	; ���� ����室����� ���⪠
	cmp DX, 0 
	jE on1
	cmp DX, 1
	jE on2
	cmp DX, 2
	jE on2
	cmp DX, 3
	jE on2
	; ��⠫�� ���⪨ (4, 5, 6) ����室��� ��ࠡ����: 7 - N mod 7, ��� ࠧ����� �ਡ����� � ������� ���
		add DX, -7
	on2:sub CX, DX; ���⪨ 1, 2, 3 �����筮 �ਡ����� � ������� ���
	on1:outnum CX;
		jmp ex
	
ex:	newline
	mov AH, 8; 㤥ন�����
	int 21h;   �⢥�
	finish
code ends
    end start
	