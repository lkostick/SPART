`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    21:53:21 01/29/2015 
// Design Name: 
// Module Name:    driver 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module driver(
    input clk,
    input rst,
    input [1:0] br_cfg,
    output reg iocs,
    output reg iorw,
    input rda,
    input tbr,
    output reg [1:0] ioaddr,
    inout [7:0] databus,
	 output reg [7:0] gpio_led
    );

	/**
	* Send the divisor to BAUD_Rate_Gen after rst, then stay in idle state
	*
	* When rda is set, store receive data into BUFFER and send it back.
	*
	* When rst is set, LED shows the dip switch
	* When rst is not set, LED shows the data in BUFFER
	*/
	reg [1:0] LOAD_COUNT;
	reg [7:0] BUFFER;
	reg [7:0] MY_ROM [0:7];
	initial $readmemh("numbers.mem", MY_ROM, 0, 7);
	reg flag;

	assign databus = (iorw) ? 8'hzz : BUFFER;

	always @(posedge clk)
	begin
		if (rst)
		begin
			LOAD_COUNT <= 2'b10;
			iocs <= 1'bx;
			iorw <= 1'bx;
			ioaddr <= 2'bx;
			flag <= 0;
			BUFFER <= 8'hxx;
		end
		// Send Divisor to BAUD_Rate_Gen
		else if (LOAD_COUNT != 2'b00)
		begin
			LOAD_COUNT <= LOAD_COUNT - 1;
			iorw <= 0;
			iocs <= 1;
			if (LOAD_COUNT == 2'b10) //load low
			begin
				ioaddr <= 2'b10;
				case (br_cfg)
					2'b00: BUFFER <= MY_ROM[0];
					2'b01: BUFFER <= MY_ROM[2];
					2'b10: BUFFER <= MY_ROM[4];
					default: BUFFER <= MY_ROM[6];
				endcase
				flag <= flag;
			end
			else //load high
			begin
				ioaddr <= 2'b11;
				case (br_cfg)
					2'b00: BUFFER <= MY_ROM[1];
					2'b01: BUFFER <= MY_ROM[3];
					2'b10: BUFFER <= MY_ROM[5];
					default: BUFFER <= MY_ROM[7];
				endcase
				flag <= flag;
			end
		end
		else if (rda == 1) //receive data
		begin
			LOAD_COUNT <= 2'b00;
			iocs <= 1;
			iorw <= 1;
			ioaddr <= 2'b00;
			flag <= 1;
			BUFFER <= databus;
		end
		else if ({flag,tbr} == 2'b11) //send data
		begin
			LOAD_COUNT <= 2'b00;
			iocs <= 1;
			iorw <= 0;
			ioaddr <= 2'b00;
			flag <= 0;
			BUFFER <= BUFFER;
		end
		else //idle
		begin
			LOAD_COUNT <= 2'b00;
			iocs <= 1;
			iorw <= 1;
			ioaddr <= 2'b00;
			flag <= flag;
			BUFFER <=BUFFER;
		end
	end
	
	always @(*)
	if (rst)
		gpio_led = {br_cfg, 6'h00};
	else
		gpio_led = BUFFER;

endmodule
