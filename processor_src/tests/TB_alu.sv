module TB_alu();
    logic [15:0] a;
    logic [15:0] b;
    logic [2:0] Op;
    logic [15:0] res;
    
    alu DUT(.a(a), .b(b), .Op(Op), .res(res));
    initial begin
        a = 16'b0000000001101010;
        b = 16'b0000000000111011;
        Op = 0; #10;
        Op = 1; #10;
        Op = 2; #10;
        Op = 3; #10;
        Op = 4; #10;
        Op = 5; #10;
        Op = 6; #10;
        $finish;
    end
    
 endmodule
