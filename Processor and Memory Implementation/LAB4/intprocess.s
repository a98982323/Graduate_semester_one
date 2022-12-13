addiu $sp,$sp,-128

move  $k0,$1
sw    $k0,0($sp)
move  $k0,$2
sw    $k0,4($sp)
move  $k0,$3
sw    $k0,8($sp)

move  $k0,$4
sw    $k0,12($sp)
move  $k0,$5
sw    $k0,16($sp)
move  $k0,$6
sw    $k0,20($sp)
move  $k0,$7
sw    $k0,24($sp)
move  $k0,$8
sw    $k0,28($sp)
move  $k0,$9
sw    $k0,32($sp)
move  $k0,$10
sw    $k0,36($sp)
move  $k0,$11
sw    $k0,40($sp)
move  $k0,$12
sw    $k0,44($sp)
move  $k0,$13
sw    $k0,48($sp)
move  $k0,$14
sw    $k0,52($sp)
move  $k0,$15
sw    $k0,56($sp)
move  $k0,$16
sw    $k0,60($sp)
move  $k0,$17
sw    $k0,64($sp)
move  $k0,$18
sw    $k0,68($sp)
move  $k0,$19
sw    $k0,72($sp)
move  $k0,$20
sw    $k0,76($sp)
move  $k0,$21
sw    $k0,80($sp)
move  $k0,$22
sw    $k0,84($sp)
move  $k0,$23
sw    $k0,88($sp)
move  $k0,$24
sw    $k0,92($sp)
move  $k0,$25
sw    $k0,96($sp)
move  $k0,$26
sw    $k0,100($sp)
move  $k0,$27
sw    $k0,104($sp)
move  $k0,$28
sw    $k0,108($sp)
move  $k0,$29
sw    $k0,112($sp)
move  $k0,$30
sw    $k0,116($sp)
move  $k0,$31
sw    $k0,120($sp)



move $8,$0
move $9,$0
move $10,$0


lw    $1,0($sp)
lw    $2,4($sp)
lw    $3,8($sp)
lw    $4,12($sp)
lw    $5,16($sp)
lw    $6,20($sp)
lw    $7,24($sp)
lw    $8,28($sp)
lw    $9,32($sp)
lw    $10,36($sp)
lw    $11,40($sp)
lw    $12,44($sp)
lw    $13,48($sp)
lw    $14,52($sp)
lw    $15,56($sp)
lw    $16,60($sp)
lw    $17,64($sp)
lw    $18,68($sp)
lw    $19,72($sp)
lw    $20,76($sp)
lw    $21,80($sp)
lw    $22,84($sp)
lw    $23,88($sp)
lw    $24,92($sp)
lw    $25,96($sp)
lw    $26,100($sp)
lw    $27,104($sp)
lw    $28,108($sp)
lw    $29,112($sp)
lw    $30,116($sp)
lw    $31,120($sp)





addiu $sp,$sp,128
jr    $31
