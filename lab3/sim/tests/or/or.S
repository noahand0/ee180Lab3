###############################################################################
# File         : or.S
# Project      : EE180 Lab (MIPS)
#
# Description:
#   Test the functionality of the 'or' instruction.
#   If the computed OR result is 0xFFFF, the test passes; otherwise it fails.
#   The test result (pass=0x1 or fail=0x0) is stored at 0x80020004 and the
#   simulation terminates by writing 0x1 to 0x80020000.
###############################################################################

    .section .boot, "x"
    .balign 4
    .set    noreorder
    .global boot
    .ent    boot
boot:
    # Initialize the base address for the test/status registers.
    lui     $s0, 0x8002         # $s0 = 0x80020000
    ori     $s1, $zero, 1       # $s1 = 0x1 (done signal)

    # Initialize test operands.
    ori     $t0, $zero, 0x5555  # $t0 = 0x00005555 (alternating 0101...)
    ori     $t1, $zero, 0xAAAA  # $t1 = 0x0000AAAA (alternating 1010...)

    # Perform the OR operation.
    or      $t2, $t0, $t1       # $t2 should be 0x0000FFFF

    # Expected result.
    ori     $t3, $zero, 0xFFFF  # $t3 = 0x0000FFFF

    # Compare the computed result with the expected result.
    bne     $t2, $t3, fail      # If not equal, branch to fail

pass:
    ori     $t4, $zero, 1       # $t4 = 0x1 (pass)
    sw      $t4, 4($s0)         # Store pass result to test register (0x80020004)
    sw      $s1, 0($s0)         # Store done signal to status register (0x80020000)
    j       done

fail:
    ori     $t4, $zero, 0       # $t4 = 0x0 (fail)
    sw      $t4, 4($s0)         # Store fail result to test register (0x80020004)
    sw      $s1, 0($s0)         # Store done signal to status register (0x80020000)

done:
    j       done               # Infinite loop to end simulation
    .end boot
