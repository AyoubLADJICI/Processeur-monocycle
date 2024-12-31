puts "Simulation script for ModelSim "

vlib work
vcom -93 ../src/instruction_memory.vhd
vcom -93 ../src/extension_signe.vhd
vcom -93 ../src/mux2v1.vhd
vcom -93 ../src/Registre_PC.vhd
vcom -93 ../src/unite_de_gestion.vhd
vcom -93 tb_unite_de_gestion.vhd

vsim tb_unite_de_gestion
view signals
add wave -binary /tb_unite_de_gestion/UUT/Clk
add wave -binary /tb_unite_de_gestion/UUT/Reset
add wave -binary /tb_unite_de_gestion/UUT/nPCsel
add wave -hexadecimal /tb_unite_de_gestion/UUT/Offset
add wave -hexadecimal /tb_unite_de_gestion/UUT/Instruction
add wave OK

run -a
