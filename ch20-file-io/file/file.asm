; file.asm
section .data
    ; expressions for conditional assembly
    CREATE      equ     1
    OVERWRITE   equ     1
    APPEND      equ     1
    O_WRITE     equ     1
    READ        equ     1
    O_READ      equ     1
    DELETE      equ     0
    
    ; syscall sybmols
    NR_read     equ     0
    NR_write    equ     1
    NR_open     equ     2
    NR_close    equ     3
    NR_lseek    equ     8   ; l stands for long; thus lseek support long integer offsets
    NR_create   equ     85
    NR_unlink   equ     87
    
    ; file status and create flags
    O_CREAT     equ     00000100q
    O_APPEND    equ     00002000q
    
    ; file access mode
    O_RDONLY    equ     000000q
    O_WRONLY    equ     000001q
    O_RDWR      equ     000002q
    
    ; permissions
    S_IRUSR     equ     00400q      ; user read 
    S_IWUSR     equ     00200q      ; user write
    
    NL          equ     0xa
    bufferlen   equ     64
    
    filename    db      "testfile.txt",0
    FD          dq      0                   ; file descriptor
    
    text1       db      "1. Hello...to everyone!",NL,0
    len1        dq      $-text1-1                       ; removes ending 0
    text2       db      "2. Here I am!",NL,0
    len2        dq      $-text2-1                       ; removes ending 0
    text3       db      "3. Alive and kicking!",NL,0
    len3        dq      $-text3-1                       ; removes ending 0
    text4       db      "Adios !!!",NL,0
    len4        dq      $-text4-1                       ; removes ending 0
    
    error_Create    db      "Error creating file",NL,0
    error_Close     db      "Error closing file",NL,0
    error_Write     db      "Error writing to file",NL,0
    error_Open      db      "Error opening file",NL,0
    error_Append    db      "Error appending to file",NL,0
    error_Delete    db      "Error deleting file",NL,0
    error_Read      db      "Error reading file",NL,0
    error_Print     db      "Error pring string",NL,0
    error_Position  db      "Error positioning in file",NL,0
    
    success_Create      db      "File created and opened",NL,0
    success_Close       db      "File closed",NL,NL,0
    success_Write       db      "Written to file",NL,0
    success_Open        db      "File opened for reading/(over)writing/updating",NL,0
    success_Append      db      "File opened for appending",NL,0
    success_Delete      db      "File deleted",NL,0
    success_Read        db      "Reading file",NL,0
    success_Position    db      "Positioned in file",NL,0

section .bss
    buffer  resb    bufferlen

section .text
    global main
main:
    push    rbp
    mov     rbp, rsp

%IF CREATE      ; create, open and then close file
    ; create and open file
    mov     rdi, filename
    call    createfile
    
    mov     qword [FD], rax     ; save file descriptor
    
    ; write to file
    mov     rdi, qword [FD]
    mov     rsi, text1
    mov     rdx, qword [len1]
    call    writefile
    
    ; close file
    mov     rdi, qword [FD]
    call    closefile
%ENDIF

%IF OVERWRITE   ; open, overwrite and then close file
    ; open file
    mov     rdi, filename
    call    openfile
    
    mov     qword [FD], rax     ; save file descriptor
    
    ; write to file #2: OVERWRITE!
    mov     rdi, qword [FD]
    mov     rsi, text2
    mov     rdx, qword [len2]
    call    writefile
    
    ; close file
    mov     rdi, qword [FD]
    call    closefile
%ENDIF

%IF APPEND  ; open, append and then close file
    ; open file to append to
    mov     rdi, filename
    call    appendfile
    
    mov     qword [FD], rax     ; save file descriptor
    
    ; write to file #3: APPEND!
    mov     rdi, qword [FD]
    mov     rsi, text3
    mov     rdx, qword [len3]
    call    writefile
    
    ; close file
    mov     rdi, qword [FD]
    call    closefile
%ENDIF

%IF O_WRITE ; open, overwrite at an offset and then close file
    ; open file to overwrite at offset
    mov     rdi, filename
    call    openfile
    
    mov     qword [FD], rax     ; save file descriptor
    
    ; position in file at offset
    mov     rdi, qword [FD]
    mov     rsi, qword [len2]   ; location offset
    mov     rdx, 0
    call    positionfile
    
    ; write to file at offset
    mov     rdi, qword [FD]
    mov     rsi, text4
    mov     rdx, qword [len4]
    call    writefile
    
    ; close file
    mov     rdi, qword [FD]
    call    closefile
%ENDIF

%IF READ    ; open, read from and then close file
    ; open file to read
    mov     rdi, filename
    call    openfile
    
    mov     qword [FD], rax     ; save file descriptor
    
    ; read from file
    mov     rdi, qword [FD]
    mov     rsi, buffer
    mov     rdx, bufferlen
    call    readfile
    
    mov     rdi, rax
    call    printstring
    
    ; close file
    mov     rdi, qword [FD]
    call    closefile
