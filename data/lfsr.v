module lfsr (
  input clk,
  input rstn,
  input en,
  output reg [127:0] q
);

  reg [127:0] next_q;

  always @(posedge clk) begin
    if (!rstn) begin
      q <= {128{1'b1}}; // Инициализация
    end else if (!en) begin
      next_q = q << 1;
      next_q[0] = q[127] ^ q[126] ^ q[125] ^ q[120]; // Обратная связь согласно полиному степени 168
      q <= next_q;
    end
  end

endmodule