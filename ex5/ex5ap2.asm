include io.asm

stack segment stack
	dw 128 dup (?)
stack ends

data segment
	HELLO db '��窨� ������, 112 ��㯯�, ����� 5.2 �������⥫쭠�', '$'
	WEL db '������ ���� � �窮� � ����(��� ���᫥��� ���ᨬ㬠 ��� �����㬠):', '$'
	GB db '�������: ', '$'

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
		
		;४
	MMa:	push BX
		push CX
		xor DH, DH
		push DX; ����
		inch DL; (
		call MM
		xor AH, AH
		push AX
		inch DL; ,
		call MM
		xor AH, AH
		push AX
		inch DL; )
		pop CX; ��������� ����� ����
		pop BX; ����� ����
		pop AX; ����
		cmp BL, CL; �ࠢ������
		jAE CM
		xchg BL, CL; ������ ��� - �� BL
	CM:	cmp AL, 'M'; ��।��塞 max ��� min
		jE A; �᫨ ���ᨬ�, � ���室
		mov AL, CL; ���� ������ �� AL
		
		pop CX
		pop BX
		pop DX
		ret
		
	A:	mov AL, BL; ���ᨬ� �� AL
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
	
	lea DX, GB
	outstr
	
	xor AH, AH
	outint AX
	newline
	
	mov AH, 8; 㤥ন����
	int 21h;   �⢥�
	
    finish
code ends
    end start 
