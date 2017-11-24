.model flat, c

.stack
.data
.code

public bcd_add

bcd_add proc \
    $dst : PTR BYTE, \
    $lhs : PTR BYTE, \
    $rhs : PTR BYTE

                ; Загружаем первое число, проверяем на нуль
                mov esi, $lhs
                test esi, esi
                jz null
                
                ; Загружаем второе число, проверяем на нуль                
                mov ebx, $rhs
                test ebx, ebx
                jz null
                
                ; Загружаем массив-приемник, проверяем на нуль
                mov edi, $dst
                test edi, edi
                jz null
                
                ; Движемся в прямом направлении
                cld
                xor eax, eax
                xor ecx, ecx
                xor edx, edx
                
                ; Загружаем очередной символ
    sum:        lodsb
    
                ; Если он ненулевой, то продолжаем
                test eax, eax
                jz first_end
                
                ; Загружаем символ из другого числа
                mov cl, [ebx]
                inc ebx
                
                ; Если символ второй строки ненулевой,
                ; то продолжаем
                jecxz second_end
                
                ; Добавляем к первому символу перенос
                ; Складываем символы и вычитаем две базы "0"
                ; Корректируем и возвращаем базу для вывода
                add eax, edx
                lea eax, [eax + ecx - '0' - '0']
                aaa
                add eax, '0'
                
                ; Выводим символ
                stosb
                
                ; Затираем символ, перенос теперь в AL
                shr eax, 8
                mov edx, eax
                
                ; Повторяем
                jmp sum
                
                ; Первая строка закончилась - обменяем указатели
    first_end:  mov esi, ebx
                
                ; Очередной символ
    @@:         lodsb
    
                ; Если он ненулевой, то продолжаем
    second_end: test eax, eax
                jz finale
                
                ; Добавляем к первому символу перенос
                ; Складываем символы и вычитаем две базы "0"
                ; Корректируем и возвращаем базу для вывода
                add eax, edx
                sub eax, '0'
                aaa
                add eax, '0'
                
                ; Записываем
                stosb
                
                ; Затираем символ, перенос теперь в AL
                shr eax, 8
                mov edx, eax
                
                ; Повторяем
                jmp @B

                ; Проверяем, не осталось ли переноса
    finale:     test edx, edx
                jz @F
                
                ; Если остался, то добавляем еще единицу
                mov eax, '1'
                stosb
                
                ; Записываем нулевой символ
    @@:         xor eax, eax
                stosb
                
                ; Возвращаем указатель на начало массив-приемника
                mov eax, $dst
                jmp exit
                
    null:       xor eax, eax
    
    exit:       ret
                
bcd_add endp

end
