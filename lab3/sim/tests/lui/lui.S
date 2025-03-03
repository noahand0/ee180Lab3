###############################################################################
# File         : lui.S
# Project      : EE180 Lab (MIPS)
#
# Description:
#   Test the functionality of the 'lui' instruction.
#   This test loads an upper immediate into a register and compares it
#   with the expected value. The pass (0x1) or fail (0x0) result is stored at
#   0x80020004 and the simulation is terminated by writing 0x1 to 0x80020000.
###############################################################################

    .section .boot, "x"
    .balign 4
    .set noreorder
    .global boot
    .ent boot
boot:
    # Initialize test/status registers.
    lui     $s0, 0x8002         # $s0 = 0x80020000 (base address)
    ori     $s1, $zero, 1       # $s1 = 0x1 (done signal)

    # Use LUI to load 0x12340000 into $t0.
    lui     $t0, 0x1234         # $t0 = 0x12340000

    # Construct the expected value 0x12340000 in $t1.
    ori     $t1, $zero, 0x1234   # $t1 = 0x00001234
    sll     $t1, $t1, 16         # $t1 = 0x12340000

    # Compare the computed value with the expected value.
    bne     $t0, $t1, fail       # Branch to fail if they do not match

pass:
    ori     $t2, $zero, 1        # $t2 = 0x1 (pass)
    sw      $t2, 4($s0)          # Store pass result at 0x80020004
    sw      $s1, 0($s0)          # Store done signal at 0x80020000
    j       done

fail:
    ori     $t2, $zero, 0        # $t2 = 0x0 (fail)
    sw      $t2, 4($s0)          # Store fail result at 0x80020004
    sw      $s1, 0($s0)          # Store done signal at 0x80020000

done:
    j       done                # Infinite loop to end simulation
    .end boot
