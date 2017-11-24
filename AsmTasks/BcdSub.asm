.model flat, c

.stack
.data
.code

extern bcd_cmp : NEAR
public bcd_sub

bcd_sub proc \
    $dst : PTR BYTE, \
    $lhs : PTR BYTE, \
    $rhs : PTR BYTE
    
local $sgn : DWORD

                ; Загружаем первое число, проверяем на нуль
                mov esi, $lhs
                test esi, esi
                jz null
                
                ; Загружаем второе число, проверяем на нуль
                mov ebx, $rhs
                test ebx, ebx
                jz null
                
                push esi
                push ebx
                
                ; Сравниваем числа для того, чтобы в дальшнейшем
                ; можно было их поменять местами
                push $rhs
                push $lhs
                call bcd_cmp

				add esp, 8
                
                pop ebx
                pop esi

                ; Загружаем массив-приемник, проверяем на нуль
                mov edi, $dst
                test edi, edi
                jz null
                
                ; Изначально знака нет
                mov $sgn, 0
                
                ; Результат сравнения чисел:
                ; 0 - равны, возвращаем нуль
                ; 1 - первое число больше
                ; -1 - первое число меньше, меняем числа местами
                cmp eax, 0
                jz zero
                jg @F
                
                ; Если число меньше, то перед результатом
                ; будет минус
                mov $sgn, 1
                xchg esi, ebx
                
                ; Движемся в прямом направлении
    @@:         cld
                xor ecx, ecx
                xor edx, edx
                
                ; Загружаем очередной символ
    sum:        xor eax, eax
				lodsb
    
                ; Если он ненулевой, то продолжаем
                test eax, eax
                jz finale
                
                ; Загружаем символ из другого числа
                mov cl, [ebx]
                inc ebx
                
                ; Если символ второй строки ненулевой,
                ; то продолжаем
                jecxz second_end
                
                ; Вычитаем из первого символа займ
                ; Вычитаем символы
                ; Корректируем и возвращаем базу для вывода
                ; sub eax, edx
				add ecx, edx
                sub eax, ecx
                aas
                add eax, '0'
                
                ; Выводим
                stosb
                
                ; Проверяем, есть ли у числа минус,
                ; Если есть, то устанавливаем регистр займа
                test eax, eax
                sets dl
                ; mov edx, eax
                
                ; Продолжаем
                jmp sum
                
                ; Загружаем очередной символ
    @@:         xor eax, eax
                lodsb
    
                ; Если он ненулевой, то продолжаем
    second_end: test eax, eax
                jz finale
                
                ; Вычитаем из первого символа займ
                ; Вычитаем символы
                ; Корректируем и возвращаем базу для вывода
                add edx, '0'
				sub eax, edx
                ; sub eax, '0'
                aas
                add eax, '0'
                
                ; Выводим
                stosb
                
                ; Проверяем, есть ли у числа минус,
                ; Если есть, то устанавливаем регистр займа
                test eax, eax
                sets dl
                ; mov edx, eax
                
                ; Продолжаем
                jmp @B

                ; Смотрим на знак
    finale:     cmp $sgn, 0
                jz @F
                
                ; Выводим минус, если надо
                mov eax, '-'
                stosb
                
                ; Выводим нулевой символ
    @@:         xor eax, eax
                stosb
                
                ; Возвращаем указатель на начало массив-приемника
                mov eax, $dst
                jmp exit
                
                ; Просто записываем нуль
    zero:       mov eax, '0'
                stosb
                xor eax, eax
                stosb
                jmp exit
                
    null:       xor eax, eax
    
    exit:       ret
                
bcd_sub endp

end
