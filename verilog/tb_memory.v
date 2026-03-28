`timescale 1ns/1ps

module tb_memory;
	reg clock;
	reg write_enable;
	reg [15:0] data_in;
	wire [15:0] data_out;

	memory uut (
		.clock(clock),
		.write_enable(write_enable),
		.data_in(data_in),
		.data_out(data_out)
	 );

	// clock generation (10ns period)
	always #5 clk = ~clk;

	task write_test(input [15:0] addr, input [15:0] data);
	begin
		write = 1;
		data_in = addr;
		@(posedge clock);
		data_in = data;
		@(posedge clock);
		$display("[%h] <= %h", addr, data);
	end
	endtask

	task read_test(input [15:0] addr);
	begin
		write = 0;
		data_in = addr;
		@(posedge clock);
		@(posedge clock);
		$display("[%h] => %h", addr, data_out);
	end
	endtask

	initial begin
		$readmemh("main.hex", uut.mem);
		$dumpfile("dump.vcd");
		$dumpvars(0, tb_memory);
	end

	integer i;

	initial begin
		clk = 0;

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
