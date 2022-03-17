module rv3_tb #(parameter wd = 4);
	reg clk;
	reg rst;
	reg datain_val, dataout_rdy;
	wire datain_rdy;
	wire dataout_val;
	reg [wd-1:0] datain;
	wire [wd-1:0] dataout; 
	
	
	
	rv3_2 r3 (.datain_val(datain_val), .dataout_rdy(dataout_rdy), .rst(rst), .clk(clk), 
	.datain(datain), .dataout(dataout),.datain_rdy(datain_rdy), .dataout_val(dataout_val));
	
	always begin
		#2 clk = ~clk;
	end
	
	initial begin
		clk = 0;
		rst = 0;
		datain_val = 0;
		dataout_rdy = 0;
		datain = 0;
		
		#5 rst = 1;
		#5 rst = 0;
		#5 datain_val = 1; dataout_rdy = 1;
		#5 datain = 1;
		#5 datain = 2; 
		#5 datain = 3;
		#5 datain = 4;
		#5 datain = 5;
		#5 datain = 6;
		#5 datain = 7;
		#5 datain = 8; 
		
		#10 $stop;
	end

endmodule
	
	/*reg [wd-1:0]  m_data  ;
    reg           m_valid ;
    wire          m_ready ;
 
    wire [wd-1:0] s_data  ;
    wire          s_valid ;
    reg           s_ready ;

    reg clk;
    reg rst;
	
	rv3 r3 (.m_data(m_data), .m_valid(m_valid), .rst_n(rst), .clk(clk), .m_ready(m_ready), .s_data(s_data),.s_valid(s_valid), .s_ready(s_ready));
	
	always begin
		#2 clk = ~clk;
	end
	
	initial begin
		clk = 0;
		rst = 0;
		m_valid = 0;
		s_ready = 0;
		m_data = 0;
		
		#5 rst = 1; m_data = 5;
		#5 rst = 0;
		#5 m_valid = 1; 
		
		#5 s_ready = 1; 
		#5 s_ready = 0; 
		#5 s_ready = 1;
		
		#10 $stop;
	end

endmodule*/

//---------------------------------------
// File Name   : ready_flop.v
// Author      : Xiangzhi Meng
// Date        : 2020-06-06
// Version     : 0.1
// Description :
// 1. ready_flop using one buffer to hold data.
//
// All rights reserved.
