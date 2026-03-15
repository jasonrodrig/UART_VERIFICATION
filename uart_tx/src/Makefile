QUESTA := /home/share/questa.csh
SHELL := /bin/csh

.ONESHELL:

all: 
	make main 
	
main:
	source $(QUESTA)
	make clean
	vlog -sv +acc +cover +fcover -l uart_tx_top.log uart_tx_top.sv
	vsim -vopt work.top -voptargs=+acc=npr -assertdebug -l simulation.log -coverage -c -do "coverage save -onexit -assert -directive -cvg -codeAll coverage.ucdb; run -all; exit"
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
	rm simulation.log wave.vcd uart_tx_top.log coverage.ucdb
	clear
	clear

