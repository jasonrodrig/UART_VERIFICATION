class uart_tx_sequence_item extends uvm_sequence_item;

	rand bit send , reset_n;
	rand bit [ 1 : 0 ] parity_type , baud_rate;
	rand bit [ 8 - 1  :0 ] data_in;
	bit data_tx , active_flag , done_flag ;

	`uvm_object_utils_begin(uart_tx_sequence_item)
	`uvm_field_int(reset_n,UVM_ALL_ON)
	`uvm_field_int(send,UVM_ALL_ON)
	`uvm_field_int(parity_type,UVM_ALL_ON)
	`uvm_field_int(baud_rate,UVM_ALL_ON)
	`uvm_field_int(data_in,UVM_ALL_ON)
	`uvm_field_int(data_tx,UVM_ALL_ON)
	`uvm_field_int(active_flag,UVM_ALL_ON)
	`uvm_field_int(done_flag,UVM_ALL_ON)
	`uvm_object_utils_end

	extern function new(string name = "uart_tx_sequence_item");
  
endclass

function uart_tx_sequence_item::new(string name = "uart_tx_sequence_item");
	super.new(name);
endfunction


