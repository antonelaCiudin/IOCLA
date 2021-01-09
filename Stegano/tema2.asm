%include "io.inc"

extern atoi
extern printf
extern exit

; Functions to read/free/print the image.
; The image is passed in argv[1].
extern read_image
extern free_image
; void print_image(int* image, int width, int height);
extern print_image

; Get image's width and height.
; Store them in img_[width, height] variables.
extern get_image_width
extern get_image_height

section .data
	use_str db "Use with ./tema2 <task_num> [opt_arg1] [opt_arg2]", 10, 0

section .bss
    task:       resd 1
    img:        resd 1
    img_width:  resd 1
    img_height: resd 1

section .text
global main

bruteforce:
    pop eax
    mov ebx, 0 ; nr linii
    mov ecx, 0 ; nr coloane
    
loop1:
    loop2:
        mov eax, [img_width] 
        mul ebx
        mov edx, 4
        mul edx
        push eax ;determina indexul liniei
        
        mov eax, ecx
        mov edx, 4
        mul edx
        pop edx
        add edx, eax ;indexul elementului
        mov eax, [img]
        
        push ecx ;salveaza contorul pt elemente
        push ebx ;salveaza valoarea liniei
        
        mov ecx, 0

        ;se verifica daca elementul curent este 'r'
        verify_r:
            mov ebx, [eax+edx]
            xor ebx, ecx
            cmp ebx, 'r'
            je verify_e
            inc ecx 
            cmp ecx, 255
            jne verify_r
            je cont
        verify_e:
            mov ebx, [eax+edx+4]
            xor ebx, ecx
            cmp ebx, 'e'
            je verify_v
            inc ecx
            cmp ecx, 255
            je cont
            jmp verify_r
        verify_v:
            mov ebx, [eax+edx+8]
            xor ebx, ecx
            cmp ebx, 'v'
            je verify_i
            inc ecx
            cmp ecx, 255
            je cont
            jmp verify_r
        verify_i:
            mov ebx, [eax+edx+12]
            xor ebx, ecx
            cmp ebx, 'i'
            je verify_e2
            inc ecx
            cmp ecx, 255
            je cont
            jmp verify_r
        verify_e2:
            mov ebx, [eax+edx+16]
            xor ebx, ecx
            cmp ebx, 'e'
            je verify_n
            inc ecx
            cmp ecx, 255
            je cont
            jmp verify_r
        verify_n:
            mov ebx, [eax+edx+20]
            xor ebx, ecx
            cmp ebx, 'n'
            je verify_t
            inc ecx
            cmp ecx, 255
            je cont
            jmp verify_r
        verify_t:
            mov ebx, [eax+edx+24]
            xor ebx, ecx
            cmp ebx, 't'
            je key_found
            inc ecx
            cmp ecx, 255
            je cont
            jmp verify_r
            
    cont: ;se continua daca nu s-a gasit tot cuvantul
    
        ;se restabilesc contoarele pentru linie si element
        pop ebx
        pop ecx

        inc ecx
        cmp ecx, [img_width]
        jne loop2
        mov ecx, 0
        inc ebx
        cmp ebx, [img_height]
        jne loop1
      
    ;se printeaza linia decriptata cu cheia gasita  
    key_found:
        pop ebx
        mov eax, [img_width]
        mul ebx
        push ebx
        mov ebx, 4
        mul ebx
        mov edx, eax
        mov eax, [img]
        push ecx ; salvez cheia pe stiva
        mov ebx, 0
        print_message:
            mov esi, [eax+edx]
            xor esi, ecx
            inc ebx
            cmp esi, 0 ; se opreste daca e terminator...
            je stop_print
            cmp ebx, [img_width]
            je stop_print ; ...sau daca e sfarsit de linie
            PRINT_CHAR esi
            add edx, 4
            jmp print_message
            
        stop_print:
        NEWLINE
        
jmp exit_bruteforce
    
