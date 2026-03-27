class uart_tx_send0_first_sequence extends uvm_sequence#(uart_tx_sequence_item);

	`uvm_object_utils(uart_tx_send0_first_sequence)

	extern function new(string name = "uart_tx_send0_first_sequence");
	extern task body();

endclass

function uart_tx_send0_first_sequence::new(string name = "uart_tx_send0_first_sequence");
	super.new(name);
endfunction

task uart_tx_send0_first_sequence::body();

	req = uart_tx_sequence_item::type_id::create("req");

	$display("\n");

	`uvm_info(get_type_name(),"=====================================================",UVM_NONE)
	`uvm_info(get_type_name(),"                 SEND 0 FIRST SEQUENCE               ",UVM_NONE)
	`uvm_info(get_type_name(),"=====================================================",UVM_NONE)

	$display("\n");
 
	repeat(1) `uvm_do_with(req,{ req.reset_n == 0 ; req.send == 0 ; req.baud_rate == 2 ; req.data_in == 'hff; req.parity_type == 0; } )
	repeat(1) `uvm_do_with(req,{ req.reset_n == 1 ; req.send == 0 ; req.baud_rate == 2 ; req.data_in == 'hff; req.parity_type == 0; } )
	repeat(7) `uvm_do_with(req,{ req.reset_n == 1 ; req.send == 1 ; req.baud_rate == 2 ; req.data_in == 'hff; req.parity_type == 0; } )
	repeat(7) `uvm_do_with(req,{ req.reset_n == 1 ; req.send == 1 ; req.baud_rate == 2 ; req.data_in == 'hff; req.parity_type == 0; } )

	$display("\n");


endtask


