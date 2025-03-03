###############################################################################
# File         : sb.S
# Project      : EE180 Lab (MIPS)
#
# Description:
#   Test the functionality of the 'sb' instruction.
#   The test stores specific bytes into memory using sb and then loads them
#   back using lb. The expected sign-extended values are compared to the loaded
#   values. If all comparisons match, the test passes; otherwise it fails.
#
#   The test result (pass = 0x1 or fail = 0x0) is stored at 0x80020004 and the
#   simulation is terminated by writing 0x1 to 0x80020000.
###############################################################################

    .section .boot, "x"
    .balign 4
    .set noreorder
    .global boot
    .ent boot
boot:
    # Initialize test/status registers.
    lui     $s0, 0x8002         # $s0 = 0x80020000 (base address for test/status)
    ori     $s1, $zero, 1       # $s1 = 0x1 (done signal)

    # Set up a valid memory address: 0x00003210.
    lui     $t0, 0             # Clear upper bits of $t0
    ori     $t0, $t0, 0x3210    # $t0 = 0x00003210

    # (Optional) Initialize the word at this address to 0.
    sw      $zero, 0($t0)

    # Prepare test bytes.
    ori     $t1, $zero, 0xAA    # Byte value for offset 0: 0xAA
    ori     $t2, $zero, 0xBB    # Byte value for offset 1: 0xBB
    ori     $t3, $zero, 0xCC    # Byte value for offset 2: 0xCC
    ori     $t4, $zero, 0xDD    # Byte value for offset 3: 0xDD

    # Store the bytes into memory using sb.
    sb      $t1, 0($t0)         # Store 0xAA at offset 0
    sb      $t2, 1($t0)         # Store 0xBB at offset 1
    sb      $t3, 2($t0)         # Store 0xCC at offset 2
    sb      $t4, 3($t0)         # Store 0xDD at offset 3

    # Load back the stored bytes with lb (which sign-extends them).
    lb      $s2, 0($t0)         # Load byte from offset 0; expect 0xFFFFFFAA
    lb      $s3, 1($t0)         # Load byte from offset 1; expect 0xFFFFFFBB
    lb      $s4, 2($t0)         # Load byte from offset 2; expect 0xFFFFFFCC
    lb      $s5, 3($t0)         # Load byte from offset 3; expect 0xFFFFFFDD

    # Construct expected sign-extended values.
    lui     $t5, 0xffff
    ori     $t5, $t5, 0xffaa    # $t5 = 0xFFFFFFAA
    lui     $t6, 0xffff
    ori     $t6, $t6, 0xffbb    # $t6 = 0xFFFFFFBB
    lui     $t7, 0xffff
    ori     $t7, $t7, 0xffcc    # $t7 = 0xFFFFFFCC
    lui     $t8, 0xffff
    ori     $t8, $t8, 0xffdd    # $t8 = 0xFFFFFFDD

    # Compare loaded values with expected values.
    subu    $v1, $t5, $s2       # $v1 = $t5 - $s2 for offset 0
    sltiu   $v0, $v1, 1         # $v0 = 1 if $s2 equals expected, 0 otherwise
    subu    $v1, $t6, $s3       # Compare offset 1
    sltiu   $v1, $v1, 1
    and     $v0, $v0, $v1       # Combine result
    subu    $v1, $t7, $s4       # Compare offset 2
    sltiu   $v1, $v1, 1
    and     $v0, $v0, $v1       # Combine result
    subu    $v1, $t8, $s5       # Compare offset 3
    sltiu   $v1, $v1, 1
    and     $v0, $v0, $v1       # Final result in $v0 (1 if all match)

    # Write test result and done signal.
    sw      $v0, 4($s0)         # Write pass (1) or fail (0) to 0x80020004
    sw      $s1, 0($s0)         # Write done signal (1) to 0x80020000

done:
    j       done               # Infinite loop to end simulation
    .end boot
