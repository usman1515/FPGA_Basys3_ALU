`timescale 1ns/100ps



module tb_alu;

    localparam DATA_WIDTH = 8;
    localparam T=5;
    integer iter_mode=0;

    logic                       clk;
    logic                       reset_n;
    logic [DATA_WIDTH-1 : 0]    in_a;
    logic [DATA_WIDTH-1 : 0]    in_b;
    logic [3:0]                 in_mode;
    logic [DATA_WIDTH-1 : 0]    out_alu;
    logic                       cout;

    alu #(
        .DATA_WIDTH (DATA_WIDTH)
    ) dut_alu (
        .clk        (clk),
        .reset_n    (reset_n),
        .in_a       (in_a),
        .in_b       (in_b),
        .in_mode    (in_mode),
        .out_alu    (out_alu),
        .cout       (cout)
    );

    always begin
        #T clk=1'b0; #T clk=1'b1;
    end

    initial begin
        iter_mode = 0;
        repeat(16) begin
            repeat(2) begin
                @(posedge clk) begin
                    reset_n = 1'b1;
                    in_a    = $urandom_range('h0,'hff);
                    in_b    = $urandom_range('h0,'hff);
                    in_mode = iter_mode;
                end
                #T;
                $display(
                    "| Time: %3d | Input A: %d | Input B: %d | Opcode: %2d | Output: %3h | Output: %3d | Cout: %h |",
                    $time, in_a, in_b, in_mode, out_alu, out_alu, cout);
            end
            iter_mode = iter_mode + 1;
        end
        $finish;
    end

    initial begin
        $dumpfile("04_alu/04_alu.vcd");
        $dumpvars(0, tb_alu);
    end

endmodule

