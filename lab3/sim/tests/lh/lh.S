###############################################################################
# File : lh.S
# Project : EE180 Lab 2: MIPS
#
# Standards/Formatting:
# MIPS gas, soft tab, 80 column
#
# Description:
# Test the functionality of the 'lh' instruction.
#
###############################################################################
 .section .boot, "x"
 .balign 4
.set noreorder
 .global boot
 .ent boot
boot:
lui $s0, 0x8002             # Load the base address of the status/test registers
ori $s1, $0, 1              # Prepare the 'done' status
lui $t0, 0                  # Load some valid address 0x00003210 to register $t0
ori $t0, $t0, 0x3210
lui $t1, 0xde0f             # Load test data
ori $t1, $t1, 0xbeef
sw $t1, 0($t0)              # Store test data at address in $t0

lh $s2, 0($t0)              # Load lower halfword (0xbeef) - sign extended to 0xffffbeef
lh $s3, 2($t0)              # Load upper halfword (0xde0f) - sign extended to 0xffffde0f

# Prepare expected values
lui $t2, 0xffff             # Expected value for $s2 (0xffffbeef)
ori $t2, $t2, 0xbeef
lui $t3, 0xffff             # Expected value for $s3 (0xffffde0f)
ori $t3, $t3, 0xde0f

# Verify results
subu $v1, $t2, $s2          # Check if $s2 matches expected value
sltiu $v0, $v1, 1           # Set $v0 to 1 if match, 0 if not

subu $v1, $t3, $s3          # Check if $s3 matches expected value
sltiu $v1, $v1, 1           # Set $v1 to 1 if match, 0 if not

and $v0, $v0, $v1           # $v0 = 1 only if both tests passed

# Additional test with positive values
lui $t1, 0x1234             # Load different test data
ori $t1, $t1, 0x5678
sw $t1, 4($t0)              # Store at offset 4 from base address

lh $s4, 4($t0)              # Load lower halfword (0x5678) - not sign extended
lh $s5, 6($t0)              # Load upper halfword (0x1234) - not sign extended

# Prepare expected values for positive halfwords
ori $t4, $0, 0x5678         # Expected value for $s4 (0x00005678)
ori $t5, $0, 0x1234         # Expected value for $s5 (0x00001234)

# Verify results
subu $v1, $t4, $s4          # Check if $s4 matches expected value
sltiu $v1, $v1, 1           # Set $v1 to 1 if match, 0 if not
and $v0, $v0, $v1           # AND with previous result

subu $v1, $t5, $s5          # Check if $s5 matches expected value
sltiu $v1, $v1, 1           # Set $v1 to 1 if match, 0 if not
and $v0, $v0, $v1           # AND with previous result

sw $v0, 4($s0)              # Set the test result
sw $s1, 0($s0)              # Set 'done'

$done:
j $done
nop
 .end boot
