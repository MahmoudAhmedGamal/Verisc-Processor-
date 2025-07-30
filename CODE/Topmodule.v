module VERI_RISC (
    input clk,
    input rst,
    output halt );
    parameter WIDTH = 8;
    parameter AWIDTH = 5;
    parameter DEPTH = (1<<AWIDTH);
    wire [WIDTH-1:0] data;
    wire [WIDTH-1:0] alu_out;
    wire a_is_zero;
    wire [2:0] opcode;
    wire data_e;
    wire ld_ac;
    wire [WIDTH-1:0] ac_out;
    wire [WIDTH-1:0] ir_reg;
    wire ld_ir;
    wire [AWIDTH-1:0] ir_addr;
    wire rd,wr,ld_pc,inc_pc,sel;
    wire [AWIDTH-1:0] addr;
    wire [AWIDTH-1:0] pc_addr;
    wire [2:0] phase;

    assign opcode = ir_reg [WIDTH-1 : WIDTH-3];
    assign ir_addr = ir_reg [WIDTH-4 : 0];

    driver #(.WIDTH(WIDTH)) driver_inst (
        .data_in(alu_out),
        .data_en(data_e),
        .data_out(data)
    );
    Register #(.WIDTH(WIDTH)) ac (
        .clk(clk),
        .rst(rst),
        .load(ld_ac),
        .data_in(alu_out),
        .data_out(ac_out)
    );
    Register #(.WIDTH(WIDTH)) ir (
        .clk(clk),
        .rst(rst),
        .load(ld_ir),
        .data_in(data),
        .data_out(ir_reg)
    );
    alu #(.WIDTH(WIDTH)) alu_inst (
        .in_a(ac_out),
        .in_b(data),
        .opcode(opcode),
        .alu_out(alu_out),
        .a_is_zero(a_is_zero)
    );
    Counter #(.WIDTH(AWIDTH)) pc (
        .clk(clk),
        .rst(rst),
        .load(ld_pc),
        .enab(inc_pc),
        .cnt_in(ir_addr),
        .cnt_out(pc_addr)
    );
    multiplexor #(.WIDTH(AWIDTH)) mux (
        .in0(ir_addr),
        .in1(pc_addr),
        .sel(sel),
        .mux_out(addr)
    );
    memory #(.AWIDTH(AWIDTH), .DWIDTH(WIDTH), .DEPTH(DEPTH)) memory_inst (
        .clk(clk),
        .wr(wr),
        .rd(rd),
        .addr(addr),
        .data_out(data)
    );
    controller controller_inst (
        .halt(halt),
        .zero(a_is_zero),
        .opcode(opcode),
        .phase(phase),
        .sel(sel),
        .rd(rd),
        .ld_ir(ld_ir),
        .inc_pc(inc_pc),
        .ld_ac(ld_ac),
        .ld_pc(ld_pc),
        .wr(wr),
        .data_e(data_e)
    );
    Counter #(.WIDTH(3)) phase_counter (
        .clk(clk),
        .rst(rst),
        .load(1'b0), // Phase counter does not need to load
        .enab(1'b1), // Always enabled to count phases
        .cnt_in(3'b0), // Not used, phase is controlled by controller
        .cnt_out(phase)
    );

endmodule   

