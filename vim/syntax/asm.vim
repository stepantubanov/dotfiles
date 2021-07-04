syn match asmBranchTarget "[?a-zA-Z0-9_]\+" contained display
syn keyword asmBranchInsn jmp je jne ja jae jb jbe jc jnc jcxz jecxz jrcxz jz jnz jg jge jl jle jo jno js jns call nextgroup=asmBranchTarget skipwhite display

syn cluster asmBranchLine contains=asmBranchInsn
syn cluster asmBranchLine add=asmBranchTarget

hi def link asmBranchInsn Identifier
hi def link asmBranchTarget Label
hi def link asmDirective Special

syn match asmHexadecimal	"\<[0-9a-fA-F]\+[hH]\>" display
