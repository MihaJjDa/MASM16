include io.asm

stack segment stack
	dw 128 dup (?)
stack ends

data segment
	S1 db '��窨� ������, 112 ��㯯�, ����� 1.3', '$'
	AS1 dw S1
	S2 db '������ ��᫥����⥫쭮��� ᨬ����� � �窮� � ����', '$'
	AS2 dw S2
	S3 db '��᫥����⥫쭮��� ᡠ����஢��� �� ᪮����', '$'
	AS3 dw S3
	S4 db '��᫥����⥫쭮��� �� ᡠ����஢��� �� ᪮����', '$'
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
	
	mov AH, 0; ���稪
	
	L:	inch AL
	
		cmp AL, '.'; �饬 ����� ��᫥����⥫쭮��
		jE cp; ����� ��᫥����⥫쭮��� => �� �஢��� ������
		
		cmp AL, ')'; ࠡ�� � ����뢠�饩 ᪮����
		jNE L1; �� ����뢠����� => �஢�ઠ �� ���뢠����
		sub AH, 1
		cmp AH, 0
		jL NB; �������� �ࠢ�����, �᫨ ���稪 ����⥫�� => ��᫥����⥫쭮��� �� ᡠ����஢���
		jmp L; �� ���� ᨬ���
		
	L1:	cmp AL, '('
		jNE L; �� ���뢠��� => �� ���� ᨬ���
		add AH, 1
		jmp L; �� ���� ᨬ���
		
	cp:	cmp AH, 0; �஢�ઠ ���稪�
		jNE NB; ���稪 ᪮��� <> 0 => ��� ������ ᪮���
		
		mov DX, AS3
		outstr
		jmp ex
		
	NB:	mov DX, AS4
		outstr
		
	
ex:	newline
	mov AH, 8; 㤥ন�����
	int 21h;   �⢥�
	finish
code ends
    end start 
