`include "timescale.v"
// synopsys translate_on


module interrupt_controller(irq,rst_n,clk,if_pc,mem_pc,intctl_epc,intctl_status,intctl_cause,iack,id2intctl_status);			
			input [5:0]	irq; //當設備發生中斷時，會產生中斷訊號，傳入中斷控制模組
			input 	rst_n;
			input 	clk;
			input 	if_pc;
			input	mem_pc; // 當前發生中斷指令之指令暫存器位置
			input	[31:0] id2intctl_status; // CP0 Registers- Status [15:10]，中斷遮罩，CP0 Registers- Status [0]控制使否啟用外部設備的中斷
			
			output 	[31:0] intctl_epc; // 備份當前執行中斷指令之指令暫存器位置
			output 	[31:0] intctl_cause; // 紀錄哪個設備發生中斷之暫存器
			output 	[31:0] intctl_status;// 紀錄與控制CPU中斷發生之狀態
			output  iack;
			
			reg   	[31:0]	intctl_epc;
			reg   	[31:0]	intctl_cause;
			reg		[31:0]	intctl_status;

			wire    [31:0]	if_pc;
			wire    [31:0]	mem_pc;
			reg				iack;
			
		
		always@(negedge clk or negedge rst_n)
        begin
			//// 當rst_n為非真時，重置暫存器為0	
			if(~rst_n)							
					begin
					iack<=1'b0;
					intctl_epc <= 32'd0;		
					intctl_status<=	32'd0;				
					intctl_cause <= 32'd0;
					end
			//當外部設備中斷發生時，先備份當前指令暫存器位置，
			//接著禁用其他設備之中斷請求，根據目前發生中斷設備(intctl_cause)，發起iack對目前發起中斷之設備進行中斷服務。		
			else if( ((irq[5]&id2intctl_status[15])|(irq[4]&id2intctl_status[14])|(irq[3]&id2intctl_status[13])
					|(irq[2]&id2intctl_status[12])|(irq[1]&id2intctl_status[11])|(irq[0]&id2intctl_status[10])) & id2intctl_status[0] )
					begin
					intctl_epc <= mem_pc ;		
					intctl_status<=	{id2intctl_status[31:1],1'b0};				//disable interrupt
					intctl_cause <= {16'b0,irq,10'b0};
					iack <= 1'b1;
					end
			else   
					begin
						// 當CPU被中斷時，CPU跳轉到0x0001000，執行中斷程序。
						if(if_pc == 32'h00001000)
							begin
							iack <= 1'b0;
							end
						else  intctl_epc <= intctl_epc;
					end
		end
endmodule
