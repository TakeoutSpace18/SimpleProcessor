/*
    add signed           res = a + b
    substract signed     res = a - b
    division             res = a / b 
    multiply             res = a * b 
    mod                  res = a % b 
    sil                  res = (a < b) ? 16'b1 : 16'b0 
    sie                  res = (a == b) ?  16'b1 : 16'b0
*/
module ALU(
    input [31:0] a,b,
    input [2:0] op,
    output [31:0] res,
    logic [31:0] reg1,reg2,
    logic [31:0] reg3
    );
    
    assign reg1 = a;
    assign reg2 = b;
    assign res = reg3;
    
    always @(op or reg1 or reg2) begin
        case(op)
        0: reg3 = reg1 + reg2; //addition 
        1: reg3 = reg1 - reg2;  //substraction 
        2: reg3 = reg1 / reg2;  //division 
        3: reg3 = reg1 * reg2;  //multiplication 
        4: reg3 = reg1 % reg2;  //mod 
        5: reg3 = (reg1 < reg2) ? 32'b1 : 32'b0;
        6: reg3 = (reg1 == reg2) ? 32'b1 : 32'b0;
        endcase 
    end
 endmodule
            
