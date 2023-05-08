module Processor(
    input i_clk,
    input i_reset
);

// Registers
reg [31:0] registers [7:0];

// RAM
logic [31:0] ram_i_data;
logic [31:0] ram_o_data;
logic [15:0] ram_addr;
logic ram_set;

RAM ram(.i_clk(i_clk), .i_data(ram_i_data), .o_data(ram_o_data), .i_set(ram_set));

enum logic [3:0] {
    instr_read,
    instr_decode,
    instr_execute
} state;

reg [15:0] instr_addr;
assign instruction = ram_o_data;
assign opcode = instruction[31:27]; // 5 bit operation code
assign r1 = instruction[26:24]; // 3 bit register number
assign r2 = instruction[23:21]; // 3 bit register number
assign r3 = instruction[20:18]; // 3 bit register number
assign arg = instruction[20:5]; // argument in immediate type instruction

always @(posedge i_reset) begin
    state <= instr_read;
    instr_addr <= 16'b0; // start executing from beginning
end

always @(posedge i_clk) begin
    case (state)
        instr_read: begin
            ram_addr <= instr_addr;
            state <= instr_decode;
        end
        instr_decode: begin
            
        end
        instr_execute: begin
        
        end
    endcase
end


endmodule
