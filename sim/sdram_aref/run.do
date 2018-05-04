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

virtual type { {5'b00001 IDLE} {5'b00010 ARBIT} {5'b00100 AREF} } state_type
virtual function {(state_type)/tb_top/sdram_inst/state_c} state_c_new
virtual function {(state_type)/tb_top/sdram_inst/state_n} state_n_new


virtual type { {4'b0010 CMD_PALL} {4'b0111 CMD_NOP} {4'b0001 CMD_AREF} } cmd_type
virtual function {(cmd_type)/tb_top/sdram_inst/cmd} cmd_new

add wave -divider {tb_top}
add wave tb_top/*
add wave -divider {sdram}
add wave tb_top/sdram_inst/*

add wave -divider {sdram_init}
add wave tb_top/sdram_inst/sdram_init_inst/*

add wave -divider {sdram_aref}
add wave tb_top/sdram_inst/sdram_aref_inst/*


.main clear

run 225us
