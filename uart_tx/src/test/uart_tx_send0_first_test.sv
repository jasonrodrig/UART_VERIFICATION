class uart_tx_send0_first_test extends uart_tx_base_test;

	`uvm_component_utils(uart_tx_send0_first_test)
	uart_tx_send0_first_sequence seq5;

	extern function new(string name = "uart_tx_send0_first_test", uvm_component parent);
	extern task run_phase(uvm_phase phase);

endclass

function uart_tx_send0_first_test::new(string name = "uart_tx_send0_first_test", uvm_component parent);
	super.new(name,parent);
endfunction

task uart_tx_send0_first_test::run_phase(uvm_phase phase);
	seq5 = uart_tx_send0_first_sequence::type_id::create("seq5");
	phase.raise_objection(this);
	seq5.start(env.agt.seqr);	
	phase.drop_objection(this);
endtask

