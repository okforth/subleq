module tb_tt_um_okforth_subleq;
	reg clock;
	reg reset;
	
	wire [7:0] data_cpu_to_mem, data_mem_to_cpu, signals;
	wire read_latch, write_latch;

	assign read_latch = signals[0];
	assign write_latch = signals[1];
	assign clock_signal = signals[2];
	assign reset_signal = signals[3];
	
	always #1 clock = ~clock;

	tt_um_okforth_subleq_cpu cpu (
		.clk(clock),
		.rst_n(reset),
		.ui_in(data_mem_to_cpu),
		.uo_out(data_cpu_to_mem),
		.uio_out(signals)
	);

	tt_memory mem (
		.clock(clock_signal),
		.reset(reset_signal),
		.read_latch(read_latch),
		.write_latch(write_latch),
		.data_in(data_cpu_to_mem),
		.data_out(data_mem_to_cpu)
	);

	initial begin
		$readmemh("main.hex", mem.memory);
		$dumpfile("dump.vcd");
		$dumpvars(0, tb_tt_okforth_subleq);

		clock = 1;
		reset = 0;

		#4;
		reset = 1;

		#10000 $finish;
	end

	always @(posedge clock) begin
		$display("t=%0t | PC=%h | A=%h | B=%h | C=%h | [A]=%h | [B]=%h | diff=%h",
			$time,
			cpu.pc,
			cpu.regA,
			cpu.regB,
			cpu.regC,
			cpu.valA,
			cpu.valB,
			cpu.diff
		);
		$display("t=%0t | RL=%b | WL=%b | CPU->MEM=%h | MEM->CPU=%h",
			$time,
			read_latch,
			write_latch,
			data_cpu_to_mem,
			data_mem_to_cpu
		);
		$display("fib: %d\n", mem.memory[45]);
	end
endmodule
