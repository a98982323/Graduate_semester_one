	.file	1 "max_return.c"	# 指定編譯器後面的彙編指令相對應的來源文件
	.section .mdebug.abi32		# 設定編譯器的標準
	.previous					# 表示恢復到當前 .section 定義之前的那個段作為當前段
	.text						# 告訴組譯器將後續程式添加到本文部分
	.align	2					# 字節對齊
	.globl	main				# 將 main 設為全域變數
	.set	nomips16			# 返回到正常的32位模式
	.ent	main				# 設置 main 的開頭
main:
	.frame	$sp,24,$31		# vars= 0, regs= 1/0, args= 16, gp= 0
	.mask	0x80000000,-8	# 為當前例程保存的每個通用暫存器設置一個打開0x80000000位的掩碼,從虛擬框架指針到寄存器被保存的字節的距離為 -8
	.fmask	0x00000000,0	# 為當前例程保存的每個浮點暫存器設置一個打開0x00000000位的掩碼。最低有效位對應於寄存器 $f0。 以字節為單位的距離為0
	.set	noreorder		# 防止組譯器對機器語言進行重新排序
	.set	nomacro			# 每當一個組譯器操作產生多個機器語言指令，印出警告
	
	addiu	$sp,$sp,-24			# $sp = $sp - 24
	sw	$31,16($sp)				# Mem[$sp + 16] = $31 
	li	$4,44					# $4 = 0x2c, a = 44
	li	$5,87					# $5 = 0x57, b = 87
	jal	sum						# $ra = PC +4 , go to address sum
	li	$6,2					# $6 = 0x2, c =2

	li	$3,536870912			# $3 = 0x20000000 , volatile int* n = (int*) 0x20000000
	sw	$2,0($3)				# Mem[$3 + 0] = $2, 
	move	$2,$0				# $2 = $0, 
	lw	$31,16($sp)				# $31 = Mem[$sp + 16]
	j	$31						# go to address $31
	addiu	$sp,$sp,24			# $sp = $sp + 24

	.set	macro				# 讓組譯器從一條組譯指令生成多條機器指令
	.set	reorder				# 重新排列機器語言指令來提高性能
	.end	main				# 設置一个程序的结束是 main
	.size	main, .-main		# 到 main 開始的距離, main 的大小也是 .-main
	.align	2					# 字節對齊
	.globl	sum					# 將 sum 設為全域變數	
	.set	nomips16			# 返回到正常的32位模式
	.ent	sum					# 設置一個程序的結束是 sum
sum:
	.frame	$sp,0,$31		# vars= 0, regs= 0/0, args= 0, gp= 0
	.mask	0x00000000,0	# 為當前例程保存的每個通用暫存器設置一個打開0x00000000位的掩碼,從虛擬框架指針到寄存器被保存的字節的距離為0
	.fmask	0x00000000,0	# 為當前例程保存的每個浮點暫存器設置一個打開0x00000000位的掩碼。最低有效位對應於寄存器 $f0。 以字節為單位的距離為0
	.set	noreorder		# 防止組譯器對機器語言進行重新排序
	.set	nomacro			# 每當一個組譯器操作產生多個機器語言指令，印出警告
	
	addu	$2,$4,$5		# $2 = $4 + $5, n = a + b
	j	$31					# go to address $31
	addu	$2,$2,$6		# $2 = $2 + $6, n = n + c

	.set	macro			# 讓組譯器從一條組譯指令生成多條機器指令
	.set	reorder			# 重新排列機器語言指令來提高性能
	.end	sum				# 設置一個程序的結束是 sum
	.size	sum, .-sum		# 到 sum 開始的距離, sum 的大小也是 .-sum
	.ident	"GCC: (GNU) 3.4.4 mipssde-6.06.01-20070420" #  註腳編譯器版本
