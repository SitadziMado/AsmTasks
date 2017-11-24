.model flat, C
.stack
.data

MAX EQU 07FFFFFFFh
MIN EQU 080000000h

.code

public saddle_element

saddle_element proc data : PTR DWORD, \
    $width : DWORD, \
    $height : DWORD, \
    $x : PTR DWORD, \
    $y : PTR DWORD 

                cld
                mov ecx, $width
                mov edx, $height

                test ecx, ecx
                jz err_zdim
                test edx, edx
                jz err_zdim
                
                xor eax, eax
                mov esi, data

    for_vert:   mov ebx, MAX        ; Min/max element
                mov ecx, $width      

    for_horz:   lodsd
                cmp eax, ebx
                jge no_new_min

                mov ebx, eax
                mov edi, ecx

    no_new_min: loop for_horz

                mov ecx, $width
                sub edi, ecx        ; Calculate index
                neg edi
                mov eax, data
                lea edi, [eax + edi * 4]

                lea eax, [ecx * 4]
                mov ecx, $height

    find_max:   cmp ebx, [edi]
                jl no_max

                add edi, eax
                loop find_max
    
                jmp success

    no_max:     dec edx
                jnz for_vert

    failure:    xor eax, eax
                jmp @F

    success:    mov ebx, data
                sub esi, ebx
                sub edi, ebx
                shr esi, 2
                shr edi, 2

                mov ebx, $width
                xor edx, edx
                
                mov eax, esi
                div ebx
                mov esi, eax
                dec esi

                xor edx, edx
                mov eax, edi
                div ebx
                ; mov edi, edx

                mov eax, $x
                mov ebx, $y
                mov [eax], edx
                mov [ebx], esi

                mov eax, 1

                jmp @F


    err_zdim:   xor eax, eax
                jmp @F

    @@:         ret

saddle_element endp ; bool

end