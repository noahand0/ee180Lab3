###############################################################################
# File         : nor_single_case.S
# Project      : EE180 Lab 2: MIPS
#
# Standards/Formatting:
#   MIPS gas, soft tab, 80 column
#
# Description:
#   Test the functionality of the 'nor' instruction with only 1 case.
#
###############################################################################

    .section .boot, "x"
    .balign 4
    .set    noreorder
    .global boot
    .ent    boot

boot:
 
    lui     $s0, 0x8002         # Base address for test/status registers (adjust as needed)
    ori     $s1, $zero, 1       # 'done' signal == 1

    lui     $t0, 0x1234
    ori     $t0, $t0, 0x5678     # $t0 = A
    lui     $t1, 0xABCD
    ori     $t1, $t1, 0xEF00     # $t1 = B

    nor     $t2, $t0, $t1       # R = nor(A, B)
    nop

    sw      $t2, 4($s0)         # Store the result of NOR at offset 4

    sw      $s1, 0($s0)         # Write 'done' signal

$done:
    j       $done               # Infinite loop
    nop

    .end    boot
