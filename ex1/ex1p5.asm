include io.asm

stack segment stack
	dw 128 dup (?)
stack ends

data segment
	S1 db '��窨� ������, 112 ��㯯�, ����� 1.5', '$'
	AS1 dw S1
	S2 db '������ �/�� �᫮', '$'
	AS2 dw S2
	S3 db '�ந�������� ����襩 � ���襩 ���: ', '$'
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
	 
	mov DX, 0; �ନ�㥬 �������
	mov BX, 10; � ����⥫�
	
	div BX
	
	mov CL, DL; ������ ��� �������, �祩�� byte �����筮, �.�. DX <= 10
	
	cmp AX, 0; �饬 �������筮� �᫮
	jNE L; �᫮ �� �������筮� => ���室 � ࠡ��
	mov AL, CL; ���� � AL �� �� ����
	jmp M; �� 㬭������
	
	L:	cmp AX, 10; �饬 ������ ����
		jB M; ����� ��� ������� => �� 㬭������
		
		mov DX, 0; �ନ�㥬 �������
		div BX
		jmp L; �த������ ������
	
	M:	mul CL
	
	mov DX, AS3
	outstr
	outint AX
	
	newline
	mov AH, 8; 㤥ন�����
	int 21h;   �⢥�
	finish
code ends
    end start
	