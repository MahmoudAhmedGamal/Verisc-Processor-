module Counter #(parameter WIDTH = 5)(
    input clk,
    input rst,
    input load,
    input enab,
    input [WIDTH-1:0] cnt_in,
    output reg [WIDTH-1:0] cnt_out
);
    reg [WIDTH-1:0] next_count;
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            cnt_out <= 0;
        end else begin
            cnt_out <= next_count;
        end
    end
    always @(*) begin
		if (load)
			next_count = cnt_in;
		else if (enab)
			next_count = cnt_out + 1;
		else
			next_count = cnt_out;
	end
endmodule