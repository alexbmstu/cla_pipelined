module cla_checker #(
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

 //LFSR счетчик и его обратный код
  lfsr lsfr_128(.clk(clk),.rstn(rstn),.en(en),.q(counter0));
  assign counter1 = ~counter0;
  assign #8 sum = counter0 + counter1;
  assign error_comb = (sum != {w{1'b1}});
  
  always @(posedge clk) begin
		if (!rstn) begin
		  error <= 1'b0;
		end
		else if (error_comb) begin
		  error <= 1'b1;
		end
  end

endmodule
