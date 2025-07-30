module memory #(parameter AWIDTH = 5, parameter DWIDTH = 8, parameter DEPTH = (1<<AWIDTH) )(
    input clk,wr,rd,
    input [AWIDTH-1:0] addr,
    inout [DWIDTH-1:0] data_out
);
    reg [DWIDTH-1:0] array [DEPTH-1:0];

    always @(posedge clk) begin
        if (wr) begin
            array[addr] <= data_out;
        end
    end

    assign data_out = (rd) ? array[addr] : {DWIDTH{1'b0}};
endmodule