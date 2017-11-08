.model flat, C
.stack
.data

.code

public mul_by_2n

mul_by_2n proc \
    $lhs : DWORD, \
    $two_pow_n : DWORD, \
    $success : PTR BYTE

                mov eax, $lhs
                mov ecx, $two_pow_n
                lea ebx, [ecx - 1]

                test ecx, ebx
                jnz not_pow2
                js not_pow2

                cdq
                imul ecx
                ; jo overflow

                mov ebx, $success
                mov byte ptr [ebx], 1
                jmp exit

    overflow:
    not_pow2:   mov ebx, $success
                mov byte ptr [ebx], 0
                xor eax, eax
                xor edx, edx

    exit:       ret

mul_by_2n endp

end