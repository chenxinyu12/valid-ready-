//3)假定slave的ready信号不满足时序要求，要对ready信号用寄存器打一拍，实现该总线握手场景；
module rv3_2 #(parameter wd = 4)       
	(
    input clk,
    input rst,
    input datain_val,
    output reg datain_rdy,
    input [wd-1:0] datain,
    output dataout_val,
    input dataout_rdy,
    output [wd-1:0] dataout
    );

//设定一级寄存器buffer.
wire store_data; 
reg [wd-1:0] buffered_data;
reg buffer_valid;

assign store_data = datain_val && datain_rdy && ~dataout_rdy; //当dataout_rdy=0, datain_rdy=1, datain_val=1时，寄存器会暂存一级数据
always @(posedge clk)
	if (rst)  buffer_valid <= 1'b0;
	else      buffer_valid <= buffer_valid ? ~dataout_rdy: store_data; //当datain_rdy=1时，由于上一个时钟周期将buffer排空，所以buffer为空

always @(posedge clk)
	if (rst)  buffered_data <= 0;
	else      buffered_data <= store_data ? datain : buffered_data;

always @(posedge clk) begin
	if (rst)  datain_rdy <= 1'b1; 
	else datain_rdy <= dataout_rdy || ((~buffer_valid) && (~store_data)); //消除气泡
	end

assign dataout_val = datain_rdy? datain_val : buffer_valid;
assign dataout  = datain_rdy? datain : buffered_data;

endmodule
