module rv2_tb #(parameter wd = 4);
	reg clk;
	reg rst;
	reg [wd-1:0] datain;
	reg datain_val;
	wire datain_rdy; 
	reg dataout_rdy; 
	wire dataout_val;
	wire [wd-1:0] dataout; 
	
	rv2 r2 (.datain_val(datain_val), .dataout_rdy(dataout_rdy), 
	.rst(rst), .clk(clk), .datain(datain), .dataout(dataout),
	.datain_rdy(datain_rdy), .dataout_val(dataout_val));
	
	always begin
		#2 clk = ~clk;
	end
	
	initial begin
		clk = 0;
		rst = 0;
		datain_val = 0;
		dataout_rdy = 0;
		datain = 0;
		
		#5 rst = 1; datain = 5;
		#5 rst = 0; //此时pipe为空，dataout_val=0，则datain_rdy为1
		#5 datain_val = 1; //master端可以发送数据，在下一个时钟沿将datain寄存于dataout
		
		#5 datain_val = 0; //由于datain寄存于dataout，master端认为slave端已获取数据，datain_val端可以归零
		#5 dataout_rdy = 1; //slave端可以接受数据，将pipe中数据取走，此时pipe可以寄存下一个数据dataout_val=0，但为了避免bubble，dataout保持不变
		#5 dataout_rdy = 0; //slave端接收数据后，停止接收数据
		
		#5 datain = 15; datain_val = 1;//master端发送数据，因为此时pipe可以寄存数据，由pipe寄存，dataout_val变为1
		#5 datain_val = 0; //后续分析过程与上类似
		#5 dataout_rdy = 1; 
		#5 dataout_rdy = 0; 
		
		#10 $stop;
	end



endmodule
