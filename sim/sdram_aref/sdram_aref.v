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
        output  wire            aref_req 
);
//=====================================================================\
// ********** Define Parameter and Internal Signals *************
//=====================================================================/
parameter   CNT1_END            =       8                       ; 
parameter   TIME_7US            =       350                     ;
parameter   PALL                =       4'b0010                 ;
parameter   NOP                 =       4'b0111                 ;
parameter   SELF                =       4'b0001                 ;


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

assign  aref_req     =       end_cnt;

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
        aref_cmd <=  NOP;
    end
    else begin
        case(cnt1)
            1       :       aref_cmd     <=  PALL;
            2       :       aref_cmd     <=  SELF;
            default :       aref_cmd     <=  NOP;
        endcase
    end
end

assign  aref_addr    =       13'b0_0100_0000_0000;





endmodule
