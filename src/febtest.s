	.include "ia-32z.s"
	.text
#.globl _f
#        .def	_f;
#        .scl	2;
#        .type	32;
#        .endef
_f:
init:   
	zLIL	1, cx
        zLIL    10, bx
calc:
        zMOV    cx, dx
        zMOV    ax, cx
        zMOV    dx, ax
        zADD    ax, cx
        zST     cx, 100, bx
        zSUBI   1, bx
        zBcc    nz, calc
end:
        zLIL    10, bx
disp:
        zLD     100, bx, ax
        zSUBI   1, bx
        zBcc    nz, disp
EXIT:
        zHLT
