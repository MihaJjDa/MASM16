include io.asm

stack segment stack
	dw 128 dup (?)
stack ends

data segment
	S1 db '��窨� ������, 112 ��㯯�, ����� 2.4', '$'
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
	
	mov BX, 16; �ନ�㥬 ����⥫�
	mov CX, 5; ���ᨬ��쭮� ������⢮ 蠣�� 横��
	mov DH, 0; �ନ�㥬 ���⮪, � 横�� ࠡ�⠥� ⮫쪮 � DL
	
	inint AX
	
	L: 	mov DL, 0;�ନ�㥬 �������
		div BX; � AX - ��⠢襥�� ����ॢ������� �᫮, � DL - ��� �����筮� ����� �᫠, � DH - 0
		cmp DL, 10
		jAE H; 16-�� ��� =>  
		add DL, '0'; �ନ�㥬 ᨬ��� ᮮ⢥�����騩 10-� ���
		jmp short I
	H:	add DL, 'A'-10; �ନ�㥬 ᨬ��� ᮮ⢥�����騩 16-� ���
	
	I:	mov BP, CX; �ନ�㥬 ����䨪��� ��� ���ᨢ�, �࠭�饣� �᫮ � ᨬ���쭮� �����
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
