include io.asm

stack segment stack
	dw 128 dup (?)
stack ends

data segment
	MaxSize equ 1000
	n dw ?
	m dw ?
	X dw MaxSize dup(?)
	
	WELC db '������ ��窨�, ��㯯� 112, ����� 5.1 �������⥫쭠�', '$'
	MSTR db '������ ������⢮ ��ப ������', '$'
	MCOL db '������ ������⢮ �⮫�殢 ������', '$'
	ERSC db '�訡�� ����� ࠧ��஢!', '$'
	YN db '������� ���� ࠧ��஢ ������?(Y/N)', '$'
	MCL db '������ ������ ������ ࠧ��஢', '$'
	MOU db '��������� �����:', '$'
	SND db '����冷祭�� �� ���뢠��� ��ப�: ', '$'
	SSM db '��������� ��ப�: ', '$'
	ECOL db '�⮫��� � ࠢ�묨 ����⠬�: ', '$'
	MDG db '������� ���������: ', '$'
	SDG db '����筠� ���������: ', '$'
	NY db '�த������ ࠡ��� �ணࠬ��?(Y/N)', '$'
data ends

pr segment 'code'
	assume ss:stack, cs:pr, ds:data
	
	outm proc far
		;�室: X1 - ᥣ���� ������, X2 - ���� ������ � ᥣ����, 
		;X3 - ������⢮ ��ப ������, X4 - ������⢮ �⮫�殢 ������
		;��室: �뢮� ������
		push BP
		mov BP, SP
		
		push AX
		push BX
		push CX
		push DX
		push ds
		
		mov DX, [BP + 6]
		mov CX, [BP + 8]; �� CX - ������⢮ ��ப
		mov BX, [BP + 10]
		mov AX, [BP + 12]
		mov ds, AX		

	OM:	push CX
		mov CX, DX
	OS:	mov AX, ds:[BX]; �뢮� ��ப�
		outint AX
		outch ' '
		add BX, 2
		loop OS
		newline
		pop CX
		loop OM
		
		pop ds
		pop DX
		pop CX
		pop BX
		pop AX
		
		pop BP
		
		ret 2*4		
	outm endp
	
	nondec proc far
		;�室: X1 - ᥣ���� ������, X2 - ���� ������ � ᥣ����, 
		;X3 - ������⢮ ��ப ������, X4 - ������⢮ �⮫�殢 ������
		;��室: �뢮� ����஢ ��ப, 㯮�冷祭��� �� ���뢠���
		push BP
		mov BP, SP
		
		push AX
		push BX
		push CX
		push DX
		push ds
		push DI
		
		mov DX, [BP + 6]
		mov CX, [BP + 8]; �� CX - ������⢮ ��ப
		mov BX, [BP + 10]
		mov AX, [BP + 12]
		mov ds, AX	
		
		mov DI, 1
	NDM:	push CX
		mov CX, DX
		dec CX
	NDS:	mov AX, ds:[BX]; �஢�ઠ ��ப�
		cmp AX, ds:[BX+2]
		jG ND
		add BX, 2
		loop NDS
		outword DI
		outch ' '
	ND:	add BX, 2
		shL CX, 1
		add BX, CX
		inc DI
		pop CX
		loop NDM
		
		pop DI
		pop ds
		pop DX
		pop CX
		pop BX
		pop AX
		
		pop BP
		
		ret 2*4		
	nondec endp
	
	sim proc far
		;�室: X1 - ᥣ���� ������, X2 - ���� ������ � ᥣ����, 
		;X3 - ������⢮ ��ப ������, X4 - ������⢮ �⮫�殢 ������
		;��室: �뢮� ����஢ ᨬ������� ��ப
		push BP
		mov BP, SP
		
		push AX
		push BX
		push CX
		push DX
		push ds
		push DI
		push SI
		
		mov DX, [BP + 6]
		mov CX, [BP + 8]; �� CX - ������⢮ ��ப
		mov BX, [BP + 10]
		mov AX, [BP + 12]
		mov ds, AX	
		
		mov DI, 1
	SIMM:	push CX
		mov CX, DX; ������⢮ 蠣�� ��� �஢�ન ��ப�
		shR CX, 1
		mov SI, BX; ����䨪��� �� ���� ��ப�
		shL DX, 1
		add SI, DX
		sub SI, 2
		shR DX, 1
		push BX
	SIMS:	mov AX, ds:[BX]; �஢�ઠ ��ப�
		cmp AX, ds:[SI]
		jNE NS
		add BX, 2
		sub SI, 2
		loop SIMS
		outword DI
		outch ' '
	NS:	pop BX; ᤢ����� 㪠��⥫� �� ����� ��ப�
		shL DX, 1
		add BX, DX
		shR DX, 1
		inc DI
		pop CX
		loop SIMM
		
		pop SI
		pop DI
		pop ds
		pop DX
		pop CX
		pop BX
		pop AX
		
		pop BP
		
		ret 2*4		
	sim endp
	
	colE proc far
		;�室: X1 - ᥣ���� ������, X2 - ���� ������ � ᥣ����, 
		;X3 - ������⢮ ��ப ������, X4 - ������⢮ �⮫�殢 ������
		;��室: �뢮� ����஢ �⮡殢 � ࠢ�묨 ����⠬�
		push BP
		mov BP, SP
		
		push AX
		push BX
		push CX
		push DX
		push ds
		push DI
		push SI
		
		mov DX, [BP + 8]
		mov CX, [BP + 6]; �� CX - ������⢮ �⮫�殢
		mov BX, [BP + 10]
		mov AX, [BP + 12]
		mov ds, AX	
		
		mov DI, 1
	ECOM:	push CX
		mov CX, DX
		dec CX
		mov AX, ds:[BX]; ��������� �ࠢ����� ��ࢮ�� ����� �⮫�� � ��⠫�묨
		mov SI, BX
		add SI, [BP + 6]		
		add SI, [BP + 6]
	ECEM:	cmp AX, ds:[SI]
		jNE NEQ
		add SI, [BP + 6]		
		add SI, [BP + 6]
		loop ECEM
		outword DI
		outch ' '
	NEQ:	add BX, 2
		inc DI
		pop CX
		loop ECOM
		
		pop SI
		pop DI
		pop ds
		pop DX
		pop CX
		pop BX
		pop AX
		
		pop BP
		
		ret 2*4		
	colE endp
	
	MD proc far
		;�室: X1 - ᥣ���� ������, X2 - ���� ������ � ᥣ����, 
		;X3 - ������⢮ ��ப � �⮫�殢 ������
		;��室: �뢮� ������� ������﫨
		push BP
		mov BP, SP
		
		push AX
		push BX
		push CX
		push DX
		push ds
		
		mov CX, [BP + 6]; �� CX - ������⢮ �⮫�殢
		mov BX, [BP + 8]
		mov AX, [BP + 10]
		mov ds, AX	
		
	
		mov DX, CX; ��� ����䨪�樨
		shL DX, 1
		add DX, 2
	DM:	mov AX, ds:[BX]
		outint AX
		outch ' '
		add BX, DX
		loop DM
		
		pop ds
		pop DX
		pop CX
		pop BX
		pop AX
		
		pop BP
		
		ret 2*3		
	MD endp
	
	SD proc far
		;�室: X1 - ᥣ���� ������, X2 - ���� ������ � ᥣ����, 
		;X3 - ������⢮ ��ப � �⮫�殢 ������
		;��室: �뢮� ����筮� ������﫨
		push BP
		mov BP, SP
		
		push AX
		push BX
		push CX
		push DX
		push ds
		
		mov CX, [BP + 6]; �� CX - ������⢮ �⮫�殢
		mov BX, [BP + 8]
		mov AX, [BP + 10]
		mov ds, AX	
		
		
		mov DX, CX; ��� ����䨪�樨
		shL DX, 1
		sub DX, 2
		add BX, DX
	DGS:	mov AX, ds:[BX]
		outint AX
		outch ' '
		add BX, DX
		loop DGS
		
		pop ds
		pop DX
		pop CX
		pop BX
		pop AX
		
		pop BP
		
		ret 2*3		
	SD endp