codify:
	;codificarea literelor, cifrelor si virgulei
    cmp edi, ','
    jne codeA
    mov byte[edx+eax], '-'
    add eax, 4
    mov byte[edx+eax], '-'
    add eax, 4
    mov byte[edx+eax], '.'
    add eax, 4
    mov byte[edx+eax], '.'
    add eax, 4
    mov byte[edx+eax], '-'
    add eax, 4
    mov byte[edx+eax], '-'
    add eax, 4
    jmp stop_codify
codeA:
    cmp edi, 'A'
    jne codeB
    mov byte[edx+eax], '.'
    add eax, 4
    mov byte[edx+eax], '-'
    add eax, 4
    jmp stop_codify
codeB:
    cmp edi, 'B'
    jne codeC
    mov byte[edx+eax], '-'
    add eax, 4
    mov byte[edx+eax], '.'
    add eax, 4
    mov byte[edx+eax], '.'
    add eax, 4
    mov byte[edx+eax], '.'
    add eax, 4
    jmp stop_codify
codeC:
    cmp edi, 'C'
    jne codeD
    mov byte[edx+eax], '-'
    add eax, 4
    mov byte[edx+eax], '.'
    add eax, 4
    mov byte[edx+eax], '-'
    add eax, 4
    mov byte[edx+eax], '.'
    add eax, 4
    jmp stop_codify
codeD:
    cmp edi, 'D'
    jne codeE
    mov byte[edx+eax], '-'
    add eax, 4
    mov byte[edx+eax], '.'
    add eax, 4
    mov byte[edx+eax], '.'
    add eax, 4
    jmp stop_codify
codeE:
    cmp edi, 'E'
    jne codeF
    mov byte[edx+eax], '.'
    add eax, 4
    jmp stop_codify
codeF:
    cmp edi, 'F'
    jne codeG
    mov byte[edx+eax], '.'
    add eax, 4
    mov byte[edx+eax], '.'
    add eax, 4
    mov byte[edx+eax], '-'
    add eax, 4
    mov byte[edx+eax], '.'
    add eax, 4
    jmp stop_codify
codeG:
    cmp edi, 'G'
    jne codeH
    mov byte[edx+eax], '-'
    add eax, 4
    mov byte[edx+eax], '-'
    add eax, 4
    mov byte[edx+eax], '.'
    add eax, 4
    jmp stop_codify
codeH:
    cmp edi, 'H'
    jne codeI
    mov byte[edx+eax], '.'
    add eax, 4
    mov byte[edx+eax], '.'
    add eax, 4
    mov byte[edx+eax], '.'
    add eax, 4
    mov byte[edx+eax], ''
    add eax, 4
    jmp stop_codify
codeI:
    cmp edi, 'I'
    jne codeJ
    mov byte[edx+eax], '.'
    add eax, 4
    mov byte[edx+eax], '.'
    add eax, 4
    jmp stop_codify
codeJ:
    cmp edi, 'J'
    jne codeK
    mov byte[edx+eax], '.'
    add eax, 4
    mov byte[edx+eax], '-'
    add eax, 4
    mov byte[edx+eax], '-'
    add eax, 4
    mov byte[edx+eax], '-'
    add eax, 4
    jmp stop_codify
codeK:
    cmp edi, 'K'
    jne codeL
    mov byte[edx+eax], '-'
    add eax, 4
    mov byte[edx+eax], '.'
    add eax, 4
    mov byte[edx+eax], '-'
    add eax, 4
    jmp stop_codify
codeL:
    cmp edi, 'L'
    jne codeM
    mov byte[edx+eax], '.'
    add eax, 4
    mov byte[edx+eax], '-'
    add eax, 4
    mov byte[edx+eax], '.'
    add eax, 4
    mov byte[edx+eax], '.'
    add eax, 4
    jmp stop_codify
codeM:
    cmp edi, 'M'
    jne codeN
    mov byte[edx+eax], '-'
    add eax, 4
    mov byte[edx+eax], '-'
    add eax, 4
    jmp stop_codify
codeN:
    cmp edi, 'N'
    jne codeO
    mov byte[edx+eax], '-'
    add eax, 4
    mov byte[edx+eax], '.'
    add eax, 4
    jmp stop_codify
codeO:
    cmp edi, 'O'
    jne codeP
    mov byte[edx+eax], '-'
    add eax, 4
    mov byte[edx+eax], '-'
    add eax, 4
    mov byte[edx+eax], '-'
    add eax, 4
    jmp stop_codify
codeP:
    cmp edi, 'P'
    jne codeQ
    mov byte[edx+eax], '.'
    add eax, 4
    mov byte[edx+eax], '-'
    add eax, 4
    mov byte[edx+eax], '-'
    add eax, 4
    mov byte[edx+eax], '.'
    add eax, 4
    jmp stop_codify
codeQ:
    cmp edi, 'Q'
    jne codeR
    mov byte[edx+eax], '-'
    add eax, 4
    mov byte[edx+eax], '-'
    add eax, 4
    mov byte[edx+eax], '.'
    add eax, 4
    mov byte[edx+eax], '-'
    add eax, 4
    jmp stop_codify
codeR:
    cmp edi, 'R'
    jne codeS
    mov byte[edx+eax], '.'
    add eax, 4
    mov byte[edx+eax], '-'
    add eax, 4
    mov byte[edx+eax], '.'
    add eax, 4
    jmp stop_codify
codeS:
    cmp edi, 'S'
    jne codeT
    mov byte[edx+eax], '.'
    add eax, 4
    mov byte[edx+eax], '.'
    add eax, 4
    mov byte[edx+eax], '.'
    add eax, 4
    jmp stop_codify
codeT:
    cmp edi, 'T'
    jne codeU
    mov byte[edx+eax], '-'
    add eax, 4
    jmp stop_codify
codeU:
    cmp edi, 'U'
    jne codeV
    mov byte[edx+eax], '.'
    add eax, 4
    mov byte[edx+eax], '.'
    add eax, 4
    mov byte[edx+eax], '-'
    add eax, 4
    jmp stop_codify
codeV:
    cmp edi, 'V'
    jne codeW
    mov byte[edx+eax], '.'
    add eax, 4
    mov byte[edx+eax], '.'
    add eax, 4
    mov byte[edx+eax], '.'
    add eax, 4
    mov byte[edx+eax], '-'
    add eax, 4
    jmp stop_codify
codeW:
    cmp edi, 'W'
    jne codeX
    mov byte[edx+eax], '.'
    add eax, 4
    mov byte[edx+eax], '-'
    add eax, 4
    mov byte[edx+eax], '-'
    add eax, 4
    jmp stop_codify
codeX:
    cmp edi, 'X'
    jne codeY
    mov byte[edx+eax], '-'
    add eax, 4
    mov byte[edx+eax], '.'
    add eax, 4
    mov byte[edx+eax], '.'
    add eax, 4
    mov byte[edx+eax], '-'
    add eax, 4
    jmp stop_codify
codeY:
    cmp edi, 'Y'
    jne codeZ
    mov byte[edx+eax], '-'
    add eax, 4
    mov byte[edx+eax], '.'
    add eax, 4
    mov byte[edx+eax], '-'
    add eax, 4
    mov byte[edx+eax], '-'
    add eax, 4
    jmp stop_codify
codeZ:
    cmp edi, 'Z'
    jne code0
    mov byte[edx+eax], '-'
    add eax, 4
    mov byte[edx+eax], '-'
    add eax, 4
    mov byte[edx+eax], '.'
    add eax, 4
    mov byte[edx+eax], '.'
    add eax, 4
    jmp stop_codify
