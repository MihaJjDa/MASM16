include io.asm

stack segment stack
	dw 128 dup (?)
stack ends

data segment
	HELLO db '��窨� ������, 112 ��㯯�, ����� 5.3 �������⥫쭠�', '$'
	WEL db '������ ���� ��� �ࠢ�����(�१ =):', '$'
	DA db '��', '$'
	NET db '���', '$'

data ends

code segment 'code'
	assume ss:stack, ds:data, cs:code

	MM proc near
		;�室 - � ���������� �������� ��㫠
		;१���� ���᫥��� - �� AL
		push DX
		
		inch DL
		cmp DL, '0'; �饬 ����
		jB MMa; �᫨ �� ��� - �� ४��ᨢ��� ����
		cmp DL, '9'
		jA MMa; �᫨ �� ��� - �� ४��ᨢ��� ����
		
		;��४
		sub DL, '0'	
		mov AL, DL	
		
		pop DX
		ret
		
		;४(�室�� � '(' )
	MMa:	push BX
		push CX
		call MM
		xor AH, AH
		push AX
		inch DL; ����
		xor DH, DH
		push DX
		call MM
		xor AH, AH
		push AX
		inch DL; )
		pop CX; ��������� ����� ����
		pop BX; ����
		pop AX; ����� ����
	CM:	cmp BL, '+'; ��।��塞 ����
		jE A; �᫨ +, � ���室
		sub AL, CL; ���� -
		
		pop CX
		pop BX
		pop DX
		ret
		
	A:	add AL, CL; +
		pop CX
		pop BX
		pop DX
		ret
	MM endp
	
start:
	mov ax,data
	mov ds,ax
	
	lea DX, HELLO
	outstr
	newline
	
	lea DX, WEL
	outstr
	newline
	
	call MM
	cbw
	push AX
	inch DL
	call MM
	pop BX
	
	cmp AL, BL
	jE D
	lea DX, NET
	jmp short exi
	
D:	lea DX, DA
	
	
exi:	outstr
	newline
	mov AH, 8; 㤥ন����
	int 21h;   �⢥�
	
    finish
code ends
    end start 
