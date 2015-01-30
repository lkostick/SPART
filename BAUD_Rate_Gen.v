`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    21:51:17 01/29/2015 
// Design Name: 
// Module Name:    BAUD_Rate_Gen 
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


module BAUD_Rate_Gen( input clk, rst, input [7:0] Divisor, input [1:0] IOADDR, output reg Enable);

	localparam LOAD_LOW = 2'b10;
	localparam LOAD_HIGH = 2'b11;

	reg [15:0] Divisor_Buffer, Counter;

	/**
	* Load value into Divisor_Buffer.
	*/
    always @(posedge clk)
		if ( rst )
			Divisor_Buffer <= 16'h0000;
		else
			case ( IOADDR )
				LOAD_LOW:		Divisor_Buffer <= {Divisor_Buffer[15:8],Divisor};
				LOAD_HIGH:		Divisor_Buffer <= {Divisor, Divisor_Buffer[7:0]};
				default:	Divisor_Buffer <= Divisor_Buffer;
			endcase
	
	/**
	* Count down and set enable signal.
	*/
	always @(posedge clk)
		if ( rst ) begin
			Counter <= 16'h0000;
			Enable <= 0;
		end
		else if (Counter == 16'h0000) begin
			Counter <= Divisor_Buffer;
			Enable <= 1;
		end
		else begin
			Counter <= Counter - 1;
			Enable <= 0;
		end

endmodule //BAUD_Rate_Gen
