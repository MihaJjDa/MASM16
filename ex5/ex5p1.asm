include io.asm

stack segment stack
	dw 128 dup (?)
stack ends

data segment
	WELC db '����� ���', '$'
	HELLO db '������ ⥪�� �� �� ����� 100 ᨬ����� � �窮� � ����', '$'
	S db 100 dup(?)
	FIR db '��ࢠ� ��ࠡ�⪠ ⥪��', '$'
	SEC db '���� ��ࠡ�⪠ ⥪��', '$'

data ends



code segment 'code'
	assume ss:stack, ds:data, es:data, cs:code
	
	OUTP proc near
		;�室: BX - ���� ⥪��, AX - ����� ⥪��
		;��室: �뢮� ⥪�� �� ����� BX ����� AX
		push CX
		push BX; ᯠᥭ�� ॣ���஢
		push AX
		
		mov CX, AX; ������⢮ 蠣�� �뢮�� ���� ����� ��ப�, ����� � AX
		jCXZ OU2
		dec BX
	OU1:	inc BX; ���४��㥬 ����䨪���
		mov AL, [BX]; �� ॣ���� ��� �뢮��
		outch AL; �뢮� ��।���� ᨬ����
		loop OU1
		
	OU2:	pop AX
		pop BX
		pop CX
		ret
	OUTP endp
	
	
	PROP proc near
		;�室: X1 - ���� ⥪��, X2 - ����� ⥪��
		;��室: ��⠭���� ZF
		push BP
		mov BP, SP
		
		push CX
		push BX;
		push AX; ᯠᥭ�� ॣ���஢
		
		mov BX, [BP+6]; ���� ⥪��
		mov DI, [BP+4]; ����� ⥪��
		dec BX
		cmp byte ptr [BX], '0'
		jB NO
		cmp byte ptr [BX], '9'
		jA NO
		cmp byte ptr [BX][DI-1], '0'
		jB NO
		cmp byte ptr [BX][DI-1], '9'
		jA NO
		mov AL, [BX]
		mov AH, [BX][DI-1]		
		xor AL, AH; ZF=1 => ��������� ����, ZF=0 => ���� 
		jmp short fin
	NO:	xor AL, AL
		xor AL, 1; ZF = 0
		
	fin:	pop AX
		pop BX
		pop CX
		
		pop BP
		ret 4
	PROP endp
	
	
	PER1 proc near
		;�室: X1 - ���� ⥪��, X2 - ����� ⥪��
		;��室: �८�ࠧ������� ��ப�
		push BP
		mov BP, SP
		
		push AX; ᯠᥭ�� ॣ���஢
		push BX
		push CX
		push SI
		push DI
		
		cld
		mov SI, [BP+6]; � SI - ���� ⥪��
		mov CX, [BP+4]; � CX - ����� ⥪��
		xor BH, BH; ����ன�� ����䨪��� ��� ���᪠ ������ �㪢
	P11:	lodsB; ���㦠�� ��।��� ᨬ���
		cmp AL, 'a'; �饬 �������� �㪢�
		jB P12; �᫨ �� ��諨 => �� ᫥���騩 蠣 横��
		cmp AL, 'a'
		jA P12; �᫨ �� ��諨 => �� ᫥���騩 蠣 横��
		sub AL, 'a'; �᫨ ��諨 => ����塞 ����� �㪢�
		mov BL, AL; �ନ�㥬 ����䨪���
		mov AL, cs:S1[BX]; ����㦠�� � AL �������� �㪢�
		mov DI, SI; �ନ�㥬 ����䨪��� ��� ����㧪� ᨬ���� � ⥪��
		dec DI
		mov ds:[DI], AL; ����㦠�� � ⥪�� �������� �㪢�;
	P12:	loop P11
	
		pop DI
		pop SI
		pop CX
		pop BX
		pop AX
	
		pop BP
		ret 4
		S1 db 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'
	PER1 endp
	
	
	PER2 proc near
		;�室: X1 - ���� ⥪��, X2 - ����� ⥪��
		;��室: �८�ࠧ������� ��ப�, AX - ����� ����� ⥪��
		push BP
		mov BP, SP
		
		; ᯠᥭ�� ॣ���஢
		push BX
		push CX
		push SI
		push DI
		
		cld
		mov SI, [BP+6]; � SI - ���� ⥪��
		mov CX, [BP+4]; � CX - ����� ⥪��
		xor BH, BH; ����ன�� ����䨪��� ��� ���᪠ ������ �㪢
	P21:	lodsB; ���㦠�� ��।��� ᨬ���
		cmp AL, 'A'; �饬 ������� �㪢�
		jB P22; �᫨ �� ��諨 => �饬 �������� �㪢�
		cmp AL, 'Z'
		jA P22; �᫨ �� ��諨 => �饬 �������� �㪢�
		sub AL, 'A'; �᫨ ��諨 => ����塞 ����� �㪢�
		mov BL, AL; �ନ�㥬 ����䨪���
		inc byte ptr cs:S2[BX]; 㢥��稢��� ���稪 �㪢�
		jmp short P23
	P22:	cmp AL, 'a'; �饬 �������� �㪢�
		jB P23; �᫨ �� ��諨 => �� ᫥���騩 蠣 横��
		cmp AL, 'z'
		jA P23; �᫨ �� ��諨 => �� ᫥���騩 蠣 横��
		sub AL, 'a'; �᫨ ��諨 => ����塞 ����� �㪢�
		mov BL, AL; �ନ�㥬 ����䨪���
		inc byte ptr cs:S2[BX+26]; 㢥��稢��� ���稪 �㪢
	P23:	loop P21
	
	
		xor AH, AH; �ନ�㥬 ����� ����� ��ப�
		mov SI, [BP+6]; � SI - ���� ⥪��
		mov CX, [BP+4]; � CX - ����� ⥪��
		mov DI, [BP+6]
	P24:	lodsB; ���㦠�� ��।��� ᨬ���
		cmp AL, 'A'; �饬 ������� �㪢�
		jB P25; �᫨ �� ��諨 => �饬 �������� �㪢�
		cmp AL, 'Z'
		jA P25; �᫨ �� ��諨 => �饬 �������� �㪢�
		mov BL, AL; �ନ�㥬 ����䨪���
		sub BL, 'A'
		cmp byte ptr cs:S2[BX], 1; �஢��塞 ������⢮ �宦����� �㪢� � ⥪��
		jNE P27; �᫨ �� 1 => �� ᫥���騩 蠣 横��
		jmp short P26; ���� �뢮���
	P25:	cmp AL, 'a'; �饬 �������� �㪢�
		jB P27; �᫨ �� ��諨 => �� ᫥���騩 蠣 横��
		cmp AL, 'z'
		jA P27; �᫨ �� ��諨 => �� ᫥���騩 蠣 横��
		mov BL, AL; �ନ�㥬 ����䨪���
		sub BL, 'a'
		cmp byte ptr cs:S2[BX+26], 1; �஢��塞 ������⢮ �宦����� �㪢� � ⥪��
		jNE P27; �᫨ �� 1 => �� ᫥���騩 蠣 横��, ���� �뢮���
	P26:	inc AH; 㢥��稢��� ����� ⥪��
		mov ds:[DI], AL; � ��� �� ����� �����!!!!!
		inc DI
	P27:	loop P24
	
		mov AL, AH; �ନ஢���� ����� ����� ⥪�� � �ଠ� ᫮��
		xor AH, AH
		
		pop DI
		pop SI
		pop CX
		pop BX
		
		pop BP
		ret 4
		S2 db 26*2 dup(0)
	PER2 endp
	
	

