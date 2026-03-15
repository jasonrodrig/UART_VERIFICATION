QUESTA := /home/share/questa.csh
SHELL := /bin/csh

.ONESHELL:

.SILENT:
	make main

all: 
	make main 
	
main:
	source $(QUESTA)
	make clean
	vlog -sv +acc +cover +fcover -l uart_tx_top.log uart_tx_top.sv
	make compile_log_err
	vsim -vopt work.top -voptargs=+acc=npr -assertdebug -l simulation.log -sva -coverage -c -do "log -r /*; add wave -r /*; coverage save -onexit -assert -directive -cvg -codeAll coverage.ucdb; run -all; exit" -wlf waveform.wlf
	make simulate_log_err
	vcover report -html coverage.ucdb -htmldir covReport -details

read:
	source $(QUESTA)
	vcover report -details coverage.ucdb

view:
	firefox ./covReport/index.html

log:
	less -R simulation.log

compile:
	vlog -sv uart_tx_top.sv

simulate:
	vsim -c top +UVM_VERBOSITY=UVM_MEDIUM -do "run -all;exit"

clean:
	rm -rf transcript work covReport 
	rm simulation.log wave.vcd uart_tx_top.log coverage.ucdb waveform.wlf
	clear
	clear

compile_log_err:
	echo ""
	echo "-----------------------------------------------------------------"
	echo "------------------- Compilation Report --------------------------"
	echo ""
	grep "^Errors" uart_tx_top.log
	echo ""
	echo "Log file path: uart_tx_top.log"
	echo ""
	echo "-----------------------------------------------------------------"
	echo "-----------------------------------------------------------------"
	echo ""

simulate_log_err:
	echo ""
	echo "------------------------------------------------------------"
	echo "-------------------- Simulation Report ---------------------"
	echo ""
	echo "UVM Fatal"
	grep "FATAL" simulation.log || echo "No UVM_FATAL"
	echo ""
	echo "UVM Errors"
	grep "ERROR" simulation.log || echo "No UVM_ERROR"
	echo ""
	echo "UVM Warnings"
	grep "WARN" simulation.log || echo "No UVM_WARNING"
	echo ""
	echo "Waveform: vsim -view waveform.wlf &"
	echo "------------------------------------------------------------"
	echo ""
