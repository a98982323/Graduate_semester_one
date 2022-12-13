`define ADDRWIDTH 32
`define DATAWIDTH 32
`define TAGWIDTH  22
`define IndexWidth 	8		// The number of bits for Index
`define Entry	   	256		// The number of entries for Cache	
`define Valid 1

`include "timescale.v"



module I_Cache (clk,rst_n, CSn, ADDR, DO, data_in, IADDR, IREQ, cache_stall_n);

	input				clk;		// System clock
	input				rst_n;		// Reset Signal
	// signals between CPU and Cache
	input				CSn;		// chip enable
	input  [31:0]		ADDR;		// read address	form CPU [31:0]=32bits
	output [31:0]		DO;			// data output
	output				cache_stall_n;	// stall signal to CPU (0 => stall)

	// signals between Main_Memory and Cache
	input [127:0]		data_in;	// IDBUS from Main_Memory (new data)
	output [31:0]		IADDR;		// address to Main Memory
	output				IREQ;		// access to Main Memory
	
	// Internal signals
	reg		[31:0]		DO_reg;
	reg					write;			// signal for data refill
	reg					stall_n;		// signal for stall
	reg					output_enable;	// signal for output data (DO)
	reg					Enable;			// Cache Enable ( based on CSn)
	// signals in Cache and CacheRam
	
	wire					Cache_Hit;			// Cache Hit
	
	wire [`IndexWidth-1:0]	index;				// Number of index
	wire [31:0]				Data_in;			// data into CacheRam  (128-bit)
	wire [31:0]				data_out;			// data out CacheRam   (32-bit)
	wire [`TAGWIDTH-1:0]	tag_in;				// tag_in  from the CPU
	wire [`TAGWIDTH-1:0]	tag_out;			// tag_out from the CacheRam
	wire					valid_in;			// Valid_in form the CPU
	wire					valid_out;			// Valid_out form the CacheRam


	reg [0:0]				Cache_Valid [0:`Entry-1];	// Registers for Valid Bit
	reg [`TAGWIDTH-1:0]		Cache_Tag	[0:`Entry-1];	// Registers for Tag
	reg [31:0]				Cache_Data 	[0:`Entry-1];	// Registers for Data

	integer i;
	
	// signals for finate state machine
	parameter 			Hit  		= 2'b00;
	parameter			Miss 		= 2'b01;
	parameter			Miss_Ready	= 2'b10;
	parameter			Reset		= 2'b11;
	
	reg	[1:0]			current_state, next_state;
	
	
//--------------------------------------------------------------------------------------------------------------
// ======================================== Begining of main code ==============================================
//--------------------------------------------------------------------------------------------------------------
	assign	Data_in = 	data_in[31:0];
	// Devide the address into each signals
	assign	IADDR 	= ADDR			 	;	// pass ADDR to memory (use IREQ signal to control) 
	assign 	index	= ADDR[9:2]					;	// get the index(Number) from ADDR
	assign	tag_in	= ADDR[31:10]				;	// get the tag  (Number) from ADDR
	assign	valid_in=   1'b1;				// set the valid in as 1
	
	// Signals about HIT and MISS
	assign 	Cache_Hit 	= ((tag_in == tag_out) & valid_out)	? 1 : 0			;	// check valid first, and compare tag 
	assign	IREQ 		= (Cache_Hit) ? 0 : 1				; 	// if (CacheEnable & Miss) ask data form Memory
	assign	DO 			= (output_enable)?DO_reg:32'bz;

	// Signals for Cache to Compare Hit or Miss
	assign data_out		= 	Cache_Data[index]		;		// Data from CacheRam
	assign tag_out   	= 	Cache_Tag[index]		;		// Tag from CacheRam
	assign valid_out 	= 	Cache_Valid[index]	;		// Valid from CacheRam

	
	assign cache_stall_n = stall_n;					// stall signal when Cache Miss happen
	always@(posedge clk)
	begin
		DO_reg = data_out;							// Set up the Output Data
		current_state = (!Enable)? Hit: next_state;
	end
	
	// Finate State Machine
	always@(*)
	begin
		case(current_state)
			Hit:			next_state = (Enable==1 && Cache_Hit==0)? Miss:Hit;
			Miss:			next_state = Miss_Ready;
			Miss_Ready:		next_state = Hit;
			Reset:			next_state = Hit;
			default:		next_state = Hit;
		endcase
	end
	
	always@(current_state)
	begin
		case(current_state)
			Miss:
			begin
				write = 0;
				stall_n = 0;
				output_enable = 0;
			end
			Miss_Ready:
			begin
				write = 1;
				stall_n = 0;
				output_enable = 0;
			end
			default:
			begin
				write = 0;
				stall_n = 1;
				output_enable = 1;
			end			
		endcase
	end
	
	
	// Fill data from Memory into Cache
	always@(negedge clk)
	begin
		Enable  = CSn;
		if(write)
		begin	
			#1 Cache_Data[index] 	 = Data_in;			// Refill Data
			#1 Cache_Tag[index]  	 = tag_in;			// Refill Tag
			#1 Cache_Valid[index]	 = valid_in;		// Refill Valid
		end
		
		if(!rst_n)
		begin
			for(i=0;i<`Entry;i=i+1)
			begin
				Cache_Valid[i]=0;
			end
		end
	end


endmodule