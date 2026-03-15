class uart_tx_monitor extends uvm_monitor;

	`uvm_component_utils(uart_tx_monitor)
	virtual uart_tx_interface.MONITOR vif;
	uvm_analysis_port#(uart_tx_sequence_item) mon_port;
	uart_tx_sequence_item seq;

	extern function new (string name = "uart_tx_monitor", uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	extern task run_phase(uvm_phase phase);
	extern task uart_tx_monitor_code();

endclass

function uart_tx_monitor:: new (string name = "uart_tx_monitor", uvm_component parent);
	super.new(name, parent);
	mon_port = new("mon_port",this);
endfunction 

function void uart_tx_monitor::build_phase(uvm_phase phase);
	super.build_phase(phase);
	if(!uvm_config_db#(virtual uart_tx_interface)::get(this,"","vif", vif))
		`uvm_fatal("NO_VIF",{"virtual interface must be set for: UART_TX_DRIVER ",get_full_name(),".vif"});
endfunction

task uart_tx_monitor::run_phase(uvm_phase phase);
	forever begin  
		seq = uart_tx_sequence_item::type_id::create("uart_tx_seq");
		uart_tx_monitor_code();   
	end
endtask

task uart_tx_monitor::uart_tx_monitor_code();

	@(vif.uart_tx_monitor_cb);
	mon_port.write(seq);
endtask


