puts "Simulation script for ModelSim "

vlib work
vcom -93 ../src/ual.vhd
vcom -93 tb_ual.vhd

vsim tb_ual
view signals
add wave *

run -a
