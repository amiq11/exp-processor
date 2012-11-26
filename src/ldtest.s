	.include "ia-32z.s"
	.text
.globl _f
#        .def	_f;
#        .scl	2;
#        .type	32;
#        .endef
_f:
	zLIL	1, ax
	zLIL	2, cx
	zLIL	64, dx
        zLIL    255, bx
        zHLT
EXIT:
