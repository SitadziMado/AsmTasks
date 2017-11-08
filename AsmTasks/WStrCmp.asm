.model flat, c
.stack
.data

.code

public wstrcmp

wstrcmp proc \
    $lhs : PTR WORD, \
    $rhs : PTR WORD, \
	$index : PTR DWORD

                xor eax, eax
                mov esi, $lhs
                mov edi, $rhs

                test esi, esi
                jz null1
                test edi, edi
                jz null2

                cld

    cmp_loop:   cmpsw
                jnz not_eq

                cmp word ptr [esi], 0
                jz equals

                jmp cmp_loop

    not_eq:     sub esi, 2
                sub edi, 2
                mov ax, [esi]
                sub ax, [edi]

                mov eax, 1
                jg @F

                mov eax, -1

    @@:         mov edx, esi
                sub edx, [$lhs]
                shr edx, 1

                jmp exit

    equals:     xor eax, eax
                xor edx, edx
                jmp exit

    null1:      mov edx, -1
                mov eax, -1
                jmp exit

    null2:      mov edx, -1
                mov eax, 1

    exit:       mov ebx, $index
                mov dword ptr [ebx], edx
                ret

wstrcmp endp

end