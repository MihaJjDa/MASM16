include io.asm

stack segment stack
	dw 128 dup (?)
stack ends

data segment
	S1 db '��窨� ������, 112 ��㯯�, �������⥫쭠� ����� 2.1', '$'
	S2 db '�뢮� ������� ᫮�:', '$'
	
	D dd 1, 12, 123, 1234, 12345, 123456, 1234567, 12345678, 123456789, 1234567890
	BUF dd ?
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
	
	mov BP, 10; ����⥫�
	mov SI, -1; ���稪 䠪��᪮�� ���� ���ᨢ�
	
	mov CX, 10
	L:	push CX
		
		inc SI; ���室 � ᫥���饩 �祩��
		mov BX, SI; �ନ஢���� ����䨪���
		add BX, BX
		add BX, BX
		
		mov AX, word ptr D[BX]; �᫮ � ����
		mov word ptr BUF, AX
		mov AX, word ptr D[BX] + 2
		mov word ptr BUF + 2, AX
		
		mov CX, 10
	    L1:	mov DX, 0; ���� ��।��� ���� �१ �������
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
			jNE L2
			cmp word ptr BUF + 2, 0; �஢�ઠ �� ������騥 �㫨 2
		L2:	loopNE L1
		
		lea DX, ANS[BX-1]
		outstr
		newline
		
		pop CX
		loop L
	
	
	mov AH, 8; 㤥ন����
	int 21h;   �⢥�
	finish
code ends
    end start 
