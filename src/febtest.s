	.include "ia-32z.s"
	.text
#.globl _f
#        .def	_f;
#        .scl	2;
#        .type	32;
#        .endef
_f:
init:   
	zLIL	1, cx   #0
        zLIL    40, bx  
calc:
        zMOV    cx, dx  #2
        zMOV    ax, cx
        zMOV    dx, ax
        zADD    ax, cx
        zST     cx, 100, bx
        zSUBI   4, bx
        zBcc    nz, calc
end:
        zLIL    40, bx  #9
disp:
        zLD     100, bx, ax  #10
        zSUBI   4, bx
        zBcc    nz, disp
EXIT:
        zHLT
