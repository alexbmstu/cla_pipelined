module cla_pipelined #(
    parameter w = 128,
    parameter s = 4  //   
) (
    input clk,
    input rstn,
    input [w-1:0] op1,
    input [w-1:0] op2,
    input valid_op1,
    input valid_op2,
    output reg [w-1:0] res,
    output reg valid  //     
);

  reg [w-1:0] stage_reg[0:s-1];
  wire [w-1:0] stage_comb[0:s-1];
  reg [w-1:0] stage_op1[0:s-1];
  reg [w-1:0] stage_op2[0:s-1];
  reg valid_reg[0:s-1];
  reg c_reg[0:s-1];
  wire c_comb[0:s-1];
  wire f[0:s-1];
  integer i, j;
  genvar k;

  initial begin
    for (i = 0; i < s; i = i + 1) begin
      stage_reg[i] <= {w{1'b0}};
      valid_reg[i] <= 1'b0;
      stage_op1[i] <= {w{1'b0}};
      stage_op2[i] <= {w{1'b0}};
      res <= {w{1'b0}};
    end
  end

  // Начальное слово состояния конвейера
  assign {c_comb[0], stage_comb[0][0*w/s+:w/s]} = {1'b0, op1[0*w/s+:w/s]} + {1'b0, op2[0*w/s+:w/s]};
  generate
    for (k = 1; k < s; k = k + 1) begin : adder
      assign {c_comb[k],stage_comb[k][k*w/s+:w/s],f[k]} = {1'b0,stage_op1[k-1][k*w/s+:w/s],c_reg[k-1]} + {1'b0,stage_op2[k-1][k*w/s+:w/s],c_reg[k-1]};
    end
  endgenerate

  always @(posedge clk) begin
    if (~rstn) begin
      res   <= {w{1'b0}};
      valid <= 1'b0;
      for (i = 0; i < s; i = i + 1) begin
        stage_reg[i] <= {w{1'b0}};
        valid_reg[i] <= 1'b0;
        stage_op1[i] <= {w{1'b0}};
        stage_op2[i] <= {w{1'b0}};
        c_reg[i] <= 1'b0;
      end
    end else begin

      //Входной порт конвейера
      valid_reg[0] <= valid_op1 & valid_op2;                  // Сигнал валидности операндов  
      stage_reg[0][0*w/s+:w/s] <= stage_comb[0][0*w/s+:w/s];  // Начальное слово состояния конвейера
      c_reg[0] <= c_comb[0];  //Сигнал переноса в старший разряд
      stage_op1[0] <= op1;  // Операнд 1 
      stage_op2[0] <= op2;  // Операнд 2
      //Стадии конвейера 1..(s-1)
      for (i = 1; i < s; i = i + 1) begin
        for (j = 1; j < s; j = j + 1) begin
          if (valid_reg[i-1] && i == j) begin
            stage_reg[i][j*w/s+:w/s] <= stage_comb[i][j*w/s+:w/s];
          end else begin
            stage_reg[i][j*w/s+:w/s] <= stage_reg[i-1][j*w/s+:w/s];
          end
          stage_op1[i] <= stage_op1[i-1];
          stage_op2[i] <= stage_op2[i-1];
          valid_reg[i] <= valid_reg[i-1];
        end
        c_reg[i] <= c_comb[i];
      end
      res   <= stage_reg[s-1];
      valid <= valid_reg[s-1];  //   
    end
  end

endmodule
