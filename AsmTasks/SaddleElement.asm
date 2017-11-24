.model flat, C
.stack
.data

$rows dd 0

MAX EQU 07FFFFFFFh
MIN EQU 080000000h

.code

public saddle_element

saddle_element proc \
    $data : PTR DWORD, \
    $width : DWORD, \
    $height : DWORD, \
    $x : PTR DWORD, \
    $y : PTR DWORD 

                ; Загружаем и проверяем матрицу на ненулевость
                mov esi, $data
                test esi, esi
                jz null
                
                ; Загружаем ширину, высоту
                ; Резервируем ширину в EDI
                xor eax, eax
                xor ebx, ebx
                mov ecx, $width
                dec ecx
                mov edx, $height
                mov edi, ecx
                
                ; Если ширина или высота меньше 2
                ; то мы не умеем с такими работать
                cmp ecx, 2
                jb null
                cmp edx, 2
                jb null
                
                ; Загружаем очередное значение
                ; В EBX хранится текущий минимум
    mins:       lodsd
                mov ebx, eax
                
                ; Загружаем очередное значение
    find_min:   lodsd
                
                ; Сравниваем следующее значение с минимумом
                ; Если минимум больше этого значения,
                ; обновляем минимум без прыжков
                cmp ebx, eax
                cmovg ebx, eax
                
                ; Ищем минимум по ширине строки
                loop find_min
                
                ; Толкаем минимум в стек, восстанавливаем ширину
                push ebx
                mov ecx, edi
                
                ; Проходимся по всей высоте
                dec edx
                jnz mins
                
                ; Загружаем ширину, вычисляем длину строки в байтах
                ; В EDI будет указатель на послдений элемент
                mov eax, $height
                mov $rows, eax
                mov ecx, $width
                mov edx, ecx
                shl edx, 2
                lea edi, [esi - 4]
                
                ; Двигаемся с конца
                std
                
                ; Достаем минимум из стека
    is_max:     pop eax
                
                ; Ищем минимум - их может быть несколько
    col:        repnz scasd
                jnz @F
                
                ; Проходимся по всей высоте
                ; В ESI загружаем адрес столбца первой строки
                mov ebx, $height
                mov esi, $data
                lea esi, [esi + ecx * 4] ; - 4]
                
                ; Проходим по столбцу и удостоверяемся,
                ; что данный минимум является максимумом
                ; В столбце
    cmp_max:    cmp eax, [esi]
                jl col
                
                ; Перемещаемся на следующую строчку
                add esi, edx
                
                ; Повторяем по всей высоте
                dec ebx
                jnz cmp_max
                
                ; Если найдено...
                jmp found
                
                ; Восстанавливаем ширину
    @@:         mov ecx, $width
                
                ; Пока не закончатся строки
                dec [$rows]
                jnz is_max
                
                ; Сбрасываем флаг
                cld
                
                ; Ничего не найдено, возвращаем "ложь"
                xor eax, eax
                jmp exit
                
                ; Сбрасываем флаг
    found:      cld
    
                ; Считываем количество строк, 
                ; по которым мы не успели пройтись
                mov ecx, $rows
                jecxz @F
                
                ; В стеке находится $rows - 1 минимумов
                dec ecx
                
                ; Очищаем стек во избежание неприятностей
    pop_all:    pop eax
                loop pop_all
    
                ; Для вычисления индекса нужно
                ; из смещения найденного элемента
                ; вычесть базу матрицы
    @@:         sub edi, $data
                shr edi, 2
                inc edi
                
                ; ...и поделить на ширину
                mov eax, edi
                mov ecx, $width
                xor edx, edx
                
                div ecx
                
                mov esi, $x
                mov edi, $y
                
                ; В EDX - столбец
                ;   EAX - строка
                mov [esi], edx
                mov [edi], eax
                
                ; Возвращаем "истину"
                mov eax, 1
                jmp exit
                
                ; Ошибка, возвращаем "ложь"
    null:       xor eax, eax
    
    exit:       ret
                

saddle_element endp

end