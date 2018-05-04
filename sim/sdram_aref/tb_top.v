/************************************************************************
 * Author        : Wen Chunyang
 * Email         : 1494640955@qq.com
 * Create time   : 2018-04-15 15:45
 * Last modified : 2018-04-15 15:45
 * Filename      : tb_top.v
 * Description   : 
 * *********************************************************************/
`timescale		1ns/1ns 

module	tb_top;

//=====================================================================\
// ********** Define Parameter and Internal Signals *************
//=====================================================================/
reg                             clk                             ;       
reg                             rst_n                           ;       


wire  [12: 0]   DRAM_ADDR                                       ;
wire  [ 1: 0]   DRAM_BA                                         ;
wire            DRAM_CAS_N                                      ;
wire            DRAM_CKE                                        ;
wire            DRAM_CLK                                        ;
wire            DRAM_CS_N                                       ;
wire  [15: 0]   DRAM_DQ                                         ;
wire  [ 3: 0]   DRAM_DQM                                        ;
wire            DRAM_RAS_N                                      ;
wire            DRAM_WE_N                                       ;

//======================================================================
// ***************      Main    Code    ****************
//======================================================================
always  #10      clk    =       ~clk;


initial begin
	clk		<=		1'b1;
	rst_n	<=		1'b0;
	#100
	rst_n	<=		1'b1;

end


//例化
sdram_model_plus    sdram_model_plus_inst(
        .Dq                     (DRAM_DQ                     ),
        .Addr                   (DRAM_ADDR                   ),
        .Ba                     (DRAM_BA                     ),
        .Clk                    (DRAM_CLK                    ),
        .Cke                    (DRAM_CKE                    ),
        .Cs_n                   (DRAM_CS_N                   ),
        .Ras_n                  (DRAM_RAS_N                  ),
        .Cas_n                  (DRAM_CAS_N                  ),
        .We_n                   (DRAM_WE_N                   ),
        .Dqm                    (DRAM_DQM                    ),
        .Debug                  (1'b1                        )
);

sdram   sdram_inst(
        .CLOCK_50               (clk                    ),
        .rst_n                  (rst_n                  ),
        //sdram
        .DRAM_ADDR              (DRAM_ADDR              ),
        .DRAM_BA                (DRAM_BA                ),
        .DRAM_CAS_N             (DRAM_CAS_N             ),
        .DRAM_CKE               (DRAM_CKE               ),
        .DRAM_CLK               (DRAM_CLK               ),
        .DRAM_CS_N              (DRAM_CS_N              ),
        .DRAM_DQ                (DRAM_DQ                ),
        .DRAM_DQM               (DRAM_DQM               ),
        .DRAM_RAS_N             (DRAM_RAS_N             ),
        .DRAM_WE_N              (DRAM_WE_N              )
);

defparam    sdram_model_plus_inst.addr_bits    =       13;
defparam    sdram_model_plus_inst.data_bits    =       16;
defparam    sdram_model_plus_inst.col_bits     =       10;
defparam    sdram_model_plus_inst.mem_sizes    =       2*1024*1024-1;


endmodule
