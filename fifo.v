module fifo(
    input  wire clk,
    input  wire rstn,
    input  wire wr_en,
    input  wire rd_en,
    input  wire [7:0] data_in,
    output reg  [7:0] data_out,
    output wire full,
    output wire empty
);
    localparam TAMANHO_FIFO = 4;
    localparam LARG_END = 2;

    reg [7:0] mem [0:TAMANHO_FIFO-1];
    reg [LARG_END:0] w_ptr = 0;
    reg [LARG_END:0] r_ptr = 0;
    wire [LARG_END-1:0] w_addr = w_ptr[LARG_END-1:0];
    wire [LARG_END-1:0] r_addr = r_ptr[LARG_END-1:0];
    wire [LARG_END:0] w_ptr_next = w_ptr + 1;

    always @(posedge clk) begin
        if (!rstn)
            w_ptr <= 0;
        else if (wr_en && !full) begin
            mem[w_addr] <= data_in;
            w_ptr <= w_ptr_next;
        end
    end

    always @(posedge clk) begin
        if (!rstn) begin
            r_ptr <= 0;
            data_out <= 8'bx;
        end else if (rd_en && !empty) begin
            data_out <= mem[r_addr];
            r_ptr <= r_ptr + 1;
        end
    end

   assign empty = (w_ptr == r_ptr);
   assign full  = (w_ptr_next[LARG_END] != r_ptr[LARG_END]) &&
                  (w_ptr_next[LARG_END-1:0] == r_addr);
               
endmodule
