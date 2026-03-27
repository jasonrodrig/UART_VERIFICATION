class uart_tx_baud_rate_9600_sequence extends uvm_sequence#(uart_tx_sequence_item);

	`uvm_object_utils(uart_tx_baud_rate_9600_sequence)

	extern function new(string name = "uart_tx_baud_rate_9600_sequence");
	extern task body();

endclass

function uart_tx_baud_rate_9600_sequence::new(string name = "uart_tx_baud_rate_9600_sequence");
	super.new(name);
endfunction

task uart_tx_baud_rate_9600_sequence::body();

	req = uart_tx_sequence_item::type_id::create("req");

	$display("\n");

	`uvm_info(get_type_name(),"=====================================================",UVM_NONE)
	`uvm_info(get_type_name(),"                 BAUD RATE OF 9600                   ",UVM_NONE)
	`uvm_info(get_type_name(),"=====================================================",UVM_NONE)

	$display("\n");
 
	`uvm_do_with(req,{ req.reset_n == 0 ;req.send == 0;  req.baud_rate == 2 ; req.data_in == 'ha5; req.parity_type == 1; } )
	repeat(14) `uvm_do_with(req,{ req.reset_n == 1 ; req.send == 1; req.baud_rate == 2 ; req.data_in == 'ha5; req.parity_type == 1;} )

	$display("\n");

endtask


