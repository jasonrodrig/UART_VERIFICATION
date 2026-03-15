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
		`uvm_do(req)
		req.print();
		//wait_for_grant();
    
		//if(!req.randomize());
		// `uvm_error("SEQ", "Randomization failed")
		
		//send_request(req);
		//wait_for_item_done();
	end
endtask


