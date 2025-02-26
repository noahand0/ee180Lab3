###############################################################################
# File : jalr.S
# Project : EE180 Lab 2: MIPS
#
# Standards/Formatting:
# MIPS gas, soft tab, 80 column
#
# Description:
# Test the functionality of the 'jalr' instruction using the single register form.
# JALR jumps to the address in the specified register and stores the return 
# address in $ra.
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
    
    # Save the expected return address to compare later
    la $t1, return_point
    
    # Prepare a register with the target address
    la $t0, target
    
    # Test JALR instruction - should jump to address in $t0 and store return address in $ra
    jalr $t0             # $ra is implicitly used for the return address
    ori $t2, $0, 5       # Delay slot instruction - should execute
    
return_point:
    # Test never reaches here directly - only via jr $ra from target
    # By this point, we've verified both the jump and the link functionality
    bne $t2, 5, fail     # Verify delay slot executed
    nop
    bne $t3, 1, fail     # Verify target code executed
    nop
    
    # All tests passed
    ori $v0, $0, 1       # Set the result to pass
    j finish
    nop
    
fail:
    ori $v0, $0, 0       # Set the result to fail
    
finish:
    sw $v0, 4($s0)       # Store the result
    sw $s1, 0($s0)       # Signal completion
    
done:
    j done
    nop

target:
    # Set a flag to indicate this code executed
    ori $t3, $0, 1
    
    # First verify that JALR correctly saved the return address in $ra
    bne $ra, $t1, fail_direct # If $ra doesn't match expected return address, fail test
    nop
    
    # If return address was correctly saved, jump back using it
    jr $ra               # Return to return_point
    nop

fail_direct:
    # Jump directly to fail if the return address is incorrect
    j fail
    nop
    
 .end boot
