.model flat, C
.stack
.data

; Генератор таблицы
; table = [str(x - 13) + ', ' if (x + 1) % 8 != 0 else str(x - 13) + ",\\\n" for x in range(0, 128 + 13)]
; print(''.join(table))
; Шифр Цезаря со сдвигом на 13
table db	0, 14, 15, 16, 17, 18, 19, 20
	  db	21, 22, 23, 24, 25, 26, 27, 28
	  db	29, 30, 31, 32, 33, 34, 35, 36
	  db	37, 38, 39, 40, 41, 42, 43, 44
	  db	45, 46, 47, 48, 49, 50, 51, 52
	  db	53, 54, 55, 56, 57, 58, 59, 60
	  db	61, 62, 63, 64, 65, 66, 67, 68
	  db	69, 70, 71, 72, 73, 74, 75, 76
	  db	77, 78, 79, 80, 81, 82, 83, 84
	  db	85, 86, 87, 88, 89, 90, 91, 92
	  db	93, 94, 95, 96, 97, 98, 99, 100
	  db	101, 102, 103, 104, 105, 106, 107, 108
	  db	109, 110, 111, 112, 113, 114, 115, 116
	  db	117, 118, 119, 120, 121, 122, 123, 124
	  db	125, 126, 127, 128, 129, 130, 131, 132
	  db	133, 134, 135, 136, 137, 138, 139, 140

itable db	-13, -12, -11, -10, -9, -8, -7, -6
	   db	-5, -4, -3, -2, -1, 0, 1, 2
	   db	3, 4, 5, 6, 7, 8, 9, 10
	   db	11, 12, 13, 14, 15, 16, 17, 18
	   db	19, 20, 21, 22, 23, 24, 25, 26
	   db	27, 28, 29, 30, 31, 32, 33, 34
	   db	35, 36, 37, 38, 39, 40, 41, 42
	   db	43, 44, 45, 46, 47, 48, 49, 50
	   db	51, 52, 53, 54, 55, 56, 57, 58
	   db	59, 60, 61, 62, 63, 64, 65, 66
	   db	67, 68, 69, 70, 71, 72, 73, 74
	   db	75, 76, 77, 78, 79, 80, 81, 82
	   db	83, 84, 85, 86, 87, 88, 89, 90
	   db	91, 92, 93, 94, 95, 96, 97, 98
	   db	99, 100, 101, 102, 103, 104, 105, 106
	   db	107, 108, 109, 110, 111, 112, 113, 114
	   db	115, 116, 117, 118, 119, 120, 121, 122
	   db	123, 124, 125, 126, 127

.code

public encrypt
public decrypt

encrypt proc \
	$string : PTR BYTE

				xor eax, eax
				mov ebx, offset table
				mov esi, $string
				mov edi, $string
				cld

	crypt_loop:	lodsb
				test eax, eax
				jz end_crypt
				xlat
				stosb
				jmp crypt_loop

	end_crypt:  mov eax, $string
				ret

encrypt endp

decrypt proc \
	$string : PTR BYTE

				xor eax, eax
				mov ebx, offset itable
				mov esi, $string
				mov edi, $string
				cld

	decrp_loop: lodsb
				test eax, eax
				jz end_decrp
				xlat
				stosb
				jmp decrp_loop

	end_decrp:	mov eax, $string
				ret

decrypt endp

end