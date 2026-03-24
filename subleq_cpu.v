module subleq_cpu (
	input wire clk,
	input wire reset
	input wire [15:0] data_in	// data to read
	output reg [15:0] data_out	// data to write
	output reg [15:0] addr		// addr of write
	output reg write		// write enable
);

reg [15:0] pc;
reg [15:0] regA, regB, regC;
reg [15:0] valA, valB;
reg [15:0] result;

reg [2:0] state;

localparam DISABLE = 0, ENABLE = 1;

always @(posedge clk or posedge reset) begin
	if (reset) begin
		pc <= 0;
		state <= 0;
	end else begin
		case (state)
			0: begin
				write <= DISABLE;
				addr <= pc;
				state <= 1;
			end

			1: begin
				regA <= data_in;
				addr <= pc + 1;
				state <= 2;
			end

			2: begin
				regB <= data_in;
				addr <= pc + 2;
				state <= 3;
			end

			3: begin
				regC <= data_in;
				addr <= regA;
				state <= 4;
			end

			4: begin
				valA <= data_in;
				addr <= regB;
				state <= 5;
			end

			5: begin
				valB = data_in;
				result = valB - valA;
				data_out <= result;
				write <= ENABLE;
				pc <= ($signed(result) <= 0) ? regC : pc + 3;
				state <= 0;
			end
		endcase
	end
end

endmodule
