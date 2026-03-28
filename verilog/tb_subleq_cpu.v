module tb_subleq_cpu;
	reg clock = 1;
	reg reset = 1;

	wire [15:0] data_cpu_to_mem;
	wire [15:0] data_mem_to_cpu;
	wire write_enable;

	always #1 clock = ~clock;

	subleq_cpu cpu (
		.clock(clock),
		.reset(reset),
		.data_in(data_mem_to_cpu),
		.data_out(data_cpu_to_mem),
		.write_enable(write_enable)
	);

	memory mem (
		.clock(clock),
		.reset(reset),
		.data_in(data_cpu_to_mem),
		.data_out(data_mem_to_cpu),
		.write_enable(write_enable)
	);

	initial begin
		$readmemh("main.hex", mem.mem);
		$dumpfile("wave.vcd");
		$dumpvars(0, tb_subleq_cpu);

		#5 reset = 0;

		#5000 $finish;
	end

	always @(posedge clock) begin
/*
		$display("t=%0t | PC=%h | A=%h | B=%h | C=%h | [A]=%h | [B]=%h",
			$time,
			cpu.pc,
			cpu.regA,
			cpu.regB,
			cpu.regC,
			cpu.valA,
			cpu.valB
		);
		$display("t=%0t | WE=%b | CPU->MEM=%h | MEM->CPU=%h",
			$time,
			write_enable,
			data_cpu_to_mem,
			data_mem_to_cpu
		);
*/
	end

	integer cycle = 0;

	always @(posedge clock) begin
		cycle = cycle + 1;
		if (cycle == 6*16) begin
			$display("Fib: %0d", mem.mem[45]);
			cycle = 0;
		end
	end
endmodule