code0:
    cmp edi, '0'
    jne code1
    mov byte[edx+eax], '-'
    add eax, 4
    mov byte[edx+eax], '-'
    add eax, 4
    mov byte[edx+eax], '-'
    add eax, 4
    mov byte[edx+eax], '-'
    add eax, 4
    mov byte[edx+eax], '-'
    add eax, 4
    jmp stop_codify
code1:
    cmp edi, '1'
    jne code2
    mov byte[edx+eax], '.'
    add eax, 4
    mov byte[edx+eax], '-'
    add eax, 4
    mov byte[edx+eax], '-'
    add eax, 4
    mov byte[edx+eax], '-'
    add eax, 4
    mov byte[edx+eax], '-'
    add eax, 4
    jmp stop_codify
code2:
    cmp edi, '2'
    jne code3
    mov byte[edx+eax], '.'
    add eax, 4
    mov byte[edx+eax], '.'
    add eax, 4
    mov byte[edx+eax], '-'
    add eax, 4
    mov byte[edx+eax], '-'
    add eax, 4
    mov byte[edx+eax], '-'
    add eax, 4
    jmp stop_codify
code3:
    cmp edi, '3'
    jne code4
    mov byte[edx+eax], '.'
    add eax, 4
    mov byte[edx+eax], '.'
    add eax, 4
    mov byte[edx+eax], '.'
    add eax, 4
    mov byte[edx+eax], '-'
    add eax, 4
    mov byte[edx+eax], '-'
    add eax, 4
    jmp stop_codify
code4:
    cmp edi, '4'
    jne code5
    mov byte[edx+eax], '.'
    add eax, 4
    mov byte[edx+eax], '.'
    add eax, 4
    mov byte[edx+eax], '.'
    add eax, 4
    mov byte[edx+eax], '.'
    add eax, 4
    mov byte[edx+eax], '-'
    add eax, 4
    jmp stop_codify
code5:
    cmp edi, '5'
    jne code6
    mov byte[edx+eax], '.'
    add eax, 4
    mov byte[edx+eax], '.'
    add eax, 4
    mov byte[edx+eax], '.'
    add eax, 4
    mov byte[edx+eax], '.'
    add eax, 4
    mov byte[edx+eax], '.'
    add eax, 4
    jmp stop_codify
code6:
    cmp edi, '6'
    jne code7
    mov byte[edx+eax], '-'
    add eax, 4
    mov byte[edx+eax], '.'
    add eax, 4
    mov byte[edx+eax], '.'
    add eax, 4
    mov byte[edx+eax], '.'
    add eax, 4
    mov byte[edx+eax], '.'
    add eax, 4
    jmp stop_codify
code7:
    cmp edi, '7'
    jne code8
    mov byte[edx+eax], '-'
    add eax, 4
    mov byte[edx+eax], '-'
    add eax, 4
    mov byte[edx+eax], '.'
    add eax, 4
    mov byte[edx+eax], '.'
    add eax, 4
    mov byte[edx+eax], '.'
    add eax, 4
    jmp stop_codify
code8:
    cmp edi, '8'
    jne code9
    mov byte[edx+eax], '-'
    add eax, 4
    mov byte[edx+eax], '-'
    add eax, 4
    mov byte[edx+eax], '-'
    add eax, 4
    mov byte[edx+eax], '.'
    add eax, 4
    mov byte[edx+eax], '.'
    add eax, 4
    jmp stop_codify
code9:
    cmp edi, '9'
    jne stop_codify
    mov byte[edx+eax], '-'
    add eax, 4
    mov byte[edx+eax], '-'
    add eax, 4
    mov byte[edx+eax], '-'
    add eax, 4
    mov byte[edx+eax], '-'
    add eax, 4
    mov byte[edx+eax], '.'
    add eax, 4

;se face jump aici daca s-a gasit un element
stop_codify:
    jmp next ;se trece la urmatorul byte
    
