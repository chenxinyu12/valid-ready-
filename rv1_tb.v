module rv1_tb #(parameter wd = 4);
	reg m_valid, s_ready, rst, clk;
	reg [wd-1:0] data_in;
	wire [wd-1:0] data_out;
	
	rv1 r1 (.m_valid(m_valid), .s_ready(s_ready), .rst(rst), 
	.clk(clk), .data_in(data_in), .data_out(data_out));
	
	always begin
		#2 clk = ~clk;
	end
	
	initial begin
		clk = 0;
		rst = 0;
		m_valid = 0;
		s_ready = 0;
		data_in = 0;
		
		#5 rst = 1; data_in = 5;
		#5 rst = 0;
		#5 m_valid = 1; //m_valid有效，s_ready无效，信号不传输
		#5 s_ready = 1; //m_valid有效，s_ready有效，信号传输
		#5 m_valid = 0; 
		#5 data_in = 15; //m_valid无效，s_ready有效，信号不传输
		#5 m_valid = 1; //m_valid有效，s_ready有效，信号传输
		#5 s_ready = 0; 
		#5 data_in = 10; //m_valid有效，s_ready无效，信号不传输
		#5 s_ready = 1; //m_valid有效，s_ready有效，信号传输
		#10 $stop;
	end



endmodule
