%include "io.mac"

section .text
    global otp
    extern printf

otp:
    ;; DO NOT MODIFY
    push    ebp
    mov     ebp, esp
    pusha

    mov     edx, [ebp + 8]      ; ciphertext
    mov     esi, [ebp + 12]     ; plaintext
    mov     edi, [ebp + 16]     ; key
    mov     ecx, [ebp + 20]     ; length
    ;; DO NOT MODIFY

criptare:
	xor     eax, eax            ; Make sure eax register is 0
	xor     ebx, ebx            ; Make sure ebx register is 0

    ;; Put the character to be encrypted in al
    ;; Put the encryption key in bl
	mov     al, byte [esi + ecx - 1]
	mov     bl, byte [edi + ecx - 1]

	xor     al, bl              ; Make xor between the element and key

    ;; Put the element that has been encrypted in chipertext
	mov [edx + ecx - 1], byte al

	loop criptare            ; Repeat the process if there's still elements

    ;; DO NOT MODIFY
    popa
    leave
    ret
    ;; DO NOT MODIFY
