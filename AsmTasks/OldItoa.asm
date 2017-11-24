.586
.model flat, C
.stack
.data

$table db   '0', '1', '2', '3', \
            '4', '5', '6', '7', \
            '8', '9', 'A', 'B', \
            'C', 'D', 'E', 'F'

$inv_table db   'F', 'E', 'D', 'C', \
                'B', 'A', '9', '8'
$inv_oct db     '7', '6', '5', '4', \
                '3', '2', '1', '0'

MAX EQU 07FFFFFFFh
MIN EQU 080000000h
EIGHT_DIGIT EQU 99999999
BASE EQU 10
LO4_MASK EQU 0Fh
HI4_MASK EQU 0F0000000h
HI3_MASK EQU 0E0000000h
SUPREME EQU 31

.code

public itoa

itoa proc \
    $dst : PTR BYTE, \
    $number : DWORD, \
    $base : DWORD
    
                cld
                mov ebx, $base
                cmp ebx, 10
                jz base10

                cmp ebx, 2
                jz base2
                cmp ebx, 8
                jz base8
                cmp ebx, 16
                jz base16

                jmp err_base

    base2:      mov ebx, put2
                jmp base_bin

    base8:      mov ebx, prepare8
                jmp base_bin

    base16:     mov ebx, prepare16

    base_bin:   xor eax, eax
                mov ecx, $number
                mov edi, $dst

                jecxz only_zero

                mov eax, ecx
                bsr ecx, eax
                mov edx, ecx
                sub ecx, SUPREME
                neg ecx
                shl eax, cl

                mov ecx, edx
                inc ecx
                mov edx, eax
                xor eax, eax

                jmp ebx
    
    only_zero:  mov eax, '0'
                stosb

                jmp ebx

    put2:       shl edx, 1
                setc al
                add eax, '0'
                stosb

                loop put2

                mov eax, 'b'
                stosb

                jmp exit

    prepare8:   mov ebx, offset $inv_oct

    put8:       mov eax, HI3_MASK
                and eax, edx
                shr eax, 29
                xlat
                shl edx, 3

                stosb

                sub ecx, 3
                ja put8

                mov eax, 'o'
                stosb

                jmp exit

    prepare16:  mov ebx, offset $inv_table

    put16:      mov eax, HI4_MASK
                and eax, edx
                shr eax, 28
                xlat
                shl edx, 4

                stosb

                sub ecx, 4
                ja put8

                jmp exit

    base10:     mov eax, $number

                xor ecx, ecx
                xor esi, esi
                xor edi, edi

                cmp eax, 0
                jge cut_to8

                neg eax
                inc edi

    cut_to8:    cmp eax, EIGHT_DIGIT
                jb @F

                shl ecx, 4
                xor edx, edx
                div ebx
                add ecx, edx

                jmp cut_to8

    @@:         shl esi, 4
                xor edx, edx
                div ebx
                add esi, edx

                test eax, eax
                jnz @B

                mov eax, edi
                mov edi, $dst
                mov ebx, swap_ac

                test eax, eax
                jz print_ecx

				mov eax, '-'
                stosb
                
    print_ecx:  jecxz finish
                mov eax, LO4_MASK
                and eax, ecx
                shr ecx, 4
                add eax, '0'
                stosb

                jmp print_ecx

    finish:     jmp ebx

    swap_ac:    mov ecx, esi
                mov ebx, exit
                jmp print_ecx

    err_base:   xor eax, eax
                ret

    exit:       xor eax, eax
                stosb
                mov eax, $dst

                ret

itoa endp


end