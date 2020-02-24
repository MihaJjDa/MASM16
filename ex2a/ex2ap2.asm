include io.asm

stack segment stack
	dw 128 dup (?)
stack ends

data segment
	S1 db '��窨� ������, 112 ��㯯�, �������⥫쭠� ����� 2.2', '$'
	S2 db '������ ������ �᫠ (�� ����� 10 �ᥫ � �� ����� 祬 10-�� ��ࠬ�):', '$'
	S3 db '�訡�� �����! ���뢠��� ࠡ���'
	
	D dd 10 dup(?)
	BUF dd 0
	ANS db 10 dup(?), '$'

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
	
	;����
	mov SI, 10
	mov BH, 0
	mov CX, 10
	I:	inch BL
		cmp BL, '.'; �饬 ����� �����
		jNE K; �᫨ �� ����� => �த������ ࠡ���
		jmp OU; �᫨ ����� => �� �����⮢�� � �뢮��
		
K:		cmp BL, ','; �饬 ����� �᫠
		jNE G; �᫨ �� ����� => �த������ ���� �᫠
		jmp I1; �᫨ ����� => ����ᨬ �᫮ � ���ᨢ
			
G:		cmp BL, '0'; �஢��塞 ���४⭮��� �����
		jB F
		cmp BL, '9'
		jA F
		jmp short P; ���४�� ���� => �த������ �ନ஢��� �᫮
F:		jmp err 
		
P:		sub BL, '0'; �ନ�㥬 ����

		mov AX, word ptr BUF; 㬭������ ����襩 ��� �᫠ �� 10
		mul SI
		mov DI, AX; ᯠᠥ� १����� ��ࢮ�� 㬭������
		mov BP, DX
		
		mov AX, word ptr BUF + 2; 㬭������ ���襩 ��� �᫠ �� 10
		mul SI
		
		cmp DX, 0; �஢��塞 ��९�������
		jNE E
		add DI, BX; �ନ�㥬 �᫮
		adc BP, AX
		jC E; �஢��塞 ��९�������
		jmp short U
E:		jmp err
U:		mov word ptr BUF, DI; ��࠭塞 � ���� ⥪�饥 �᫮
		mov word ptr BUF + 2, BP
		
		jmp I; �த������ ���� ���

	I1: mov BP, CX; �ନ஢���� ����䨪���
		sub BP, 10
		neg BP
		add BP, BP
		add BP, BP
		
		mov AX, word ptr BUF; ����㦠�� � ���ᨢ ��।��� ������� �᫮
		mov word ptr D[BP], AX
		mov AX, word ptr BUF + 2
		mov word ptr D[BP] + 2, AX
		
		mov word ptr BUF, 0; ����塞 ���� ��� ���쭥�襩 ࠡ���
		mov word ptr BUF + 2, 0
		loop I
	

OU:	; ࠡ�� � ��᫥���� �������� �᫮�
	mov BP, CX; �ନ஢���� ����䨪���
	sub BP, 10
	neg BP
	add BP, BP
	add BP, BP
		
	mov AX, word ptr BUF; ����㦠�� � ���ᨢ ��।��� ������� �᫮
	mov word ptr D[BP], AX
	mov AX, word ptr BUF + 2
	mov word ptr D[BP] + 2, AX
	dec CX; 㬥��蠥� �� 1 ॣ���� ��� ���쭥�譥�� �뢮��

	; �����
	mov BP, 10; ����⥫�
	mov SI, -1; ���稪 䠪��᪮�� ���� ���ᨢ�
	
	sub CX, 10; �����⠢������ ������⢮ 蠣�� 横�� � ����ᨬ��� �� ������⢠ ��������� �ᥫ
	neg CX
	O:	push CX
		
		inc SI; ���室 � ᫥���饩 �祩��
		mov BX, SI; �ନ஢���� ����䨪���
		add BX, BX
		add BX, BX
		
		mov AX, word ptr D[BX]; �᫮ � ����
		mov word ptr BUF, AX
		mov AX, word ptr D[BX] + 2
		mov word ptr BUF + 2, AX
		
		mov CX, 10
	    O1:	mov DX, 0; ���� ��।��� ���� �१ �������
			mov AX, word ptr BUF + 2
			div BP
			mov word ptr BUF + 2, AX
			mov AX, word ptr BUF
			div BP
			mov word ptr BUF, AX
			
			mov BX, CX; �ନ஢���� ����䨪���
			add DL, '0'; �ନ஢���� ᨬ���� ����
			mov ANS[BX-1], DL; ������ ��।��� ����
			cmp word ptr BUF, 0; �஢�ઠ �� ������騥 �㫨 1
			jNE O2
			cmp word ptr BUF + 2, 0; �஢�ઠ �� ������騥 �㫨 2
		O2:	loopNE O1
		
		lea DX, ANS[BX-1]
		outstr
		newline
		
		pop CX
		loop O

	jmp short ex
err:lea DX, S3
	outstr
	
ex:	mov AH, 8; 㤥ন����
	int 21h;   �⢥�
	finish
code ends
    end start 
