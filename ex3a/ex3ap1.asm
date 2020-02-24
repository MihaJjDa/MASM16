include io.asm

stack segment stack
	dw 128 dup (?)
stack ends

data segment
	S1 db '������ ��窨�, 112 ��㯯�, ����� 3.1 �������⥫쭠�', '$'
	S2 db '������ ����筮� �᫮ �� 16 ��� � �஡���� � ����', '$'
	S3 db '�������������: ', '$'
	S4 db '�����������:', '$'

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
	
	xor AX, AX
	xor CL, CL
	
I:	inch DL; ���� ���⮩, �������� ��� �������ਥ�
	cmp DL, ' '
	jNE I1
	cmp CX, 3
	jE PR
	inc CL
	jmp I
I1:	sub DL, '0'
	shL AX, 1
	or AL, DL
	jmp I	

PR:	mov CX, 16
L:	RoR AX, 1; �ନ��� ��ॢ���⮥ ��������� �᫮
	RcL BX, 1	
	loop L	
	not BX; ��ࠦ��
	test AX, BX; � ��� ���� �१ ��� 㬭������
	jZ S
	
	lea DX, S3; ��ᨬ����筮
	outstr
	not BX
	and BX, 0000000110000000b; � BX - ��ॢ���⮥ AX, ᯠᠥ� �㦭� ��� ����
	and AX, 1111111001111111b; 㤠�塞 㦥 ���㦭� ����
	or AX, BX; ����砥� ����室���� �᫮
	jmp OU
	

S:	lea DX, S4
	outstr
	cmp AX, 0; �⤥��� ��砩, ����� �᫮ - 0, ⠪ ��� ���� �㤥� ��横������� �����
	jZ OU
	mov CL, 8
	RoR AX, CL; �८�ࠧ㥬 �᫮ ⠪�� ��ࠧ��, �⮡� 業�� �᫠ �������� �� ��� ����
	xor CL, CL
R:	RoR AX, 1; �饬 ��ࢮ� �宦����� �������(᪮�쪮 ᤢ���� �㦭� ᤥ���� �⮡� ������� �� 1)
	inc CL; ��⠥� ᤨ���
	jNC R
	; ��諨 => ᤢ���� �����, �⮡� �㦭�� ������ ��������� �� ���
	and AX, 0111111111111111b; ����塞 ��
	RoL AX, CL; ᤢ����� ��� ࠧ� ⠪, �⮡� ���� ������ ��������� �� �ࠢ�� ���
	RoL AX, CL; ��⠫ � �ᮢ�� �� �㬠���, ᫮��� ���᭮���� ������
	and AX, 1111111111111110b; ����塞
	RoR AX, CL; �����頥� �᫮ � ���ﭨ� �� ��ࠡ�⪨
	mov CL, 8
	RoL AX, CL; �����頥� �᫮ � ��室��� ���ﭨ�	
	
OU:	mov CX, 16
	xor BL, BL
M:	RoL AX, 1
	jC O1
	outword 0
	jmp short LM
O1:	outword 1
LM:	inc BL
	cmp BL, 4
	jNE LOM
	xor BL, BL
	outch ' '
LOM:loop M


ex:	newline
	mov AH, 8; 㤥ন���
	int 21h;   �⢥�
	finish
code ends
    end start 
