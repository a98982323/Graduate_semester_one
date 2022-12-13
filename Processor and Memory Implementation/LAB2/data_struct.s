	.file	1 "data_struct.c"   # 指定編譯器後面的彙編指令相對應的來源文件
	.section .mdebug.abi32 		# 設定編譯器的標準
	.previous					# 表示恢復到當前 .section 定義之前的那個段作為當前段
	.rdata						# 任何在.rdata偽操作生效時定義的符號都屬於這個類別。類別，它類似於數據，但在執行過程中不能被修改
	.align	2					# 字節對齊
.LC0:							
	.word	60					# 設一個字元，代表一個字節
	.word	70					# 設一個字元，代表一個字節
	.word	70					# 設一個字元，代表一個字節
	.align	2					# 字節對齊
.LC1:
	.word	70					# 設一個字元，代表一個字節
	.word	50					# 設一個字元，代表一個字節	
	.word	80					# 設一個字元，代表一個字節
	.text						# 告訴 assembly 在文本部分添加後續程式
	.align	2				# 字節對齊
	.globl	main			# 將 main 設為區域變數
	.set	nomips16		# 返回到正常的32位模式
	.ent	main			# 設置 main 的開頭
main:
	.frame	$sp,32,$31		# vars= 32, regs= 0/0, args= 0, gp= 0
	.mask	0x00000000,0	# 為當前例程保存的每個通用暫存器設置一個打開0x00000000位的掩碼,從虛擬框架指針到寄存器被保存的字節的距離為0
	.fmask	0x00000000,0	# 為當前例程保存的每個浮點暫存器設置一個打開0x00000000位的掩碼。最低有效位對應於寄存器 $f0。 以字節為單位的距離為0
	.set	noreorder		# 防止組譯器對機器語言進行重新排序
	.set	nomacro			# 每當一個組譯器操作產生多個機器語言指令，打印警告
	
	addiu	$sp,$sp,-32		# $sp = $sp - 32
	li	$4,536870912		# $4 = 0x2000 0000
	ori	$6,$4,0x20			# $6 = $4 or 0x20
	lui	$2,%hi(.LC0)		# $2 = %hi(.LC0) * 2^16
	lw	$9,%lo(.LC0)($2)	# $9 = Memory[$2 + %lo(.LC0) ]
	addiu	$2,$2,%lo(.LC0)	# $2 = $2 + %lo(.LC0)	
	lw	$7,4($2)			# $7 = Memory[$2 + 4]
	lw	$8,8($2)			# $8 = Memory[$2 + 8]
	lui	$2,%hi(.LC1)		# $2 = %hi(.LC1) * 2^16
	lw	$5,%lo(.LC1)($2)	# $5 = Memory[$2 + %lo(.LC1) ]
	addiu	$2,$2,%lo(.LC1) # $2 = $2 + %lo(.LC1)
	lw	$3,4($2)			# $3 = Memory[$2 + 4]
	lw	$2,8($2)			# $2 = Memory[$2 + 8]
	sw	$5,16($sp)			# Memory[$sp + 16] = $5
	sw	$3,20($sp)			# Memory[$sp + 20] = $3
	sw	$2,24($sp)			# Memory[$sp + 24] = $2
	sw	$9,0($4)			# Memory[$4 + 0] = $9
	sw	$7,4($4)			# Memory[$4 + 4] = $7
	sw	$8,8($4)			# Memory[$4 + 8] = $8
	lw	$3,20($sp)			# $3 = Memory[$sp + 20]
	lw	$4,24($sp)			# $4 = Memory[$sp + 24]
	lw	$2,16($sp)			# $2 = Memory[$sp + 16]		
	sw	$2,0($6)			# Memory[$6 + 0] = $2
	sw	$3,4($6)			# Memory[$6 + 4] = $3
	sw	$4,8($6)			# Memory[$6 + 8] = $4
	j	$31					# go to address stored in $31
	addiu	$sp,$sp,32		# $sp = $sp + 32

	.set	macro	# n lets the assembler generate multiple machine instructions from a single assembler instruction
	.set	reorder	# 重新排列機器語言指令來提高性能
	.end	main	# 设置一个程序的结束是 main
	.size	main, .-main	# 到 main 開始的距離, main 的大小也是 .-main
	.ident	"GCC: (GNU) 3.4.4 mipssde-6.06.01-20070420" # 註腳編譯器版本
