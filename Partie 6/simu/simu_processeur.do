puts "Simulation script for ModelSim "

vlib work
vcom -2008 ../src/ual.vhd
vcom -2008 ../src/banc_de_registre.vhd
vcom -2008 ../src/mux2v1.vhd
vcom -2008 ../src/extension_signe.vhd
vcom -2008 ../src/memoire_de_donnees.vhd
vcom -2008 ../src/unite_de_traitement.vhd
vcom -2008 ../src/Registre_PC.vhd
vcom -2008 ../src/instruction_memory_IRQ.vhd
vcom -2008 ../src/unite_de_gestion.vhd
vcom -2008 ../src/decodeur.vhd
vcom -2008 ../src/Registre32.vhd
vcom -2008 ../src/unite_de_controle.vhd
vcom -2008 ../src/processeur.vhd
vcom -2008 ../src/vic.vhd
vcom -2008 tb_processeur.vhd

vsim tb_processeur
view signals
add wave -binary /tb_processeur/UUT/Clk
add wave -binary /tb_processeur/UUT/Reset
add wave -hexadecimal /tb_processeur/UUT/Afficheur
add wave -hexadecimal /tb_processeur/UUT/I_unite_de_controle/Instruction
add wave OK

run -a
