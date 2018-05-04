/************************************************************************
 * Author        : Wen Chunyang
 * Email         : 1494640955@qq.com
 * Create time   : 2018-04-15 17:07
 * Last modified : 2018-04-15 17:07
 * Filename      : uart_tx.v
 * Description   : 
 * *********************************************************************/
module  uart_tx(
        input                   clk                     ,
        input                   rst_n                   ,
        //uart_rx
        input                   tx_trig                 ,
        input         [ 7: 0]   tx_data                 ,
        //uart_tx
        output  reg             rs232_tx 
);
//=====================================================================\
// ********** Define Parameter and Internal Signals *************
//=====================================================================/
parameter   BAUD_END    =       5208                            ;
parameter   CNT1_END    =       10                              ;

reg     [12: 0]                 cnt0                            ;
wire                            add_cnt0                        ;
wire                            end_cnt0                        ;

reg     [ 3: 0]                 cnt1                            ;
wire                            add_cnt1                        ;
wire                            end_cnt1                        ;

reg                             flag                            ;
reg     [ 7: 0]                 tx_data_temp                    ; 
wire    [ 9: 0]                 data                            ; 
//======================================================================
// ***************      Main    Code    ****************
//======================================================================
//cnt0
always @(posedge clk or negedge rst_n)begin
    if(!rst_n)begin
        cnt0 <= 0;
    end
    else if(add_cnt0)begin
        if(end_cnt0)
            cnt0 <= 0;
        else
            cnt0 <= cnt0 + 1;
    end
end

assign  add_cnt0        =       flag;
assign  end_cnt0        =       add_cnt0 && cnt0 == BAUD_END-1;

//cnt1
always @(posedge clk or negedge rst_n)begin 
    if(!rst_n)begin
        cnt1 <= 0;
    end
    else if(add_cnt1)begin
        if(end_cnt1)
            cnt1 <= 0;
        else
            cnt1 <= cnt1 + 1;
    end
end

assign  add_cnt1        =       end_cnt0;
assign  end_cnt1        =       add_cnt1 && cnt1 == CNT1_END-1;

//flag
always  @(posedge clk or negedge rst_n)begin
    if(rst_n==1'b0)begin
        flag    <=      1'b0;
    end
    else if(tx_trig)begin
        flag    <=      1'b1;
    end
    else if(end_cnt1)begin

    end
end

assign  data    =       {1'b1,tx_data_temp,1'b0};

//tx_data_temp
always  @(posedge clk or negedge rst_n)begin
    if(rst_n==1'b0)begin
        tx_data_temp    <=      8'h00;
    end
    else if(tx_trig)begin
        tx_data_temp    <=      tx_data;
    end
end

//rs232_tx
always  @(posedge clk or negedge rst_n)begin
    if(rst_n==1'b0)begin
        rs232_tx    <=      1'b1;
    end
    else if(add_cnt0 && cnt0 == 1-1)begin
        rs232_tx    <=      data[cnt1];
    end
end


endmodule
