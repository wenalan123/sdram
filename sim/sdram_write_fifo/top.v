/************************************************************************
 * Author        : Wen Chunyang
 * Email         : 1494640955@qq.com
 * Create time   : 2018-04-30 14:53
 * Last modified : 2018-04-30 14:53
 * Filename      : top.v
 * Description   : 
 * *********************************************************************/
module  top(
        input                   CLOCK_50                ,
        input                   rst_n                   ,
        //sdram
        output  wire  [12: 0]   DRAM_ADDR               ,
        output  wire  [ 1: 0]   DRAM_BA                 ,
        output  wire            DRAM_CAS_N              ,
        output  wire            DRAM_CKE                ,
        output  wire            DRAM_CLK                ,
        output  wire            DRAM_CS_N               ,
        inout   wire  [15: 0]   DRAM_DQ                 ,
        output  wire  [ 3: 0]   DRAM_DQM                ,
        output  wire            DRAM_RAS_N              ,
        output  wire            DRAM_WE_N               ,
        //rs232
        input                   rs232_rx           
);
//=====================================================================\
// ********** Define Parameter and Internal Signals *************
//=====================================================================/
wire                            clk                             ; 

wire    [ 7: 0]                 rx_data                         ;
wire                            flag_rx_end                     ;
wire                            wr_trig                         ;
wire                            wfifo_wr_en                     ;
wire    [ 7: 0]                 wfifo_wr_data                   ;

wire                            wfifo_rd_en                     ;
wire    [ 7: 0]                 wfifo_rd_data                   ;

wire                            empty                           ;
wire                            full                            ;
//======================================================================
// ***************      Main    Code    ****************
//======================================================================
assign  clk     =       CLOCK_50;

uart_rx uart_rx_inst(
        .clk                    (clk                    ),
        .rst_n                  (rst_n                  ),
        //uart
        .rs232_rx               (rs232_rx               ),
        //
        .rx_data                (rx_data                ),
        .flag_rx_end            (flag_rx_end            )
);

decode  decode_inst(
        .clk                    (clk                    ),
        .rst_n                  (rst_n                  ),
        //uart_rx
        .rx_data                (rx_data                ),
        .flag_rx_end            (flag_rx_end            ),
        .wr_trig                (wr_trig                ),
        .rd_trig                (rd_trig                ),
        .wfifo_wr_en            (wfifo_wr_en            ),
        .wfifo_wr_data          (wfifo_wr_data          )
);

fifo_16x8   wfifo_16x8_inst(
        .clock                  (clk                    ),
        .data                   (wfifo_wr_data          ),
        .rdreq                  (wfifo_rd_en            ),
        .wrreq                  (wfifo_wr_en            ),
        .empty                  (empty                  ),
        .full                   (full                   ),
        .q                      (wfifo_rd_data          )
);

sdram_top   sdram_top_inst(
        .clk                    (clk                    ),
        .rst_n                  (rst_n                  ),
        //other
        .wr_trig                (wr_trig                ),
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
        .DRAM_WE_N              (DRAM_WE_N              ),
        //wfifo
        .wfifo_rd_en            (wfifo_rd_en            ),
        .wfifo_rd_data          (wfifo_rd_data          )
);








endmodule
