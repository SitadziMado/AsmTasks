.model flat, C

.stack

.data
align 16

$comressed dd 4 dup(0)

.code

public saddle_element

saddle_element4x4 proc \
    $matrix : PTR DWORD, \
    $success : PTR BYTE

                mov esi, $matrix
                
                movups xmm0, [esi]
                movups xmm1, [esi + 4 * 4]
                movups xmm2, [esi + 8 * 4]
                movups xmm3, [esi + 12 * 4]
                
                minps xmm0, xmm1
                minps xmm0, xmm2
                minps xmm0, xmm3
                
                movaps $compressed, xmm0
                
                movss xmm0, [$compressed]
                movss xmm1, [$compressed + 1]
                movss xmm2, [$compressed + 2]
                movss xmm3, [$compressed + 3]
                
                mov

saddle_element endp