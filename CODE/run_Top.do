vlib work
vlog Topmodule.v risc_test.v 
vsim -voptargs=+acc work.risc_test
add wave *
run -all
#quit -sim