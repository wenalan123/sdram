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


reg     [ 7: 0]                 mem_a[5:0]                      ;
reg     [ 7: 0]                 mem_b[5:0]                      ;



//======================================================================
// ***************      Main    Code    ****************
//======================================================================
always  #10      clk    =       ~clk;

initial $readmemh("./tx_data.txt",mem_a);
initial $readmemh("./tx_data2.txt",mem_b);
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
    for(i=0;i<6;i=i+1)begin
        tx_bit(mem_a[i]);
    end
endtask

task    tx_byte2();
    integer i;
    for(i=0;i<6;i=i+1)begin
        tx_bit(mem_b[i]);
    end
endtask

initial begin
	clk		<=		1'b1;
	rst_n	<=		1'b0;
    rs232_tx<=      1'b1;
	#100
	rst_n	<=		1'b1;
    #205000
    tx_byte();
    #2000
    tx_byte2();
end


//例化
sdram_model_plus    sdram_model_plus_inst(
        .Dq                     (DRAM_DQ                ),
        .Addr                   (DRAM_ADDR              ),
        .Ba                     (DRAM_BA                ),
        .Clk                    (DRAM_CLK               ),
        .Cke                    (DRAM_CKE               ),
        .Cs_n                   (DRAM_CS_N              ),
        .Ras_n                  (DRAM_RAS_N             ),
        .Cas_n                  (DRAM_CAS_N             ),
        .We_n                   (DRAM_WE_N              ),
        .Dqm                    (DRAM_DQM               ),
        .Debug                  (1'b1                   )
);

top top_inst(
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
        .DRAM_WE_N              (DRAM_WE_N              ),
        //rs232
        .rs232_rx               (rs232_tx               ),
        .rs232_tx               (                       )
);

defparam    sdram_model_plus_inst.addr_bits    =       13;
defparam    sdram_model_plus_inst.data_bits    =       16;
defparam    sdram_model_plus_inst.col_bits     =       10;
defparam    sdram_model_plus_inst.mem_sizes    =       2*1024*1024-1;

defparam    top_inst.uart_rx_inst.BAUD_END     =       28;
defparam    top_inst.uart_tx_inst.BAUD_END     =       28;
endmodule
