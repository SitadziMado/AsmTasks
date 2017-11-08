.model flat, c

.stack
.data
.code

public bcd_sub

bcd_sub proc \
    $dst : PTR BYTE, \
    $lhs : PTR BYTE, \
    $rhs : PTR BYTE

                mov esi, $lhs
                mov edi, $rhs

                cmp byte ptr [esi], 0
                jz null_1
                cmp byte ptr [edi], 0
                jz null_2

                ; Skip trailing zeores
                mov eax, '0'

                mov ecx, -1
                repz scasb
                xchg esi, edi
                mov ecx, -1
                repz scasb
                xchg esi, edi

                dec esi
                dec edi
                
                xor eax, eax
                xor ebx, ebx
                xor ecx, ecx
                xor edx, edx

                cld

    cmp_loop:   cmpsb
                jnz diff

    continue:   inc ecx
                inc edx

                cmp byte ptr [esi], 0
                jz end_1

                cmp byte ptr [edi], 0
                jz end_2

                jmp cmp_loop

    diff:       seta al
                setb ah
                test ebx, ebx
                jnz continue

                mov ebx, eax
                jmp continue

    end_1:      cmp byte ptr [edi], 0
                jz eq_len

                xor eax, eax
                xchg ecx, edx
                neg ecx

                repnz scasb
                inc ecx
                dec edi ; Needed?

                neg ecx
                xchg ecx, edx
                jmp @F

    end_2:      cmp byte ptr [esi], 0
                jz eq_len

                xor eax, eax
                xchg esi, edi
                neg ecx

                repnz scasb
                inc ecx
                dec edi ; Needed?

                neg ecx
                xchg esi, edi

    @@:         xor eax, eax
                cmp ecx, edx
                ja @F

                xchg esi, edi
                xchg ecx, edx
                inc eax

                jmp @F

    eq_len:     xor eax, eax
                test bl, bl     ; 1 > 2?
                jnz @F

                xchg esi, edi
                inc eax

    @@:         ;dec ecx
                ;dec edx
                ;dec esi
                ;dec edi
				sub esi, 2
				sub edi, 2

                xchg ecx, edx
                
                ; Отмотать
                ; cmpsb

                mov ebx, edi
                mov edi, $dst

                test eax, eax
                jz put_0

                mov eax, '-'
                stosb

	put_0:  	mov eax, '0'
				stosb

                std
                lea edi, [edx + edi - 1] ; Смотреть
				xor eax, eax
				stosb

                xor edx, edx

    sub_loop:   xor eax, eax
                lodsb
                add al, dl
                mov dl, [ebx]

                sub al, dl
                aas
                add al, '0'
                stosb

                shr ax, 8
                mov dl, al
                
                dec ebx
                loop sub_loop

                lodsb
                add dl, al
                lea eax, [edx]
                stosb

                mov eax, $dst
                jmp exit

    null_1:     mov edi, $dst
                jmp fill_exit

    null_2:     mov esi, edi
                mov edi, $dst
                mov eax, '-'
                stosb

    fill_exit:  lodsb
                stosb
                test eax, eax
                jnz fill_exit

    exit:       cld
                ret
    
bcd_sub endp

end