transcript on


vlib work

vlog -sv ../src/lifo.sv
vlog -sv ../src/ram_memory.sv
vlog -sv ../src/pntr_logic.sv
vlog -sv ./lifo_tb.sv

vsim -novopt lifo_tb 

add wave /lifo_tb/clk
add wave /lifo_tb/rst
add wave /lifo_tb/wrreq_i
add wave -radix hex /lifo_tb/data_i
add wave /lifo_tb/rdreq_i
add wave -radix hex /lifo_tb/q_o
add wave /lifo_tb/empty_o
add wave /lifo_tb/full_o
add wave -radix unsigned /lifo_tb/usedw_o


run -all

