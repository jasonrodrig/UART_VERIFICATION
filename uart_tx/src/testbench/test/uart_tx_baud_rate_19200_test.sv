class uart_tx_baud_rate_19200_test extends uart_tx_base_test;

	`uvm_component_utils(uart_tx_baud_rate_19200_test)
	uart_tx_baud_rate_19200_sequence seq4;

	extern function new(string name = "uart_tx_baud_rate_19200_test", uvm_component parent);
	extern task run_phase(uvm_phase phase);

endclass

function uart_tx_baud_rate_19200_test::new(string name = "uart_tx_baud_rate_19200_test", uvm_component parent);
	super.new(name,parent);
endfunction

task uart_tx_baud_rate_19200_test::run_phase(uvm_phase phase);
	seq4 = uart_tx_baud_rate_19200_sequence::type_id::create("seq4");
	phase.raise_objection(this);
	seq4.start(env.agt.seqr);	
	phase.drop_objection(this);
endtask

