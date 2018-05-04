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

add wave -divider {tb_top}
add wave tb_top/*
add wave -divider {sdram}
add wave tb_top/sdram_inst/*

add wave -divider {sdram_init}
add wave tb_top/sdram_inst/sdram_init_inst/*

run 400us