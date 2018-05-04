/************************************************************************
 * Author        : Wen Chunyang
 * Email         : 1494640955@qq.com
 * Create time   : 2018-04-15 18:58
 * Last modified : 2018-04-15 18:58
 * Filename      : sdram.v
 * Description   : 
 * *********************************************************************/
module  sdram(
        input                   CLOCK_50                ,
        input                   rst_n                   ,
        //sdram
        output  wire  [12: 0]   DRAM_ADDR               ,
        output  wire  [ 1: 0]   DRAM_BA                 ,
        output  wire            DRAM_CAS_N              ,
        output  wire            DRAM_CKE                ,
        output  wire            DRAM_CLK                ,
        output  wire            DRAM_CS_N               ,
        inout   wire  [15: 0]   DRAM_DQ                 ,
        output  wire  [ 3: 0]   DRAM_DQM                ,
        output  wire            DRAM_RAS_N              ,
        output  wire            DRAM_WE_N               
);
//=====================================================================\
// ********** Define Parameter and Internal Signals *************
//=====================================================================/
parameter   IDLE        =       5'b0_0001                       ;
parameter   ARBIT       =       5'b0_0010                       ;
parameter   AREF        =       5'b0_0100                       ;

reg     [ 4: 0]                 state_c                        ;
reg     [ 4: 0]                 state_n                        ; 

//sdram
reg     [ 3: 0]                 cmd                             ; 
reg     [12: 0]                 addr                            ;
wire                            clk                             ; 
//init
wire    [ 3: 0]                 init_cmd                        ;
wire    [12: 0]                 init_addr                       ; 
wire                            flag_init_end                   ; 

//aref
wire                            flag_aref_end                   ;
wire    [ 3: 0]                 aref_cmd                        ;
wire    [12: 0]                 aref_addr                       ;
wire                            aref_req                        ;
reg                             aref_en                         ; 

//======================================================================
// ***************      Main    Code    ****************
//======================================================================
assign  {DRAM_CS_N,DRAM_RAS_N,DRAM_CAS_N,DRAM_WE_N}     =       cmd;
assign  DRAM_ADDR               =       addr;
assign  DRAM_CKE                =       1'b1;
assign  DRAM_DQM                =       2'b00;
assign  DRAM_CLK                =       ~CLOCK_50;
assign  DRAM_BA                 =       2'b00;
assign  clk                     =       CLOCK_50;

//state_c
always@(posedge clk or negedge rst_n)begin
    if(!rst_n)begin
        state_c <= IDLE;
    end
    else begin
        state_c <= state_n;
    end
end


//state_n
always@(*)begin
    case(state_c)
        IDLE:begin
            if(flag_init_end)begin
                state_n = ARBIT;
            end
            else begin
                state_n = state_c;
            end
        end
        ARBIT:begin
            if(aref_en)begin
                state_n = AREF;
            end
            else begin
                state_n = state_c;
            end
        end
        AREF:begin
            if(flag_aref_end)begin
                state_n = ARBIT;
            end
            else begin
                state_n = state_c;
            end
        end
        default:begin
            state_n = IDLE;
        end
    endcase
end

//aref_en
always  @(posedge clk or negedge rst_n)begin
    if(rst_n==1'b0)begin
        aref_en  <=  1'b0;
    end
    else if(aref_req)begin
        aref_en  <=  1'b1;
    end
    else if(flag_aref_end)begin
        aref_en  <=  1'b0;
    end
end

//cmd,addr
always  @(posedge clk or negedge rst_n)begin
    if(rst_n==1'b0)begin
        cmd     <=      init_cmd;
        addr    <=      init_addr;
    end
    else begin
        case(state_n)
            IDLE:begin
                cmd     <=  init_cmd;
                addr    <=  init_addr;
            end
            AREF:begin
                cmd     <=  aref_cmd;
                addr    <=  init_addr;
            end
            default:begin
                cmd     <=  aref_cmd;
                addr    <=  init_addr;
            end
        endcase
    end
end








sdram_init  sdram_init_inst(
        .clk                    (clk                    ),
        .rst_n                  (rst_n                  ),
        //
        .init_cmd               (init_cmd               ),
        .init_addr              (init_addr              ),
        .flag_init_end          (flag_init_end          )
);

sdram_aref  sdram_aref_inst(
        .clk                     (clk                   ),
        .rst_n                   (rst_n                 ),
        //communicatino with sdram               
        .flag_init_end           (flag_init_end         ),
        .aref_en                 (aref_en               ),
        .flag_aref_end           (flag_aref_end         ),
        .aref_cmd                (aref_cmd              ),
        .aref_addr               (aref_addr             ),
        .aref_req                (aref_req              )
);



endmodule
