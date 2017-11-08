.model flat, c
.stack
.data

.code

public strstr

strstr proc \
    $string : PTR BYTE, \
    $substring : PTR BYTE

                xor eax, eax
                xor edx, edx
                mov esi, $substring
                mov edi, $string
                mov ebx, esi
                cld

                lodsb

                test eax, eax
                jz null_str

    main_loop:  scasb
                jz match

                cmp byte ptr [edi], 0
                jz not_found

                jmp main_loop

    match:      lea edx, [edi - 1]

    @@:         lodsb
                test eax, eax
                jz found

                scasb
                jnz @F

                jmp @B

    @@:         mov esi, ebx
                lodsb
                dec edi     ; Need verification
                jmp main_loop

    found:      mov eax, edx
                jmp exit

    not_found:  
    null_str:   xor eax, eax

    exit:       ret

strstr endp

end