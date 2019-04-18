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
  output logic [AWIDTH:0]   usedw_o
  
  output logic [DWIDTH-1:0] q_o  
);


endmodule
