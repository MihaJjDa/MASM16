; ��� ����������� ����������� ������� ���� �����������
; ��������� 866 (� Notepad++: ���� ��������� - ��������� -
; ��������� - OEM 866).
; �᫨ ⥪��, ��稭�� � �⮩ ��ப�, �⠥��� ��ଠ�쭮,
; � 䠩� � �ࠢ��쭮� ����஢��.

include io.asm ;������祭�� ����権 �����-�뢮��

stack segment stack
	dw 128 dup (?)
stack ends

data segment
; ���� ��� ��६����� � ����⠭�
	N EQU 100
	A DB N DUP(?) 
	B DB 26 DUP(0)

data ends

code segment 'code'
	assume ss:stack, ds:data, cs:code
; ���� ��� ���ᠭ�� ��楤��

start:
	mov ax,data
	mov ds,ax
; ������� �ணࠬ�� ������ �ᯮ�������� �����
	
	mov BP, 0
L:	inch AH
	mov A[BP], AH
	INC BP
	cmp AH, '.'
	jE ex
	jmp L
ex:	mov BH, 0
	mov BP, 0
L2:	cmp A[BP], '.'
	JE print
	mov BL, A[BP]
	SUB BL, 'a'
	inc B[BX]
	inc BP
	JMP L2
print: 
	mov BP, 0
	mov AH, 0
L3:	mov AL, B[BP]
	inc BP
	outint AX
	cmp bp, 26
	je exit
	jmp L3
exit: newline

	
	
	
	mov AH, 8; 㤥ন����
	int 21h;   �⢥�
	
    finish
code ends
    end start 