morse:
    mov ecx, 0
    push ebx
    mov ebx, 4
    mul ebx
    pop ebx
    
    print:
    	;parcurg fiecare byte incepand cu indexul oferit
        movzx edi, byte[ebx]
        cmp edi, 0x00
        je stop
        mov edx, [img]
        jmp codify
    	next:
        inc ebx
        movzx edi, byte[ebx]
        cmp edi, 0x00
        je continue
        ;verificare pentru adaugare de spatiu
        mov byte[edx+eax], ' '
        add eax, 4
    continue:
        jmp print

    stop:
    mov byte[edx+eax], 0x00 ;se adauga terminatorul de string

jmp exit_morse  
    
blur:
    PRINT_STRING "P2"
    NEWLINE
    PRINT_DEC 4, [img_width]
    PRINT_STRING " "
    PRINT_DEC 4, [img_height]
    NEWLINE
    mov ecx, 0
    mov ebx, 0
    mov esi, 0
    
    ;se cauta elementul maxim
    loop_max1:
        loop_max2:
        mov eax, [img_width]
        mul ebx
        mov edx, 4
        mul edx
        push eax ;determina indexul liniei
        
        mov eax, ecx
        mov edx, 4
        mul edx
        pop edx
        add edx, eax ;indexul elementului
        
        mov eax, [img]
        mov eax, [eax+edx] ;dereferentiere
        cmp eax, esi
        
        jng continue_max
        mov esi, eax ;maximul va fi stocat in esi
        
        continue_max:
        
        inc ecx
        cmp ecx, [img_width]
        jne loop_max2
        mov ecx, 0
        inc ebx
        cmp ebx, [img_height]
        jne loop_max1
        
    PRINT_DEC 4, esi ;printeaza maximul in output
    NEWLINE
    
    mov ecx, 0
    mov esi, [img]
    
    ;printeaza prima linie a matricei
    print_first_line:
        mov eax, 4
        mul ecx
        PRINT_DEC 4, [esi+eax]
        PRINT_STRING " "
        inc ecx
        cmp ecx, [img_width]
        jne print_first_line
    
    ;parcugerea va incepe de la a doua linie din matrice
    mov ebx, 1
    mov ecx, 1
    
loop1_blur:
        NEWLINE
        push ebx
        
        mov eax, [img_width]
        mul ebx
        mov edx, 4
        mul edx
        mov esi, [img]
        PRINT_DEC 4, [esi+eax] ;printeaza I-ul element de pe linie neschimbat
        PRINT_STRING " "
    loop2_blur:
        mov eax, [img_width]
        mul ebx
        mov edx, 4
        mul edx
        push eax ;determina indexul liniei
        
        mov eax, ecx
        mov edx, 4
        mul edx
        pop edx
        add edx, eax ;indexul elementului
        
        push ecx
        push ebx
        
        mov esi, [img]
        
        ;in eax se stocheaza suma celor 5 elemente
        mov eax, [esi+edx] ;elementul curent
        add eax, [esi+edx+4] ;el din dreapta
        add eax, [esi+edx-4] ;el din stanga
        mov ebx, edx
        push eax ;salvare suma
        mov eax, [img_width]
        mov ecx, 4
        mul ecx
        mov ecx, eax
        
        pop eax ;restabilire suma
        
        mov edx, ebx
        sub ebx, ecx
        add eax, [esi+ebx] ;el de jos
        mov ebx, edx
        add ebx, ecx
        add eax, [esi+ebx] ;el de sus
        push edx ;salvare index curent
        xor edx, edx
        mov ecx, 5
        div ecx ;calculare medie
        pop edx ;restabilire index
        PRINT_DEC 4, eax ;printare element modificat
        PRINT_STRING " "

        pop ebx
        pop ecx

        inc ecx
        mov edx, [img_width]
        sub edx, 1
        cmp ecx, edx
        jne loop2_blur
        
        push ebx
        push ecx
        
        mov eax, [img_width]
        mul ebx
        mov edx, 4
        mul edx
        push eax
        
        mov eax, ecx
        mov edx, 4
        mul edx
        pop edx
        add edx, eax
        mov esi, [img]
        
        PRINT_DEC 4, [esi+edx] ;printare ultimul element
        PRINT_STRING " "
        
        pop ecx
        pop ebx
        
        push edx
        
        mov ecx, 1
        inc ebx
        mov edx, [img_height]
        sub edx, 1
        cmp edx, ebx
        je no
        pop edx
        no:
        cmp edx, ebx ;se verifica daca e penultimul element
        jne loop1_blur
        NEWLINE
        
        pop edx
        mov ebx, edx
        mov ecx, 0
    
    ;printeaza ultima linie
    print_last_line:
        add ebx, 4
        PRINT_DEC 4, [esi+ebx]
        PRINT_STRING " "
        inc ecx
        cmp ecx, [img_width]
        jne print_last_line

