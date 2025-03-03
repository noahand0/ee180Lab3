###############################################################################
# File         : xori.S
# Project      : EE180 Lab 2: MIPS
#
# Standards/Formatting:
#   MIPS gas, soft tab, 80 column
#
# Description:
#   Test the functionality of the 'xori' instruction.
#
###############################################################################

    .section .boot, "x"
    .balign 4
    .set    noreorder
    .global boot
    .ent    boot
boot:
    lui     $s0, 0x8002         # Load the base address of the status/test registers
    ori     $s1, $0, 1          # Prepare the 'done' status

    lui     $t0, 0xffff         # A = 0xffff0000
    xori    $t0, 0xffff         # A = 0xffffffff
    addiu   $t1, $t0, 3         # $t1 = 2
    ori     $t0, $0, 0xffff     # A = 0x0000ffff
    xori	$t0, 0xffff         # A = 0x00000000
    addiu   $t0, $t0, 1

    sub   $t2, $t1, $t0       # $t2 = 2 - 1 = 1.

    

    sw      $t2, 4($s0)         # Set the test result
    sw      $s1, 0($s0)         # Set 'done'
$done:
    j       $done
    nop

    .end boot
