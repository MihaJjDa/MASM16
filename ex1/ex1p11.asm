include io.asm

stack segment stack
	dw 128 dup (?)
stack ends

data segment
	S1 db '��窨� ������, 112 ��㯯�, ����� 1.11', '$'
	AS1 dw S1
data ends

code segment 'code'
	assume ss:stack, ds:data, cs:code

start:
	mov ax,data
	mov ds,ax
	
	mov DX, AS1 
	outstr
	newline
	
	mov BL, 10; ����⥫�
	mov DL, 0; ���稪
	
	mov CX, 102; 102 - ��ࢮ� ���室�饥 �᫮
	L:	mov AX, CX; ������ �᫮ �� ࠡ���
		div BL; ����砥� ����� ����, ���⪮�� ������� �����筮 (�.�. max N div 10 = 99, mod = 9)
		mov BH, AH; ����� ���� - �� BH
		mov AH, 0; �����⠢������ ᫥��饥 �������
		div BL; ���� � ����� ���� - �� AH � AL
		cmp AH, AL; ������ �ࠢ�����
		jE L1; = => �� ᫥���饥 �᫮
		
		cmp AH, BH
		jE L1; = => �� ᫥���饥 �᫮
		
		cmp BH, AL
		jE L1; = => �� ᫥���饥 �᫮
		
		outnum CX, 4 
		inc DL; �뢥�� => ����ᨫ� ���稪
		cmp DL, 18; �뢥�� �� 18 �ᥫ?
		jNE L1; �� �뢥�� => �� ᫥���饥 �᫮
		
		mov DL, 0; �뢥�� => ���㫨� ���稪
		newline; � ��ॢ���� ��ப�
	L1:	inc CX; ����砥� ᫥���饥 �᫮
		cmp CX, 988; 987 - ���ᨬ��쭮� �㦭�� �᫮
		jE ex; 988 => �� ��室
		jmp L; �� 988 => �த������ ࠡ���
			
ex:	mov AH, 8; 㤥ন�����
	int 21h;   �⢥�
	finish; �⢥� �� ������� � �࠭
code ends
    end start
	