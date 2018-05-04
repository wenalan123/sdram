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
reg                             tx_trig                         ;
reg     [ 7: 0]                 tx_data                         ; 
wire                            rs232_tx                        ; 

//======================================================================
// ***************      Main    Code    ****************
//======================================================================
always  #5      clk    =       ~clk;


initial begin
	clk		<=		1'b1;
	rst_n	<=		1'b0;
    tx_trig <=      1'b0;
    tx_data <=      8'h00;
	#100
	rst_n	<=		1'b1;
    #100
    tx_data <=      8'h12;
    #100
    tx_trig <=      1'b1;
    #10
    tx_trig <=      1'b0;

    #5600
    tx_data <=      8'h34;
    #100
    tx_trig <=      1'b1;
    #10
    tx_trig <=      1'b0;

    #5600
    tx_data <=      8'h56;
    #100
    tx_trig <=      1'b1;
    #10
    tx_trig <=      1'b0;

    #5600
    tx_data <=      8'h78;
    #100
    tx_trig <=      1'b1;
    #10
    tx_trig <=      1'b0;
end


//例化
uart_tx uart_tx_inst(
        .clk                    (clk                    ),
        .rst_n                  (rst_n                  ),
        //uart_rx
        .tx_trig                (tx_trig                ),
        .tx_data                (tx_data                ),
        //uart_tx
        .rs232_tx               (rs232_tx               )
);

defparam    uart_tx_inst.BAUD_END   =       56;

endmodule
