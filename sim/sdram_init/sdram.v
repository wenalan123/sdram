/************************************************************************
 * Author        : Wen Chunyang
 * Email         : 1494640955@qq.com
 * Create time   : 2018-04-15 18:58
 * Last modified : 2018-04-15 18:58
 * Filename      : sdram.v
 * Description   : 
 * *********************************************************************/
module  sdram(
        input                   CLOCK_50                ,
        input                   rst_n                   ,
        //sdram
        output  wire  [12: 0]   DRAM_ADDR               ,
        output  wire  [ 1: 0]   DRAM_BA                 ,
        output  wire            DRAM_CAS_N              ,
        output  wire            DRAM_CKE                ,
        output  wire            DRAM_CLK                ,
        output  wire            DRAM_CS_N               ,
        output  wire  [15: 0]   DRAM_DQ                 ,
        output  wire  [ 3: 0]   DRAM_DQM                ,
        output  wire            DRAM_RAS_N              ,
        output  wire            DRAM_WE_N               
);
//=====================================================================\
// ********** Define Parameter and Internal Signals *************
//=====================================================================/
wire    [ 3: 0]                 cmd                             ;
wire                            flag_init_end                   ; 



//======================================================================
// ***************      Main    Code    ****************
//======================================================================
assign  {DRAM_CS_N,DRAM_RAS_N,DRAM_CAS_N,DRAM_WE_N}     =       cmd;
assign  DRAM_CKE                =       1'b1;
assign  DRAM_DQM                =       2'b00;
assign  DRAM_CLK                =       ~CLOCK_50;
assign  DRAM_BA                 =       2'b00;


sdram_init  sdram_init_inst(
        .clk                    (CLOCK_50               ),
        .rst_n                  (rst_n                  ),
        //
        .cmd                    (cmd                    ),
        .addr                   (DRAM_ADDR              ),
        .flag_init_end          (flag_init_end          )
);
endmodule
