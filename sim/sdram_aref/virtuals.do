virtual type { \
{0x2 PALL}\
{0x7 NOP}\
{0x1 SELF}\
} cmd_type
virtual type { \
{0x1 IDLE}\
{0x2 ARBIT}\
{0x4 AREF}\
} state_type
virtual function -install /tb_top/sdram_inst -env /tb_top { (state_type)/tb_top/sdram_inst/state_c} state_c_new
virtual function -install /tb_top/sdram_inst -env /tb_top { (state_type)/tb_top/sdram_inst/state_n} state_n_new
virtual function -install /tb_top/sdram_inst -env /tb_top { (cmd_type)/tb_top/sdram_inst/cmd} cmd_new
