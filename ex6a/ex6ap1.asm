include io.asm

stack segment stack
	dw 128 dup (?)
stack ends

data segment
	WELC db '������ ��窨�, ��㯯� 112, ����� 6.1 �������⥫쭠�', '$'
	HELLO db '������ ��ப� �� 10 ᨬ�����', '$'
	BB db '��ப� ��� ���:', '$'
	LEN equ 10
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
	lea DX, HELLO
	outstr
	newline
	
	; ���� ��ப�
	cld; ���४�஢�� ���ࠢ�����
	lea DI, S; �����⮢�� ����䨪���
	mov CX, LEN; ���ᨬ��쭠� ����� ⥪��
INP:	inch AL; ���� ��।���� ᨬ����
	stosB; AL � ��ப�
	loop INP

	; 㤠����� �ᥫ
	lea SI, S; �� SI - �⥭�� ��।���� ᨬ���� �� ��ப�
	lea DI, S; �� DI - ���������� ��ப� � 㤠������ ���
	mov CX, LEN; ����� ��ப�
PER:	lodsB; ���㦠�� ��।��� ᨬ���
	cmp AL, '0'; �饬 ����
	jB PER1; �᫨ ��� - �� ᫥���騩 蠣 横��
	cmp AL, '9'
	jA PER1; �᫨ ��� - �� ᫥���騩 蠣 横��
	jmp short PER2
PER1:	stosB	
PER2:	loop PER
	;���������� �஡�����
	mov CX, SI; ������⢮ �஡���� = SI - DI
	sub CX, DI
	mov AL, ' '
rep	stosB

	; �뢮� ��ப�
	lea DX, BB
	outstr
	newline
	mov CX, LEN; ���ᨬ��쭮� �᫮ 蠣�� �뢮��
	lea SI, S; ����ந���� ����䨪��� ��� �뢮��
OU1:	lodsB; ���㦠�� ᨬ��� �� ��ப�
	outch AL; �뢮� ��।���� ᨬ����
	loop OU1
	
	mov AH, 8; 㤥ঠ���
	int 21h;   �⢥�
	newline
    finish
code ends
    end start
