// ========= opcodes =========
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
parameter halt   = 5'b01100;

// ===========================

module Processor(
    input i_clk,
    input i_reset
);

// 8 Registers
reg [31:0] registers [7:0];

// RAM
wire [15:0] ram_addr;
wire [31:0] ram_o_data;
reg [31:0] ram_i_data;
reg ram_set_flag;

RAM ram(.i_clk(i_clk), .i_data(ram_i_data), .o_data(ram_o_data), .i_set(ram_set_flag), .i_addr(ram_addr));

// ALU
reg [31:0] alu_operand_a;
reg [31:0] alu_operand_b;
wire [31:0] alu_result;

ALU alu(.a(alu_operand_a), .b(alu_operand_b), .op(opcode), .res(alu_result));

// FSM states
enum logic [3:0] {
    instr_read,
    instr_execute,
    alu_load_operands,
    alu_get_result,
    instr_next
} state;

reg [15:0] instr_addr;
reg [31:0] instruction;

wire [4:0] opcode;
wire [2:0] r1;
wire [2:0] r2;
wire [2:0] r3;
wire [15:0] arg;

assign opcode = instruction[31:27]; // 5 bit operation code
assign r1 = instruction[26:24]; // 3 bit register number
assign r2 = instruction[23:21]; // 3 bit register number
assign r3 = instruction[20:18]; // 3 bit register number
assign arg = instruction[23:8]; // argument in immediate type instruction

// jump instruction
wire [15:0] jmp_addr;
reg jmp_flag;
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
            state <= instr_execute;
        end
        
        instr_execute: begin
            case (opcode)
                add: state <= alu_load_operands;
                sub: state <= alu_load_operands;
                div: state <= alu_load_operands;
                mul: state <= alu_load_operands;
                mod: state <= alu_load_operands;
                sil: state <= alu_load_operands;
                sie: state <= alu_load_operands;
                
                copy: begin
                    registers[r1] <= registers[r2];
                    state <= instr_next;
                end
                
                jmp: begin
                    jmp_flag <= registers[r1][0];
                    state <= instr_next;
                end
                
                load: begin
                    registers[r1] <= ram_o_data;
                    state <= instr_next;
                end
                
                store: begin 
                    ram_i_data <= registers[r1];
                    ram_set_flag <= 1'b1;
                    state <= instr_next;
                end
                
                set: begin
                    registers[r1] <= {16'h0000, arg};
                    state <= instr_next;
                end
                
                halt: state <= instr_next;
            endcase
        end
        
        alu_load_operands: begin
            alu_operand_a <= registers[r1];
            alu_operand_b <= registers[r2];
            state <= alu_get_result;
        end
        
        alu_get_result: begin 
            registers[r3] <= alu_result;
            state <= instr_next;
        end

        instr_next: begin
            // reset flags before next instruction
            ram_set_flag <= 1'b0; 
            jmp_flag <= 0;
            
            case (jmp_flag)
                1'b0: begin 
                    instr_addr <= instr_addr + 1;
                end
                1'b1: begin
                    instr_addr <= jmp_addr;
                end
            endcase
            state <= instr_read;
        end
    endcase
end
endmodule
