`timescale 1ns/100ps
module test();

	/**
	* This is our testbench for the top_level module by sending a value to the
	* spart. The driver should send the same data back, which can be displayed
	* through the waveform.
	*/
	reg clk, rst, rxd;
	wire txd;
	integer i;
	top_level iTOP(.clk(clk),.rst(rst),.txd(txd),.rxd(rxd),.br_cfg(2'b00));

	initial
	begin
		clk = 1;
		forever #5 clk=~clk;
	end

	initial
	begin
		rst =1;
		#30 rst =0;
	end
reg [7:0] value;
	initial begin
	//set data to be sent
	value = 8'ha6;
	rxd = 1;
	#100;
	// send start bit
	rxd = 0;
	#320;
	// send data bit
	for(i = 0; i < 8; i=i+1) begin
		rxd = value[i];
		#320;
	end
	// send stop bit
	rxd = 1;
	end

	initial
		#8000 $stop;
endmodule
