`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12.05.2023 21:02:35
// Design Name: 
// Module Name: TB_Processor
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module TB_Processor();

logic clk;
logic reset;

Processor DUT(.i_clk(clk), .i_reset(reset));

always begin
    clk = 1'b0; #10;
    clk = 1'b1; #10;

end

initial begin
    reset = 1'b1; #20;
    reset = 1'b0;
    #500;
    $finish;
end

endmodule
