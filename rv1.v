// 1)实现上述总线同步握手场景，不考虑异步场景
module rv1 #(parameter wd = 4)(
	input rst, clk,
	input m_valid,
	input s_ready,
	input [wd-1:0] data_in,
	output reg [wd-1:0] data_out 
);
	
	always @(posedge clk) begin
		if (rst) data_out <= 0;
		else if (m_valid && s_ready) //当m_valid和s_ready同时有效时，完成信号传输
			data_out <= data_in;
		else data_out <= data_out;
	end

endmodule