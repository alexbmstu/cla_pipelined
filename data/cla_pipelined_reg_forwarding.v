module cla_pipelined #(
    parameter w = 128,
    parameter s = 4  // Количество этапов конвейера
) (
    input clk,
    input rstn,
    input [w-1:0] op1,
    input [w-1:0] op2,
    input valid_op1,
    input valid_op2,
    output reg [w-1:0] res,
    output reg valid // Указывает на наличие валидного результата
);

  (* retiming_forward = 1 *) reg [w-1:0] stage_reg[0:s-1];
  reg valid_reg[0:s-1];

  always @(posedge clk) begin
    if (~rstn) begin
      res   <= {w{1'b0}};
      valid <= 1'b0;
      for (integer i = 0; i < s; i = i + 1) begin
        stage_reg[i] <= {w{1'b0}};
        valid_reg[i] <= 1'b0;
      end
    end else begin
      valid_reg[0] <= valid_op1 & valid_op2; // Оба операнда должны быть валидными

      if (valid_reg[0]) begin
        stage_reg[0] <= op1 + op2;  // Первый этап: сложение
      end else begin
        stage_reg[0] <= {w{1'b0}}; // Очистка этапа, если невалидный вход
      end

      for (integer i = 1; i < s; i = i + 1) begin
        valid_reg[i] <= valid_reg[i-1]; // Распространение сигнала валидности
        stage_reg[i] <= stage_reg[i-1]; // Сдвиг данных через этапы конвейера
      end

      res <= stage_reg[s-1];
      valid <= valid_reg[s-1]; // Валидный результат только если входные данные были валидными на всех этапах конвейера
    end
  end

endmodule
