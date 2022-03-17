//2)假定master的valid信号不满足时序要求，要对valid信号用寄存器打一拍，实现该总线握手场景。
//思路：插入一级pipe，时钟沿到来将valid信号和data数据寄存于pipe，下一个时钟沿由slave取出pipe中数据。
//为避免bubble，当ready信号为低，且pipe为空时，将数据先寄存于pipe级寄存器。
//根据上述描述，基本逻辑代码如下：
//ro <= ri || !vo; //当slave端信号为高，或者pipe为空时（vo=0），master端接收到ready为高信号
//vo <= (ro) ? vi : vo; //ro信号为高，则将vi寄存于pipe（vo），否则vo保持不变
//do <= (ro && vi) ? di : do; //ro信号为高，则将di寄存于pipe（do），否则do保持不变

module rv2 #(parameter wd = 4)(
	input clk, rst,
	input [wd-1:0] datain,
	input datain_val,
	output datain_rdy, 
	input dataout_rdy, 
	output reg dataout_val,
	output reg [wd-1:0] dataout 
);

	assign datain_rdy = dataout_rdy || !dataout_val; //当slave端信号为高，或者pipe为空时（vo=0），master端接收到ready为高信号
	
	always @(posedge clk) begin
		if (rst) begin
			dataout_val <= 0;
			dataout <= 0;
		end
		else begin
			dataout_val <= (datain_rdy) ? datain_val : dataout_val; //ro信号为高，则将vi寄存于pipe（vo），否则vo保持不变
			dataout <= (datain_rdy && datain_val) ? datain : dataout;
		end
	end


endmodule