jmp exit_blur  

main:
    mov ebp, esp; for correct debugging
    ; Prologue
    ; Do not modify!
    push ebp
    mov ebp, esp

    mov eax, [ebp + 8]
    cmp eax, 1
    jne not_zero_param

    push use_str
    call printf
    add esp, 4

    push -1
    call exit

not_zero_param:
    ; We read the image. You can thank us later! :)
    ; You have it stored at img variable's address.
    mov eax, [ebp + 12]
    push DWORD[eax + 4]
    call read_image
    add esp, 4
    mov [img], eax

    ; We saved the image's dimensions in the variables below.
    call get_image_width
    mov [img_width], eax

    call get_image_height
    mov [img_height], eax

    ; Let's get the task number. It will be stored at task variable's address.
    mov eax, [ebp + 12]
    push DWORD[eax + 8]
    call atoi
    add esp, 4
    mov [task], eax

    ; There you go! Have fun! :D
    mov eax, [task]
    cmp eax, 1
    je solve_task1
    cmp eax, 2
    je solve_task2
    cmp eax, 3
    je solve_task3
    cmp eax, 4
    je solve_task4
    cmp eax, 5
    je solve_task5
    cmp eax, 6
    je solve_task6
    cmp eax, 7
    je solve_task7
    jmp done

solve_task1:
	;TODO Task1
	;sare la "functia" de rezolvare
    jmp bruteforce
exit_bruteforce:
    pop ecx ;cheia
    pop ebx ;linia
    PRINT_DEC 4, ecx
    NEWLINE
    PRINT_DEC 4, ebx
    NEWLINE
    jmp done
solve_task2:
    ; TODO Task2
    
    jmp done
solve_task3:
	;TODO Task3
    mov eax, [ebp+12]
    mov ebx, dword[eax+12]
    
    mov eax, [ebp+12]
    mov edx, dword[eax+16]
    push edx
    call atoi ;apeleaza atoi pentru 
    
    jmp morse
exit_morse:
    mov ebx, [img_height]
    mov ecx, [img_width]
    mov eax, [img]
    push ebx
    push ecx
    push eax
    call print_image

    jmp done
solve_task4:
    ; TODO Task4
    
    mov ebx, [img_height]
    mov ecx, [img_width]
    mov eax, [img]
    push ebx
    push ecx
    push eax
    call print_image
    jmp done
solve_task5:
    ; TODO Task5
    jmp done
solve_task6:
    ; TODO Task6
    mov ebx, [img_height]
    mov ecx, [img_width]
    mov eax, [img]
    push ebx
    push ecx
    push eax
    ;call print_image
    
    jmp blur
exit_blur:
    
    jmp done
solve_task7:
    ; TODO Task7
    jmp done

    ; Free the memory allocated for the image.
done:
    push DWORD[img]
    call free_image
    add esp, 4
    

    ; Epilogue
    ; Do not modify!
    xor eax, eax 
    leave
    ret
