###############################################################################
# File         : lb.S
# Project      : EE180 Lab 2: MIPS
#
# Standards/Formatting:
#   MIPS gas, soft tab, 80 column
#
# Description:
#   Test the functionality of the 'lb' instruction.
#
###############################################################################


    .section .boot, "x"
    .balign 4
    .set    noreorder
    .global boot
    .ent    boot
boot:
    lui     $s0, 0x8002         # Load the base address of the status/test registers
    ori     $s1, $0, 1          # Prepare the 'done' status
    lui     $t0, 0              # Load some valid address 0x00003210 to register $t0
    ori     $t0, $t0, 0x3210
    lui     $t1, 0xdead
    ori     $t1, $t1, 0xbeef    # $t1 contains 0xdeadbeef
    sw      $t1, 0($t0)         # mem at address $t0 holds 0xdeadbeef
    lh      $s2, 0($t0)         # 0xffffdead
    lh      $s3, 2($t0)         # 0xffffbeef
    lui     $t2, 0xffff
    ori     $t2, $t2, 0xdead
    lui     $t3, 0xffff
    ori     $t3, $t3, 0xbeef 

    subu    $v1, $t2, $s2
    sltiu   $v0, $v1, 1
    subu    $v1, $t3, $s3
    sltiu   $v1, $v1, 1
    and     $v0, $v0, $v1
    sw      $v0, 4($s0)         # Set the test result
    sw      $s1, 0($s0)         # Set 'done'

$done:
    j       $done
    nop

    .end boot
