puts "Simulation script for ModelSim "

vlib work
vcom -93 ../src/mux2v1.vhd
vcom -93 tb_mux2v1.vhd

vsim tb_mux2v1
view signals


add wave -decimal /tb_mux2v1/UUT/A
add wave -decimal /tb_mux2v1/UUT/B
add wave -binary  /tb_mux2v1/UUT/COM
add wave -decimal /tb_mux2v1/UUT/S
add wave OK

run -a