.model flat, c

.stack
.data
.code

extern bcd_cmp : near
public bcd_sub

bcd_sub proc \
    $dst : PTR BYTE, \
    $lhs : PTR BYTE, \
    $rhs : PTR BYTE

                mov esi, $lhs
                mov ebx, $rhs
                ; mov edi, $dst
    
                test esi, esi
                jz null
                test ebx, ebx
                jz null
                test edi, edi
                jz null
    
                push ebx
                push esi
                call bcd_cmp
                add esp, 8
                
                mov esi, $lhs
                mov ebx, $rhs
                mov edi, $dst

				cld
                xor edx, edx
                
                cmp eax, 0
                jg greater
                jl less
                
                mov eax, '0'
                stosb
                xor eax, eax
                stosb
                lea eax, [edi - 2]
                
                jmp exit
                
                ; Первое число больше второго, все в порядке
    greater:    xor eax, eax
                xor ecx, ecx
                jmp @F
    
    less:       xor eax, eax
                xor ecx, ecx
                mov edx, '-'
                jmp @F
                
    @@:         lodsb
                
                test eax, eax
                jz finale
                cmp eax, '0'
                jb err
                cmp eax, '9'
                ja err
    
                test ecx, ecx
                mov cl, [ebx]
                sbb al, cl
                setc cl
                das
                
                add eax, '0'
                stosb
                
                inc ebx
                
                jmp @B
                
    finale:     test cl, cl
                jz @F
                mov eax, '9'
                stosb
                
    @@:         test edx, edx
                jz @F
                
                mov eax, edx
                stosb
                
    @@:         xor eax, eax
                stosb
                jmp exit
                
    err:        
    null:       xor eax, eax
    
    exit:       ret
    
bcd_sub endp

; bcd_sub proc \
;     $dst : PTR BYTE, \
;     $lhs : PTR BYTE, \
;     $rhs : PTR BYTE
; 
;                 mov esi, $lhs
;                 mov edi, $rhs
; 
;                 cmp byte ptr [esi], 0
;                 jz null_1
;                 cmp byte ptr [edi], 0
;                 jz null_2
; 
;                 ; Skip trailing zeroes
;                 mov eax, '0'
; 
;                 mov ecx, -1
;                 repz scasb
;                 xchg esi, edi
;                 mov ecx, -1
;                 repz scasb
;                 xchg esi, edi
; 
;                 dec esi
;                 dec edi
;                 
;                 xor eax, eax
;                 xor ebx, ebx
;                 xor ecx, ecx
;                 xor edx, edx
; 
;                 cld
; 
;     cmp_loop:   cmpsb
;                 jnz diff
; 
;     continue:   inc ecx
;                 inc edx
; 
;                 cmp byte ptr [esi], 0
;                 jz end_1
; 
;                 cmp byte ptr [edi], 0
;                 jz end_2
; 
;                 jmp cmp_loop
; 
;     diff:       seta al
;                 setb ah
;                 test ebx, ebx
;                 jnz continue
; 
;                 mov ebx, eax
;                 jmp continue
; 
;     end_1:      cmp byte ptr [edi], 0
;                 jz eq_len
; 
;                 xor eax, eax
;                 xchg ecx, edx
;                 neg ecx
; 
;                 repnz scasb
;                 inc ecx
;                 dec edi ; Needed?
; 
;                 neg ecx
;                 xchg ecx, edx
;                 jmp @F
; 
;     end_2:      cmp byte ptr [esi], 0
;                 jz eq_len
; 
;                 xor eax, eax
;                 xchg esi, edi
;                 neg ecx
; 
;                 repnz scasb
;                 inc ecx
;                 dec edi ; Needed?
; 
;                 neg ecx
;                 xchg esi, edi
; 
;     @@:         xor eax, eax
;                 cmp ecx, edx
;                 ja @F
; 
;                 xchg esi, edi
;                 xchg ecx, edx
;                 inc eax
; 
;                 jmp @F
; 
;     eq_len:     xor eax, eax
;                 test bl, bl     ; 1 > 2?
;                 jnz @F
; 
;                 xchg esi, edi
;                 inc eax
; 
;     @@:         ;dec ecx
;                 ;dec edx
;                 ;dec esi
;                 ;dec edi
; 				sub esi, 2
; 				sub edi, 2
; 
;                 xchg ecx, edx
;                 
;                 ; Отмотать
;                 ; cmpsb
; 
;                 mov ebx, edi
;                 mov edi, $dst
; 
;                 test eax, eax
;                 jz put_0
; 
;                 mov eax, '-'
;                 stosb
; 
; 	put_0:  	mov eax, '0'
; 				stosb
; 
;                 std
;                 lea edi, [edx + edi - 1] ; Смотреть
; 				xor eax, eax
; 				stosb
; 
;                 xor edx, edx
; 
;     sub_loop:   xor eax, eax
;                 lodsb
;                 add al, dl
;                 mov dl, [ebx]
; 
;                 sub al, dl
;                 aas
;                 add al, '0'
;                 stosb
; 
;                 shr ax, 8
;                 mov dl, al
;                 
;                 dec ebx
;                 loop sub_loop
; 
;                 lodsb
;                 add dl, al
;                 lea eax, [edx]
;                 stosb
; 
;                 mov eax, $dst
;                 jmp exit
; 
;     null_1:     mov edi, $dst
;                 jmp fill_exit
; 
;     null_2:     mov esi, edi
;                 mov edi, $dst
;                 mov eax, '-'
;                 stosb
; 
;     fill_exit:  lodsb
;                 stosb
;                 test eax, eax
;                 jnz fill_exit
; 
;     exit:       cld
;                 ret
;     
; bcd_sub endp

end