module tb_cpu;

reg clock = 0;
reg reset = 1;

cpu uut (
	.clock(clock),
	.reset(reset)
);

always #5 clock = ~clock;

initial begin
	$dumpfile("wave.vcd");
	$dumpvars(0, tb_cpu);

	// initializing memory manually
	uut.memory[0] = 3;
	uut.memory[1] = 4;
	uut.memory[2] = 6;
	uut.memory[3] = 7;
	uut.memory[4] = 7;
	uut.memory[5] = 7;
	uut.memory[6] = 3;
	uut.memory[7] = 4;
	uut.memory[8] = 0;

	#20 reset = 0;

	#1000 $finish;
end

always @(posedge clock) begin
	$display("t=%0t | PC=%0d | A=%0d | B=%0d | C=%0d | [A]=%0d | [B]=%0d",
		$time,
		uut.pc,
		$signed(uut.A),
		$signed(uut.B),
		$signed(uut.C),
		$signed(uut.valA),
		$signed(uut.valB)
	);
end

endmodule
