
module rv4 #(parameter wd = 4)(
	input clk, rst,
	input [wd-1:0] datain,
	input datain_val,
	output datain_rdy, 
	input dataout_rdy, 
	output dataout_val,
	output [wd-1:0] dataout 
);

	//rv2部分
	reg [wd-1:0] data_pipe;
	reg datapipe_rdy;
	reg datapipe_val;
	
	assign datain_rdy = datapipe_rdy || !datapipe_val; //当slave端信号为高，或者pipe为空时（vo=0），master端接收到ready为高信号
	
	always @(posedge clk) begin
		if (rst) begin
			datapipe_val <= 0;
			data_pipe <= 0;
		end
		else begin
			datapipe_val <= (datain_rdy) ? datain_val : datapipe_val; //ro信号为高，则将vi寄存于pipe（vo），否则vo保持不变
			data_pipe <= (datain_rdy && datain_val) ? datain : data_pipe;
		end
	end
	
	
	//rv3部分
	wire store_data; 
	reg [wd-1:0] buffered_data;
	reg buffer_valid;

	assign store_data = datapipe_val && datapipe_rdy && ~dataout_rdy; //当dataout_rdy=0, datain_rdy=1, datain_val=1时，寄存器会暂存一级数据
	always @(posedge clk)
		if (rst)  buffer_valid <= 1'b0;
		else buffer_valid <= buffer_valid ? ~dataout_rdy: store_data; //当datain_rdy=1时，由于上一个时钟周期将buffer排空，所以buffer为空

	always @(posedge clk)
		if (rst)  buffered_data <= 0;
	else      buffered_data <= store_data ? data_pipe : buffered_data;

	always @(posedge clk) begin
		if (rst)  datapipe_rdy <= 1'b1; 
		else datapipe_rdy <= dataout_rdy || ((~buffer_valid) && (~store_data)); //消除气泡
	end

	assign dataout_val = datapipe_rdy? datapipe_val : buffer_valid;
	assign dataout  = datapipe_rdy? data_pipe : buffered_data;



endmodule
