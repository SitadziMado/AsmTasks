.model flat, c

.stack
.data
.code

public bcd_add

bcd_add proc \
    $dst : PTR BYTE, \
    $lhs : PTR BYTE, \
    $rhs : PTR BYTE

                mov esi, $lhs
                mov ebx, $rhs
                mov edi, $dst
                
                test esi, esi
                jz null
                test ebx, ebx
                jz null
                test edi, edi
                jz null
                
                xor eax, eax
                xor ecx, ecx
                xor edx, edx
                cld
                
    sum_loop:   lodsb
                
                test eax, eax
                jz first_end
                cmp eax, '0'
                jb err
                cmp eax, '9'
                ja err
                
                mov cl, [ebx]
                test ecx, ecx
                jz second_end
                cmp ecx, '0'
                jb err
                cmp ecx, '9'
                ja err

                shr edx, 1
                adc al, cl
                aaa
                add al, '0'
                
                stosb
                shr eax, 8
                mov edx, eax
                
                inc ebx
                jmp sum_loop
                
    first_end:  mov esi, ebx
                jmp @F
    
    second_end: dec esi
    
    @@:         lodsb
                
                test eax, eax
                jz @F
                cmp eax, '0'
                jb err
                cmp eax, '9'
                ja err

                ; shr edx, 1
                add al, dl
                aaa
                add al, '0'
                
                stosb
                shr eax, 8
                mov edx, eax
                
                jmp @B
                
    @@:         mov eax, edx
                test eax, eax
                jz skip_carry
                
                add eax, '0'
                stosb
                
    skip_carry: xor eax, eax
                stosb
                
                mov eax, $dst
                
                jmp exit
                
	err:
    null:       xor eax, eax
    
    exit:       ret
                
bcd_add endp

; bcd_add proc \
;     $dst : PTR BYTE, \
;     $lhs : PTR BYTE, \
;     $rhs : PTR BYTE
; 
;                 mov edi, $lhs
;                 mov ebx, $rhs
; 
;                 xor eax, eax
;                 xor ecx, ecx
;                 dec ecx
;                 
;                 cld
;                 repnz scasb ; AL <=> [EDI++]
;                 dec edi
;                 mov edx, ecx
;                 neg edx
;                 sub edx, 2
; 
;                 xchg edi, ebx
;                 xor ecx, ecx
;                 dec ecx
; 
;                 cld
;                 repnz scasb
;                 dec edi
;                 std
;                 mov eax, ecx
;                 neg eax
;                 sub eax, 2
; 
;                 mov esi, edi
; 
;                 cmp eax, edx
;                 cmovae edi, eax
;                 cmovb edi, edx
;                 cmova eax, edx
;                 mov ecx, eax
; 
;                 jecxz exit
; 
;                 mov eax, $dst
;                 lea edi, [eax + edi + 1]
;                 mov byte ptr [eax], '0'
; 
;                 xor eax, eax
;                 stosb
; 
;                 xor edx, edx
;                 dec esi
;                 dec ebx
;                 clc
; 
;                 ;esi - one
;                 ;ebx - another one
;                 ;edi - result
;                 ;ecx - loop counter
; 
;     @@:         lodsb ; AL <- [ESI--]
;                 add dl, [ebx]
; 
;                 add al, dl
;                 aaa
;                 add al, '0'
;                 stosb ; [EDI--] <- AL
; 
;                 shr ax, 8
;                 mov dl, al
;                 
;                 dec ebx
;                 loop @B
; 
;                 test dl, dl
;                 jz exit
; 
;                 lea eax, [edx + '0']
;                 stosb
; 
;     exit:       mov eax, $dst
;                 cld
;                 ret
; 
;     empty:      mov eax, edi
;                 ret
;     
; bcd_add endp

end