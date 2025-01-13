module cla_checker_pipelined #(
  parameter w = 128
)
(
  input 	rstn,
  input 	clk,
  input 	en,
  output reg error
);
  (* KEEP="TRUE" *)(* DONT_TOUCH="TRUE" *) wire [w-1:0] counter0;
  (* KEEP="TRUE" *)(* DONT_TOUCH="TRUE" *) wire [w-1:0] counter1;
  (* KEEP="TRUE" *)(* DONT_TOUCH="TRUE" *) wire[w-1:0] sum;
  wire error_comb;
  wire sum_valid;
  //LFSR     
  lfsr lfsr_inst(.clk(clk),.rstn(rstn),.en(en),.q(counter0));
  assign counter1 = ~counter0;
  assign error_comb = sum_valid & (sum != {w{1'b1}});

  //   
  pipelined_adder #(
		.w(128),       //  
		.s(4)          //   
  ) pipelined_adder_inst (
		.clk(clk),
		.rstn(rstn),
		.op1(counter0),
		.op2(counter1),
		.valid_op1(~en),
		.valid_op2(~en),
		.res(sum),
		.valid(sum_valid)
  );

  always @(posedge clk) begin
		if (!rstn) begin
		  error <= 1'b0;
		end
		else if (error_comb) begin
		  error <= 1'b1;
		end
  end

  wire[35:0] control0; 
  icon icon_inst (
	  .CONTROL0(control0) 	// INOUT BUS [35:0]
  );

  ila ila_inst (
	   .CONTROL(control0),  // INOUT BUS [35:0]
	   .CLK(clk), 			    // IN
	   .TRIG0(counter0), 	  // IN BUS [127:0]
	   .TRIG1(counter1), 	  // IN BUS [127:0]
	   .TRIG2(sum), 		    // IN BUS [127:0]
	   .TRIG3(error_comb),	// IN BUS [0:0]
	   .TRIG4(error) 		    // IN BUS [0:0]
  );
	
endmodule
