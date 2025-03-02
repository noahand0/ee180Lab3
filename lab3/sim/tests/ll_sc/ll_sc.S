###############################################################################
# File         : ll_sc.S
# Project      : EE180 Lab 2: MIPS
#
# Standards/Formatting:
#   MIPS gas, soft tab, 80 column
#
# Description:
#   Test the functionality of the 'll and sc' instruction.
#
###############################################################################

    .section .boot, "x"
    .balign 4
    .set    noreorder
    .global boot
    .ent    boot

boot:
    
    lui     $s0, 0x8002         # $s0 = 0x80020000 (done/status base)
    ori     $s0, $s0, 0x0000
    #    0($s0) => "done" register
    #    4($s0) => "pass/fail" test register

    ori     $s1, $zero, 1       # Value to write for "done"

    
    lui     $t0, 0x0000
    ori     $t0, $t0, 0x3210    # $t0 = 0x00003210 (our test address)

    li      $t1, 0xABCD1234     # Some initial data pattern
    sw      $t1, 0($t0)

   
    ll      $t2, 0($t0)         # Load-linked
    addi    $t2, $t2, 1         # Increment the loaded value
    sc      $t2, 0($t0)         # Store-conditional
                                # - On success: memory updated, $t2=1
                                # - On failure: memory unchanged, $t2=0

    
    beqz    $t2, fail           # If $t2 == 0 => SC failed => jump to fail

pass:
    # SC succeeded; write 1 => pass
    li      $v0, 1
    sw      $v0, 4($s0)         # Pass => store 0x1 at 0x80020004
    b       done

fail:
    # SC failed; write 0 => fail
    li      $v0, 0
    sw      $v0, 4($s0)         # Fail => store 0x0 at 0x80020004

done:
    
    sw      $s1, 0($s0)         # Done => store 0x1 at 0x80020000

# Loop forever (so the simulator sees done and halts)
stop:
    j stop
    nop

    .end boot
