.model flat, C
.stack
.data

.code

public div_by_2n

div_by_2n proc \
    $lhs : DWORD, \
    $two_pow_n : DWORD, \
    $success : PTR BYTE

                mov eax, $lhs
                xor esi, esi

                test eax, eax
                jns unsigned

                neg eax
                inc esi

    unsigned:   mov edx, $two_pow_n
                lea ebx, [edx - 1]

                test edx, ebx
                jnz not_pow2
                js not_pow2

                bsf ecx, edx
                jz zero

                shr eax, cl
                
                test esi, esi
                jz @F

                neg eax

    @@:         mov ebx, $success
                mov byte ptr [ebx], 1
                jmp exit

    zero:
    not_pow2:   mov ebx, $success
                mov byte ptr [ebx], 0
                xor eax, eax

    exit:		ret

div_by_2n endp

end