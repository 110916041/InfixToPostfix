;�Ǹ��G110916041
;�@�̡G�\���`
;�ާ@�����G��J���Ǫ��⦡�A�i��J+-*/%�A�]�i�άA��'()'�����j
;		   ��J���A����|�o��Ϋ�Ǫ�ܪ��⦡
;�۵��G
;	  �ŦX�з�
;	  1. �{�����N�q�B�i�H��Ķ����
;	  2. �{���i�N���ǹB�⦡�ন��ǹB�⦡
;	  3. �䴩�A��
;���ơG100

INCLUDE Irvine32.inc
.data
InputString BYTE 50 + 1 DUP(0)
.code
main PROC
	push 50
	push OFFSET InputString
	call InfixToPostfix
exit
main ENDP

InfixToPostfix PROC
	push ebp
	mov ebp, esp               ;[EBP + 4] �x�s return address �ҥH����
	mov edx, [ebp + 8]			;new operator
	mov ecx, [ebp + 12]        ;last operator
	call ReadString 
	mov esi, OFFSET InputString
	push '#'                   ;�P�_Ū������٬O0��
	L1:  
		;Ū����J
		mov eax, 0
		mov al, [esi]
		.IF (al == 0)
			jmp L2
		.ELSEIF (al == '(')             
			push [esi]
			inc esi
			jmp L1
		.ELSEIF (al == ')')
			jmp L3
		.ELSE
			call Priority_Of_Operator    ;�P�_���� 
			.IF ebx != 0                 ;��operator�A�i����
				jmp L4
			.ELSE                        ;��operand������X
				call WriteChar
				inc esi
				jmp L1
			.ENDIF
		.ENDIF
	L2:  
		;�P�_��X�O�_�쵲���A�٬OŪ����Ʀr0
		.IF (BYTE PTR [esp] == '#')
			pop eax
			mov eax, 0
			mov esp, ebp
			pop ebp
			ret 8
		.ELSE
			pop eax
			call WriteChar
			jmp L2
		.ENDIF
	L3:
		;�YŪ����k�A���A�h��Xstack���쥪�A��
		mov eax, [esp]
		.IF (al == '(')
			pop edx
			inc esi
			jmp L1
		.ELSE
			pop eax
			call WriteChar
			jmp L3
		.ENDIF
	L4:
		;�NŪ�J��operator�Pstack��top���priority
		mov ecx, ebx
		mov al, BYTE PTR [esp]
		call Priority_Of_Operator
		cmp ebx, ecx
		jge PopToEmpty
		push [esi]
		inc esi
		jmp L1

	PopToEmpty:
		call WriteChar
		pop edx
		mov al, BYTE PTR [esp]
		call Priority_Of_Operator
		.IF (ebx > ecx || ebx == ecx)
			jmp PopToEmpty
		.ELSE
			push [esi]
			inc esi
			jmp L1
		.ENDIF
InfixToPostfix ENDP


;�u���סG �C---------->��
;��X����  0=>1=>  =>3=>4  , '()'����X
Priority_Of_Operator PROC
	.IF(eax == '#')
		mov ebx, 1
		ret
	.ELSEIF (eax == ')' || eax == '(')
		mov ebx, 2
		ret
	.ELSEIF (eax == '+' || eax == '-')
		mov ebx, 3
		ret
	.ELSEIF (eax == '*' || eax == '/' || eax == '%')
		mov ebx, 4
		ret
	.ELSE
		mov ebx, 0
		ret
	.ENDIF
Priority_Of_Operator ENDP

END main