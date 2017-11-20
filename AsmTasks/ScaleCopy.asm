.model flat, C
.stack
.data

.code

public scale_copy

scale_copy proc \
    $dst : PTR DWORD, \
    $src : PTR DWORD, \
    $len : DWORD, \
    $scale_factor : DWORD

                ; Перемещаем в регистры все нужные переменные
                mov ebx, $scale_factor
                mov ecx, ebx
                mov edx, $len
                mov esi, $src
                mov edi, $dst
                cld

                ; Если длина нулевая, то выходим
                ; Если фактор расширения нулевой, выходим
                test edx, edx
                jz error
                jecxz error

                ; Загружаем следующее двойное слово
    main_loop:  lodsd

                ; Загружаем счетчик повторений фактором расширения
                ; Повторяем двойные слова в приемник
                mov ecx, ebx
                rep stosd

                ; Выполняем пока не пройдем по каждому элементу
                dec edx
                jnz main_loop

                ; Возвращаем указатель на начало приемника
                mov eax, $dst
                jmp exit

    error:      xor eax, eax

    exit:       ret

scale_copy endp

end