%include "io.mac"

section .text
    global caesar
    extern printf

caesar:
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
    xor     eax, eax            ; Make sure eax is 0

    ;; Copy in al the curent element from plaintext
    mov     al, byte [esi + ecx - 1]

    cmp     al, 65              ; Check if the element is a letter
    jb      montare             ; If not, add it to chipertext as it is

    cmp     al, 90              ; Check if it's uppercase
    ja lowercase                ; if not, go check if it's lowercase

uppercase:
    sub     al, 65              ; Substract 'A' to get index in alphabet
    add     eax, edi            ; Add the key

    mov     ebx, 26             ; Put 26 in ebx for division
    div     bl                  ; Divide by 26 to get the new alphabet index

    ;; Get the remainer which represents the relative position to 'A'
    mov     bl, ah

    xor     eax, eax            ; Make eax 0
    mov     al, bl              ; Put the final index in al
    add     al, 65              ; Get the encrypted element
    jmp montare                 ; Go put it in plaintext

lowercase:
    ;; Check if the element is between 'Z' and 'a' in ASCII
    cmp     al, 97
    jb montare                  ; If yes, don't change it

    ;; Check if the element has the ASCII value bigger than 'z'
    cmp     al, 122
    ja montare                  ; If yes, don't change it

    sub     al, 97              ; Substract 'a' to get the index in alphabet
    add     eax, edi            ; Add the key

    mov     ebx, 26             ; Put 26 in ebx for division 
    div     bl                  ; Divide by 26 to get the new aplhabet index

    ;; Get the remainer which represents the relative position to 'a'
    mov     bl, ah

    xor     eax, eax            ; Make eax 0
    mov     al, bl              ; Put the final index in al
    add     al, 97              ; Get the encrypted element

montare:
    ;; Add the element obtained by the encryption in chipertext
    mov     [edx + ecx - 1], byte al
    loop criptare               ; Repeat the process if there's still elements

    ;; DO NOT MODIFY
    popa
    leave
    ret
    ;; DO NOT MODIFY
