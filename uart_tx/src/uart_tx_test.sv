class uart_tx_base_test extends uvm_test;

	`uvm_component_utils(uart_tx_base_test)
	uart_tx_environment env;
	uart_tx_sequence seq;
	uart_tx_report_server srv;

	extern function new(string name = "uart_tx_base_test", uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	extern function void end_of_elaboration();
	extern task run_phase(uvm_phase phase);

endclass

function uart_tx_base_test::new(string name = "uart_tx_base_test", uvm_component parent);
	super.new(name,parent);
endfunction

function void uart_tx_base_test::build_phase(uvm_phase phase);
	super.build_phase(phase);
	env = uart_tx_environment::type_id::create("env", this);
	seq = uart_tx_sequence::type_id::create("seq");
	srv = new();
	uvm_report_server::set_server(srv);
endfunction

function void uart_tx_base_test::end_of_elaboration();
	uvm_top.print_topology();
endfunction

task uart_tx_base_test::run_phase(uvm_phase phase);
	phase.raise_objection(this);
	seq.start(env.agt.seqr);
	// phase.phase_done.set_drain_time(this, 20);
	phase.drop_objection(this);
endtask


