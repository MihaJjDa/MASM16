include io.asm

stack segment stack
	dw 128 dup (?)
stack ends

data segment
	HELLO db '��窨� ������, 112 ��㯯�, ����� 4.2', '$'
	WEL db '������ ���� � �窮� � ����:', '$'
	GB db '�������: ', '$'

data ends

code segment 'code'
	assume ss:stack, ds:data, cs:code

start:
	mov ax,data
	mov ds,ax
	
	lea DX, HELLO
	outstr
	newline
	
	lea DX, WEL
	outstr
	newline
	
	xor DX, DX
	push DX; �� ��砩

L:	inch DL
	cmp DL, '.'; �饬 �����
	jNE L1; �᫨ �� ����� - ࠡ�⠥� �����
	jmp ex; ���� �� ��室

L1:	cmp DL, '('; �ய�᪠�� ���뢠�騥 ᪮���
	jE L
	
	cmp DL, ','; �ய�᪠�� ������
	jE L

	cmp DL, ')'; �饬 ����� ��।���� ��ࠦ����
	jNE L2; �᫨ �� ����� - ��ࠡ��뢠�� �����訩�� ���� ��� ����
	pop CX; ���� ��������� ����� ����
	pop BX; ����� ����
	pop AX; ����
	cmp BX, CX; �ࠢ������
	jAE CM
	xchg BX, CX; ������ ��� - �� BX
CM:	cmp AX, 'M'; ��।��塞 max ��� min
	jE A; �᫨ ���ᨬ�, � ���室
	push CX; ���� ������ � �⥪
	jmp L; � ����� � 横�
A:	push BX; ���ᨬ� 
	jmp L; ࠡ�⠥� � 横�� �����
	
L2:	cmp DL, 'M'; �饬 �� ����
	jE P; �� ��� - ����ᨬ � �⥪
	cmp DL, 'm'; �饬 �� ����
	jE P; �� ��� - ����ᨬ � �⥪
	sub DL, '0'; ��� - ������ �� ᨬ���� ���� ᠬ� ����
P:	push DX; � � �⥪
	jmp L; ࠡ�⠥� � 横��
	
ex: 	lea DX, GB
	outstr
	
	pop DX; �����祬 १����
	outint DX
	newline
	
	pop DX; 㡥६ 0
	mov AH, 8; 㤥ন����
	int 21h;   �⢥�
	
    finish
code ends
    end start 
