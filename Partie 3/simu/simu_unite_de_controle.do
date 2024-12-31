puts "Simulation script for ModelSim "

vlib work
vcom -2008 ../src/Decodeur.vhd
vcom -2008 ../src/Registre32.vhd
vcom -2008 ../src/unite_de_controle.vhd
vcom -2008 tb_unite_de_controle.vhd

vsim tb_unite_de_controle
view signals
add wave -binary /tb_unite_de_controle/UUT/Clk
add wave -binary /tb_unite_de_controle/UUT/Reset
add wave -hexadecimal /tb_unite_de_controle/UUT/Instruction
add wave -position inserpoint -radix ASCII \
sim:/tb_unite_de_controle/UUT/I_Decodeur/instr_courante
add wave -binary /tb_unite_de_controle/UUT/nPCSel
add wave -binary /tb_unite_de_controle/UUT/RegWr
add wave -binary /tb_unite_de_controle/UUT/ALUSrc
add wave -binary /tb_unite_de_controle/UUT/ALUCtrl
add wave -binary /tb_unite_de_controle/UUT/PSREN
add wave -binary /tb_unite_de_controle/UUT/MemWr
add wave -binary /tb_unite_de_controle/UUT/WrSrc
add wave -binary /tb_unite_de_controle/UUT/RegSel
add wave -binary /tb_unite_de_controle/UUT/RegAff
add wave OK

run -a