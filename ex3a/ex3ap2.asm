include io.asm

stack segment stack
	dw 128 dup (?)
stack ends

data segment
	S1 db '������ ��窨�, 112 ��㯯�, ����� 3.2 �������⥫쭠�', '$'
	S2 db '����� � ������⢮�', '$'
	S3 db '������ �������: ', '$'
	S4 db '����ୠ� �������!', '$'
	S5 db '��᫮ �� �室�� � ������⢮', '$'
	S6 db '��᫮ �室�� � ������⢮', '$'
	S7 db '������⢮ ����⮢ ������⢠: ', '$'
	S8 db '�������� ������⢠:', '$'
	
	L equ 5
	R equ 155
	S db (R-L)/8 + 1 dup (0)

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
	
PR:	lea DX, S3
	outstr

	flush
	inch DL
	
	cmp DL, '.'
	jNE PR1
	jmp ex
	
PR1:	cmp DL, '+'
	jNE PR2
	jmp NA
	
PR2:	cmp DL, '-'
	jNE PR3
	jmp NS
	
PR3:cmp DL, '?'
	jNE PR4
	jmp NQ
	
PR4:cmp DL, '='
	jNE PR5
	jmp NR
	
PR5:cmp DL, ':'
	jNE err
	jmp NO
	
err:lea DX, S4
	outstr
	newline
	jmp PR

NA:	inint BX
	cmp BX, L
	jB ENA
	cmp BX, R
	jA ENA
	jmp short NA1
ENA:	jmp err
NA1:	sub BX, L
	mov AX, BX
	
	mov CL, 3
	shR BX, CL; ���� �᫠
	
	and AL, 111b; ��� �᫠
	mov CL, 10000000b; ��᪠ ����������
	Xchg AL, CL
	RoR AL, CL
	or S[BX], AL
	jmp PR
	
NS:	inint BX
	cmp BX, L
	jB ENS
	cmp BX, R
	jA ENS
	jmp short NS1
ENS:jmp err

NS1:sub BX, L
	mov AX, BX
	
	mov CL, 3
	shR BX, CL; ���� �᫠
	
	and AL, 111b; ��� �᫠
	mov CL, 01111111b; ��᪠ 㤠�����
	Xchg AL, CL
	RoR AL, CL
	and S[BX], AL
	jmp PR
	
NQ:	inint BX
	cmp BX, L
	jB ENQ
	cmp BX, R
	jA ENQ
	jmp short NQ1
ENQ:	jmp err

NQ1:	sub BX, L
	mov AX, BX
	
	mov CL, 3
	shR BX, CL; ���� �᫠
	
	and AL, 111b;��� �᫠
	mov CL, 10000000b; ��᪠ ���᪠
	Xchg AL, CL
	RoR AL, CL; ����砥� ������� ��� �������騬 ��⮬
	and AL, S[BX]; 㬭�����
	jNZ NQY; �᫨ �� ����, � �᫮ ����

	lea DX, S5; ���� ��� ���
	outstr
	newline
	jmp PR
NQY:lea DX, S6
	outstr
	newline
	jmp PR	

NR:	mov AL, 0; ���稪
	mov CX,(R-L)/8+1; �᫮ ���⮢ ������⢠
B:	mov BX, CX; �ନ�㥬 ����䨪���
	dec BX
	mov AH, S[BX]; ����㦠�� �� ॣ���� ⥪�騩 ����
	push CX
	mov CX, 8; �஢�ਬ ����� ���
	Bi:	shL AH, 1; ᤢ�����, �饬 CF = 1
		jNC LBi; �᫨ CF = 0 - �� ��砫� 横��
		inc AL; ���� ����蠥� ���稪
	LBi:loop Bi
	pop CX
	loop B
	lea DX, S7
	outstr
	outword AX
	newline
	jmp PR

NO:	lea DX, S8
	outstr
	mov DX, L-1; ���稪 �᫠ ��� �뢮��
	mov CX,(R-L)/8+1
F:	mov BX, CX; �ନ�㥬 ����䨪���
	dec BX
	sub BX, 18; �� ⥯� ���� � ��砫� ������⢠
	neg BX
	mov AH, S[BX]
	push CX
	mov CX, 8
	Fi:	inc DX; �஢��塞 ᫥���饥 �᫮
		shL AH, 1; �饬 CF = 1
		jNC LFi
		outword DX, 4; �뢮��� � ��砥 ������ �᫠ � ������⢥
	LFi:loop Fi
	pop CX
	loop F
	newline
	jmp PR	

ex:	mov AH, 8; 㤥ন���
	int 21h;   �⢥�
	finish
code ends
    end start 
