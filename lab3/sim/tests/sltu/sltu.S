###############################################################################
# File         : sltu.S
# Project      : EE180 Lab (MIPS)
#
# Description:
#   Test the functionality of the 'sltu' instruction.
#   The test compares two registers using unsigned comparison.
#   If the first register is less than the second (unsigned), the result is 1;
#   otherwise, it is 0. The result is stored at 0x80020004 and the simulation
#   terminates by writing 0x1 to 0x80020000.
###############################################################################

    .section .boot, "x"
    .balign 4
    .set    noreorder
    .global boot
    .ent    boot
boot:
    lui     $s0, 0x8002         # Load base address of test/status registers: 0x80020000
    ori     $s1, $zero, 1       # Set done signal = 1

    # Set up values for unsigned comparison.
    # $t1 = 0x00000010 (16)
    ori     $t1, $zero, 0x10

    # $t2 = 0xFFFFFFF0
    lui     $t2, 0xffff         # $t2 = 0xffff0000
    ori     $t2, $t2, 0xfff0    # $t2 = 0xfffffff0

    # Perform unsigned less-than comparison.
    # sltu sets $t0 = 1 if $t1 < $t2 (unsigned), else 0.
    sltu    $t0, $t1, $t2

    sw      $t0, 4($s0)         # Store test result at 0x80020004
    sw      $s1, 0($s0)         # Store done signal at 0x80020000

done:
    j       done               # Infinite loop to end simulation
    nop
    .end boot
