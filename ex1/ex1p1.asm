include io.asm

stack segment stack
	dw 128 dup (?)
stack ends

data segment
	S1 db '��窨� ������, 112 ��㯯�, ����� 1.1', '$'
	AS1 dw S1
	S2 db '������ ����ࠫ쭮� �᫮', '$'
	AS2 dw S2
	S3 db '�⥯��� �ன�� ������� �᫠ (-1 - �᫮ �� ���� �⥯���� �ன��): ', '$'
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
	
	inint AX; ���� ����ࠫ쭮�� �᫠
	
	mov DX, AS3
	outstr
	
	mov CL, 0; ��砫쭠� �⥯���
	mov BX, 3; ���� ����⥫�
  
	L:	cmp AX, 1; N ? 1
		jE OPK; N=1 => �뢮� �⥯���

		mov DX, 0; �ନ஢���� ��������
		div BX; N / 3
		cmp DX, 0; N mod 3 ? 0
		jNE KS1; N �� ��⭮ 3 => �뢮� -1
		inc CX; ������� �⥯���
		jmp L; �⥯��� �� �᭠, �� ��砫� 横��
		
	KS1:mov CX, -1; -1 �� ॣ����
		outint CX; �뢮� -1
	    jmp ex; �⮯
	
	OPK:mov CH, 0; �ନ஢���� �⢥�
		outword CX; �뢮� �⥯���
  
ex:	newline
	mov AH, 8; 㤥ন����
	int 21h;   �⢥�
	finish
code ends
    end start 
