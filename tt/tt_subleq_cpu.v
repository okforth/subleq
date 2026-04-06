module tt_okforth_subleq_cpu (
	input  wire [7:0] ui_in,	// Dedicated inputs
	output wire [7:0] uo_out,	// Dedicated outputs
	input  wire [7:0] uio_in,	// IOs: Input path
	output wire [7:0] uio_out,	// IOs: Output path
	output wire [7:0] uio_oe,	// IOs: Enable path (active high: 0=input, 1=output)
	input  wire       ena,		// will go high when the design is enabled
	input  wire       clk,		// clock
	input  wire       rst_n		// reset_n - low to reset
);

	wire clock;
	wire reset;
wire [7:0] data_in; reg [7:0] data_out;
	reg read_latch;
	reg write_latch;

	assign clock = clk;
	assign reset = ~rst_n;
	assign data_in = ui_in;
	assign uo_out = data_out;

	assign uio_oe = 8'hFF;			// set all uio pins as output
	assign uio_out[0] = read_latch;
	assign uio_out[1] = write_latch;
	assign uio_out[2] = clock;
	assign uio_out[3] = reset;

	reg [15:0] pc, regA, regB, regC, valA, valB, diff;

	reg [4:0] state;

	always @(posedge clock) begin
		if (reset) begin
			pc <= 0;
			state <= 0;
			read_latch <= 0;
			write_latch <= 0;
		end else begin
			case (state)
				0: begin
					read_latch <= 1;
					data_out <= pc[7:0];
					state <= 1;
				end
				1: begin
					read_latch <= 0;
					data_out <= pc[15:8];
					state <= 2;
				end
				2: begin
					pc <= pc + 1;
					state <= 3;
				end
				3: begin
					state <= 4;
				end
				4: begin
					regA[7:0] <= data_in;
					state <= 5;
				end
				5: begin
					regA[15:8] <= data_in;

					read_latch <= 1;
					data_out <= pc[7:0];
					state <= 6;
				end
				6: begin
					read_latch <= 0;
					data_out <= pc[15:8];
					state <= 7;
				end
				7: begin
					pc <= pc + 1;
					state <= 8;
				end
				8: begin
					state <= 9;
				end
				9: begin
					regB[7:0] <= data_in;
					state <= 10;
				end
				10: begin
					regB[15:8] <= data_in;

					read_latch <= 1;
					data_out <= pc[7:0];
					state <= 11;
				end
				11: begin
					read_latch <= 0;
					data_out <= pc[15:8];
					state <= 12;
				end
				12: begin
					pc <= pc + 1;
					state <= 13;
				end
				13: begin
					state <= 14;
				end
				14: begin
					regC[7:0] <= data_in;
					state <= 15;
				end
				15: begin
					regC[15:8] <= data_in;

					read_latch <= 1;
					data_out <= regA[7:0];
					state <= 16;
				end
				16: begin
					read_latch <= 0;
					data_out <= regA[15:8];
					state <= 17;
				end
				17: begin
					state <= 18;
				end
				18: begin
					state <= 19;
				end
				19: begin
					valA[7:0] <= data_in;
					state <= 20;
				end
				20: begin
					valA[15:8] <= data_in;

					read_latch <= 1;
					data_out <= regB[7:0];
					state <= 21;
				end
				21: begin
					read_latch <= 0;
					data_out <= regB[15:8];
					state <= 22;
				end
				22: begin
					state <= 23;
				end
				23: begin
					state <= 24;
				end
				24: begin
					valB[7:0] <= data_in;
					state <= 25;
				end
				25: begin
					valB[15:8] <= data_in;

					write_latch <= 1;
					data_out <= regB[7:0];
					state <= 26;
				end
				26: begin
					diff <= valB - valA;

					write_latch <= 0;
					data_out <= regB[15:8];
					state <= 27;
				end
				27: begin
					pc <= (diff <= 0) ? regC : pc;

					data_out <= diff[7:0];
					state <= 28;
				end
				28: begin
					data_out <= diff[15:8];
					state <= 0;
				end
			endcase
		end
	end

endmodule
