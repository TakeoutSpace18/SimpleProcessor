`timescale 1ns / 1ps

module TB_Ram();

logic clk;
logic [15:0] addr;
logic set;
logic [31:0] i_data;
logic [31:0] o_data;

RAM DUT(.i_addr(addr), .i_clk(clk), .i_set(set), .i_data(i_data), .o_data(o_data));

always begin
    clk = 1'b0; #10;
    clk = 1'b1; #10;
end    

initial begin
    set = 1'b0;
    addr = 16'b0; #20;
    addr += 1; #20;
    addr += 1; #20;
    addr += 1; #20;

    set = 1'b1;
    i_data = 32'hAAAAAAAA;
    addr = 16'b0;
    #20;

    set = 1'b1;
    i_data = 32'hAAAAAAAA;
    addr += 2;
    #20;

    set = 1'b0;
    addr = 16'b0; #20;
    addr += 1; #20;
    addr += 1; #20;
    addr += 1; #20;
    $finish;
end


endmodule
