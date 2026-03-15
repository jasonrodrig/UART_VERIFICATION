class uart_tx_environment extends uvm_env;

	`uvm_component_utils(uart_tx_environment)
	uart_tx_agent       agt;
	uart_tx_scoreboard  scb;
  uart_tx_subscriber  sub;

	extern function new(string name = "uart_tx_environment", uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	extern function void connect_phase(uvm_phase phase);

endclass

function uart_tx_environment::new(string name = "uart_tx_environment", uvm_component parent);
	super.new(name, parent);
endfunction

function void uart_tx_environment::build_phase(uvm_phase phase);
	super.build_phase(phase);
	agt = uart_tx_agent::type_id::create("agt", this);
	scb = uart_tx_scoreboard::type_id::create("scb", this);
	sub = uart_tx_subscriber::type_id::create("sub", this);
endfunction

function void uart_tx_environment::connect_phase(uvm_phase phase);
	agt.mon.mon_port.connect(scb.scb_port);
	agt.mon.mon_port.connect(sub.analysis_export);
endfunction


