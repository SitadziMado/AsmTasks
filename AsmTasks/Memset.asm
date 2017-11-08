.586
.model flat, C
.stack
.data

MAX EQU 07FFFFFFFh
MIN EQU 080000000h
BASE EQU 0Ah
SEP0 EQU '`'
SEP1 EQU "'"
SEP2 EQU "_"

.code

public memset

memset proc \
	dst : PTR DWORD, \
    value : DWORD, \
    len : DWORD

				mov ecx, len
				jecxz exit

				mov eax, value
				mov edi, dst

				rep stosb

	exit:		ret

memset endp

end