include io.asm

stack segment stack
	dw 128 dup (?)
stack ends

data segment
	WELC db '������ ��窨�, ��㯯� 112, ����� 6.2 �������⥫쭠�', '$'
	HELLO1 db '������ ����� ��ப�:', '$'
	HELLO2 db '������ ��ப� ������ �����:', '$'
	BB db '��ப� � ������� ������ �㪢:', '$'
	LEN equ 256
	S db LEN dup(?)
	S1 db 'abcdefghijklmnopqrstuvwxyz'; �ᯮ����⥫쭠� ��ப�


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
	
	; ������ ������ �㪢 �� �����쪨�
	xor BH, BH; ����ன�� ����䨪���
	xor CH, CH; � CX - ����� ��ப�
	mov CL, S
	lea SI, S+1; ����ன�� ����䨪��� ��� ���᪠ ������ �㪢
PER:	lodsB; ���㦠�� ��।��� ᨬ���
	cmp AL, 'A'; �饬 ������ �㪢�
	jB PER1; �᫨ �� ��諨 => �� ᫥���騩 蠣 横��
	cmp AL, 'Z'
	jA PER1; �᫨ �� ��諨 => �� ᫥���騩 蠣 横��
	sub AL, 'A'; �᫨ ��諨 => ����塞 ����� �㪢�
	mov BL, AL; �ନ�㥬 ����䨪���
	mov AL, S1[BX]; ����㦠�� � AL �������� �㪢�
	mov DI, SI; �ନ�㥬 ����䨪��� ��� ����㧪� ᨬ���� � ��ப�
	dec DI
	stosB; ����㦠�� � ��ப� �������� �㪢�
PER1:	loop PER
	

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
