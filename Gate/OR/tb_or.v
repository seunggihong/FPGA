`timescale 1ns/100ps

module tb_or;
	reg x1, x2;
	wire y;

	or target(x1, x2, y)

	initial begin
		#1 x1 = 0; x2 = 0;
		#1 x2 = 1;
		#1 x1 = 1; x2 = 0;
		#1 x2 = 1;
	end
endmodule