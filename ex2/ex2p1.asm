include io.asm

stack segment stack
	dw 128 dup (?)
stack ends

data segment
	S1 db '��窨� ������, 112 ��㯯�, ����� 2.1', '$'
	S2 db '������ ⥪�� �� ������ ��⨭᪨� �㪢 � �窮� � ����', '$'

	LAT db 26 dup(0)

data ends

code segment 'code'
	assume ss:stack, ds:data, cs:code

start:
	mov ax,data
	mov ds,ax
	
	lea DX, S1 
	outstr
	newline
	
	lea DX, S2
	outstr
	newline
	
	mov BH, 0; �ନ�㥬 ����䨪���, ࠡ�⠥� ⮫쪮 � BL, �.�. �� �멤�� �� �������� byte
	L: 	inch BL
		cmp BL, '.'; �饬 ����� ⥪��
		jE ex; �᫨ ����� => �� ��室
		sub BL, 'A'; �ନ�㥬 ����䨪��� ��� �㦭�� �祩��
		cmp LAT[BX], 1; �஢��塞 �宦�����
		jE L; �᫨ �� ��ࢮ� => �� ���� 蠣 横��
		mov LAT[BX], 1; ���� 䨪��㥬 �宦�����
		add BL, 'A'; �ନ�㥬 �㪢�
		outch BL
		jmp L		
  
ex:	newline
	mov AH, 8; 㤥ন����
	int 21h;   �⢥�
	finish
code ends
    end start 
