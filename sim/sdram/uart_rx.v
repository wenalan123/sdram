/************************************************************************
 * Author        : Wen Chunyang
 * Email         : 1494640955@qq.com
 * Create time   : 2018-04-15 15:08
 * Last modified : 2018-04-15 15:08
 * Filename      : uart.v
 * Description   : 
 * *********************************************************************/
module  uart_rx(
        input                   clk                     ,
        input                   rst_n                   ,
        //uart
        input                   rs232_rx                ,
        //
        output  reg   [ 7: 0]   rx_data                 ,
        output  reg             flag_rx_end
);
//=====================================================================\
// ********** Define Parameter and Internal Signals *************
//=====================================================================/
parameter   BAUD_END    =       5208                            ;
parameter   BAUD_M      =       BAUD_END/2-1                    ;
parameter   CNT1_END    =       9                               ;

reg     [ 9: 0]                 cnt0                            ;
wire                            add_cnt0                        ;
wire                            end_cnt0                        ;

reg     [ 3: 0]                 cnt1                            ;
wire                            add_cnt1                        ;
wire                            end_cnt1                        ;
reg                             rx_flag                         ; 
reg     [ 2: 0]                 rx_r                            ; 
//======================================================================
// ***************      Main    Code    ****************
//======================================================================
//rx_r 打3拍，前2拍做异步处理，后面一拍是为了获取下降沿
always  @(posedge clk or negedge rst_n)begin
    if(rst_n==1'b0)begin
        rx_r    <=      'd0;
    end
    else begin
        rx_r    <=      {rx_r[1:0],rs232_rx};
    end
end

//获取rx_r[1]的下降沿
assign  rx_neg  =   (~rx_r[1]) && rx_r[2];

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

assign  add_cnt0        =       rx_flag;
assign  end_cnt0        =       add_cnt0 && cnt0 == BAUD_END-1;

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

//rx_flag
always  @(posedge clk or negedge rst_n)begin
    if(rst_n==1'b0)begin
        rx_flag     <=      1'b0;
    end
    else if(end_cnt1)begin  
        rx_flag     <=      1'b0;
    end
    else if(rx_neg)begin  
        rx_flag     <=      1'b1;
    end
end

//rx_data
always  @(posedge clk or negedge rst_n)begin
    if(rst_n==1'b0)begin
        rx_data     <=      'd0;
    end
    else if(add_cnt0 && cnt0 == BAUD_M)begin
        rx_data     <=      {rx_r[1],rx_data[7:1]};
    end
end

//flag_rx_end
always  @(posedge clk or negedge rst_n)begin
    if(rst_n==1'b0)begin
        flag_rx_end     <=      1'b0;
    end
    else if(end_cnt1)begin
        flag_rx_end     <=      1'b1;
    end
    else begin
        flag_rx_end     <=      1'b0;
    end
end


endmodule
