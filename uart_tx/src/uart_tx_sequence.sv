class uart_tx_sequence extends uvm_sequence#(uart_tx_sequence_item);

	`uvm_object_utils(uart_tx_sequence)

	extern function new(string name = "uart_tx_sequence");
	extern task body();

endclass

function uart_tx_sequence::new(string name = "uart_tx_sequence");
	super.new(name);
endfunction

task uart_tx_sequence::body();
	repeat(1)begin
		req = uart_tx_sequence_item::type_id::create("req");
		`uvm_do_with(req,{ req.baud_rate == 2 ; })
		//`uvm_do_with(req,{ req.baud_rate == 3 ; })
		

	end
endtask