start:
	mov AX, data
	mov DS, AX
	
	lea DX, WELC
	outstr
	newline
	lea DX, HELLO
	outstr
	newline
	
	; ���� ⥪��
	xor BX, BX; �����⮢�� ����䨪���
	mov CX, 100; ���ᨬ��쭠� ����� ⥪��
IN1:	inch AL; ���� ��।���� ᨬ����
	cmp AL, '.'; �饬 ����� ⥪��, ��� � ⥪�� �� ������
	jE IN2; ��諨 => �� ��室
	mov S[BX], AL; ���� ����ᨬ � ���ᨢ ᨬ���
	inc BL; � ���४��㥬 ����䨪��� (� �⮣� � BX �㤥� �࠭����� ����� ⥪��)
	loop IN1
IN2:	mov AX, BX
	lea BX, S


	; �஢�ઠ ᢮��⢠
	push BX
	push AX
	call PROP
	jZ PERF2
	
	; ��ࢠ� ��ࠡ�⪠
	lea DX, FIR 
	outstr
	newline
	push BX
	push AX
	call PER1
	jmp OUT1

PERF2:; ���� ��ࠡ�⪠
	lea DX, SEC 
	outstr
	newline	
	push BX
	push AX
	call PER2
	
	; �뢮� ⥪�� 
OUT1:	call OUTP
	
EX:	mov AH, 8; 㤥ঠ���
	int 21h;   �⢥�
	newline
    finish
code ends
    end start
