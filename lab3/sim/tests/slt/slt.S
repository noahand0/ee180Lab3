###############################################################################
# File         : slt.S
# Project      : EE180 Lab (MIPS)
#
# Description:
#   Test the functionality of the 'slt' instruction.
#   The test compares two registers and sets the destination to 1 if the first
#   is less than the second, otherwise to 0. The result is stored at
#   0x80020004, and a done signal (0x1) is stored at 0x80020000.
###############################################################################

    .section .boot, "x"
    .balign 4
    .set noreorder
    .global boot
    .ent boot
boot:
    lui     $s0, 0x8002         # Load base address of test/status registers (0x80020000)
    ori     $s1, $zero, 1       # Set done signal = 1

    # Set two values for comparison.
    ori     $t1, $zero, 100     # $t1 = 100
    ori     $t2, $zero, 200     # $t2 = 200

    # Compare: set $t0 = 1 if $t1 < $t2, else 0.
    slt     $t0, $t1, $t2       # Expected result: $t0 = 1

    sw      $t0, 4($s0)         # Store test result at 0x80020004
    sw      $s1, 0($s0)         # Store done signal at 0x80020000

done:
    j       done               # Infinite loop to end simulation
    nop
    .end boot
