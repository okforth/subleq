`timescale 1ns/1ps

module tb_tt_memory;
	reg clock;
	reg reset;
	reg read_latch = 0;
	reg write_latch = 0;
	reg [7:0] data_in;
	wire [7:0] data_out;

	reg [15:0] val;

	tt_memory uut (
		.clock(clock),
		.reset(reset),
		.read_latch(read_latch),
		.write_latch(write_latch),
		.data_in(data_in),
		.data_out(data_out)
	 );

	always #1 clock = ~clock;

	task write_test(input [15:0] addr, input [15:0] data);
	begin
		write_latch = 1;
		data_in = addr[7:0];
		#2

		write_latch = 0;
		data_in = addr[15:8];
		#2

		data_in = data[7:0];
		#2

		data_in = data[15:8];
		#2

		$display("[%h] <= %h", addr, data);
	end
	endtask

	task read_test(input [15:0] addr);
	begin
		read_latch = 1;
		data_in = addr[7:0];
		#2

		read_latch = 0;
		data_in = addr[15:8];
		#2

		#2
		val[7:0] = data_out;

		#2
		val[15:8] = data_out;
		$display("[%h] => %h", addr, val);
	end
	endtask

	initial begin
		$readmemh("main.hex", uut.memory);
		$dumpfile("dump.vcd");
		$dumpvars(0, tb_tt_memory);
	end

	integer i;

	initial begin
		clock = 1;
		reset = 1;
		#2;
		reset = 0;

		for (i = 0; i < 50; i = i + 1) begin
			read_test(i);
		end

		write_test(16'h000A, 16'h1234);
		write_test(16'h000B, 16'hABCD);
		read_test(16'h000A);
		read_test(16'h000B);

		$finish;
	end
endmodule
