.586
.model flat, C
.stack
.data

.code

public memset

memset proc \
	dst : PTR DWORD, \
    value : DWORD, \
    len : DWORD

                ; Проверяем, не нулевая ли длина?
				mov ecx, len
				jecxz exit

                ; Устанавливаем регистры значениями
				mov eax, value
				mov edi, dst

                ; Записываем побайтово в память
				rep stosb

	exit:		ret

memset endp

end