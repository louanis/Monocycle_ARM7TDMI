vlib work
vcom ../../src/ALU.vhd
vcom ../../src/RegisterARM.vhd
vcom tb_ALU_RegBench.vhd
vsim tb_ALU_RegBench
add wave -hex *
run 200ns