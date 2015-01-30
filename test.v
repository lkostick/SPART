`timescale 1ns/100ps
module test();

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
	value = 8'b11011100;
	rxd = 1;
	#100;
	rxd = 0;
	#320;
	for(i = 0; i < 8; i=i+1) begin
		rxd = value[i];
		#320;
	end
	rxd = 1;
	forever begin
		$display("txd =%b tbr =%b",txd, iTOP.tbr);
	#320;
end
	end

	initial
		#8000 $finish;
	initial
	begin
		//#1 $display("time =%6d, TxD=%b, RxD = %b, rda = %b, tbr = %b",$time,txd,rxd,iTOP.rda,iTOP.tbr);
		//forever #10 $display("time =%6d, TxD=%b, RxD = %b Enable = %b, Signal = %h Count = %h",$time,txd,rxd,iTOP.spart0.Enable, iTOP.spart0.iRECE.Signal_C,iTOP.spart0.iRECE.Counter);
	end
endmodule
