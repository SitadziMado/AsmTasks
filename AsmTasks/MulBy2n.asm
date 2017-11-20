.model flat, C
.stack
.data

.code

public mul_by_2n

mul_by_2n proc \
    $lhs : DWORD, \
    $two_pow_n : DWORD, \
    $success : PTR BYTE

                ; Загружаем переменные в регистры
                ; В EBX загружаем (второй параметр - 1)
                mov eax, $lhs
                mov ecx, $two_pow_n
                lea ebx, [ecx - 1]

                ; Проверяем на степень двойки хитрой битовой магией:
                ; Если (a & (a - 1)) => число не степень двойки
                test ecx, ebx
                jnz not_pow2
                js not_pow2

                ; Перемножаем первый параметр на второй,
                ; содержащий подтвержденную степень двойки
                cdq
                imul ecx
                ; jo overflow

                ; Успех! Возвращаем число и флаг успеха
                mov ebx, $success
                mov byte ptr [ebx], 1
                jmp exit

                
    ; overflow:
    
                ; В случае неудачи обнуляем EAX, EDX,
                ; в $success записываем false
    not_pow2:   mov ebx, $success
                mov byte ptr [ebx], 0
                xor eax, eax
                xor edx, edx

    exit:       ret

mul_by_2n endp

end