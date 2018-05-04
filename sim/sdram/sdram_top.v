/************************************************************************
 * Author        : Wen Chunyang
 * Email         : 1494640955@qq.com
 * Create time   : 2018-04-15 18:58
 * Last modified : 2018-04-15 18:58
 * Filename      : sdram.v
 * Description   : 
 * *********************************************************************/
module  sdram_top(
        input                   clk                     ,
        input                   rst_n                   ,
        //other
        input                   wr_trig                 ,
        input                   rd_trig                 ,
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
        output  wire            DRAM_WE_N               ,
        //wfifo
        output  wire            wfifo_rd_en             ,
        output  wire  [ 7: 0]   wfifo_rd_data           ,
        //rfifo
        output  wire            rfifo_wr_en             ,
        output  wire  [ 7: 0]   rfifo_wr_data 
);
//=====================================================================\
// ********** Define Parameter and Internal Signals *************
//=====================================================================/
//state
parameter   IDLE        =       5'b0_0001                       ;
parameter   ARBIT       =       5'b0_0010                       ;
parameter   AREF        =       5'b0_0100                       ;
parameter   WRITE       =       5'b0_1000                       ;
parameter   READ        =       5'b1_0000                       ;
//CMD
parameter   CMD_NOP     =       4'b0111                         ;
reg     [ 4: 0]                 state_c                         ;
reg     [ 4: 0]                 state_n                         ; 
//sdram
reg     [ 3: 0]                 cmd                             ; 
reg     [12: 0]                 addr                            ;
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
//write
reg                             wr_en                           ;
wire                            wr_req                          ;
wire                            flag_wr_end                     ;
wire    [ 3: 0]                 wr_cmd                          ;
wire    [12: 0]                 wr_addr                         ;
wire    [15: 0]                 wr_data                         ;
//read
reg                             rd_en                           ;
wire                            rd_req                          ;
wire                            flag_rd_end                     ;
wire    [ 3: 0]                 rd_cmd                          ;
wire    [12: 0]                 rd_addr                         ;
wire    [15: 0]                 rd_data                         ;
//======================================================================
// ***************      Main    Code    ****************
//======================================================================
assign  {DRAM_CS_N,DRAM_RAS_N,DRAM_CAS_N,DRAM_WE_N}     =       cmd;
assign  DRAM_ADDR               =       addr;
assign  DRAM_CKE                =       1'b1;
assign  DRAM_DQM                =       2'b00;
assign  DRAM_CLK                =       ~clk;
assign  DRAM_BA                 =       2'b00;
assign  DRAM_DQ                 =       (state_c == WRITE) ? wr_data : 16'dz;
assign  rd_data                 =       DRAM_DQ;  
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
            else if(wr_en)begin
                state_n = WRITE;
            end
            else if(rd_en)begin
                state_n = READ;
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
        WRITE:begin
            if(flag_wr_end)
                state_n = ARBIT;
            else
                state_n = state_c;
        end
        READ:begin
            if(flag_rd_end)
                state_n = ARBIT;
            else
                state_n = state_c;
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
    else if(state_c == ARBIT && aref_req == 1'b1)begin
        aref_en  <=  1'b1;
    end
    else if(flag_aref_end)begin
        aref_en  <=  1'b0;
    end
end

//wr_en
always  @(posedge clk or negedge rst_n)begin
    if(rst_n==1'b0)begin
        wr_en   <=  1'b0;
    end
    else if(state_c == ARBIT && aref_req == 1'b0 && wr_req == 1'b1)begin
        wr_en   <=  1'b1;
    end
    else begin
        wr_en   <=  1'b0;
    end
end

//rd_en
always  @(posedge clk or negedge rst_n)begin
    if(rst_n==1'b0)begin
        rd_en   <=  1'b0;
    end
    else if(state_c == ARBIT && aref_req == 1'b0 && wr_req == 1'b0 && rd_req == 1'b1)begin
        rd_en   <=  1'b1;
    end
    else begin
        rd_en   <=  1'b0;
    end
end

//cmd,addr
always  @(*)begin
    case(state_n)
        IDLE:begin
            cmd     <=  init_cmd;
            addr    <=  init_addr;
        end
        ARBIT:begin
            cmd     <=  CMD_NOP;
            addr    <=  init_addr;
        end
        AREF:begin
            cmd     <=  aref_cmd;
            addr    <=  aref_addr;
        end
        WRITE:begin
            cmd     <=  wr_cmd;
            addr    <=  wr_addr;
        end
        READ:begin
            cmd     <=  rd_cmd;
            addr    <=  rd_addr;
        end
        default:begin
            cmd     <=  cmd;
            addr    <=  addr;
        end
    endcase
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

sdram_write sdram_write_inst(
        .clk                    (clk                    ),
        .rst_n                  (rst_n                  ),
        //communicate with sdram
        .aref_req               (aref_req               ),
        .wr_en                  (wr_en                  ),
        .wr_trig                (wr_trig                ),
        .wr_req                 (wr_req                 ),
        .flag_wr_end            (flag_wr_end            ),
        .wr_cmd                 (wr_cmd                 ),
        .wr_addr                (wr_addr                ),
        .wr_data                (wr_data                ),
        //wfifo
        .wfifo_rd_en            (wfifo_rd_en            ),
        .wfifo_rd_data          (wfifo_rd_data          )
);

sdram_read  sdram_read_inst(
        .clk                    (clk                    ),
        .rst_n                  (rst_n                  ),
        //communicate with sdram
        .aref_req               (aref_req               ),
        .rd_en                  (rd_en                  ),
        .rd_trig                (rd_trig                ),
        .rd_req                 (rd_req                 ),
        .flag_rd_end            (flag_rd_end            ),
        .rd_cmd                 (rd_cmd                 ),
        .rd_addr                (rd_addr                ),
        .rd_data                (rd_data                ),
        //rfifo
        .rfifo_wr_en            (rfifo_wr_en            ),
        .rfifo_wr_data          (rfifo_wr_data          )
);

endmodule
