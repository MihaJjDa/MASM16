include io.asm

stack segment stack
	dw 128 dup (?)
stack ends

data segment
	S1 db '��窨� ������, 112 ��㯯�, ����� 1.9', '$'
	AS1 dw S1
	S2 db '������ ⥪��, ����騩 �� ᫮�, ࠧ�������� �����묨, � �����稢��騩�� �窮�', '$'
	AS2 dw S2
	S3 db '������⢮ ᫮�, ��稭������ � �����稢������ � ����� � ⮩ �� �㪢�: ', '$'
	AS3 dw S3
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
	
	mov CX, 0; c��稪
	; ⥪�� �� ���⮩, ����� �� ��⠢���� �᫮��� �஢�ન ���⮣� ⥪��
	L:	inch BL; ������ ���� ᨬ��� ᫮��
		mov AL, BL; ����ᨬ ���� ᨬ��� � ॣ����
		M:	mov AH, BL; ����ᨬ ����� ᫥���騩 ᨬ��� � �㣨���...
			inch BL
			cmp BL, '.';... ���� �� ����⨬ ���...
			jE oi1; ��諨 ��� => �� ��室
			
			cmp BL, ',';... ��� �������
			jNE M; �� ������ => �� ᫥���騩 ᨬ���
			
			cmp AH, AL; ������ => �ࠢ������ ���� � ��᫥���� ᨬ����
			jNE L; �� ࠢ�� => �� ����� ᫮��
			inc CX; ࠢ�� => ����蠥� ���稪...
			jmp L;...� �� ����� ᫮��
	
	oi1:cmp AL, AH; ��ࠡ�⪠ ��᫥����� ᫮��
		jNE oi
		inc CX
	
	oi:	mov DX, AS3
		outstr	
		outnum CX
	
	newline
	mov AH, 8; 㤥ন�����
	int 21h;   �⢥�
	finish
code ends
    end start
	