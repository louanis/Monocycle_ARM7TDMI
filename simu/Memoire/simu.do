vlib work
vcom ../../src/Memoire_data.vhd
vcom tb_Memory.vhd
vsim tb_Memory
add wave -hex *
run 80ns