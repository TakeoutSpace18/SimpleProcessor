// word size: 32 bit
// address width: 16 bit
// max mem size: 2^16 = 65535 words 

module RAM (
    input i_clk,
    input i_set, 
    input [15:0] i_addr,
    input [31:0] i_data,

    output logic [31:0] o_data
);

reg [31:0] memory [255:0];

assign o_data = memory[i_addr];

initial begin
    $readmemh("memory.mem", memory, 0, 255);
end

always_ff @( posedge i_clk ) begin
    if (i_set)
        memory[i_addr] <= i_data;
end

endmodule
