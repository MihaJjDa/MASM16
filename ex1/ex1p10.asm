include io.asm

stack segment stack
	dw 128 dup (?)
stack ends

data segment
	S1 db '��窨� ������, 112 ��㯯�, ����� 1.10 '$'
	AS1 dw S1
	S2 db '������ 㬭������ ���������� �ᥫ', '$'
	AS2 dw S2
	S3 db '  |  0  1  2  3  4  5  6  7  8  9', '$'
	AS3 dw S3
    S4 db 33 dup('-'), '$'
	AS4 dw S4
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
	
	mov DX, AS4
	outstr
	
	mov BX, 0; ��砫쭮� ���祭�� �⮫�殢�� �����⥫�� (word - ��� �뢮��)
	; BH �� �६� �믮������ �ணࠬ�� �ᥣ�� 0
	mov CX, 10
	L:	newline
		outnum BX
		outch ' '
		outch '|'
		mov DL, 0; ��砫쭮� ���祭�� ��ப���� �����⥫��
		mov SI, CX
		mov CX, 10
		K: 	mov AL, BL; �⮫�殢� �����⥫� � ॣ����()
			mul DL; ���祭�� ��� ⠡����, AH �� �㦭� �������
			outnum AX, 3
			inc DL; ᫥���騩 ��ப��� �����⥫�
			loop K
		mov CX, SI
		inc BX; ᫥���騩 �⮫�殢� �����⥫�	
		loop L
	
	newline
	mov AH, 8; 㤥ন�����
	int 21h;   �⢥�
	finish
code ends
    end start
	