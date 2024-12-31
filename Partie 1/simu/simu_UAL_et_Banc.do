puts "Simulation script for ModelSim "

vlib work
vcom -2008 ../src/banc_de_registre.vhd
vcom -2008 ../src/ual.vhd
vcom -2008 ../src/ual_et_banc_de_registre.vhd
vcom -2008 tb_ual_et_banc_de_registre.vhd

vsim tb_ual_et_banc_de_registre
view signals
add wave *

add wave -position inserpoint -radix decimal \
sim:/tb_ual_et_banc_de_registre/UUT/I_banc_de_registre/Banc

run -a