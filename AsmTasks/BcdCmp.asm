.model flat, c
.data

.code

public bcd_cmp

bcd_cmp proc \
    $first : PTR BYTE, \
    $second : PTR BYTE
                
                ; Ищем нулевой символ
                xor eax, eax
                
                ; Загружаем первую строку
                mov edi, $first
                
                ; Ищем нулевой символ до конца строки
                mov ecx, -1
                repnz scasb
                
                ; Отступаем обратно на два символа,
                ; так как строковые функции сначала делают
                ; инкремент, а потом сравнивают
                add ecx, 2
                neg ecx
                
                ; Сохраняем длину и указатель на конец первой строки
                mov edx, ecx
                mov esi, edi
                
                ; Делаем то же самое со второй строкой
                mov edi, $second
                
                mov ecx, -1
                repnz scasb
                
                add ecx, 2
                neg ecx
                
                ; Сравниваем по длине:
                ; 1 > 2: +1 
                ; 1 < 2: -1
                cmp edx, ecx
                ja greater
                jb less
                
                ; Иначе идем дальше
                sub esi, 2
                sub edi, 2
                
                ; Двигаемся с конца
                std
                
                ; Сравниваем, пока символы равны
                repz cmpsb
                jnz not_eq
                
                ; Все символы оказались равными - успех
                xor eax, eax
                jmp exit
                
                ; Отступаем на символ
    not_eq:     inc esi
                inc edi
                
                ; Загружаем символ и тут же сравниваем
                lodsb
                scasb
                
                ; Смотрим на признак: меньше или больше
                jb less
                ; ja greater
                
    greater:    mov eax, 1
                jmp exit
    
    less:       mov eax, -1
    
    exit:       cld
				ret
                
bcd_cmp endp

end