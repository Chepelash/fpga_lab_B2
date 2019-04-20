module lifo_wrap #(
  parameter DWIDTH = 8,
  parameter AWIDTH = 3
)
(
  input                     clk_i,
  input                     srst_i,
  
  input                     wrreq_i,
  input                     rdreq_i,
  
  input        [DWIDTH-1:0] data_i,
  
  output logic              empty_o,
  output logic              full_o,
  output logic [AWIDTH:0]   usedw_o,
  
  output logic [DWIDTH-1:0] q_o
);


logic              srst_i_wrap;
  
logic              wrreq_i_wrap;
logic              rdreq_i_wrap;
  
logic [DWIDTH-1:0] data_i_wrap;
  
logic              empty_o_wrap;
logic              full_o_wrap;
logic [AWIDTH:0]   usedw_o_wrap;
  
logic [DWIDTH-1:0] q_o_wrap;


lifo #(
  .DWIDTH  ( DWIDTH       ),
  .AWIDTH  ( AWIDTH       )
) lifo_1   (
  .clk_i   ( clk_i        ),
  .srst_i  ( srst_i_wrap  ),
  
  .wrreq_i ( wrreq_i_wrap ),
  .rdreq_i ( rdreq_i_wrap ),
  
  .data_i  ( data_i_wrap  ),
  
  .empty_o ( empty_o_wrap ),
  .full_o  ( full_o_wrap  ),
  .usedw_o ( usedw_o_wrap ),
  
  .q_o     ( q_o_wrap     )
);


always_ff @( posedge clk_i )
  begin
    srst_i_wrap  <= srst_i;
    
    wrreq_i_wrap <= wrreq_i;
    rdreq_i_wrap <= rdreq_i;
    
    data_i_wrap  <= data_i;
    
    empty_o      <= empty_o_wrap;
    full_o       <= full_o_wrap;
    usedw_o      <= usedw_o_wrap;
    
    q_o          <= q_o_wrap;
    
  end

endmodule 
