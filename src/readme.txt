aa为写命令，bb为读命令
读写的数据长度修改：
sdram_write.v     COL_END*4
sdram_read.v	  COL_END*4
decode.v		  CNT_END    cnt的位宽