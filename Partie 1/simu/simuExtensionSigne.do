puts "Simulation script for ModelSim "

vlib work
vcom -93 ../src/extension_signe.vhd
vcom -93 tb_extension_signe.vhd

vsim tb_extension_signe
view signals

add wave *

run -a