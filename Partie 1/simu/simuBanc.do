puts "Simulation script for ModelSim "

vlib work
vcom -2008 ../src/banc_de_registre.vhd
vcom -2008 tb_banc_de_registre.vhd

vsim tb_banc_de_registre
view signals
add wave *

add wave -position inserpoint -radix decimal \
sim:/UUT/Banc

run -a