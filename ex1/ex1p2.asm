include io.asm

stack segment stack
	dw 128 dup (?)
stack ends

data segment
	N dw ?
	S1 db '��窨� ������, 112 ��㯯�, ����� 1.2', '$'
	AS1 dw S1
	S2 db '������ ����ࠫ쭮� �᫮, ����襥 1', '$'
	AS2 dw S2
	S3 db '������ �᫮ - ��⠢���', '$'
	AS3 dw S3
	S4 db '������ �᫮ - ���⮥', '$'
	AS4 dw S4

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
	
	inint N; ���� ����ࠫ쭮�� �᫠
	
	mov AX, N;
    cmp AX, 2; �ᮡ� ��砩 N = 2, �.�. ��ࢮ� ������� �㤥� ��� ���⪠ � �ணࠬ�� ���,
	jE PR; �� 2 - ��⠢���. �������� ���稪 ���� ��訬 ��ਠ�⮢, ������ ���� �ࠢ�����
	
	mov BX, 2; �ନ஢���� ��ࢮ�� ����⥫�
	mov DX, 0; �ନ஢���� ���ᨬ��쭮�� ����⥫�
	div BX;
	mov CX, AX; N div 2 -> CX
	
	L:	mov AX, N; �ନ஢���� ��������
		mov DX, 0
		
		div BX; ������� N �� ⥪�騩 ����⥫�, �饬 ���⮪
		
		cmp DX, 0; �ࠢ����� ���⪠ � 0
		jE NPR; N mod BX = 0 => N - ��⠢��� => ��室 �� 横��
		
		cmp BX, CX; �ࠢ����� ����⥫� � ���ᨬ����
		jAE PR; ⥪�騩 ����⥫� ����� ���� ࠢ�� ���ᨬ��쭮�� => ��室 �� 横��, �᫮ ���⮥
			; ����� - �⤥��� ��砩 ��� ������ (2 div 2 = 1 <> BX = 2, � �㦭� ��室��� �� 横�� �ࠧ�)
		inc BX; �ନ�㥬 ᫥���騩 ����⥫�
		jmp L; �� ��砫� 横��
		
	NPR:mov DX, AS3
		outstr
		jmp ex
		
	PR:mov DX, AS4
		outstr
	
ex:	newline
	mov AH, 8; 㤥ন����
	int 21h;   �⢥�
	finish
code ends
    end start 
