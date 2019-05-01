module pntr_logic #(
  parameter AWIDTH = 4
)(
  input                     clk_i,
  input                     srst_i,
  
  input                     wrreq_i,
  input                     rdreq_i,
  
  output logic              wren_o,
  output logic [AWIDTH-1:0] rdpntr_o, 
  output logic [AWIDTH-1:0] wrpntr_o,
  
  output logic              empty_o,
  output logic              full_o,
  output logic [AWIDTH:0]   usedw_o
);


logic [AWIDTH-1:0] top; // pntr to the top of stack
logic [AWIDTH-1:0] top_succ_wr;
logic [AWIDTH-1:0] top_succ_rd;
logic [AWIDTH-1:0] top_succ;
logic [AWIDTH-1:0] top_next;


logic [AWIDTH-1:0] rdpntr; 
logic [AWIDTH-1:0] wrpntr;

logic [AWIDTH:0]   usedw;
logic [AWIDTH:0]   usedw_next;

logic              empty;
logic              empty_next;
logic              full;
logic              full_next;

assign full_o   = full;
assign empty_o  = empty;
assign usedw_o  = usedw;
assign rdpntr_o = rdpntr;
assign wrpntr_o = wrpntr;

assign wren_o = wrreq_i & (~full_o); // wren for ram

assign rdpntr = top - '1;
assign wrpntr = top;

always_ff @( posedge clk_i )
  begin
    if( srst_i )
      begin
        top   <= '0;
        empty <= '1;
        full  <= '0;
        usedw <= '0;
      end
    else
      begin
        top   <= top_next;
        empty <= empty_next;
        full  <= full_next;
        usedw <= usedw_next;
      end
  end

always_comb
  begin
    top_next    = top;
    top_succ_wr = top + '1;
    top_succ_rd = top - '1;
    
    empty_next = empty;
    full_next  = full;
    usedw_next = usedw;
    
    if( wrreq_i && !full)
      begin
        top_next   = top_succ_wr;
        usedw_next = usedw + 1'b1;
        empty_next = '0;
        if( top_succ_wr == '0 )
          full_next = '1;
      end
    else if( rdreq_i && !empty )
      begin
        top_next   = top_succ_rd;
        usedw_next = usedw - 1'b1;
        full_next  = '0;
        if( top_succ_rd == '0 )
          empty_next = '1;
      end
  end
endmodule
