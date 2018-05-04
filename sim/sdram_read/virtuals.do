virtual type { \
{0x2 PALL}\
{0x7 NOP}\
{0x1 AREF}\
{0x4 WRITE}\
{0x3 ACT}\
{0x0 MRS}\
{0x5 READ}\
} cmd_type
virtual type { \
{0x1 RD_IDLE}\
{0x2 RD_REQ}\
{0x4 RD_ACTIVE}\
{0x8 RD_READ}\
{0x10 RD_BREAK}\
} rd_state_type
virtual type { \
{0x1 WR_IDLE}\
{0x2 WR_REQ}\
{0x4 WR_ACTIVE}\
{0x8 WR_WRITE}\
{0x10 WR_BREAK}\
} wr_state_type
virtual type { \
{0x1 IDLE}\
{0x2 ARBIT}\
{0x4 AREF}\
{0x8 WRITE}\
} state_type
virtual function -install /tb_top/sdram_top_inst -env /tb_top { (state_type)/tb_top/sdram_top_inst/state_c} top_state_c
virtual function -install /tb_top/sdram_top_inst -env /tb_top { (state_type)/tb_top/sdram_top_inst/state_n} top_state_n
virtual function -install /tb_top/sdram_top_inst/sdram_write_inst -env /tb_top { (wr_state_type)/tb_top/sdram_top_inst/sdram_write_inst/state_c} wr_state_c
virtual function -install /tb_top/sdram_top_inst/sdram_write_inst -env /tb_top { (wr_state_type)/tb_top/sdram_top_inst/sdram_write_inst/state_n} wr_state_n
virtual function -install /tb_top/sdram_top_inst/sdram_read_inst -env /tb_top { (rd_state_type)/tb_top/sdram_top_inst/sdram_read_inst/state_c} rd_state_c
virtual function -install /tb_top/sdram_top_inst/sdram_read_inst -env /tb_top { (rd_state_type)/tb_top/sdram_top_inst/sdram_read_inst/state_n} rd_state_n
virtual function -install /tb_top/sdram_top_inst -env /tb_top { (cmd_type)/tb_top/sdram_top_inst/cmd} cmd_new
virtual function -install /tb_top/sdram_top_inst/sdram_init_inst -env /tb_top { (cmd_type)/tb_top/sdram_top_inst/sdram_init_inst/init_cmd} init_cmd_new
virtual function -install /tb_top/sdram_top_inst/sdram_write_inst -env /tb_top { (cmd_type)/tb_top/sdram_top_inst/sdram_write_inst/wr_cmd} wr_cmd_new
virtual function -install /tb_top/sdram_top_inst/sdram_read_inst -env /tb_top { (cmd_type)/tb_top/sdram_top_inst/sdram_read_inst/rd_cmd} rd_cmd_new
virtual type { \
{0x2 PALL}\
{0x7 NOP}\
{0x1 AREF}\
{0x4 WRITE}\
{0x3 ACT}\
{0x0 MRS}\
{0x5 READ}\
} cmd_type
virtual type { \
{0x1 RD_IDLE}\
{0x2 RD_REQ}\
{0x4 RD_ACTIVE}\
{0x8 RD_READ}\
{0x10 RD_BREAK}\
} rd_state_type
virtual type { \
{0x1 WR_IDLE}\
{0x2 WR_REQ}\
{0x4 WR_ACTIVE}\
{0x8 WR_WRITE}\
{0x10 WR_BREAK}\
} wr_state_type
virtual type { \
{0x1 IDLE}\
{0x2 ARBIT}\
{0x4 AREF}\
{0x8 WRITE}\
} state_type
virtual function -install /tb_top/sdram_top_inst -env /tb_top { (state_type)/tb_top/sdram_top_inst/state_c} top_state_c
virtual function -install /tb_top/sdram_top_inst -env /tb_top { (state_type)/tb_top/sdram_top_inst/state_n} top_state_n
virtual function -install /tb_top/sdram_top_inst/sdram_write_inst -env /tb_top { (wr_state_type)/tb_top/sdram_top_inst/sdram_write_inst/state_c} wr_state_c
virtual function -install /tb_top/sdram_top_inst/sdram_write_inst -env /tb_top { (wr_state_type)/tb_top/sdram_top_inst/sdram_write_inst/state_n} wr_state_n
virtual function -install /tb_top/sdram_top_inst/sdram_read_inst -env /tb_top { (rd_state_type)/tb_top/sdram_top_inst/sdram_read_inst/state_c} rd_state_c
virtual function -install /tb_top/sdram_top_inst/sdram_read_inst -env /tb_top { (rd_state_type)/tb_top/sdram_top_inst/sdram_read_inst/state_n} rd_state_n
virtual function -install /tb_top/sdram_top_inst -env /tb_top { (cmd_type)/tb_top/sdram_top_inst/cmd} cmd_new
virtual function -install /tb_top/sdram_top_inst/sdram_init_inst -env /tb_top { (cmd_type)/tb_top/sdram_top_inst/sdram_init_inst/init_cmd} init_cmd_new
virtual function -install /tb_top/sdram_top_inst/sdram_write_inst -env /tb_top { (cmd_type)/tb_top/sdram_top_inst/sdram_write_inst/wr_cmd} wr_cmd_new
virtual function -install /tb_top/sdram_top_inst/sdram_read_inst -env /tb_top { (cmd_type)/tb_top/sdram_top_inst/sdram_read_inst/rd_cmd} rd_cmd_new
virtual type { \
{0x2 PALL}\
{0x7 NOP}\
{0x1 AREF}\
{0x4 WRITE}\
{0x3 ACT}\
{0x0 MRS}\
{0x5 READ}\
} cmd_type
virtual type { \
{0x1 RD_IDLE}\
{0x2 RD_REQ}\
{0x4 RD_ACTIVE}\
{0x8 RD_READ}\
{0x10 RD_BREAK}\
} rd_state_type
virtual type { \
{0x1 WR_IDLE}\
{0x2 WR_REQ}\
{0x4 WR_ACTIVE}\
{0x8 WR_WRITE}\
{0x10 WR_BREAK}\
} wr_state_type
virtual type { \
{0x1 IDLE}\
{0x2 ARBIT}\
{0x4 AREF}\
{0x8 WRITE}\
} state_type
virtual function -install /tb_top/sdram_top_inst -env /tb_top { (state_type)/tb_top/sdram_top_inst/state_c} top_state_c
virtual function -install /tb_top/sdram_top_inst -env /tb_top { (state_type)/tb_top/sdram_top_inst/state_n} top_state_n
virtual function -install /tb_top/sdram_top_inst/sdram_write_inst -env /tb_top { (wr_state_type)/tb_top/sdram_top_inst/sdram_write_inst/state_c} wr_state_c
virtual function -install /tb_top/sdram_top_inst/sdram_write_inst -env /tb_top { (wr_state_type)/tb_top/sdram_top_inst/sdram_write_inst/state_n} wr_state_n
virtual function -install /tb_top/sdram_top_inst/sdram_read_inst -env /tb_top { (rd_state_type)/tb_top/sdram_top_inst/sdram_read_inst/state_c} rd_state_c
virtual function -install /tb_top/sdram_top_inst/sdram_read_inst -env /tb_top { (rd_state_type)/tb_top/sdram_top_inst/sdram_read_inst/state_n} rd_state_n
virtual function -install /tb_top/sdram_top_inst -env /tb_top { (cmd_type)/tb_top/sdram_top_inst/cmd} cmd_new
virtual function -install /tb_top/sdram_top_inst/sdram_init_inst -env /tb_top { (cmd_type)/tb_top/sdram_top_inst/sdram_init_inst/init_cmd} init_cmd_new
virtual function -install /tb_top/sdram_top_inst/sdram_write_inst -env /tb_top { (cmd_type)/tb_top/sdram_top_inst/sdram_write_inst/wr_cmd} wr_cmd_new
virtual function -install /tb_top/sdram_top_inst/sdram_read_inst -env /tb_top { (cmd_type)/tb_top/sdram_top_inst/sdram_read_inst/rd_cmd} rd_cmd_new
