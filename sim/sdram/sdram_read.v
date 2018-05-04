/************************************************************************
 * Author        : Wen Chunyang
 * Email         : 1494640955@qq.com
 * Create time   : 2018-04-27 15:26
 * Last modified : 2018-04-27 15:26
 * Filename      : sdram_rdite.v
 * Description   : 
 * *********************************************************************/
module  sdram_read(
        input                   clk                     ,
        input                   rst_n                   ,
        //communicate with sdram
        input                   aref_req                ,
        input                   rd_en                   ,
        input                   rd_trig                 ,
        output  wire            rd_req                  ,
        output  reg             flag_rd_end             ,
        output  reg   [ 3: 0]   rd_cmd                  ,
        output  reg   [12: 0]   rd_addr                 ,
        input   wire  [15: 0]   rd_data                 ,
        //rfifo
        output  wire            rfifo_wr_en             ,
        output  wire  [ 7: 0]   rfifo_wr_data 
);
//=====================================================================\
// ********** Define Parameter and Internal Signals *************
//=====================================================================/
parameter   RD_IDLE         =   5'b0_0001                       ;
parameter   RD_REQ          =   5'b0_0010                       ;
parameter   RD_ACTIVE       =   5'b0_0100                       ;
parameter   RD_READ         =   5'b0_1000                       ;
parameter   RD_BREAK        =   5'b1_0000                       ;
reg     [ 4: 0]                 state_c                         ;
reg     [ 4: 0]                 state_n                         ;
//CMD                                                           
parameter   CMD_PALL        =   4'b0010                         ;
parameter   CMD_NOP         =   4'b0111                         ;
parameter   CMD_AREF        =   4'b0001                         ;
parameter   CMD_WRITE       =   4'b0100                         ;
parameter   CMD_READ        =   4'b0101                         ; 
parameter   CMD_ACT         =   4'b0011                         ; 
                                                                
parameter   COL_END         =   1                               ;//rd_col_addr = {col_cnt,burst_cnt};
parameter   ROW_END         =   1                               ;
parameter   BURST_END       =   4                               ;

reg                             flag_rd                         ;
reg                             rd_data_end                     ;
reg                             sd_row_end                      ; 
reg                             flag_rd_end_temp                ; 
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

wire                            read_to_pre                     ; 
wire    [12: 0]                 rd_row_addr                     ;
wire    [ 9: 0]                 rd_col_addr                     ; 

//rfifo
reg                             wr_en                           ; 
reg     [ 1: 0]                 rfifo_wr_en_r                   ;
reg     [ 1: 0]                 end_row_cnt_r                   ; 
//======================================================================
// ***************      Main    Code    ****************
//======================================================================
//state_c
always@(posedge clk or negedge rst_n)begin
    if(!rst_n)begin
        state_c <= RD_IDLE;
    end
    else begin
        state_c <= state_n;
    end
end

