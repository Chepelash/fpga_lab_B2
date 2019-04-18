module lifo_tb;

parameter  int CLK_T  = 60;

parameter  int DWIDTH = 8;
parameter  int AWIDTH = 3;

localparam int ADRESSES = 2**AWIDTH;

logic              clk;
logic              rst;
  
logic              wrreq_i;
logic              rdreq_i;
  
logic [DWIDTH-1:0] data_i;
  
logic              empty_o;
logic              full_o;
logic [AWIDTH:0]   usedw_o;
  
logic [DWIDTH-1:0] q_o;

int                queue[$];

lifo #(
  .DWIDTH  ( DWIDTH  ),
  .AWIDTH  ( AWIDTH  )
) DUT (
  .clk_i   ( clk     ),
  .srst_i  ( rst     ),
  
  .wrreq_i ( wrreq_i ),
  .rdreq_i ( rdreq_i ),
  
  .data_i  ( data_i  ),
  
  .empty_o ( empty_o ),
  .full_o  ( full_o  ),
  .usedw_o ( usedw_o ),
  
  .q_o     ( q_o     )
);

task automatic clk_gen;
  
  forever
    begin
      # ( CLK_T / 2 );
      clk <= ~clk;
    end
  
endtask

task automatic apply_rst;
  
  rst <= 1'b1;
  @( posedge clk );
  rst <= 1'b0;
  @( posedge clk );

endtask

task automatic init;

  rst     <= '0;
  clk     <= '1;
  rdreq_i <= '0;
  wrreq_i <= '0;
  
endtask

bit [DWIDTH-1:0] wr_data;

task automatic writing_test;
  $display("Starting writing test!");
  
  wrreq_i <= '1;
  for( int i = 0; i < ADRESSES; i++ )
    begin
      if( full_o == '1 )
        begin
          $display("Fail! Unexpected full flag");
          $stop();
        end
      if( i == 2 && empty_o == 1)
        begin
          $display("Fail! Unexpected empty flag");
          $stop();
        end
      if( i > 0 && i != usedw_o+1 )
        begin
          $display("Fail! Usedw wrong counting");
          $display("i = %d; usedw_o+1 = %d", i, usedw_o+1);
          $stop();
        end
        
      wr_data = $urandom_range(2**DWIDTH - 1); 
      queue.push_back(wr_data);
      data_i <= wr_data;
      
      @( posedge clk );
      
    end
  wrreq_i <= '0;
  @( posedge clk );
  // fail states 
  if( full_o != 1 )
    begin
      $display("Fail! Unexpected full flag");
      $stop();
    end
  if( empty_o == 1 )
    begin
      $display("Fail! Unexpected empty flag");
      $stop();
    end
  if( usedw_o != 8 )
    begin
      $display("Fail! Wrong usedw number");
      $stop();
    end
endtask


bit [DWIDTH-1:0] rd_data;

task automatic reading_test;
  $display("Starting reading test!");
  
  @( posedge clk );
  rdreq_i <= '1;    
  for( int i = 0; i < ADRESSES; i++ )
    begin
      @( posedge clk );      
      if( empty_o == '1 )
        begin
          $display("Fail! Unexpected empty flag");
          $stop();
        end
      rd_data = queue.pop_back();
      if( q_o != rd_data )
        begin
          $display("Fail! Unexpected data read. q_o = %b, rd_data = %b", q_o, rd_data);
          $stop();
        end        
    end
  rdreq_i <= '0;
  @( posedge clk );
  if( full_o == 1 )
    begin
      $display("Fail! Unexpected full flag");
      $stop();
    end
  if( empty_o != 1 )
    begin
      $display("Fail! Expected empty flag");
      $stop();
    end
  if( usedw_o != 0 )
    begin
      $display("Fail! Expected 0 usedw");
      $stop();
    end  
  
endtask

task automatic overwriting;


endtask

initial
  begin
    init();
    fork
      clk_gen();
    join_none
    apply_rst();
    
    $display("Starting testbench!");
    
    writing_test();
    $display("Writing test - OK!");
    
    reading_test();
    $display("Reading test - OK!");
    
//    overwriting();
//    for( int i = 0; i < 100; i++ )
//      @( posedge clk );
    
    $stop();
  end
endmodule
