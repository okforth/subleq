module memory (
	input wire clock,
	input wire reset,
	input wire write_enable,
	input wire [15:0] data_in,
	output reg [15:0] data_out
);

	reg [15:0] mem [0:65535];
	reg [15:0] addr;
	reg phase; // 0 = expect address, 1 = expect data

	always @(negedge clock) begin
		if (reset) begin
			phase <= 0;
		end else if (write_enable) begin
			case (phase)
				0: begin
					addr <= data_in;
					phase <= 1;
				end
				1: begin
					mem[addr] <= data_in;
					phase <= 0;
				end
			endcase
		end else begin
			data_out <= mem[data_in];
		end
	end

endmodule
