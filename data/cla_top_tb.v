`timescale 1ns / 1ps

module cla_top_tb;

	// Inputs
	reg clk;
	reg rst;

	// Outputs
	wire error;
	wire locked;

	// Instantiate the Unit Under Test (UUT)
	cla_top uut (
		.rst(rst),
		.user_clk(clk),
		.en(1'b0),
		.error(error),
		.locked(locked)
	);

	initial begin
		// Initialize Inputs
		clk = 1'b0;
		rst = 1'b1;
		// Wait 100 ns for global reset to finish
		#100;
		rst = 1'b0;
		#10;
	end

   always #5 clk = ~clk;
      
endmodule

