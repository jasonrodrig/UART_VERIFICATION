class uart_tx_regression_test extends uart_tx_base_test;

	`uvm_component_utils(uart_tx_regression_test)
	uart_tx_regression_sequence seq;

	extern function new(string name = "uart_tx_regression_test", uvm_component parent);
	extern task run_phase(uvm_phase phase);

endclass

function uart_tx_regression_test::new(string name = "uart_tx_regression_test", uvm_component parent);
	super.new(name,parent);
endfunction

task uart_tx_regression_test::run_phase(uvm_phase phase);
	seq = uart_tx_regression_sequence::type_id::create("seq");
	phase.raise_objection(this);
	seq.start(env.agt.seqr);	
	phase.drop_objection(this);
endtask

