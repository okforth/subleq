module memory (
	input wire clk,
	input wire write,
	input wire [15:0] addr,
	input wire [15:0] data_in,
	output reg [15:0] data_out
);

	reg [15:0] mem [0:65535];

	always @(posedge clk) begin
		if (write) mem[addr] <= data_in;

		data_out <= mem[addr];
	end

endmodule
