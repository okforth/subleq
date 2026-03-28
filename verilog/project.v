module tt_um_okforth_subleq (
	input  wire [7:0] ui_in,	// Dedicated inputs
	output wire [7:0] uo_out,	// Dedicated outputs
	input  wire [7:0] uio_in,	// IOs: Input path
	output wire [7:0] uio_out,	// IOs: Output path
	output wire [7:0] uio_oe,	// IOs: Enable path (active high: 0=input, 1=output)
	input  wire       ena,		// will go high when the design is enabled
	input  wire       clk,		// clock
	input  wire       rst_n		// reset_n - low to reset
);

	wire        write_enable;
	wire [14:0] data_in;
	wire [14:0] data_out;

	assign data_in[14:8] =  ui_in[6:0]	// upper 7 bits
	assign data_in[7:0]  = uio_in[7:0]	// lower 8 bits
	// ui_in[7] is unused

	assign  uo_out[6:0] = data_out[14:8];	// upper 7 bits
	assign uio_out[7:0] = data_out[7:0];	// lower 8 bits
	assign  uo_out[7]   = write_enable;

	assign uio_oe = out_enable ? 8'hFF : 8'h00;

	subleq_cpu cpu(
		.clock(clk),
		.reset(~rst_n),
		.data_in(data_in),
		.data_out(data_out)
		.write_enable(write_enable),
		.out_enable(out_enable),
	);

endmodule
