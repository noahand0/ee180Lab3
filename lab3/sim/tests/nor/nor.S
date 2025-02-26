###############################################################################
# File : nor.S
# Project : EE180 Lab 2: MIPS
#
# Standards/Formatting:
# MIPS gas, soft tab, 80 column
#
# Description:
# Test the functionality of the 'nor' instruction.
#
###############################################################################
 .section .boot, "x"
 .balign 4
.set noreorder
 .global boot
 .ent boot
boot:
lui $s0, 0x8002 # Load the base address of the status/test registers
ori $s1, $0, 1 # Prepare the 'done' status
lui $t0, 0xdeaf # A = 0xdeafbeef
ori $t0, $t0, 0xbeef
lui $t1, 0x3141 # B = 0x31415927
ori $t1, $t1, 0x5927
lui $t2, 0xefee # C = 0xefeee7c8
ori $t2, $t2, 0xe7c8
nor $t3, $t0, $t1 # D = nor(A,B) = ~(A|B) = ~(0xdeafbeef|0x31415927) = ~0xffefa7ef = 0x00105810
nop
nor $t4, $t3, $t2 # E = nor(D,C) = ~(0x00105810|0xefeee7c8) = ~0xeffeeff8 = 0x10011007
nop
nop
sw $t4, 4($s0) # Set the test result
sw $s1, 0($s0) # Set 'done'
$done:
j $done
nop
 .end boot
