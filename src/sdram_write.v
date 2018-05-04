/************************************************************************
 * Author        : Wen Chunyang
 * Email         : 1494640955@qq.com
 * Create time   : 2018-04-27 15:26
 * Last modified : 2018-04-27 15:26
 * Filename      : sdram_write.v
 * Description   : 
 * *********************************************************************/
module  sdram_write(
        input                   clk                     ,
        input                   rst_n                   ,
        //communicate with sdram
        input                   aref_req                ,
        input                   wr_en                   ,
        input                   wr_trig                 ,
        output  wire            wr_req                  ,
        output  reg             flag_wr_end             ,
        output  reg   [ 3: 0]   wr_cmd                  ,
        output  reg   [12: 0]   wr_addr                 ,
        output  wire  [15: 0]   wr_data                 ,
        //wfifo
        output  wire            wfifo_rd_en             ,
        input         [ 7: 0]   wfifo_rd_data                     
);
//=====================================================================\
// ********** Define Parameter and Internal Signals *************
//=====================================================================/
parameter   WR_IDLE         =   5'b0_0001                       ;
parameter   WR_REQ          =   5'b0_0010                       ;
parameter   WR_ACTIVE       =   5'b0_0100                       ;
parameter   WR_WRITE        =   5'b0_1000                       ;
parameter   WR_BREAK        =   5'b1_0000                       ;
reg     [ 4: 0]                 state_c                         ;
reg     [ 4: 0]                 state_n                         ;
//CMD                                                           
parameter   CMD_PALL        =   4'b0010                         ;
parameter   CMD_NOP         =   4'b0111                         ;
parameter   CMD_AREF        =   4'b0001                         ;
parameter   CMD_WRITE       =   4'b0100                         ;
parameter   CMD_ACT         =   4'b0011                         ; 
//     
parameter   COL_END         =   3                               ;//wr_col_addr = {col_cnt,burst_cnt};  2*n个数
parameter   ROW_END         =   1                               ;
parameter   BURST_END       =   4                               ;

reg                             flag_wr                         ;
reg                             wr_data_end                     ;
reg                             sd_row_end                      ; 
reg                             flag_wr_end_temp                ; 
//burst_cnt
reg     [ 1: 0]                 burst_cnt                       ;
wire                            add_burst_cnt                   ;
wire                            end_burst_cnt                   ;
//col_cnt
reg     [ 7: 0]                 col_cnt                         ;
wire                            add_col_cnt                     ;
wire                            end_col_cnt                     ; 
//row_cnt
reg     [12: 0]                 row_cnt                         ;
wire                            add_row_cnt                     ;
wire                            end_row_cnt                     ; 

wire                            write_to_pre                    ; 
wire    [12: 0]                 wr_row_addr                     ;
wire    [ 9: 0]                 wr_col_addr                     ; 
//======================================================================
// ***************      Main    Code    ****************
//======================================================================
//state_c
always@(posedge clk or negedge rst_n)begin
    if(!rst_n)begin
        state_c <= WR_IDLE;
    end
    else begin
        state_c <= state_n;
    end
end

