class uart_tx_mid_transfer_send0_sequence extends uvm_sequence#(uart_tx_sequence_item);

	`uvm_object_utils(uart_tx_mid_transfer_send0_sequence)

	extern function new(string name = "uart_tx_mid_transfer_send0_sequence");
	extern task body();

endclass

function uart_tx_mid_transfer_send0_sequence::new(string name = "uart_tx_mid_transfer_send0_sequence");
	super.new(name);
endfunction

task uart_tx_mid_transfer_send0_sequence::body();

	req = uart_tx_sequence_item::type_id::create("req");

	$display("\n");

	`uvm_info(get_type_name(),"=====================================================",UVM_NONE)
	`uvm_info(get_type_name(),"            MID TRANSFER SEND 0 SEQUENCE             ",UVM_NONE)
	`uvm_info(get_type_name(),"=====================================================",UVM_NONE)

	$display("\n");
 
	repeat(1) `uvm_do_with(req,{ req.reset_n == 0 ; req.send == 0 ; req.baud_rate == 1 ; req.data_in == 'hbe; req.parity_type == 2; } )
	repeat(7) `uvm_do_with(req,{ req.reset_n == 1 ; req.send == 1 ; req.baud_rate == 1 ; req.data_in == 'hbe; req.parity_type == 2; } )
	repeat(1) `uvm_do_with(req,{ req.reset_n == 1 ; req.send == 0 ; req.baud_rate == 1 ; req.data_in == 'hbe; req.parity_type == 2; } )
	repeat(7) `uvm_do_with(req,{ req.reset_n == 1 ; req.send == 1 ; req.baud_rate == 1 ; req.data_in == 'hbe; req.parity_type == 2; } )

	$display("\n");

	`uvm_info(get_type_name(),"=====================================================",UVM_NONE)
	`uvm_info(get_type_name(),"            MID TRANSFER SEND 0 SEQUENCE             ",UVM_NONE)
	`uvm_info(get_type_name(),"=====================================================",UVM_NONE)

	$display("\n");
 
	repeat(1) `uvm_do_with(req,{ req.reset_n == 0 ; req.send == 0 ; req.baud_rate == 3 ; req.data_in == 'hbe; req.parity_type == 1; } )
	repeat(7) `uvm_do_with(req,{ req.reset_n == 1 ; req.send == 1 ; req.baud_rate == 3 ; req.data_in == 'hbe; req.parity_type == 1; } )
	repeat(1) `uvm_do_with(req,{ req.reset_n == 1 ; req.send == 0 ; req.baud_rate == 3 ; req.data_in == 'hbe; req.parity_type == 1; } )
	repeat(7) `uvm_do_with(req,{ req.reset_n == 1 ; req.send == 1 ; req.baud_rate == 3 ; req.data_in == 'hbe; req.parity_type == 1; } )

	$display("\n");

endtask


