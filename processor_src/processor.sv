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

// ALU
logic [31:0] alu_operand_a;
logic [31:0] alu_operand_b;
logic [31:0] alu_result;
logic [2:0] alu_opcode;

ALU alu(.a(alu_operand_a), .b(alu_operand_b), .op(alu_opcode));

parameter add    = 5'b00000;
parameter sub    = 5'b00001;
parameter div    = 5'b00010;
parameter mul    = 5'b00011;
parameter mod    = 5'b00100;
parameter sil    = 5'b00101;
parameter sie    = 5'b00110;
parameter copy   = 5'b00111;
parameter jmp    = 5'b01000;
parameter load   = 5'b01001;
parameter store  = 5'b01010;
parameter set    = 5'b01011;


enum logic [3:0] {
    instr_read,
    instr_decode,
    instr_execute,
    instr_next
} state;

reg [15:0] instr_addr;
reg [31:0] instruction;
wire [4:0] opcode;
wire [2:0] r1;
wire [2:0] r2;
wire [2:0] r3;
wire [15:0] arg;

assign instruction = ram_o_data;
assign opcode = instruction[31:27]; // 5 bit operation code
assign r1 = instruction[26:24]; // 3 bit register number
assign r2 = instruction[23:21]; // 3 bit register number
assign r3 = instruction[20:18]; // 3 bit register number
assign arg = instruction[20:5]; // argument in immediate type instruction

// jump instruction
wire [15:0] jmp_addr;
wire jmp_flag;
assign jmp_flag = (opcode == jmp);
assign jmp_addr = arg;

always @(posedge i_reset) begin
    state <= instr_read;
    instr_addr <= 16'b0; // start executing from beginning
end

assign ram_addr = (state == instr_read ? instr_addr : arg);

always @(posedge i_clk) begin
    case (state)
        instr_read: begin
            instruction <= ram_o_data;
            state <= instr_decode;
        end
        
        instr_decode: begin
            case (opcode)
                add: begin
                    alu_operand_a <= registers[r1];
                    alu_operand_b <= registers[r2];
                    alu_opcode <= opcode;
                end
                copy: begin
                    registers[r1] <= registers[r2];
                end
                load: begin
                    ram_addr <= arg;
                end
                store: begin
                    ram_set <= 1'b1;
                    ram_addr <= arg;
                    ram_i_data <= registers[r1];
                end
                set: begin
                    registers[r1] <= {16'h0000, arg};
                end
                
            endcase
        end
        
        instr_execute: begin
           case (opcode)
                add: begin
                   registers[r3] <= alu_result;
                end
            endcase
        end
        
        instr_next: begin
            case (jmp_flag)
                1'b0: begin 
                    instr_addr <= instr_addr + 1;
                end
                1'b1: begin
                    instr_addr <= jmp_addr;
                end
            endcase
        end
    endcase
end


endmodule
