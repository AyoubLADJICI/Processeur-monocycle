puts "Simulation script for ModelSim "

vlib work
vcom -93 ../src/ual.vhd
vcom -93 ../src/banc_de_registre.vhd
vcom -93 ../src/mux2v1.vhd
vcom -93 ../src/extension_signe.vhd
vcom -93 ../src/memoire_de_donnees.vhd
vcom -93 ../src/unite_de_traitement.vhd
vcom -93 tb_unite_de_traitement.vhd

vsim tb_unite_de_traitement
view signals
add wave -binary /tb_unite_de_traitement/UUT/CLK
add wave -binary /tb_unite_de_traitement/UUT/Reset
add wave -binary /tb_unite_de_traitement/UUT/OP
add wave -binary /tb_unite_de_traitement/UUT/RA
add wave -binary /tb_unite_de_traitement/UUT/RB
add wave -binary /tb_unite_de_traitement/UUT/RW
add wave WE
add wave COM1
add wave COM2
add wave -binary /tb_unite_de_traitement/UUT/Imm
add wave N
add wave Z
add wave C
add wave V
add wave -hexadecimal /tb_unite_de_traitement/UUT/Sout
add wave OK

run -a