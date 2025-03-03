###############################################################################
# File : bgtz.S
# Project : EE180 Lab 2: MIPS
#
# Standards/Formatting:
# MIPS gas, soft tab, 80 column
#
# Description:
# Test the functionality of the 'bgtz' instruction.
#
###############################################################################
 .section .boot, "x"
 .balign 4
.set noreorder
 .global boot
 .ent boot
boot:
    lui $s0, 0x8002      # Load the base address of the status/test registers
    ori $s1, $0, 1       # Prepare the 'done' status

    ori $t0, $0, 5       # Load positive value 5
    bgtz $t0, $target1   # Should branch (5 > 0)
    ori $v0, $0, 0       # The test fails if we don't branch
    j $finish
    nop

$target1:
    lui $t1, 0xffff      # Load negative value -1
    ori $t1, $t1, 0xffff
    bgtz $t1, $fail      # Should not branch (-1 is not > 0)
    ori $t2, $0, 0       # Load zero
    bgtz $t2, $fail      # Should not branch (0 is not > 0)
    ori $v0, $0, 1       # Set the result to pass
    j $finish
    nop

$fail:
    ori $v0, $0, 0       # Set the result to fail

$finish:
    sw $v0, 4($s0)       # Store the test result
    sw $s1, 0($s0)       # Set 'done'

$done:
    j $done
nop
 .end boot
