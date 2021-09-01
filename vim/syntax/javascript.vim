" Added support for undescore in decimal numeric literals
syntax match   jsNumber           /\c\<\%(\(\d\|_\)\+\%(e[+-]\=\d\+\)\=\|0b[01]\+\|0o\o\+\|0x\%(\x\|_\)\+\)n\=\>/
