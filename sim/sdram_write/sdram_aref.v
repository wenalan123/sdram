/************************************************************************
 * Author        : Wen Chunyang
 * Email         : 1494640955@qq.com
 * Create time   : 2018-04-26 16:38
 * Last modified : 2018-04-26 16:38
 * Filename      : sdram_aref.v
 * Description   : 
 * *********************************************************************/
module  sdram_aref(
        input                   clk                     ,
        input                   rst_n                   ,
        //communicatino with sdram     
        input                   flag_init_end           ,
        input                   aref_en                  ,
        output  wire            flag_aref_end            ,
        output  reg   [ 3: 0]   aref_cmd                 ,
        output  wire  [12: 0]   aref_addr                ,
        output  reg             aref_req 
);
//=====================================================================\
// ********** Define Parameter and Internal Signals *************
//=====================================================================/
parameter   CNT1_END        =       7                           ; 
parameter   TIME_7US        =       350                         ;
//CMD
parameter   CMD_PALL        =       4'b0010                     ;
parameter   CMD_NOP         =       4'b0111                     ;
parameter   CMD_AREF        =       4'b0001                     ;


reg     [ 8: 0]                 cnt                             ;
wire                            add_cnt                         ;
wire                            end_cnt                         ; 

reg     [ 2: 0]                 cnt1                            ;
wire                            add_cnt1                        ;
wire                            end_cnt1                        ;

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

assign  add_cnt     =       flag_init_end;       
assign  end_cnt     =       add_cnt && cnt == TIME_7US-1;   

//aref_req
always  @(posedge clk or negedge rst_n)begin
    if(rst_n==1'b0)begin
        aref_req    <=  1'b0;
    end
    else if(end_cnt)begin
        aref_req    <=  1'b1;
    end
    else if(aref_en)begin
        aref_req    <=  1'b0;
    end
end


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

assign  add_cnt1        =       aref_en;       
assign  end_cnt1        =       add_cnt1 && cnt1 == CNT1_END-1;

assign  flag_aref_end    =       end_cnt1;

//aref_cmd
always  @(posedge clk or negedge rst_n)begin
    if(rst_n==1'b0)begin
        aref_cmd <=  CMD_NOP;
    end
    else if(cnt1 == 'd1)begin
            aref_cmd     <=  CMD_AREF;
    end
    else begin
        aref_cmd     <=  CMD_NOP;
    end

end

assign  aref_addr    =       13'b0_0100_0000_0000;





endmodule
