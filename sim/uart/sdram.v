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
        //uart
        input                   UART_RXD                ,
        output  wire            UART_TXD 
);
//=====================================================================\
// ********** Define Parameter and Internal Signals *************
//=====================================================================/
wire    [ 7: 0]                 rx_data                         ;
wire                            po_flag                         ; 
wire                            clk                             ;
wire                            rst_n                           ; 
//======================================================================
// ***************      Main    Code    ****************
//======================================================================
uart_rx uart_rx_inst(
        .clk                    (clk                    ),
        .rst_n                  (rst_n                  ),
        //uart
        .rs232_rx               (UART_RXD               ),
        //
        .rx_data                (rx_data                ),
        .po_flag                (po_flag                )
);
uart_tx uart_tx_inst(
        .clk                    (clk                    ),
        .rst_n                  (rst_n                  ),
        //uart_rx
        .tx_trig                (po_flag                ),
        .tx_data                (rx_data                ),
        //uart_tx
        .rs232_tx               (UART_TXD               )
);

pll_clk	pll_clk_inst (
        .inclk0                 (CLOCK_50               ),
        .c0                     (clk                    ),
        .locked                 (rst_n                  )
);

endmodule
