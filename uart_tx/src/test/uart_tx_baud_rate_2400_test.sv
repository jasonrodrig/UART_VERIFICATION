class uart_tx_baud_rate_2400_test extends uart_tx_base_test;

	`uvm_component_utils(uart_tx_baud_rate_2400_test)
	uart_tx_baud_rate_2400_sequence seq1;

	extern function new(string name = "uart_tx_baud_rate_2400_test", uvm_component parent);
	extern task run_phase(uvm_phase phase);

endclass

function uart_tx_baud_rate_2400_test::new(string name = "uart_tx_baud_rate_2400_test", uvm_component parent);
	super.new(name,parent);
endfunction

task uart_tx_baud_rate_2400_test::run_phase(uvm_phase phase);
	seq1 = uart_tx_baud_rate_2400_sequence::type_id::create("seq1");
	phase.raise_objection(this);
	seq1.start(env.agt.seqr);	
	phase.drop_objection(this);
endtask

