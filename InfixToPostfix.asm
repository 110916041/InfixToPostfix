;學號：110916041
;作者：許証曜
;操作說明：輸入中序的算式，可輸入+-*/%，也可用括號'()'做間隔
;		   輸入完，執行會得到用後序表示的算式
;自評：
;	  符合標準
;	  1. 程式有意義且可以組譯執行
;	  2. 程式可將中序運算式轉成後序運算式
;	  3. 支援括號
;分數：100

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
	mov ebp, esp               ;[EBP + 4] 儲存 return address 所以不用
	mov edx, [ebp + 8]			;new operator
	mov ecx, [ebp + 12]        ;last operator
	call ReadString 
	mov esi, OFFSET InputString
	push '#'                   ;判斷讀取到尾還是0用
	L1:  
		;讀取輸入
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
			call Priority_Of_Operator    ;判斷順序 
			.IF ebx != 0                 ;為operator，進行比較
				jmp L4
			.ELSE                        ;為operand直接輸出
				call WriteChar
				inc esi
				jmp L1
			.ENDIF
		.ENDIF
	L2:  
		;判斷輸出是否到結尾，還是讀取到數字0
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
		;若讀取到右括號，則輸出stack直到左括號
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
		;將讀入的operator與stack的top比較priority
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


;優先度： 低---------->高
;輸出順序  0=>1=>  =>3=>4  , '()'不輸出
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