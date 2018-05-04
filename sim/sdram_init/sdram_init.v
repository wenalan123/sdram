/************************************************************************
 * Author        : Wen Chunyang
 * Email         : 1494640955@qq.com
 * Create time   : 2018-04-15 21:33
 * Last modified : 2018-04-15 21:33
 * Filename      : sdram_init.v
 * Description   : 
 * *********************************************************************/
module  sdram_init(
        input                   clk                     ,
        input                   rst_n                   ,
        //
        output  reg   [ 3: 0]   cmd                     ,
        output  reg   [12: 0]   addr                    ,
        output  reg             flag_init_end 
);
//=====================================================================\
// ********** Define Parameter and Internal Signals *************
//=====================================================================/
parameter   DELAY_200US     =       10_000                      ;
parameter   CMD_END         =       11                          ;

parameter   PALL            =       4'b0010                     ;
parameter   NOP             =       4'b0111                     ;
parameter   SELF            =       4'b0001                     ;
parameter   MRS             =       4'b0000                     ;

reg     [13: 0]                 cnt                             ;
wire                            add_cnt                         ;
wire                            end_cnt                         ;

reg     [ 3: 0]                 cnt1                            ;
wire                            add_cnt1                        ;
wire                            end_cnt1                        ;

reg                             flag_200us                      ; 
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

assign  add_cnt     =       flag_200us == 1'b0;       
assign  end_cnt     =       add_cnt && cnt == DELAY_200US-1;   

//flag_200us
always  @(posedge clk or negedge rst_n)begin
    if(rst_n==1'b0)begin
        flag_200us  <=  1'b0;
    end
    else if(end_cnt)begin
        flag_200us  <=  1'b1;
    end
end

//cnt1
always @(posedge clk or negedge rst_n)begin
    if(!rst_n)begin
        cnt1 <= 0;
    end
    else if(add_cnt1)begin
        if(end_cnt1)
            cnt1 <= cnt1;
        else
            cnt1 <= cnt1 + 1;
    end
end

assign  add_cnt1        =       (flag_200us == 1'b1) && (flag_init_end == 1'b0);       
assign  end_cnt1        =       add_cnt1 && cnt1 == CMD_END-1;

//flag_init_end
always  @(posedge clk or negedge rst_n)begin
    if(rst_n==1'b0)begin
        flag_init_end   <=  1'b0;
    end
    else if(end_cnt1)begin
        flag_init_end   <=  1'b1;
    end
end

//cmd,addr
always  @(posedge clk or negedge rst_n)begin
    if(rst_n==1'b0)begin
        cmd     <=      NOP;
        addr    <=      13'b0_0100_0000_0000;
    end
    else if(flag_200us)begin
        case(cnt1)
            0:  begin
                cmd     <=      PALL;
                addr    <=      13'b0_0100_0000_0000;
            end
            1:  begin
                cmd     <=      SELF;
                addr    <=      13'b0_0100_0000_0000;
            end
            5:  begin
                cmd     <=      SELF;
                addr    <=      13'b0_0100_0000_0000;
            end
            9:  begin
                cmd     <=      MRS;
                addr    <=      13'b0_0000_0011_0010;
            end
            default:begin
                cmd     <=      NOP;
                addr    <=      13'b0_0100_0000_0000;
            end
        endcase
    end
end




endmodule
