include io.asm

stack segment stack
	dw 128 dup (?)
stack ends

data segment
	WELC db '������ ��窨�, ��㯯� 112, ����� 6.3 �������⥫쭠�', '$'
	HELLO1 db '������ ����� ��ப�:', '$'
	HELLO2 db '������ ��ப� ������ �����:', '$'
	BB db '��ப� ��� �஡����:', '$'
	LEN equ 256
	S db LEN dup(?)

data ends

code segment 'code'
	assume ss:stack, ds:data, es:data, cs:code

start:
	mov AX, data
	mov ds, AX
	mov AX, data
	mov es, AX
	
	lea DX, WELC
	outstr
	newline
	
	lea DX, HELLO1
	outstr
	newline
	inint CX; ���� ����� ��ப�
	mov S, CL; ����ᨬ � �㫥��� �祩�� ����� ��ப�

	
	lea DX, HELLO2
	outstr
	newline
	jCXZ CXZ1
	cld
	lea DI, S+1; ����䨪��� ��� �����
INP:	inch AL; ���� ��ப�
	stosB
	loop INP
	
	; 㤠����� �஡����
	xor CH, CH
	mov CL, S
	lea SI, S+1; ����ன�� ����䨪��� ��� ���᪠ �஡����
	lea DI, S+1; ����ன�� ����䨪��� ��� ��⠢�� ᨬ�����
PER:	lodsB; ���㦠�� ��।��� ᨬ���
	cmp AL, ' '; �饬 �஡��
	jE PER1; �᫨ �஡�� => �� ᫥���騩 蠣 横��
	stosB; ���� ����㦠��
	jmp short PER2
PER1:	dec byte ptr S
PER2:	loop PER
	

	; �뢮� ��ப�
	xor CH, CH
	mov CL, S; ���ᨬ��쭮� �᫮ 蠣�� �뢮��
	lea SI, S+1; ����ந���� ����䨪��� ��� �뢮��
	
CXZ1:	lea DX, BB
	outstr
	newline
	jCXZ CXZ2

OU1:	lodsB; ���㦠�� ᨬ��� �� ��ப�
	outch AL; �뢮� ��।���� ᨬ����
	loop OU1
	
CXZ2:	mov AH, 8; 㤥ঠ���
	int 21h;   �⢥�
	newline
    finish
code ends
    end start
