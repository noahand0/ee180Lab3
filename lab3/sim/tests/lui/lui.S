###############################################################################
# File : lui.S
# Project : EE180 Lab 2: MIPS
#
# Standards/Formatting:
# MIPS gas, soft tab, 80 column
#
# Description:
# Test the functionality of the 'lui' instruction.
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

# Test 1: Load basic value
lui $s2, 0x1234             # Load 0x12340000 into $s2
lui $t0, 0x1234             # Load expected value upper bits
ori $t0, $0, 0              # Expected value: 0x12340000
subu $v1, $t0, $s2          # Compute difference
sltiu $v0, $v1, 1           # Set $v0 to 1 if match, 0 if not

# Test 2: Load maximum value
lui $s3, 0xffff             # Load 0xffff0000 into $s3
lui $t1, 0xffff             # Load expected value
ori $t1, $0, 0              # Expected value: 0xffff0000
subu $v1, $t1, $s3          # Compute difference
sltiu $v1, $v1, 1           # Set $v1 to 1 if match, 0 if not
and $v0, $v0, $v1           # Combine results

# Test 3: Load zero value
lui $s4, 0                  # Load 0x00000000 into $s4
ori $t2, $0, 0              # Expected value: 0x00000000
subu $v1, $t2, $s4          # Compute difference
sltiu $v1, $v1, 1           # Set $v1 to 1 if match, 0 if not
and $v0, $v0, $v1           # Combine results

# Test 4: Check lower bits are zeroed
ori $s5, $0, 0xffff         # Set lower bits to all 1s
lui $s5, 0xabcd             # Load 0xabcd0000, should overwrite lower bits
lui $t3, 0xabcd             # Load expected value
ori $t3, $0, 0              # Expected value: 0xabcd0000
subu $v1, $t3, $s5          # Compute difference
sltiu $v1, $v1, 1           # Set $v1 to 1 if match, 0 if not
and $v0, $v0, $v1           # Combine results

# Test 5: Check that lower bits aren't affected by lui's sign extension
lui $s6, 0x8000             # Load 0x80000000 (negative value in two's complement)
lui $t4, 0x8000             # Load expected value
ori $t4, $0, 0              # Expected value: 0x80000000
subu $v1, $t4, $s6          # Compute difference
sltiu $v1, $v1, 1           # Set $v1 to 1 if match, 0 if not
and $v0, $v0, $v1           # Combine results

sw $v0, 4($s0)              # Set the test result
sw $s1, 0($s0)              # Set 'done'

$done:
j $done
nop
 .end boot
