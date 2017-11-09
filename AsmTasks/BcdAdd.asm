.model flat, c

.stack
.data
.code

public bcd_add

bcd_add proc \
    $dst : PTR BYTE, \
    $lhs : PTR BYTE, \
    $rhs : PTR BYTE

                mov edi, $lhs
                mov ebx, $rhs

                xor eax, eax
                xor ecx, ecx
                dec ecx
                
                cld
                repnz scasb ; AL <=> [EDI++]
                dec edi
                mov edx, ecx
                neg edx
                sub edx, 2

                xchg edi, ebx
                xor ecx, ecx
                dec ecx

                cld
                repnz scasb
                dec edi
                std
                mov eax, ecx
                neg eax
                sub eax, 2

                mov esi, edi

                cmp eax, edx
                cmovae edi, eax
                cmovb edi, edx
                cmova eax, edx
                mov ecx, eax

                jecxz exit

                mov eax, $dst
                lea edi, [eax + edi + 1]
                mov byte ptr [eax], '0'

                xor eax, eax
                stosb

                xor edx, edx
                dec esi
                dec ebx
                clc

                ;esi - one
                ;ebx - another one
                ;edi - result
                ;ecx - loop counter

    @@:         lodsb ; AL <- [ESI--]
                add dl, [ebx]

                add al, dl
                aaa
                add al, '0'
                stosb ; [EDI--] <- AL

                shr ax, 8
                mov dl, al
                
                dec ebx
                loop @B

                test dl, dl
                jz exit

                lea eax, [edx + '0']
                stosb

    exit:       mov eax, $dst
                cld
                ret

    empty:      mov eax, edi
                ret
    
bcd_add endp

end