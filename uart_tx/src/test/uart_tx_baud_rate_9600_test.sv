class uart_tx_baud_rate_9600_test extends uart_tx_base_test;

	`uvm_component_utils(uart_tx_baud_rate_9600_test)
	uart_tx_baud_rate_9600_sequence seq3;

	extern function new(string name = "uart_tx_baud_rate_9600_test", uvm_component parent);
	extern task run_phase(uvm_phase phase);

endclass

function uart_tx_baud_rate_9600_test::new(string name = "uart_tx_baud_rate_9600_test", uvm_component parent);
	super.new(name,parent);
endfunction

task uart_tx_baud_rate_9600_test::run_phase(uvm_phase phase);
	seq3 = uart_tx_baud_rate_9600_sequence::type_id::create("seq3");
	phase.raise_objection(this);
	seq3.start(env.agt.seqr);	
	phase.drop_objection(this);
endtask

