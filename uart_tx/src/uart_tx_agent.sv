class uart_tx_agent extends uvm_agent;

	`uvm_component_utils(uart_tx_agent)
	uart_tx_driver     driv;
	uart_tx_sequencer  seqr;
	uart_tx_monitor    mon;

	extern function new(string name = "uart_tx_agent", uvm_component parent); 
	extern function void build_phase(uvm_phase phase);
	extern function void connect_phase(uvm_phase phase);

endclass 

function uart_tx_agent::new(string name = "uart_tx_agent", uvm_component parent);
	super.new(name, parent);
endfunction 

function void uart_tx_agent::build_phase(uvm_phase phase);
	super.build_phase(phase);
	driv = uart_tx_driver::type_id::create("driv", this);
	seqr = uart_tx_sequencer::type_id::create("seqr", this);
	mon = uart_tx_monitor::type_id::create("mon", this);
endfunction

function void uart_tx_agent::connect_phase(uvm_phase phase);
	driv.seq_item_port.connect(seqr.seq_item_export);
endfunction


