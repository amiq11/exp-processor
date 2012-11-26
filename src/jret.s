	.include "ia-32z.s"
	.text
init:
        zLIL    40, ax
        zLIL    1, cx
        zLIL    2, dx
        zLIL    3, bx
        zLIL    4, si
        zLIL    5, di
start:
        zLIL    1020, bp
        zLIL    1020, sp
        zJALR   ax
        zHLT
hoge:
        zPUSH   ax
        zPUSH   cx
        zPUSH   dx
        zPUSH   bx
        zPUSH   si
        zPUSH   di
        zLIL    64, ax
        zLIL    65, cx
        zLIL    66, dx
        zLIL    67, bx
        zLIL    68, si
        zLIL    69, di
        zPOP    di
        zPOP    si
        zPOP    bx
	zPOP	dx
	zPOP	cx
	zPOP	ax
        zRET
