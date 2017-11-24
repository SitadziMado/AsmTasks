.model flat, C

.stack

.data

.code

public first_last_of

first_last_of proc \
    $item : DWORD, \
    $array : PTR DWORD, \
    $size : DWORD, \
    $first : PTR DWORD, \
    $last : PTR DWORD

                mov edi, $array
                
                ; Если нулевой указатель, то не найдено
                test edi, edi
                jz null
                
                ; Загружаем параметры
                mov eax, $item
                mov ecx, $size
                mov edx, ecx
                
                ; Ищем до первой встречи, если не найдено,
                ; то выход
                repnz scasb
                jnz no_match
                
                ; SCASB имеет свойство делать инкремент,
                ; а потом сравнивать, так что после
                ; предыдущей команды он на шаг впереди
                dec edi
                
                ; Устанавливаем значение индекса первого
                ; найденного элемента
                mov ebx, $first
                mov [ebx], edi
                
                ; Добавляем к адресу найденного символа
                ; количество оставшихся + 1, тем самым 
                ; перемещаемся в конец строки
                lea edi, [edi + ecx + 1]
                
                ; Изменяем направление и ищем с конца
                std
                mov ecx, edx
                repnz scasb
                
                ; Аналогично предыдущему, только в другую сторону
                inc edi
                
                ; Устанавливаем значение индекса последнего
                ; найденного элемента
                mov ebx, [$last]
                mov [ebx], edi
                
                cld
                
                jmp exit
    
    no_match:   
    null:       xor eax, eax
    
    exit:       ret

first_last_of endp

end