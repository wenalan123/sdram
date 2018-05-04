#create work library
vlib work

vlog	"./altera_lib/*.v"
vlog	"./*.v"
#vsim -L xilinxcorelib_ver -L unisims_ver -L unimacro_ver -L secureip -lib work -voptargs=\"+acc\" -t 1ps work.tb_top #这个是ISE的ip核仿真才需要的
vsim	-voptargs=+acc work.tb_top    

# Set the window types
view wave
view structure
view signals

virtual type { {5'b00001 IDLE} {5'b00010 ARBIT} {5'b00100 AREF} {5'b01000 WRITE} } state_type
virtual function {(state_type)/tb_top/sdram_top_inst/state_c} top_state_c
virtual function {(state_type)/tb_top/sdram_top_inst/state_n} top_state_n

virtual type { {5'b00001 WR_IDLE} {5'b00010 WR_REQ} {5'b00100 WR_ACTIVE} {5'b01000 WR_WRITE} {5'b10000 WR_BREAK} } wr_state_type
virtual function {(wr_state_type)/tb_top/sdram_top_inst/sdram_write_inst/state_c} wr_state_c
virtual function {(wr_state_type)/tb_top/sdram_top_inst/sdram_write_inst/state_n} wr_state_n

virtual type { {5'b00001 RD_IDLE} {5'b00010 RD_REQ} {5'b00100 RD_ACTIVE} {5'b01000 RD_READ} {5'b10000 RD_BREAK} } rd_state_type
virtual function {(rd_state_type)/tb_top/sdram_top_inst/sdram_read_inst/state_c} rd_state_c
virtual function {(rd_state_type)/tb_top/sdram_top_inst/sdram_read_inst/state_n} rd_state_n


virtual type { {4'b0010 CMD_PALL} {4'b0111 CMD_NOP} {4'b0001 CMD_AREF} {4'b0100 CMD_WRITE} {4'b0011 CMD_ACT} {4'b0000 CMD_MRS}} cmd_type
virtual function {(cmd_type)/tb_top/sdram_top_inst/cmd} cmd_new

virtual function {(cmd_type)/tb_top/sdram_top_inst/sdram_init_inst/init_cmd} init_cmd_new
virtual function {(cmd_type)/tb_top/sdram_top_inst/sdram_write_inst/wr_cmd} wr_cmd_new
virtual function {(cmd_type)/tb_top/sdram_top_inst/sdram_read_inst/rd_cmd} rd_cmd_new

add wave -divider {tb_top}
add wave tb_top/*
add wave -divider {sdram_top}
add wave tb_top/sdram_top_inst/*

add wave -divider {sdram_init}
add wave tb_top/sdram_top_inst/sdram_init_inst/*

add wave -divider {sdram_aref}
add wave tb_top/sdram_top_inst/sdram_aref_inst/*

add wave -divider {sdram_write}
add wave tb_top/sdram_top_inst/sdram_write_inst/*

add wave -divider {sdram_read}
add wave tb_top/sdram_top_inst/sdram_read_inst/*

.main clear

run 200us
