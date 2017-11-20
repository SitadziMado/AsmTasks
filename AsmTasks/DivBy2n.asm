.model flat, C
.stack
.data

.code

public div_by_2n

div_by_2n proc \
    $lhs : DWORD, \
    $two_pow_n : DWORD, \
    $success : PTR BYTE

                ; Копируем в EAX первый параметр
                mov eax, $lhs
                xor esi, esi

                ; Если у числа нет знака, то к следующей метке
                test eax, eax
                jns unsigned

                ; Иначе отрицаем число и устанавливаем в ESI
                ; признак знака
                neg eax
                inc esi

                ; Второй параметр копируем в EDX
                ; В EBX присваиваем EDX - 1 
    unsigned:   mov edx, $two_pow_n
                lea ebx, [edx - 1]

                ; Проверяем на степень двойки хитрой битовой магией:
                ; Если (a & (a - 1)) => число не степень двойки
                test edx, ebx
                jnz not_pow2
                js not_pow2

                ; Ищем первый (и единственный) единичный бит второго параметра
                ; Если его не находим, то деление на ноль - выходим
                bsf ecx, edx
                jz zero

                ; Сдвигаем на количество битов,
                ; эквивалентное делению на второй параметр
                shr eax, cl
                
                ; Если без знака, то пропускаем
                test esi, esi
                jz @F

                ; Иначе отрицаем число снова
                neg eax

                ; Устанавливаем флаг удачи
    @@:         mov ebx, $success
                mov byte ptr [ebx], 1
                jmp exit

                ; Очищаем флаг удачи
    zero:
    not_pow2:   mov ebx, $success
                mov byte ptr [ebx], 0
                xor eax, eax

    exit:		ret

div_by_2n endp

end