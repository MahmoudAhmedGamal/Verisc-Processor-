module controller (
    input [2:0]phase,
    input zero,
    input [2:0] opcode,
    output reg sel,rd,ld_ir,halt,inc_pc,ld_ac,ld_pc,wr,data_e
);
    localparam HLT = 3'b000;
    localparam SKZ = 3'b001;
    localparam ADD = 3'b010;
    localparam AND = 3'b011;        
    localparam XOR = 3'b100;
    localparam LDA = 3'b101;
    localparam STO = 3'b110;
    localparam JMP = 3'b111;

    localparam INST_ADDR =0;
    localparam INST_FETCH =1;
    localparam INST_LOAD=2;
    localparam IDLE=3;
    localparam OP_ADDR=4;
    localparam OP_FETCH=5;
    localparam ALU_OP=6;
    localparam STORE=7;

    reg ALUOP;
    reg HALT;
    reg jmp;
    reg Skz;
    reg sto;

    always @(*) begin
        case(opcode)
            HLT: begin
                ALUOP = 0;
                HALT = 1;
                Skz = 0; 
                sto = 0; 
                jmp = 0; 
            end

            SKZ: begin
                ALUOP = 0;
                HALT = 0;
                Skz = 1; 
                sto = 0; 
                jmp = 0; 
            end

            ADD: begin
                ALUOP = 1;
                HALT = 0;
                Skz = 0; 
                sto = 0; 
                jmp = 0; 
            end

            AND:begin
                ALUOP = 1;
                HALT = 0;
                Skz = 0; 
                sto = 0; 
                jmp = 0; 
            end 
            
            XOR: begin
                ALUOP = 1;
                HALT = 0;
                Skz = 0; 
                sto = 0; 
                jmp = 0; 
            end

            LDA: begin
                ALUOP = 1;
                HALT = 0;
                Skz = 0; 
                sto = 0; 
                jmp = 0; 
            end


            STO: begin
                ALUOP = 0;
                HALT = 0;
                Skz = 0; 
                sto = 1; 
                jmp = 0; 
            end
            JMP: begin
                ALUOP = 0;
                HALT = 0;
                Skz = 0; 
                sto = 0; 
                jmp = 1; 
            end
            default: begin
                ALUOP = 0;
                HALT = 0;
                Skz = 0; 
                sto = 0; 
                jmp = 0; 
            end
        endcase
        case(phase)
            INST_ADDR: begin
                sel = 1;
                rd = 0;
                ld_ir = 0;
                halt = 0;
                inc_pc = 0;
                ld_ac = 0;
                ld_pc = 0;
                wr = 0;
                data_e = 0;
            end
            INST_FETCH: begin
                sel = 1;
                rd = 1;
                ld_ir = 0;
                halt = 0;
                inc_pc = 0;
                ld_ac = 0;
                ld_pc = 0;
                wr = 0;
                data_e = 0;
            end
            INST_LOAD: begin
                sel = 1;
                rd = 1;
                ld_ir = 1;
                halt = 0;
                inc_pc = 0;
                ld_ac = 0;
                ld_pc = 0;
                wr = 0;
                data_e = 0;
            end
            IDLE: begin
                sel = 1;
                rd = 1;
                ld_ir = 1;
                halt = 0;
                inc_pc = 0;
                ld_ac = 0;
                ld_pc = 0;
                wr = 0;
                data_e = 0;
            end
            OP_ADDR: begin
                sel = 0;
                rd = 0;
                ld_ir = 0;
                halt = HALT;
                inc_pc = 1;
                ld_ac = 0;
                ld_pc = 0;
                wr = 0;
                data_e = 0;
            end
            OP_FETCH: begin
                sel = 0;
                rd = ALUOP;
                ld_ir = 0;
                halt = 0;
                inc_pc = 0;
                ld_ac = 0;
                ld_pc = 0;
                wr = 0;
                data_e = 0;
            end
            ALU_OP: begin
                sel = 0;
                rd = ALUOP;
                ld_ir = 0;
                halt =  0;
                inc_pc = (Skz && zero);
                ld_ac = 0;
                ld_pc = jmp;
                wr = 0;
                data_e = sto;
            end
            STORE: begin
                sel = 0;
                rd = ALUOP;
                ld_ir = 0;
                halt = 0;
                inc_pc = 0;
                ld_ac = ALUOP;
                ld_pc = jmp;
                wr = sto;
                data_e = sto;
            end
            default: begin
                sel = 0;
                rd = 0;
                ld_ir = 0;
                halt = 0;
                inc_pc = 0;
                ld_ac = 0;
                ld_pc = 0;
                wr = 0;
                data_e = 0;
            end
        endcase
    end
endmodule
        