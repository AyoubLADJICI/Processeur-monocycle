puts "Simulation script for ModelSim "

vlib work
vcom -93 ../src/vic.vhd
vcom -93 tb_vic.vhd



vsim tb_vic
view signals
add wave -binary /tb_vic/vic_inst/Clk
add wave -binary /tb_vic/vic_inst/Reset
add wave -binary /tb_vic/vic_inst/IRQ_SERV
add wave -binary /tb_vic/vic_inst/IRQ0
add wave -position inserpoint -radix binary \
sim:/vic_inst/IRQ0_memo
add wave -binary /tb_vic/vic_inst/IRQ1
add wave -position inserpoint -radix binary \
sim:/vic_inst/IRQ1_memo
add wave -binary /tb_vic/vic_inst/IRQ
add wave -hexadecimal /tb_vic/vic_inst/VICPC
add wave OK


run -a