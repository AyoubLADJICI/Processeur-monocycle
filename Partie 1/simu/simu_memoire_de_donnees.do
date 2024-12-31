puts "Simulation script for ModelSim "

vlib work
vcom -2008 ../src/memoire_de_donnees.vhd
vcom -2008 tb_memoire_de_donnees.vhd

vsim tb_memoire_de_donnees
view signals

add wave -binary /tb_memoire_de_donnees/UUT/CLK
add wave -binary /tb_memoire_de_donnees/UUT/Reset
add wave -binary /tb_memoire_de_donnees/UUT/WrEN
add wave -decimal /tb_memoire_de_donnees/UUT/Addr
add wave -hexadecimal /tb_memoire_de_donnees/UUT/DataIn
add wave -hexadecimal /tb_memoire_de_donnees/UUT/DataOut
add wave OK

add wave -position inserpoint -radix hexadecimal \
sim:/tb_memoire_de_donnees/UUT/memoire

run -a