%ENDIF

%IF O_READ  ; open, read at offset and then close file
    ; open file to read at offset
    mov     rdi, filename
    call    openfile
    
    mov     qword [FD], rax     ; save file descriptor
    
    ; position in file at offset
    mov     rdi, qword [FD]
    mov     rsi, qword [len2]   ; skip first line
    mov     rdx, 0
    call    positionfile
    
    ; read from file at offset
    mov     rdi, qword [FD]
    mov     rsi, buffer
    mov     rdx, 10             ; number of characters to read
    call    readfile
    
    mov     rdi, rax
    call    printstring
    
    ; close file
    mov     rdi, qword [FD]
    call    closefile
%ENDIF

%IF DELETE  ; delete a file
    mov     rdi, filename
    call    deletefile
%ENDIF

    leave
    ret

;------------------------------------------------------------------------------
;-----------------------FILE OPERATION FUNCTIONS-------------------------------
;------------------------------------------------------------------------------
    global readfile
readfile:
    mov     rax, NR_read
    syscall                 ; rax contains the number of characters to read
    
    cmp     rax, 0
    jl      readerror
    
    mov     byte [rsi+rax], 0   ; add a terminating 0
    mov     rax, rsi
    mov     rdi, success_Read
    push    rax                 ; caller saved
    call    printstring
    pop     rax                 ; caller saved
    
    ret
readerror:
    mov     rdi, error_Read
    call    printstring
    
    ret
;------------------------------------------------------------------------------
    global deletefile
deletefile:
    mov     rax, NR_unlink
    syscall
    
    cmp     rax, 0
    jl      deleteerror
    
    mov     rdi, success_Delete
    call    printstring
    
    ret
deleteerror:
    mov     rdi, error_Delete
    call    printstring
    
    ret
;------------------------------------------------------------------------------
    global appendfile
appendfile:
    mov     rax, NR_open
    mov     rsi, O_RDWR | O_APPEND
    syscall
    
    cmp     rax, 0
    jl      appenderror
    
    mov     rdi, success_Append
    push    rax                     ; caller saved
    call    printstring
    pop     rax                     ; caller saved
    
    ret
appenderror:
    mov     rdi, error_Append
    call    printstring
    
    ret
;------------------------------------------------------------------------------
    global openfile
openfile:
    mov     rax, NR_open
    mov     rsi, O_RDWR
    syscall
    
    cmp     rax, 0
    jl      openerror
    
    mov     rdi, success_Open
    push    rax                     ; caller saved
    call    printstring
    pop     rax                     ; caller saved
    
    ret
openerror:
    mov     rdi, error_Open
    call    printstring
    
    ret
;------------------------------------------------------------------------------
    global writefile
writefile:
    mov     rax, NR_write
    syscall
    
    cmp     rax, 0
    jl      writeerror
    
    mov     rdi, success_Write
    call    printstring
    
    ret
writeerror:
    mov     rdi, error_Write
    call    printstring
    
    ret
;------------------------------------------------------------------------------
    global positionfile
positionfile:
    mov     rax, NR_lseek
    syscall
    
    cmp     rax, 0
    jl      positionerror
    
    mov     rdi, success_Position
    call    printstring
    
    ret
positionerror:
    mov     rdi, error_Position
    call    printstring
    
    ret
;------------------------------------------------------------------------------
    global closefile
closefile:
    mov     rax, NR_close
    syscall
    
    cmp     rax, 0
    jl      closeerror
    
    mov     rdi, success_Close
    call    printstring
    
    ret
closeerror:
    mov     rdi, error_Close
    call    printstring
    
    ret
;------------------------------------------------------------------------------
    global createfile
createfile:
    mov     rax, NR_create
    mov     rsi, S_IRUSR | S_IWUSR
    syscall
    
    cmp     rax, 0                  ; rax contains file descriptor
    jl      createerror
    
    mov     rdi, success_Create
    push    rax                     ; caller saved
    call    printstring
    pop     rax                     ; caller saved
    
    ret
createerror:
    mov     rdi, error_Create
    call    printstring
    
    ret
;------------------------------------------------------------------------------
    global printstring
printstring:
    ; count characters
    mov     r12, rdi
    mov     rdx, 0
strloop:
    cmp     byte [r12], 0
    je      strdone
    
    inc     rdx             ; rdx contains length
    inc     r12
    jmp     strloop
strdone:
    cmp     rdx, 0          ; no string = 0 length
    je      prtdone
    
    mov     rsi, rdi
    mov     rax, 1
    mov     rdi, 1
    syscall
prtdone:
    ret