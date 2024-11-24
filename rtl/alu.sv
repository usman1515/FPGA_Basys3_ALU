`include "macros_alu.sv"
`timescale 1us/100ns



module alu #(parameter DATA_WIDTH=`DATA_WIDTH) (
    input   wire                    clk,
    input   wire                    reset_n,
    input   wire [`DATA_WIDTH-1:0]  in_a,
    input   wire [`DATA_WIDTH-1:0]  in_b,
    input   wire [3:0]              in_mode,
    output  wire [`DATA_WIDTH-1:0]  out_alu,
    output  wire                    cout
);

    reg [`DATA_WIDTH-1:0] alu_result;
    reg [`DATA_WIDTH:0] tmp;

    always @(posedge clk) begin
        if(reset_n) begin
            case(in_mode)
                `MODE0  : alu_result = in_a + in_b;
                `MODE1  : alu_result = in_a - in_b;
                `MODE2  : alu_result = in_a * in_b;
                `MODE3  : alu_result = in_a / in_b;
                `MODE4  : alu_result = in_a << 1;
                `MODE5  : alu_result = in_a >> 1;
                `MODE6  : alu_result = {in_a[`DATA_WIDTH-2:0], in_a[`DATA_WIDTH-1]};
                `MODE7  : alu_result = {in_a[0], in_a[`DATA_WIDTH-1:1]};
                `MODE8  : alu_result = in_a & in_b;
                `MODE9  : alu_result = in_a | in_b;
                `MODE10 : alu_result = in_a ^ in_b;
                `MODE11 : alu_result = ~(in_a & in_b);
                `MODE12 : alu_result = ~(in_a | in_b);
                `MODE13 : alu_result = ~(in_a ^ in_b);
                `MODE14 : alu_result = (in_a > in_b)? 8'd1 : 8'd0;
                `MODE15 : alu_result = (in_a == in_b)? 8'd1 : 8'd0;
                default : alu_result = in_a + in_b;
            endcase
        end
        // out_alu = alu_result;
        tmp = {1'b0,in_a} + {1'b0,in_b};
        // cout = tmp[DATA_WIDTH];
    end

    assign out_alu = alu_result;
    // tmp = {1'b0,in_a} + {1'b0,in_b};
    assign cout = tmp[`DATA_WIDTH];

endmodule

