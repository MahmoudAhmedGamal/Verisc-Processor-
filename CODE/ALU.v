module alu #(parameter WIDTH = 8)(
    input [WIDTH-1:0] in_a,
    input [WIDTH-1:0] in_b,
    input [2:0] opcode, // Operation selector
    output reg [WIDTH-1:0] alu_out,
    output reg a_is_zero 
);
localparam HLT = 3'b000;
localparam SKZ = 3'b001;
localparam ADD = 3'b010;
localparam AND = 3'b011;        
localparam XOR = 3'b100;
localparam LDA = 3'b101;
localparam STO = 3'b110;
localparam JMP = 3'b111;

    always @(*) begin
        case (opcode)
            HLT: begin
                alu_out = in_a; // PASS A
                a_is_zero = (in_a == 0);
            end
            SKZ: begin
                alu_out = in_a;//PASS A
                a_is_zero = (in_a == 0);
            end
            ADD: begin
                alu_out = in_a + in_b;//ADD
                a_is_zero = (in_a == 0);
            end
            AND: begin
                alu_out = in_a & in_b;//AND
                a_is_zero = (in_a == 0);
            end
            XOR: begin
                alu_out = in_a ^ in_b;//XOR
                a_is_zero = (in_a == 0);
            end
            LDA: begin
                alu_out = in_b;//PASS B
                a_is_zero = (in_a == 0);
            end
            STO: begin
                alu_out = in_a;//PASS A
                a_is_zero = (in_a == 0);
            end
            JMP: begin
                alu_out = in_a; //PASS A
                a_is_zero = (in_a == 0);
            end
            default: begin
                alu_out = 0;//Undefined operation
                a_is_zero = (in_a == 0);
            end
        endcase
    end
endmodule