//state_n
always@(*)begin
    case(state_c)
        RD_IDLE:begin
            if(rd_trig)begin
                state_n = RD_REQ;
            end
            else begin
                state_n = state_c;
            end
        end
        RD_REQ:begin
            if(rd_en)begin
                state_n = RD_ACTIVE;
            end
            else begin
                state_n = state_c;
            end
        end
        RD_ACTIVE:begin
            state_n = RD_READ;
        end
        RD_READ:begin
            if(read_to_pre)
                state_n = RD_BREAK;
            else
                state_n = state_c;
        end
        RD_BREAK:begin
            if(aref_req == 1'b1 && flag_rd == 1'b1)
                state_n = RD_REQ;
            else if(flag_rd == 1'b1)
                state_n = RD_ACTIVE;
            else
                state_n = RD_IDLE;
        end
        default:begin
            state_n = RD_IDLE;
        end
    endcase
end


//刷新时间到了，或者数据写完了，或者换行继续写
assign  read_to_pre    =       (aref_req == 1'b1 && burst_cnt == 'd0 && flag_rd == 1'b1) || (rd_data_end == 1'b1) || (sd_row_end == 1'b1 && flag_rd == 1'b1);

//flag_rd_end_temp
always  @(posedge clk or negedge rst_n)begin
    if(rst_n==1'b0)begin
        flag_rd_end_temp <=  1'b0;
    end
    else if((state_n == RD_BREAK) && ((aref_req == 1'b1 && flag_rd == 1'b1) || rd_data_end == 1'b1))begin
        flag_rd_end_temp <=  1'b1;
    end
    else begin
        flag_rd_end_temp <=  1'b0;
    end
end

//flag_rd_end
always  @(posedge clk or negedge rst_n)begin
    if(rst_n==1'b0)begin
        flag_rd_end <=  1'b0;
    end
    else begin
        flag_rd_end <=  flag_rd_end_temp;
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

assign  add_burst_cnt     =       state_n == RD_READ;       
assign  end_burst_cnt     =       add_burst_cnt && burst_cnt == BURST_END-1;   

//flag_rd
always  @(posedge clk or negedge rst_n)begin
    if(rst_n==1'b0)begin
        flag_rd <=  1'b0;
    end
    else if(rd_trig)begin
        flag_rd <=  1'b1;
    end
    else if(rd_data_end)begin
        flag_rd <=  1'b0;
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

//rd_data_end
always  @(posedge clk or negedge rst_n)begin
    if(rst_n==1'b0)begin
        rd_data_end <=  1'b0;
    end
    else begin
        rd_data_end <=  end_row_cnt;
    end
end

//rd_cmd,rd_addr
always  @(posedge clk or negedge rst_n)begin
    if(rst_n == 1'b0)begin
        rd_cmd  <=  CMD_NOP;
        rd_addr <=  13'b0_0100_0000_0000;
    end
    else begin
        case(state_n)
            RD_ACTIVE:begin
                rd_cmd  <=  CMD_ACT;
                rd_addr <=  rd_row_addr;
            end
            RD_READ:begin
                if(burst_cnt == 'd0)begin
                    rd_cmd  <=  CMD_READ;
                    rd_addr <=  {3'b000,rd_col_addr};
                end 
                else begin
                    rd_cmd  <=  CMD_NOP;
                    rd_addr <=  {3'b000,rd_col_addr};
                end
            end
            RD_BREAK:begin
                rd_cmd  <=  CMD_PALL;
                rd_addr <=  13'b0_0100_0000_0000;
            end
            default:begin
                rd_cmd  <=  CMD_NOP;
                rd_addr <=  13'b0_0100_0000_0000;
            end
        endcase
    end
end

//end_row_cnt_r
always  @(posedge clk or negedge rst_n)begin
    if(rst_n==1'b0)begin
        end_row_cnt_r   <=  2'b00;
    end
    else begin
        end_row_cnt_r   <=  {end_row_cnt_r[0],end_row_cnt};
    end
end

//wr_en
always  @(posedge clk or negedge rst_n)begin
    if(rst_n==1'b0)begin
        wr_en   <=  1'b0;
    end
    else if(state_c == RD_READ)begin
        wr_en   <=  1'b1;
    end
    else if(end_row_cnt_r[1])begin
        wr_en   <=  1'b0;
    end
end

//rfifo_wr_en_r
always  @(posedge clk or negedge rst_n)begin
    if(rst_n==1'b0)begin
        rfifo_wr_en_r   <=  2'b00;
    end
    else begin
        rfifo_wr_en_r   <=  {rfifo_wr_en_r[0],wr_en};
    end
end

assign  rfifo_wr_en     =       rfifo_wr_en_r[1];
assign  rfifo_wr_data   =       rd_data;

assign  rd_col_addr     =       {col_cnt,burst_cnt};
assign  rd_row_addr     =       row_cnt;

assign  rd_req          =       state_n ==  RD_REQ;





endmodule
