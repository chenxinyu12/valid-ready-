module rv4_tb #(parameter wd = 4);
	reg clk;
	reg rst;
	reg datain_val, dataout_rdy;
	wire datain_rdy;
	wire dataout_val;
	reg [wd-1:0] datain;
	wire [wd-1:0] dataout; 
	
	
	
	rv4 r4 (.datain_val(datain_val), .dataout_rdy(dataout_rdy), .rst(rst), .clk(clk), 
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
