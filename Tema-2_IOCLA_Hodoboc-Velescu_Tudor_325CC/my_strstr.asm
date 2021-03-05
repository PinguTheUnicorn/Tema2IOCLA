%include "io.mac"

section .bss
    ;; Variables declared to be able to use more registers
    haystack_len    resd 1
    needle_len  resd 1

section .text
    global my_strstr
    extern printf

my_strstr:
    ;; DO NOT MODIFY
    push    ebp
    mov     ebp, esp
    pusha

    mov     edi, [ebp + 8]      ; substr_index
    mov     esi, [ebp + 12]     ; haystack
    mov     ebx, [ebp + 16]     ; needle
    mov     ecx, [ebp + 20]     ; haystack_len
    mov     edx, [ebp + 24]     ; needle_len
    ;; DO NOT MODIFY

    ;; Save haystack_len and needle_len in variables
    mov     [haystack_len], ecx
    mov     [needle_len], edx

    xor     ecx, ecx            ; Start iterating from 0

search:
    xor     edx, edx            ; Make edx 0
    xor     eax, eax            ; Make eax 0

    ;; Put the current element from haystack in al
    mov     al, byte [esi + ecx]

    ;; Compare it to the first element from needle
    cmp     al, byte [ebx]
    jne continue                ; If it doesn't match, continue searching

    push    ecx                 ; Save curent haystack index in stack
    add     esi, ecx            ; Move the pointer to current position
    mov     ecx, [needle_len]   ; Move the needle length in ecx

test:
    ;; Get the last element in esi that can possibly match in al
    mov     al, byte [esi + ecx - 1]

    ;; Check if it matches
    cmp     al, byte [ebx + ecx - 1]
    
    ;; If it doesn't match, search for another set of characters
    jne false
    loop test                ; Else, keep testing

true:
    ;; If the full match was found, get the found index from stack
    pop     ecx
    jmp found                   ; Exit the loop

false:
    ;; If the streak broke, go back to last index
    pop     ecx
    sub     esi, ecx            ; Bring esi to usual state

continue:
    inc     ecx                 ; Increment index
    mov     edx, [haystack_len] ; Get the haystack length

    ;; Get the minimum index at which the needle can be found
    sub     edx, [needle_len]

    ;; Check if the minimum length was reached
    cmp     ecx, edx
    jbe search                  ; If it wasn't, keep searching

notFound:
    ;; Get the haystack_len + 1 index needle wasn't found
    add     ecx, [needle_len]
    mov     [edi], ecx          ; Put the index in substr_index address
    jmp exit                    ; Exit the program

found:
    mov     [edi], ecx          ; Put the index in substr_index address

exit:
    ;; DO NOT MODIFY
    popa
    leave
    ret
    ;; DO NOT MODIFY