pr ends	
	
	
code segment 'code'
	assume ss:stack, ds:data, cs:code


start:
	mov ax,data
	mov ds,ax
	
	lea DX, WELC
	outstr
	newline
	
insc:	lea DX, MSTR; ����� ������⢠ ��ப
	outstr
	newline
	inint AX
	mov N, AX
	
	lea DX, MCOL; ����� ������⢠ �⮡�殢
	outstr
	newline
	inint AX
	mov M, AX
	
	mov AX, N; �஢�ઠ ���४⭮�� ࠧ��୮�� ������
	mov BX, M
	mul BX
	cmp AX, MaxSize; ����, �� �ந�������� �� �⠭�� ������ ᫮���
	jBE inm; �᫨ ���४⭮ - �����
	
	lea DX, ersc; ���� ᮮ�頥� �� �訡��
	outstr
	newline
	lea DX, YN; � �।������ ����� ࠧ���� ������
	outstr
	newline
	inch DL
	cmp DL, 'Y'
	jE insc
	jmp ex
	
inm:	lea DX, MCL; ���� ������
	outstr
	newline
	mov CX, AX; ������⢮ �祥� ������ �� ���稪
	xor BX, BX
inp:	inint AX
	mov X[BX], AX
	add BX, 2
	loop inp
	flush
	
	lea DX, MOU
	outstr
	newline
	mov AX, seg X
	push AX
	mov AX, offset X
	push AX
	push N
	push M
	call outM; �뢮��� ������
	
	lea DX, SND
	outstr
	mov AX, seg X
	push AX
	mov AX, offset X
	push AX
	push N
	push M
	call nondec; �뢮��� 1
	newline
	
	lea DX, SSM
	outstr
	mov AX, seg X
	push AX
	mov AX, offset X
	push AX
	push N
	push M
	call sim; �뢮��� 2
	newline
	
	lea DX, ECOL
	outstr
	mov AX, seg X
	push AX
	mov AX, offset X
	push AX
	push N
	push M
	call colE; �뢮��� 3
	newline
	
	mov AX, N
	cmp AX, M
	jNE NYL
	
	lea DX, MDG
	outstr
	mov AX, seg X
	push AX
	mov AX, offset X
	push AX
	push N
	call MD
	newline
	
	lea DX, SDG
	outstr
	mov AX, seg X
	push AX
	mov AX, offset X
	push AX
	push N
	call SD
	newline
	
NYL:	lea DX, NY; � �।������ ����� ࠧ���� ������
	outstr
	newline
	inch DL
	cmp DL, 'Y'
	jNE ex
	jmp insc
	
ex:	mov AH, 8; 㤥ঠ���
	int 21h;   �⢥�
	finish
code ends
    end start 
