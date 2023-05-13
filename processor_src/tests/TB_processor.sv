`timescale 1ns / 1ps

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
    #10000;
    $finish;
end

endmodule
