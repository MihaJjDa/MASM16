include io.asm

stack segment stack
	dw 128 dup (?)
stack ends

data segment
	P dw ?
	Q dw ?
	S1 db '��窨� ������, 112 ��㯯�, ����� 1.4', '$'
	AS1 dw S1
	S2 db '������ �஡� � �ଠ� P/Q', '$'
	AS2 dw S2
	S3 db '������ P', '$'
	AS3 dw S3
	S4 db '������ Q', '$'
	AS4 dw S4
	S5 db '��᫮ � �����筮� �஡�: ', '$'
	AS5 dw S5
data ends

code segment 'code'
	assume ss:stack, ds:data, cs:code

start:
	mov ax,data
	mov ds,ax
	
	mov DX, AS1 
	outstr
	newline
	
	mov DX, AS2
	outstr
	newline
	
	mov DX, AS3
	outstr
	newline
	
	inint P
	
	mov DX, AS4
	outstr
	newline
	
	inint Q
	
	mov AX, P; ���� 楫�� ��� 
	mov DX, 0
	mov BX, Q
	
	div BX
	
	outword AX
	
	outch '.'
	
	mov SI, 10
	
	mov CX, 5
	L:	mov AX, DX; ���� ��।��� �����筮� ���� �஡��� ���
	    mul SI
		div BX
		outword AX
		loop L
			
	newline
	mov AH, 8; 㤥ন�����
	int 21h;   �⢥�
	finish
code ends
    end start
	