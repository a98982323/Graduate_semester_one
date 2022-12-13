mfc0 $k0, $14 
nop
nop
nop
sw   $k0,4($0)

mfc0 $k0, $12
nop
nop
nop
sw   $k0,8($0)

mfc0 $k0, $13
nop
nop
nop
sw   $k0,12($0)
nop
nop
nop

mfc0 $k0,$13
nop
nop
nop
li   $k1,4096
add  $k1,$k0,$k1
jalr   $k1
nop
nop
nop
lw   $k0,4($0)
nop
nop
nop

mtc0 $k0, $14
nop
nop
nop
lw   $k0,8($0)
nop
nop
nop

mtc0 $k0, $12
nop
nop
nop
lw   $k0,12($0)
nop
nop
nop

mtc0 $k0, $13
nop
nop
nop
li $k1,64513

mtc0 $k1,$12
mfc0 $k0,$14
nop
nop
nop
jr  $k0


