%include "includes/io.inc"

extern getAST
extern freeAST

struc myStruct
    data:       resd 1
    left:  resd 1
    right: resd 1
endstruc

section .data
    myvarl dd 0
    myvar2 dd 0
    myvar3 dd 0
    myvar4 dd 0
    
    equationTree:
        istruc myStruct
            at data, dd 0
            at left, dd '\0'
            at right, dd '\0'
        iend
        
section .bss
    ; La aceasta adresa, scheletul stocheaza radacina arborelui
    root: resd 1

section .text
global main

atoi:
    mov eax, 0
convert:
    movzx esi, byte [edi]
    test esi, esi
    je done
    
    cmp esi, 48
    jl error
    
    cmp esi, 57
    jg error
    
    sub esi, 48
    imul eax, 10
    add eax, esi
    
    inc edi
    jmp convert
error:    
    mov eax, esi
done:
    ret
    
binary_print:
    push ebp
    mov ebp, esp
    
    mov ecx, [ebx + 4]  ;verific sa fie stangul
    test ecx, ecx
    je NoNextElement  ;daca nu e stangul

    push ebx
    mov ebx, [ebx + left]
    call binary_print
    mov [myvar3], eax
    
    
    
    pop ebx
    
    cmp ebx, [root]
    jne trr
    mov [myvar4], eax
    
    
trr:    
    
    push ebx ;
    mov ebx, [ebx + right]
    call binary_print
    mov [myvar2], eax
    pop ebx ;
    
    ;jmp aici
    cmp ebx, [root]
    jne rrr
    mov eax, [myvar4]
    mov [myvar3], eax
    
rrr:
    mov ebx, [ebx]
    mov edi, ebx
    call atoi
    cmp eax, 43
    je adunare
    cmp eax, 45
    je scadere
    cmp eax, 42
    je inmultire
    
    mov eax, [myvar3]
    mov ebx, [myvar2]
    cdq
    idiv ebx

    jmp aici

adunare:
    mov eax, [myvar3]
    add eax, [myvar2]
    jmp aici
scadere:
    mov eax, [myvar3]
    sub eax, [myvar2]
    jmp aici
inmultire:
    mov eax, [myvar3]
    mov edx, [myvar2]
    imul edx
aici:
    leave
    ret
    
NoNextElement:
    mov ecx, [ebx] ;print [ecx]
    mov edi, ecx
    call atoi 
    cmp eax, 45
    
    jne continua

    add edi, 1
    call atoi
    not eax
    add eax, 1
continua:
    leave
    ret

main:
    mov ebp, esp; for correct debugging
    push ebp
    mov ebp, esp
    
    ; Se citeste arborele si se scrie la adresa indicata mai sus
    call getAST
    mov [root], eax
    
    ; Implementati rezolvarea aici:   
    mov ebx, [root]   
    call binary_print
    PRINT_DEC 4, eax
    ;NEWLINE
    ;PRINT_DEC 4, [myvar4]
    ;NEWLINE
    ;PRINT_DEC 4, [myvar3]
    ;NEWLINE
    ;PRINT_DEC 4, [myvar2]

    ;Free
    push dword [root]
    call freeAST
    xor eax, eax
    leave
    ret