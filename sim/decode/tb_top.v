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

reg     [ 7: 0]                 rx_data                         ;
reg                             rx_flag                         ;
wire                            wr_trig                         ;
wire                            rd_trig                         ;
wire                            wfifo_wr_en                     ;
wire    [ 7: 0]                 wfifo_wr_data                   ;



//======================================================================
// ***************      Main    Code    ****************
//======================================================================
always  #10      clk    =       ~clk;


initial begin
	clk		<=		1'b1;
	rst_n	<=		1'b0;
    rx_flag <=      1'b0;
    rx_data <=      8'h00;
	#100
	rst_n	<=		1'b1;
    #100
    rx_flag <=      1'b1;
    rx_data <=      8'h55;
    #20
    rx_flag <=      1'b0;
    #200

    rx_flag <=      1'b1;
    rx_data <=      8'h12;
    #20
    rx_flag <=      1'b0;
    #200

    rx_flag <=      1'b1;
    rx_data <=      8'h34;
    #20
    rx_flag <=      1'b0;
    #200

    rx_flag <=      1'b1;
    rx_data <=      8'h56;
    #20
    rx_flag <=      1'b0;
    #200

    rx_flag <=      1'b1;
    rx_data <=      8'h78;
    #20
    rx_flag <=      1'b0;
    #200

    rx_flag <=      1'b1;
    rx_data <=      8'haa;
    #20
    rx_flag <=      1'b0;


end


//例化
decode  decode_inst(
        .clk                    (clk                    ),
        .rst_n                  (rst_n                  ),
        //uart_rx
        .rx_data                (rx_data                ),
        .rx_flag                (rx_flag                ),
        .wr_trig                (wr_trig                ),
        .rd_trig                (rd_trig                ),
        .wfifo_wr_en            (wfifo_wr_en            ),
        .wfifo_wr_data          (wfifo_wr_data          )
);


endmodule
