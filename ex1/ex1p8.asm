include io.asm

stack segment stack
	dw 128 dup (?)
stack ends

data segment
	S1 db '��窨� ������, 112 ��㯯�, ����� 1.8', '$'
	AS1 dw S1
	S2 db '������ �㬬� ���� D1+-D2+-..+-Dk, 0<=Di<=9, k>=1', '$'
	AS2 dw S2
	S3 db '�������: ', '$'
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
	
	inch AL
	sub AL, '0'; �ନ�㥬 ��砫쭮� ���祭�� �㬬� D1
	mov AH, 0; �ᯮ���� ����� ॣ����, ��� �������⭮ �������⢮ ᫠������ (���� 100 ᫠������ � �� 9)
	
	L: 	inch BL; ���� �窨 ���� �����
		cmp BL, '.'; ����� �㬬� => �� ��室
		jE oi
		
		inch CL; ���뢠�� ��।��� ����
		sub CL, '0'; �ନ�㥬 ��।��� ᫠������
		mov CH, 0
		cmp BL, '+'; ��।��塞 ���� ᫠�������
		jE N; �᫨ +, � �ய�᪠�� neg
		neg CX
	N:	add AX, CX; �ନ�㥬 �㬬�
		jmp L; �� ��।��� ᫠������
	
	oi:	mov DX, AS3
		outstr
		outint AX		
		
	newline
	mov AH, 8; 㤥ন�����
	int 21h;   �⢥�
	finish
code ends
    end start
	