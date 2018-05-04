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

reg                             rs232_tx                        ;
wire    [ 7: 0]                 rx_data                         ;
wire                            po_flag                         ; 
reg     [ 7: 0]                 mem_a[3:0]                      ; 
//======================================================================
// ***************      Main    Code    ****************
//======================================================================
always  #5      clk    =       ~clk;
initial $readmemh("./tx_data.txt",mem_a);

task    tx_bit(
        input         [ 7: 0]   data 
);
integer i;
    for(i=0;i<10;i=i+1)begin
        case(i)
            0:  rs232_tx    <=      1'b0;
            1:  rs232_tx    <=      data[0];
            2:  rs232_tx    <=      data[1];
            3:  rs232_tx    <=      data[2];
            4:  rs232_tx    <=      data[3];
            5:  rs232_tx    <=      data[4];
            6:  rs232_tx    <=      data[5];
            7:  rs232_tx    <=      data[6];
            8:  rs232_tx    <=      data[7];
            9:  rs232_tx    <=      1'b1;
            default:
                rs232_tx    <=      1'b1;
        endcase
        #560;
    end
endtask

task    tx_byte();
    integer i;
    for(i=0;i<4;i=i+1)begin
        tx_bit(mem_a[i]);
    end
endtask

initial begin
	clk		    <=		1'b1;
	rst_n	    <=		1'b0;
    rs232_tx    <=      1'b1;
	#100
	rst_n	    <=		1'b1;
    #100
    tx_byte();
end


//例化
uart_rx uart_rx_inst(
        .clk                    (clk                    ),
        .rst_n                  (rst_n                  ),
        //uart
        .rs232_rx               (rs232_tx               ),
        //
        .rx_data                (rx_data                ),
        .po_flag                (po_flag                )
);
defparam    uart_rx_inst.BAUD_END   =   56;

endmodule
