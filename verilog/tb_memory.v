`timescale 1ns/1ps

module tb_memory;
	reg clk;
	reg write;
	reg [15:0] addr;
	reg [15:0] data_in;
	wire [15:0] data_out;

	memory uut (
		.clk(clk),
		.write(write),
		.addr(addr),
		.data_in(data_in),
		.data_out(data_out)
	 );

	// clock generation (10ns period)
	always #5 clk = ~clk;

	task write_test(input [15:0] a, input [15:0] x);
	begin
		write = 1;
		addr = a;
		data_in = x;
		$display("[%h] <= %h", addr, data_in);
		@(posedge clk);
	end
	endtask

	task read_test(input [15:0] a);
	begin
		write = 0;
		addr = a;
		@(posedge clk);
		@(posedge clk);
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
