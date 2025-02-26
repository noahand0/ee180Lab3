###############################################################################
# File : jal.S
# Project : EE180 Lab 2: MIPS
#
# Standards/Formatting:
# MIPS gas, soft tab, 80 column
#
# Description:
# Test the functionality of the 'jal' instruction.
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
    ori $v0, $0, 0       # The test result starts as a failure
    
    # Save the address after the jal instruction to compare later
    la $t1, $return_point
    
    # Test JAL instruction - should jump to target and store return address in $ra
    jal target
    nop                  # Delay slot
    
$return_point:
    # Test never reaches here directly - only via jr $ra from target
    # By this point, if correct, we've verified both the jump and the link functionality
    ori $v0, $0, 1       # Set the result to pass
    
$finish:
    sw $v0, 4($s0)       # Store the result
    sw $s1, 0($s0)       # Signal completion
    
$done:
    j $done
    nop

target:
    # First verify that JAL correctly saved the return address in $ra
    bne $ra, $t1, $finish # If $ra doesn't match expected return address, fail test
    nop
    
    # If return address was correctly saved, jump back using it
    jr $ra               # Return to $return_point
    nop
 .end boot
