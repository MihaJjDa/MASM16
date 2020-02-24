include io.asm

stack segment stack
	dw 128 dup (?)
stack ends

data segment
	S1 db '��窨� ������, 112 ��㯯�, �������⥫쭠� ����� 2.4', '$'
	S2 db '������ 2 �᫠:', '$'
	S3 db '�訡�� �����! ���뢠��� ࠡ���'
	S4 db '�ந�������� ��� �ᥫ:', '$'
	
	D dd 2 dup(?)
	W dd 2 dup(?)
	BUF dd 2 dup (0)
	ANS db 20 dup(0), '$'

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
	mov CX, 2
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
		sub BP, 2
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
	sub BP, 2
	neg BP
	add BP, BP
	add BP, BP
		
	mov AX, word ptr BUF; ����㦠�� � ���ᨢ ��।��� ������� �᫮
	mov word ptr D[BP], AX
	mov AX, word ptr BUF + 2
	mov word ptr D[BP] + 2, AX
	; ���������
	mov AX, word ptr D; ᯨᠫ � ��ࠤ�� �/�, �������� ��� �������ਥ�, �奬� ���稫 �� �㡮�
	mul word ptr D[4]
	mov word ptr W, AX
	mov word ptr W[2], DX
	
	mov AX, word ptr D[2]
	mul word ptr D[6]
	mov word ptr W[4], AX
	mov word ptr W[6], DX
	
	mov AX, word ptr D
	mul word ptr D[6]
	add word ptr W[2], AX
	adc word ptr W[4], DX
	adc word ptr W[6], 0
	
	mov AX, word ptr D[2]
	mul word ptr D[4]
	add word ptr W[2], AX
	adc word ptr W[4], DX
	adc word ptr W[6], 0
	
	; �����
OT:	lea DX, S4
	outstr
	newline
	
	mov BP, 10; ����⥫�
	
	mov BX, -2
	mov CX, 4
MVB:add BX, 2
	mov AX, word ptr W[BX]; �᫮ � ����
	mov word ptr BUF[BX], AX
	loop MVB
		
	mov CX, 20
    O1:	push CX

			mov CX, 4
			mov BX, 8 
			mov DX, 0; ���� ��।��� ���� �१ �������
		O3:	sub BX, 2
			mov AX, word ptr BUF[BX]
			div BP
			mov word ptr BUF[BX], AX
			loop O3
			
		pop CX
		
		mov BX, CX; �ନ஢���� ����䨪���
		add DL, '0'; �ନ஢���� ᨬ���� ����
		mov ANS[BX-1], DL; ������ ��।��� ����
		
		push CX
		
		mov CX, 4
		mov SI, -2
		O4:	add SI, 2
			cmp word ptr BUF[SI], 0; �஢�ઠ �� ������騥 �㫨
			jNE O2
			loop O4
			
	O2:	pop CX
		loopNE O1
	
		lea DX, ANS[BX-1]
		outstr
		newline
		
	jmp short ex
err:lea DX, S3
	outstr
	newline
	
ex:	mov AH, 8; 㤥ন����
	int 21h;   �⢥�
	finish
code ends
    end start 
	