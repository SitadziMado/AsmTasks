.model flat, C
.stack
.data

DIGITS_PER_DWORD EQU 8

$suffix db '*', 'b', '*', 'o', 'h'

.code

public itoa

itoa proc \
    $dst : PTR BYTE, \
    $number : DWORD, \
    $base : DWORD

                mov ebx, $base
                
                ; Проверяем на поддерживаемые СС
                cmp ebx, 2
                jz bin
                cmp ebx, 8
                jz bin
                cmp ebx, 16
                jz bin
                cmp ebx, 10
                jnz err_base
                
                ; Загружаем число в EAX
                mov eax, $number
                
                ; Делаем EAX положительным без прыжков
                mov ebx, eax
                neg ebx
                test eax, eax
                cmovs eax, ebx
                
                ; Загружаем основание СС: 10
                ; ESI и EDI будут хранить упакованные
                ; двоично-десятичные цифры
                mov ebx, 10
                xor esi, esi
                xor edi, edi
                
                ; Количество двоично-десятичных цифр в двойном слове
    @@:         mov ecx, DIGITS_PER_DWORD
                
                ; Если число - ноль, то завершаем
    digits:     test eax, eax
                jz @F
                
                ; Делим на 10
                xor edx, edx
                div ebx
                
                ; Сдвигаем ESI на 4, добавляем очередную
                ; двоично-десятичную цифру
                shl esi, 4
                or esi, edx
                
                ; Продолжаем до восьми раз - 
                ; вместимости двойного слова
                loop digits
                
                ; Если число нулевое - то EDI не потребуется
                test eax, eax
                jz @F
                
                ; Перемещаем ESI в EDI - очищаем ESI
                ; Продолжаем сохранять двоично-десятичные цифры
                mov edi, esi
                xor esi, esi
                jmp @B
                
                ; Загружаем число, резервируем высшее слово
                ; полученного двоично-десятичного числа в EBX
                ; Загружаем указатель на строку назначения
    @@:         mov eax, $number
                mov ebx, edi
                mov edi, $dst
                cld
                
                ; Проверяем число на знак
                test eax, eax
                jns no_sgn
                
                ; Записываем минус в случае его присутствия
                mov eax, '-'
                stosb
                
                ; Вычисляем количество двоично-десятичных 
                ; цифр в ESI - если их 0, записываем "0"
                ; выходим
    no_sgn:     add ecx, -8
                neg ecx
                jecxz zero
                
                ; Записываем очередной символ:
                ; берем нижнюю двоично-десятичную цифру
                ; операцией поразрядного "И" от числа и
                ; 1111b - так в EAX оказываются нижние 4 бита
                ; Добавляем '0' - получаем символ, готовый к записи
    write:      mov eax, esi
                and eax, 0Fh
                add eax, '0'
                shr esi, 4
                
                ; Записываем его
                stosb
                
                ; Продолжаем столько раз, сколько цифр в ESI
                loop write
                
                ; Если ESI был перенесен в EDI, то там 8 символов
                ; Если EDI пуст, то заканчиваем работу
                mov ecx, DIGITS_PER_DWORD
                xchg esi, ebx
                test esi, esi
                jnz write
                
                ; Пишем нулевой символ
                xor eax, eax
                stosb
                
                ; Возвращаем указатель на начало строки
                mov eax, $dst
                
				jmp exit
                
                ; Записываем в ECX количество битов для сдвига (1, 3, 4)
                ; В EBX будет маска нижних битов для последующего
                ; превращения в символ
    bin:        bsf ecx, ebx
                dec ebx
                
                mov esi, $number
                mov edi, $dst
                
                ; Находим индекс старшего бита в числе
                xor edx, edx
                bsr eax, esi
                jz bzero
                
                ; Делим индекс старшего бита на биты/цифра
                ; Округляем в большую сторону нехитрыми манипуляциями
                ; Это нужно для расчета нужного места для числа
				inc eax
                div ecx
                test edx, edx
                setnz dl
                add eax, edx
                
                ; Прибавляем количество символов к началу строки,
                ; единица для суффикса
                lea edi, [edi + eax + 1]
                
                ; Маска теперь в EDX
                mov edx, ebx
                
                ; Пишем нулевой символ и суффикс в конец числа
                std
                xor eax, eax
                stosb
                mov eax, ecx
                lea ebx, [$suffix]
                xlat
                
                stosb
                
                ; Считываем следующую цифру
                ; двоичного/восьмеричного/шестнадцатеричного числа
    bdigits:    mov ebx, esi
                and ebx, edx
                shr esi, cl
                
                ; Превращаем цифру в символ
                lea eax, [ebx + '0']
                cmp eax, '9'
                jbe @F
                
                ; Если это шестнадцатеричная цифра, то нехитрыми
                ; манипуляциями превращаем ее в букву
                add eax, 'A' - '0' - 10
                
                ; Записываем...
    @@:         stosb
    
                ; Если еще не ноль, то продолжаем
                test esi, esi
                jnz bdigits
                
                ; (обязательно) очищаем флаг направления
                cld
                mov eax, $dst
                jmp exit
                
                ; Пишем "0" и выходим
    zero:       mov eax, '0'
                stosb
                
                ; ...нулевой символ
                xor eax, eax
                stosb
                
                mov eax, $dst
                
                jmp exit
                
                ; Пишем "0" и выходим
    bzero:      mov eax, '0'
                stosb
                
                ; Записываем суффикс
                mov eax, ecx
                lea ebx, [$suffix]
                xlat
                stosb
                
                ; ...нулевой символ
                xor eax, eax
                stosb
                
                mov eax, $dst
                
                jmp exit
                
    err_base:   xor eax, eax
    
    exit:       ret
    
itoa endp

end