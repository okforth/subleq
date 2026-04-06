module tt_memory (
	input wire clock,
	input wire reset,
	input wire read_latch,
	input wire write_latch,
	input wire [7:0] data_in,
	output reg [7:0] data_out
);

	reg [15:0] memory [0:65535];
	reg [15:0] address, value;
	reg [1:0] read_state, write_state;

	always @(posedge clock) begin
		if (reset) begin
			$display("Reset mode active!");
			read_state <= 0;
			write_state <= 0;
		end else begin
			if (read_latch) begin
				address[7:0] <= data_in;
				read_state <= 1;
			end

			else if (read_state) begin
				case (read_state)
					1: begin
						address[15:8] = data_in;
						value <= memory[address];
						read_state <= 2;
					end
					2: begin
						data_out <= value[7:0];
						read_state <= 3;
					end
					3: begin
						data_out <= value[15:8];
						read_state <= 0;
					end
				endcase
			end

			else if (write_latch) begin
				address[7:0] <= data_in;
				write_state <= 1;
			end

			else if (write_state) begin
				case (write_state)
					1: begin
						address[15:8] <= data_in;
						write_state <= 2;
					end
					2: begin
						value[7:0] <= data_in;
						write_state <= 3;
					end
					3: begin
						value[15:8] = data_in;
						memory[address] <= value;
						write_state <= 0;
					end
				endcase
			end
		end
	end

endmodule
