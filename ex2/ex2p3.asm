include io.asm

stack segment stack
	dw 128 dup (?)
stack ends

data segment
	S1 db '��窨� ������, 112 ��㯯�, ����� 2.3', '$'
	S2 db '������ 楫�� �᫮', '$'
	
	N db 5 dup(0), '$'

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
	
	mov BX, 10; �ନ�㥬 ����⥫�
	mov CX, 5; ���ᨬ��쭮� ������⢮ 蠣�� 横��
	mov DH, 0; �ନ�㥬 ���⮪, � 横�� ࠡ�⠥� ⮫쪮 � DL
	
	inint AX
	cmp AX, 0; �஢��塞, �� ����⥫쭮� �� �᫮
	jGE L; �᫨ ��� => �ࠧ� � 横�	
	outch '-'; ���� �뢮��� �����
	neg AX; � ࠡ�⠥� � ���㫥� �᫠
	
	L: 	mov DL, 0;�ନ�㥬 �������
		div BX; � AX - ��⠢襥�� ����ॢ������� �᫮, � DL - ��� �����筮� ����� �᫠, � DH - 0
		add DL, '0'; �ନ�㥬 ᨬ��� ᮮ⢥�����騩 ���
		mov BP, CX; �ନ�㥬 ����䨪��� ��� ���ᨢ�, �࠭�饣� �᫮ � ᨬ���쭮� �����
		mov N[BP-1], DL; ����ᨬ � ���ᨢ ��।��� ����
		cmp AX, 0; �������⥫쭠� �஢�ઠ, ��᫥������ ���㫥��� ��������
		loopNE L; �᫨ ������� ���� => �� ��室
		
	lea DX, N[BP-1]
	outstr
	
	newline
	mov AH, 8; 㤥ন����
	int 21h;   �⢥�
	finish
code ends
    end start 
