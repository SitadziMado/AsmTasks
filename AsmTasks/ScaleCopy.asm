.model flat, C
.stack
.data

.code

public scale_copy

scale_copy proc \
    $dst : PTR DWORD, \
    $src : PTR DWORD, \
    $len : DWORD, \
    $scale_factor : DWORD

                mov ebx, $scale_factor
                mov edx, $len
                mov esi, $src
                mov edi, $dst
                cld

                test edx, edx
                jz error
                jecxz error

    main_loop:  lodsd

                mov ecx, ebx
                rep stosd

                dec edx
                jnz main_loop

                mov eax, $dst
                jmp exit

    error:      xor eax, eax

    exit:       ret

scale_copy endp

end