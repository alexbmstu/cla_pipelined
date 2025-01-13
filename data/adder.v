//  adder.v
module adder #(
  parameter w = 6
)
(
  input [w-1:0]	a,
  input [w-1:0]	b,
  output [w:0]  sum
);
  assign sum = a + b;
  
endmodule
