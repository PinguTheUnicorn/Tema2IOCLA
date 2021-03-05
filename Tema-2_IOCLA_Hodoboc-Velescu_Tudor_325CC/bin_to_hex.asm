%include "io.mac"

section .bss
	;; Variables to store data
	value: resb 1
	rest: resb 1
	contor_hexa: resb 1

section .text
    global bin_to_hex
    extern printf

bin_to_hex:
    ;; DO NOT MODIFY
    push    ebp
    mov     ebp, esp
    pusha

    mov     edx, [ebp + 8]      ; hexa_value
    mov     esi, [ebp + 12]     ; bin_sequence
    mov     ecx, [ebp + 16]     ; length
    ;; DO NOT MODIFY

prep:
	mov byte [value], 0
	xor 	ebx, ebx			; Make ebx 0
	mov 	bl, 4				; Put 4 in ebx
	mov 	eax, ecx			; Put the number of characters for division
	div 	bl					; Get the nuber of characters for hexa_value

	mov 	byte [rest], ah		; Final characters that won't form a set of 4

	;; The number of characters after the conversion to hexa
	mov 	byte [contor_hexa], al

	xor 	ebx, ebx
	xor 	eax, eax
	mov 	bl, byte [rest]

	;; Check if there are characters that won't form a set of 4
	cmp 	ebx, 0
	je adaugare					; If not, continue

	inc 	byte [contor_hexa]	; If yes, number of hexa characters increases

adaugare:
	xor 	ebx, ebx
	mov 	al, byte [contor_hexa]

	;; Put the '\n' character at the end
	mov 	byte [edx + eax], 10

	;; Make sure there are no lost bits in registers
	xor 	eax, eax
	xor 	ebx, ebx
	xor 	edi, edi

start:
	;; Check if current bit is 0
	mov 	al, byte [esi + ecx - 1]
	cmp 	al, 48
	je inc_contor				; If yes, continue

add_value:
	mov 	bl, 1				; Put the bit to shift to current position
	push 	ecx					; Save current bin index
	mov 	ecx, edi			; Put the shifting index
	shl 	bl, cl				; Shift left to get value of current bit of 1
	pop 	ecx					; Retrive bin index
	add 	byte [value], bl	; Add to total value of current set
	xor 	ebx, ebx

inc_contor:
	inc 	edi					; Increase shift index
	cmp 	edi, 4				; Check if it reached end of set
	jne loop 					; If not, continue

montare:
	xor 	edi, edi			; Reset the shift index
	xor 	ebx, ebx
	mov 	bl, byte [value]
	mov 	byte [value], 0		; Reset value

	;; Check if value is coresponding to digits or letters
	cmp 	ebx, 10
	jae letter

digit:
	add 	bl, 48				; Convert the value to digit
	jmp after_conversion		; Put the character in haxa_value

letter:
	add 	bl, 55				; Conert the value to letter

after_conversion:
	xor 	eax, eax
	mov 	al, byte [contor_hexa]

	;; Put the character in corresponding place
	mov 	byte [edx + eax -1], bl

	;; Decrease the index in hexa_value
	dec 	byte [contor_hexa]

loop:
	dec 	ecx					; Decrease bin_sequence index
	xor 	ebx, ebx
	mov 	bl, byte [rest]
	cmp 	ecx, ebx			; Check if end of 4-bits sequences was reached
	jnz start					; If not, continue

	cmp 	ecx, 0				; Check if there are any more characters
	je final 					; Else, jump to final

loop_rest:
	mov 	al, byte [esi + ecx - 1]
	cmp 	al, 48				; Check if current bit is 1
	je exit_rest					; If not, continue to next bit

add_rest_value:
	mov 	bl, 1				; Put the bit to shift to current position
	push 	ecx					; Save current bin index
	mov 	ecx, edi			; Put the shifting index
	shl 	bl, cl				; Shift left to get value of current bit of 1
	pop 	ecx					; Retrive bin index
	add 	byte [value], bl	; Add to total value of current set
	xor 	ebx, ebx
	inc 	edi					; Increase shift index

exit_rest:
	dec 	ecx					; Decrease bin index
	jnz 	loop_rest			; If there are any more characters, repeat

	xor 	ebx, ebx
	mov 	bl, byte [value]	; Get the value of last character
	add 	bl, 48				; Convert to digit
	mov 	byte [edx], bl		; Put character in hexa_value

final:
    ;; DO NOT MODIFY
    popa
    leave
    ret
    ;; DO NOT MODIFY
