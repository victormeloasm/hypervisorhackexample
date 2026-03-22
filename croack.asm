format ELF64 executable 3
entry start

segment readable executable

start:
    mov eax, 1
    mov edi, 1
    mov rsi, msg_title
    mov edx, msg_title_len
    syscall

    mov eax, 0x40000000
    cpuid

    mov dword [maxleaf], eax
    mov dword [vendor+0], ebx
    mov dword [vendor+4], ecx
    mov dword [vendor+8], edx

    mov eax, 1
    mov edi, 1
    mov rsi, msg_vendor
    mov edx, msg_vendor_len
    syscall

    mov eax, 1
    mov edi, 1
    mov rsi, vendor
    mov edx, 12
    syscall

    mov eax, 1
    mov edi, 1
    mov rsi, nl
    mov edx, 1
    syscall

    mov eax, 1
    mov edi, 1
    mov rsi, msg_max
    mov edx, msg_max_len
    syscall

    mov eax, dword [maxleaf]
    lea rdi, [hexbuf]
    call u32_to_hex

    mov eax, 1
    mov edi, 1
    mov rsi, hexbuf
    mov edx, 8
    syscall

    mov eax, 1
    mov edi, 1
    mov rsi, nl
    mov edx, 1
    syscall

    mov eax, 60
    xor edi, edi
    syscall

u32_to_hex:
    push rcx
    push r8

    mov ecx, 8
    mov r8d, eax

.hex_loop:
    mov eax, r8d
    shr eax, 28
    and eax, 0Fh
    cmp eax, 9
    jbe .digit
    add eax, 'A' - 10
    jmp .store
.digit:
    add eax, '0'
.store:
    mov byte [rdi], al
    inc rdi
    shl r8d, 4
    loop .hex_loop

    pop r8
    pop rcx
    ret

segment readable writable

msg_title db 'Croack Hypervisor Demo (FASM)', 10
msg_title_len = $ - msg_title

msg_vendor db 'Hypervisor CPUID vendor: '
msg_vendor_len = $ - msg_vendor

msg_max db 'Max leaf: 0x'
msg_max_len = $ - msg_max

vendor  db 12 dup(0)
maxleaf dd 0
hexbuf  db 8 dup(0)
nl      db 10