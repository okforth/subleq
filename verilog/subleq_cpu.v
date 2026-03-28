module subleq_cpu (
	input wire clock,
	input wire reset,
	input wire [15:0] data_in,
	output reg [15:0] data_out,
	output reg write_enable
);

reg [15:0] pc, regA, regB, regC, valA, valB;

reg [2:0] state;

always @(posedge clock) begin
	if (reset) begin
		pc <= 0;
		state <= 0;
	end else begin
		case (state)
			0: begin
				write_enable <= 0;
				data_out <= pc;
				state <= 1;
			end
			1: begin
				regA <= data_in;
				data_out <= pc + 1;
				state <= 2;
			end
			2: begin
				regB <= data_in;
				data_out <= pc + 2;
				state <= 3;
			end
			3: begin
				regC <= data_in;
				data_out <= regA;
				state <= 4;
			end
			4: begin
				valA <= data_in;
				data_out <= regB;
				state <= 5;
			end
			5: begin
				valB = data_in - valA;
				pc <= (valB <= 0) ? regC : pc + 3;
				write_enable <= 1;
				data_out <= regB;
				state <= 6;
			end
			6: begin
				data_out <= valB;
				state <= 0;
			end
		endcase
	end
end

endmodule
