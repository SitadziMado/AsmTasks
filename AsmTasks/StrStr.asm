.model flat, c
.stack
.data

.code

public strstr

strstr proc \
    $string : PTR BYTE, \
    $substring : PTR BYTE

                ; Загружаем в регистры указатели на строку, подстроку,
                ; дублируем подстроку
                xor eax, eax
                xor edx, edx
                mov esi, $substring
                mov edi, $string
                mov ebx, esi
                cld

                ; Проверяем на нулевые указатели
                test esi, esi
                jz null_str
                test edi, edi
                jz null_str
                
                ; Загружаем первый символ
                lodsb

                ; Проверяем на пустую подстроку
                test eax, eax
                jz null_str

                ; Сравниваем первый символ подстроки с символами строки
                ; Если они равны:
                ;    перейти на метку сравнения дальнейших символов
    main_loop:  scasb
                jz match

                ; Если строка закончилась, то неудача
                cmp byte ptr [edi], 0
                jz not_found

                ; Продолжаем
                jmp main_loop

                ; Загружаем указатель на предыдущий символ строки
                ; (начало возможной подстроки)
    match:      lea edx, [edi - 1]

                ; Загружаем следующий символ подстроки
                ; Если подстрока закончилась, то удача
    @@:         lodsb
                test eax, eax
                jz found

                ; Сравниваем со следующим символом строки
                ; Если не равно, то к следующей @@-метке
                scasb
                jnz @F

                jmp @B

                ; Возвращаем указатель подстроки на ее начало,
                ; берем первый символ, возвращаемся на поиск снова
    @@:         mov esi, ebx
                lodsb
                dec edi     ; Need verification
                jmp main_loop

                ; Если найдено, то возвращаем сохраненный в EDX индекс
    found:      mov eax, edx
                jmp exit

    not_found:  
    null_str:   xor eax, eax

    exit:       ret

strstr endp

end