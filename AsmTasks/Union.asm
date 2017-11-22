.model flat, C
.stack
.data

.code

LEN EQU 512

; Макрос для подстановки вместо базовых операторов на множестве
@set_op macro \
    _op_name, \
    _op

    public _&_op_name
    
    ; Название функции образуется конкатенацией параметра 
    ; _op_name и нижнего подчеркивания
    _&_op_name proc \
        $dst_set : PTR DWORD, \
        $src_set : PTR DWORD
        
                    push ecx
                    push esi
                    push edi
        
                    ; Извлекаем указатели на множества из стека
                    mov esi, $src_set
                    mov edi, $dst_set

                    ; Устанавливаем длину множеств
                    mov ecx, LEN

                    ; В цикле выполняем оператор _op, заданный в параметре 
                    ; для каждых 16 байт последовательности с помощью команд SSE
        @@:         movaps xmm1, [esi]
                    movaps xmm0, [edi]
                    _op xmm0, xmm1
                    movaps [edi], xmm0

                    ; Следующие 16 байт
                    add esi, 16
                    add edi, 16

                    loop @B

                    pop edi
                    pop esi
                    pop ecx
                    
                    ret

    _&_op_name endp

endm

@comp_dword_bit macro
    
    ; Записываем в EDI - указатель на множество
    ;            в EAX - элемент
    mov edi, $set
    xor eax, eax
    mov ax, $item
    
    ; Делим элемент на 32 посредством сдвига:
    ; Частное в EAX, остаток в EDX
    mov edx, 31
    and edx, eax
    shr eax, 5
    
    ; Версия с делением, от которой пришлось отказаться
    ; mov ecx, 32
    ; xor edx, edx

    ; div ecx
    
endm

public _find
public _insert
public _remove

; Создаем и экспортируем функции множеств
@set_op union, por
@set_op difference, pxor
@set_op intersection, pand

_find proc \
    $set : PTR DWORD, \
    $item : WORD \

                push edi
    
                ; Используем вышеописанный макрос
                @comp_dword_bit

                ; Загружаем в ECX двойное слово с текущим элементом
                ; При этом в EAX - индекс двойного слова,
                ;            EDX - индекс бита наличия
                ; Далее проверяем бит с индексом EDX
                mov ecx, [edi + eax * 4]
                xor eax, eax
                bt ecx, edx

                ; Возвращаем true/false
                ; в зависимости от значения бита
                setc al

                pop edi
                
                ret

_find endp

_insert proc \
    $set : PTR DWORD, \
    $item : WORD \
                
                push edi
                
                ; Используем вышеописанный макрос
                @comp_dword_bit
                
                ; Загружаем в ECX двойное слово с текущим элементом
                ; При этом в EAX - индекс двойного слова,
                ;            EDX - индекс бита наличия
                ; Далее устанавливаем бит с индексом EDX
                lea edi, [edi + eax * 4]
                mov eax, [edi]
                bts eax, edx

                ; Записываем двойное слово с измененным битом
                ; в память
                mov [edi], eax

                pop edi
                
                ret

_insert endp

_remove proc \
    $set : PTR DWORD, \
    $item : WORD \
    
                push edi
    
                ; Используем вышеописанный макрос
                @comp_dword_bit
                
                ; Загружаем в ECX двойное слово с текущим элементом
                ; При этом в EAX - индекс двойного слова,
                ;            EDX - индекс бита наличия
                ; Далее обнуляем бит с индексом EDX
                lea edi, [edi + eax * 4]
                mov eax, [edi]
                btr eax, edx
                
                ; Записываем двойное слово с измененным битом
                ; в память
                mov [edi], eax

                pop edi
                
                ret

_remove endp

end