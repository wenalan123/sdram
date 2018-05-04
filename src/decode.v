/************************************************************************
 * Author        : Wen Chunyang
 * Email         : 1494640955@qq.com
 * Create time   : 2018-04-29 20:44
 * Last modified : 2018-04-29 20:44
 * Filename      : decode.v
 * Description   : 
 * *********************************************************************/
module  decode(
        input                   clk                     ,
        input                   rst_n                   ,
        //uart_rx
        input         [ 7: 0]   rx_data                 ,
        input                   flag_rx_end             ,
        output  reg             wr_trig                 ,
        output  reg             rd_trig                 ,
        output  reg             wfifo_wr_en             ,
        output  wire  [ 7: 0]   wfifo_wr_data 
);
//=====================================================================\
// ********** Define Parameter and Internal Signals *************
//=====================================================================/
parameter   CNT_END     =       12                              ;

reg     [ 3: 0]                 cnt                             ;
wire                            add_cnt                         ;
wire                            end_cnt                         ;

reg                             flag                            ;

//======================================================================
// ***************      Main    Code    ****************
//======================================================================
//cnt
always @(posedge clk or negedge rst_n)begin
    if(!rst_n)begin
        cnt <= 0;
    end
    else if(add_cnt)begin
        if(end_cnt)
            cnt <= 0;
        else
            cnt <= cnt + 1;
    end
end

assign  add_cnt     =       flag && flag_rx_end;       
assign  end_cnt     =       add_cnt && cnt == CNT_END-1;

//flag
always  @(posedge clk or negedge rst_n)begin
    if(rst_n==1'b0)begin
        flag    <=  1'b0;
    end
    else if(flag_rx_end && rx_data == 8'haa)begin
        flag    <=  1'b1;
    end
    else if(end_cnt)begin
        flag    <=  1'b0;
    end
end

//wr_trig
always  @(posedge clk or negedge rst_n)begin
    if(rst_n==1'b0)begin
        wr_trig <=  1'b0;
    end
    else if(add_cnt && cnt == CNT_END-1)begin
        wr_trig <=  1'b1;
    end
    else begin
        wr_trig <=  1'b0;
    end
end

//rd_trig
always  @(posedge clk or negedge rst_n)begin
    if(rst_n==1'b0)begin
        rd_trig <=  1'b0;
    end
    else if(flag_rx_end && rx_data == 8'hbb)begin
        rd_trig <=  1'b1;
    end
    else begin
        rd_trig <=  1'b0;
    end
end

//wfifo_wr_en
always  @(posedge clk or negedge rst_n)begin
    if(rst_n==1'b0)begin
        wfifo_wr_en <=  1'b0;
    end
    else if(flag)begin
        wfifo_wr_en <=  flag_rx_end;
    end
    else begin
        wfifo_wr_en <=  1'b0;
    end
end

assign  wfifo_wr_data   =   rx_data;






endmodule
