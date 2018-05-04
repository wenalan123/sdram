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
        output  wire            UART_TXD                ,
        input                   UART_RXD
);
//=====================================================================\
// ********** Define Parameter and Internal Signals *************
//=====================================================================/
wire                            clk                             ; 
wire                            rst_n                           ; 
//uart_rx
wire    [ 7: 0]                 rx_data                         ;
wire                            flag_rx_end                     ;
wire                            wr_trig                         ;
wire                            rd_trig                         ; 
//wfifo
wire                            wfifo_wr_en                     ;
wire    [ 7: 0]                 wfifo_wr_data                   ;
wire                            wfifo_rd_en                     ;
wire    [ 7: 0]                 wfifo_rd_data                   ;
//rfifo
wire    [ 7: 0]                 rfifo_wr_data                   ;
wire                            rfifo_rd_en                     ;
wire                            rfifo_wr_en                     ;
wire                            rfifo_empty                     ;
wire    [ 7: 0]                 rfifo_rd_data                   ;
//======================================================================
// ***************      Main    Code    ****************
//======================================================================

pll_clk	pll_clk_inst (
        .inclk0                 (CLOCK_50               ),
        .c0                     (clk                    ),
        .locked                 (rst_n                  )
);

uart_rx uart_rx_inst(
        .clk                    (clk                    ),
        .rst_n                  (rst_n                  ),
        //uart
        .rs232_rx               (UART_RXD               ),
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

fifo_16x8	wfifo_16x8_inst (
        .data                   (wfifo_wr_data          ),
        .rdclk                  (clk                    ),
        .rdreq                  (wfifo_rd_en            ),
        .wrclk                  (clk                    ),
        .wrreq                  (wfifo_wr_en            ),
        .q                      (wfifo_rd_data          ),
        .rdempty                (                       ),
        .wrfull                 (                       )
);

uart_tx uart_tx_inst(
        .clk                    (clk                    ),
        .rst_n                  (rst_n                  ),
        //uart_tx
        .rs232_tx               (UART_TXD               ),
        //rfifo
        .rfifo_rd_en            (rfifo_rd_en            ),
        .rfifo_rd_data          (rfifo_rd_data          ),
        .rfifo_empty            (rfifo_empty            )
);

fifo_16x8	rfifo_16x8_inst (
        .data                   (rfifo_wr_data          ),
        .rdclk                  (clk                    ),
        .rdreq                  (rfifo_rd_en            ),
        .wrclk                  (DRAM_CLK               ),
        .wrreq                  (rfifo_wr_en            ),
        .q                      (rfifo_rd_data          ),
        .rdempty                (rfifo_empty            ),
        .wrfull                 (                       )
);

sdram_top   sdram_top_inst(
        .clk                    (clk                    ),
        .rst_n                  (rst_n                  ),
        //other
        .wr_trig                (wr_trig                ),
        .rd_trig                (rd_trig                ),
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
        .wfifo_rd_data          (wfifo_rd_data          ),
        //rfifo
        .rfifo_wr_en            (rfifo_wr_en            ),
        .rfifo_wr_data          (rfifo_wr_data          ) 
);

endmodule
