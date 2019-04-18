module lifo #(
  parameter DWIDTH = 8,
  parameter AWIDTH = 3
)(
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

logic              wren; 
logic [AWIDTH-1:0] rdpntr;
logic [AWIDTH-1:0] wrpntr;

ram_memory #(
  .DWIDTH   ( DWIDTH ),
  .AWIDTH   ( AWIDTH )
) ram_mem   (
  .clk_i    ( clk_i  ),
  .srst_i   ( srst_i ), 
  
  .wren_i   ( wren   ),  // wren = 1 if wrreq && !full
  .rdpntr_i ( rdpntr ),
  .wrpntr_i ( wrpntr ),
  
  .data_i   ( data_i ),
  
  .q_o      ( q_o    )
);

pntr_logic    #(
  .AWIDTH      ( AWIDTH )
) pntr_logic_1 (
  .clk_i       ( clk_i   ),
  .srst_i      ( srst_i  ),
  
  .wrreq_i     ( wrreq_i ),
  .rdreq_i     ( rdreq_i ),
  
  .wren_o      ( wren    ),
  .rdpntr_o    ( rdpntr  ),
  .wrpntr_o    ( wrpntr  ),
  
  .empty_o     ( empty_o ),
  .full_o      ( full_o  ),
  .usedw_o     ( usedw_o )
);

endmodule
