.model flat, c
.data

.code

public bcd_cmp
; public bcd_sub

bcd_cmp proc \
    $first : PTR BYTE, \
    $second : PTR BYTE
    
                mov esi, $first
                mov edi, $second
                
                xchg esi, edi

                xor eax, eax
                mov ecx, -1
                mov edx, -1
                
                repnz scasb
                
                neg ecx
                ; dec ecx
                
                xchg ecx, edx
                xchg esi, edi

                repnz scasb
                
                neg ecx
                ; dec ecx
                
                cmp ecx, edx
                jb above
                ja below
                
                std
                
                repz cmpsb
                jnz diff
                jecxz equals
                
    diff:       inc esi
                inc edi
                
                lodsb
                sub al, [edi]
                jb below
                ja above
                
    equals:     xor eax, eax
                jmp exit
                
    above:      mov eax, 1
                jmp exit
                
    below:      mov eax, -1
                
                xchg esi, edi
                
    exit:       ret
                
bcd_cmp endp

end