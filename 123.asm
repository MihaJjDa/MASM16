; ��� ����������� ����������� ������� ���� �����������
; ��������� 866 (� Notepad++: ���� ��������� - ��������� -
; ��������� - OEM 866).
; �᫨ ⥪��, ��稭�� � �⮩ ��ப�, �⠥��� ��ଠ�쭮,
; � 䠩� � �ࠢ��쭮� ����஢��.

include io.asm ;������祭�� ����権 �����-�뢮��

stack segment stack
	dw 128 dup (?)
stack ends

data segment
; ���� ��� ��६����� � ����⠭�
	Y db ?
data ends

code segment 'code'
	assume ss:stack, ds:data, cs:code
; ���� ��� ���ᠭ�� ��楤��

start:
	mov ax,data
	mov ds,ax
; ������� �ணࠬ�� ������ �ᯮ�������� �����
	mov AL, '!'
	mov BX, offset Y
	mov ds:[BX], AL
	outch ds:[BX]

    finish
code ends
    end start 
