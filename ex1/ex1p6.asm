include io.asm

stack segment stack
	dw 128 dup (?)
stack ends

data segment
	S1 db '��窨� ������, 112 ��㯯�, ����� 1.6', '$'
	AS1 dw S1
	S2 db '������ �᫮ � ����筮� ��⥬� ��᫥���', '$'
	AS2 dw S2
	S3 db '������ �᫠ � �����筮� ��⥬� ��᫥���: ', '$'
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
	
	mov BX, 5; 5 - �ॡ㥬�� ��⥬� ��᫥���
	
	mov AX, 0; �����⠢������ ॣ�����
	mov CH, 0; ����室�� ��� ᫮����� CL � AX, � 横�� �� �������
	L: 	inch CL
		cmp CL, ' '; ���� ���� �᫠
		jE on; ����� �᫠ => �� �뢮�
		
		sub CL, '0'; ���᫥��� ����
		mul BX; �奬�
		add AX, CX; ��୥�
		jmp L; �த������ ���� ���
	
	on:	mov DX, AS3
		outstr
		outnum AX
	
	newline
	mov AH, 8; 㤥ন�����
	int 21h;   �⢥�
	finish
code ends
    end start
	