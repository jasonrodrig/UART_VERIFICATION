class uart_tx_driver extends uvm_driver #(uart_tx_sequence_item);

	`uvm_component_utils(uart_tx_driver)
	virtual uart_tx_interface.DRIVER vif;

	extern function new (string name = "uart_tx_driver", uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	extern task run_phase(uvm_phase phase);
	extern task uart_tx_driver_code();

endclass

function uart_tx_driver:: new (string name = "uart_tx_driver", uvm_component parent);
	super.new(name, parent);
endfunction 

function void uart_tx_driver::build_phase(uvm_phase phase);
	super.build_phase(phase);
	if(!uvm_config_db#(virtual uart_tx_interface)::get(this,"","vif", vif))
		`uvm_fatal("NO_VIF",{"virtual interface must be set for: UART_TX_DRIVER ",get_full_name(),".vif"});
endfunction

task uart_tx_driver::run_phase(uvm_phase phase);
	forever begin  
		seq_item_port.get_next_item(req);
		uart_tx_driver_code();   
		seq_item_port.item_done();
	end
endtask

task uart_tx_driver::uart_tx_driver_code();

@(vif.uart_tx_driver_cb);

endtask


