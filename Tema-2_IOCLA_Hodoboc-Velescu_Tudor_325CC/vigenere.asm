%include "io.mac"

section .bss
    ;; Variables declared to be able to use more registers
    key_len resd 1
    plaintext_len resd 1

section .text
    global vigenere
    extern printf

vigenere:
    ;; DO NOT MODIFY
    push    ebp
    mov     ebp, esp
    pusha

    mov     edx, [ebp + 8]      ; ciphertext
    mov     esi, [ebp + 12]     ; plaintext
    mov     ecx, [ebp + 16]     ; plaintext_len
    mov     edi, [ebp + 20]     ; key
    mov     ebx, [ebp + 24]     ; key_len
    ;; DO NOT MODIFY

    ;; Save key_len and plaintext_len in variables
    mov     [key_len], dword ebx
    mov     [plaintext_len], dword ecx

    xor     ebx, ebx            ; Make ebx 0 to use it later
    xor     ecx, ecx            ; Start the iteration from 0

criptare:
    xor     eax, eax            ; Make eax 0

    ;; Get the element to be encrypted
    mov     al, byte [esi + ecx]

    cmp     al, 65              ; Check if the element is letter
    jb montare                  ; Else, don;t change it

    cmp     al, 90              ; Check if it's uppercase
    ja lowercase                ; Else, check if it's lowercase

uppercase:
    inc     ebx                 ; Increment the index of element in the key
    cmp     ebx, [key_len]      ; Check if it exceeded the array
    jbe     shift_upper         ; If it didn't, proceed to shifting

    mov ebx, 1                  ; Else, go back to the first element

shift_upper:
    push    ebx                 ; Save current index of key in stack

    ;; Get the character in key
    mov     bl, byte [edi + ebx - 1]
    
    ;; Calculate the relative shifting positions to current position
    sub     bl, 65 

    sub     al, 65              ; Calculate the index in alphabet
    add     al, bl              ; Calculate the relative shift position to 'A'
    mov     bl, 26              ; Put 26 in bl for division

    div     bl                  ; Divide to 26 to get new position in alphabet

    ;; Get the remainer which represents the relative position to 'A'
    mov     bl, ah

    xor     eax, eax            ; Make eax 0
    mov     al, 65              ; Put 'A' in eax
    add     al, bl              ; Get the encrypted element
    pop     ebx                 ; Restore the index of key in ebx
    jmp montare                 ; Put the encrypted element in plaintext

lowercase:
    ;; Check if the element is between 'Z' and 'a' in ASCII
    cmp     al, 97
    jb montare                  ; If yes, don't change it

    ;; Check if the element has the ASCII value bigger than 'z'
    cmp     al, 122
    ja montare                  ; If yes, don't change it

    inc     ebx                 ; Increment the index of element in the key
    cmp     ebx, [key_len]      ; Check if it exceeded the array
    jbe shift_lower             ; If it didn't, proceed to shifting

    mov     ebx, 1              ; Else, go back to the first element

shift_lower:
    push    ebx                 ; Save current index of key in stack

    ;; Get the character in key
    mov     bl, byte [edi + ebx - 1]

    ;; Calculate the relative shifting positions to current position
    sub     bl, 65

    sub     al, 97              ; Calculate the index in alphabet
    add     al, bl              ; Calculate the relative shift position to 'a'
    mov     bl, 26              ; Put 26 in bl for division

    div     bl                  ; Divide to 26 to get new position in alphabet

    ;; Get the remainer which represents the relative position to 'a'
    mov     bl, ah

    xor     eax, eax            ; Make eax 0
    mov     al, 97              ; Put 'a' in eax
    add     al, bl              ; Get the encrypted element
    pop     ebx                 ; Restore the index of key in ebx
    jmp montare                 ; Put the encrypted element in plaintext

montare:
    ;; Add the element obtained by the encryption in chipertext
    mov     [edx + ecx], al
    inc     ecx                 ; Increment the index

    ;; Check if it reached the end
    cmp     ecx, [plaintext_len]
    jb criptare                 ; If not, go to next element

    ;; DO NOT MODIFY
    popa
    leave
    ret
    ;; DO NOT MODIFY
