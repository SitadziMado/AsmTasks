.586
.model flat, C
.stack
.data

MAX EQU 07FFFFFFFh
MIN EQU 080000000h
BASE EQU 0Ah
SEP0 EQU '`'
SEP1 EQU "'"
SEP2 EQU "_"

.code

public atoi

atoi proc \
    $number : PTR DWORD, \
    $src : PTR BYTE

                mov esi, $src
                xor eax, eax

                cld
                lodsb
                test eax, eax
                jz err_empty

                xor edi, edi
                call skip_ws

                cmp eax, '+'
                jnz @F

                lodsb
                jmp prepare

    @@:         cmp eax, '-'
                jnz prepare
                
                inc edi
                lodsb
                
    prepare:    call skip_ws
                ; mov ebx, BASE
                xor ecx, ecx
                xor edx, edx

    parse:      imul ecx, ecx, BASE
                jo err_of

                cmp eax, '0'
                jb err_nan
                cmp eax, '9'
                ja err_nan

                sub eax, '0'
                add ecx, eax

    separator:  lodsb
                cmp eax, 0
                jz success
                cmp eax, ' '
                jz success
                cmp eax, SEP0
                jz separator
                cmp eax, SEP1
                jz separator
                cmp eax, SEP2
                jz separator

                jmp parse

    skip_ws:    cmp eax, ' '
                jnz @F

                lodsb

                jmp skip_ws

    @@:         retn

    err_of:     ; Overflow
    err_nan:    ; Do the same
    err_empty:  xor eax, eax
                jmp exit

    success:    mov eax, 1
                test edi, edi
                jz as_is
                
                neg ecx

    as_is:      mov edi, $number
                mov [edi], ecx

    exit:       ret

atoi endp ; bool

end