//state_n
always@(*)begin
    case(state_c)
        WR_IDLE:begin
            if(wr_trig)begin
                state_n = WR_REQ;
            end
            else begin
                state_n = state_c;
            end
        end
        WR_REQ:begin
            if(wr_en)begin
                state_n = WR_ACTIVE;
            end
            else begin
                state_n = state_c;
            end
        end
        WR_ACTIVE:begin
            state_n = WR_WRITE;
        end
        WR_WRITE:begin
            if(write_to_pre)
                state_n = WR_BREAK;
            else
                state_n = state_c;
        end
        WR_BREAK:begin
            if(aref_req == 1'b1 && flag_wr == 1'b1)
                state_n = WR_REQ;
            else if(flag_wr == 1'b1)
                state_n = WR_ACTIVE;
            else
                state_n = WR_IDLE;
        end
        default:begin
            state_n = WR_IDLE;
        end
    endcase
end


//刷新时间到了，或者数据写完了，或者换行继续写
assign  write_to_pre    =       (aref_req == 1'b1 && burst_cnt == 'd0 && flag_wr == 1'b1) || (wr_data_end == 1'b1) || (sd_row_end == 1'b1 && flag_wr == 1'b1);

//flag_wr_end_temp
always  @(posedge clk or negedge rst_n)begin
    if(rst_n==1'b0)begin
        flag_wr_end_temp <=  1'b0;
    end
    else if((state_n == WR_BREAK) && ((aref_req == 1'b1 && flag_wr == 1'b1) || wr_data_end == 1'b1))begin
        flag_wr_end_temp <=  1'b1;
    end
    else begin
        flag_wr_end_temp <=  1'b0;
    end
end

//flag_wr_end
always  @(posedge clk or negedge rst_n)begin
    if(rst_n==1'b0)begin
        flag_wr_end <=  1'b0;
    end
    else begin
        flag_wr_end <=  flag_wr_end_temp;
    end
end



//burst_cnt
always @(posedge clk or negedge rst_n)begin
    if(!rst_n)begin
        burst_cnt <= 0;
    end
    else if(add_burst_cnt)begin
        if(end_burst_cnt)
            burst_cnt <= 0;
        else
            burst_cnt <= burst_cnt + 1;
    end
end

assign  add_burst_cnt     =       state_n == WR_WRITE;       
assign  end_burst_cnt     =       add_burst_cnt && burst_cnt == BURST_END-1;   

//flag_wr
always  @(posedge clk or negedge rst_n)begin
    if(rst_n==1'b0)begin
        flag_wr <=  1'b0;
    end
    else if(wr_trig)begin
        flag_wr <=  1'b1;
    end
    else if(wr_data_end)begin
        flag_wr <=  1'b0;
    end
end


//col_cnt
always @(posedge clk or negedge rst_n)begin
    if(!rst_n)begin
        col_cnt <= 0;
    end
    else if(add_col_cnt)begin
        if(end_col_cnt)
            col_cnt <= 0;
        else
            col_cnt <= col_cnt + 1;
    end
end

assign  add_col_cnt     =       burst_cnt == 'd3;       
assign  end_col_cnt     =       add_col_cnt && col_cnt == COL_END-1;   

//sd_row_end
always  @(posedge clk or negedge rst_n)begin
    if(rst_n==1'b0)begin
        sd_row_end  <=  1'b0;
    end
    else begin
        sd_row_end  <=  end_col_cnt;
    end
end

//row_cnt
always @(posedge clk or negedge rst_n)begin
    if(!rst_n)begin
        row_cnt <= 0;
    end
    else if(add_row_cnt)begin
        if(end_row_cnt)
            row_cnt <= 0;
        else
            row_cnt <= row_cnt + 1;
    end
end

assign  add_row_cnt     =       end_col_cnt;       
assign  end_row_cnt     =       add_row_cnt && row_cnt == ROW_END-1;   

//wr_data_end
always  @(posedge clk or negedge rst_n)begin
    if(rst_n==1'b0)begin
        wr_data_end <=  1'b0;
    end
    else begin
        wr_data_end <=  end_row_cnt;
    end
end

//wr_cmd,wr_addr
always  @(posedge clk or negedge rst_n)begin
    if(rst_n == 1'b0)begin
        wr_cmd  <=  CMD_NOP;
        wr_addr <=  13'b0_0100_0000_0000;
    end
    else begin
        case(state_n)
            WR_ACTIVE:begin
                wr_cmd  <=  CMD_ACT;
                wr_addr <=  wr_row_addr;
            end
            WR_WRITE:begin
                if(burst_cnt == 'd0)begin
                    wr_cmd  <=  CMD_WRITE;
                    wr_addr <=  {3'b000,wr_col_addr};
                end 
                else begin
                    wr_cmd  <=  CMD_NOP;
                    wr_addr <=  {3'b000,wr_col_addr};
                end
            end
            WR_BREAK:begin
                wr_cmd  <=  CMD_PALL;
                wr_addr <=  13'b0_0100_0000_0000;
            end
            default:begin
                wr_cmd  <=  CMD_NOP;
                wr_addr <=  13'b0_0100_0000_0000;
            end
        endcase
    end
end

assign  wfifo_rd_en     =       state_n[3];
assign  wr_col_addr     =       {col_cnt,burst_cnt};
assign  wr_row_addr     =       row_cnt;

assign  wr_req          =       state_n ==  WR_REQ;
assign  wr_data         =       wfifo_rd_data;




endmodule
