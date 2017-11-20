.model flat, c
.stack
.data

.code

public wstrcmp

wstrcmp proc \
    $lhs : PTR WORD, \
    $rhs : PTR WORD, \
	$index : PTR DWORD

                ; Копируем исходные данные в регистры
                xor eax, eax
                mov esi, $lhs
                mov edi, $rhs

                ; Проверяем, не нулевые ли строки?
                test esi, esi
                jz null1
                test edi, edi
                jz null2

                ; Очищаем флаг направления
                cld

                ; Сравниваем строки, если не равны:
                ; то на выход
    cmp_loop:   cmpsw
                jnz not_eq

                ; Если обе строки закончились на нулевые,
                ; то они равны
                cmp word ptr [esi], 0
                jz equals

                ; Продолжаем
                jmp cmp_loop

                ; Перемещаемся к предыдущему символу,
                ; загружаем их разницу в AX
    not_eq:     sub esi, 2
                sub edi, 2
                mov ax, [esi]
                sub ax, [edi]

                ; Если 1 > 2, то возвращаем 1
                mov eax, 1
                jg @F

                ; Иначе -1
                mov eax, -1

                ; Формируем индекс несовпавшего элемента:
                ; из текущего смещения вычитаем начало
                ; строки, делим на 2, так как строка
                ; двубайтная
    @@:         mov edx, esi
                sub edx, [$lhs]
                shr edx, 1

                jmp exit

                ; Если строки равны, то индекс <- (-1)
    equals:     xor eax, eax
                mov edx, -1
                jmp exit

    null1:      mov edx, -1
                mov eax, -1
                jmp exit

    null2:      mov edx, -1
                mov eax, 1

                ; Записываем в память по указателю,
                ; хранящемуся в $index
    exit:       mov ebx, $index
                mov dword ptr [ebx], edx
                ret

wstrcmp endp

end