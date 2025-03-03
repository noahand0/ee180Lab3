###############################################################################
# File : addi.S
# Project : EE180 Lab 2: MIPS
#
# Standards/Formatting:
# MIPS gas, soft tab, 80 column
#
# Description:
# Test the functionality of the 'addi' instruction.
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

# Test basic positive addition
ori $t0, $zero, 100  # A = 100
nop
addi $t1, $t0, 50    # B = A + 50 = 150
nop

# Test basic negative addition
ori $t2, $zero, 200  # C = 200
nop
addi $t3, $t2, -75   # D = C - 75 = 125
nop

# Test with negative values
lui $t4, 0xffff      # E = -100
nop
ori $t4, $t4, 0xff9c # Complete E = -100
nop
addi $t5, $t4, 150   # F = E + 150 = 50
nop

# Test with zero
addi $t6, $zero, 25  # G = 0 + 25 = 25
nop
addi $t7, $t6, 0     # H = G + 0 = 25
nop

# Test signed overflow
lui $t8, 0x7fff      # Load upper bits of MAX_INT
nop
ori $t8, $t8, 0xffff # I = 0x7fffffff (MAX_INT)
nop
addi $t9, $t8, 1     # J = I + 1 = overflow (should cause exception if enabled)
nop

# Store results
sw $t1, 4($s0)       # Store result 150
sw $t3, 8($s0)       # Store result 125
sw $t5, 12($s0)      # Store result 50
sw $t7, 16($s0)      # Store result 25
sw $t9, 20($s0)      # Store result of overflow test

sw $s1, 0($s0)       # Set 'done'
$done:
j $done
nop
 .end boot
