module ram_memory #(
  parameter DWIDTH = 8,
  parameter AWIDTH = 4
)(
  input                     clk_i,
  input                     srst_i, 
  
  input                     wren_i,  // wren = 1 if wrreq && !full
  input        [AWIDTH-1:0] rdpntr_i,
  input        [AWIDTH-1:0] wrpntr_i,
  
  input        [DWIDTH-1:0] data_i,
  
  output logic [DWIDTH-1:0] q_o
);

(* ramstyle = "M10K, no_rw_check" *) logic [DWIDTH-1:0] mem [0:2**AWIDTH-1];

// reading mechanism
assign q_o = mem[rdpntr_i];


// writing mechanism
always_ff @( posedge clk_i )
  begin
    if( wren_i )
      mem[wrpntr_i] <= data_i;
  end
endmodule
