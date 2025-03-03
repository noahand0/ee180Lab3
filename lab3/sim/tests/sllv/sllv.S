###############################################################################
# File         : sllv.S
# Project      : EE180 Lab (MIPS)
#
# Description:
#   Test the functionality of the 'sllv' instruction.
#   The test shifts a word left by a variable amount and compares the result
#   with the expected value. The pass (0x1) or fail (0x0) result is stored at
#   0x80020004 and the simulation is terminated by writing 0x1 to 0x80020000.
###############################################################################

    .section .boot, "x"
    .balign 4
    .set    noreorder
    .global boot
    .ent    boot
boot:
    lui     $s0, 0x8002         # Load base address of test/status registers: 0x80020000
    ori     $s1, $zero, 1       # Done signal = 0x1

    # Load test value: $t0 = 0xdeafbeef
    lui     $t0, 0xdeaf
    ori     $t0, $t0, 0xbeef

    # Set shift amount: shift left by 4 bits
    ori     $t1, $zero, 4

    # Perform variable left shift: $t2 = $t0 << 4
    sllv    $t2, $t0, $t1       # Expected result: 0xEAFBEEF0

    # Construct the expected result.
    lui     $t3, 0xeafb         # $t3 = 0xEAFB0000
    ori     $t3, $t3, 0xeef0     # $t3 = 0xEAFBEEF0

    # Compare the computed result with the expected result.
    subu    $t4, $t2, $t3       # $t4 = $t2 - $t3 (should be 0)
    sltiu   $v0, $t4, 1         # $v0 = 1 if $t4 == 0, else 0

    sw      $v0, 4($s0)         # Store test result at 0x80020004
    sw      $s1, 0($s0)         # Store done signal at 0x80020000

done:
    j       done               # Infinite loop to end simulation
    nop
    .end boot
