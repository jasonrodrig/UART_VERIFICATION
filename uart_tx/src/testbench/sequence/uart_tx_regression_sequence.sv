class uart_tx_regression_sequence extends uvm_sequence#(uart_tx_sequence_item);

	`uvm_object_utils(uart_tx_regression_sequence)
  
  uart_tx_baud_rate_2400_sequence       seq1;
  uart_tx_baud_rate_4800_sequence       seq2;
  uart_tx_baud_rate_9600_sequence       seq3;
  uart_tx_baud_rate_19200_sequence      seq4;
  uart_tx_send0_first_sequence          seq5;
  uart_tx_mid_transfer_send0_sequence   seq6;

	extern function new(string name = "uart_tx_regression_sequence");
	extern task body();

endclass

function uart_tx_regression_sequence::new(string name = "uart_tx_regression_sequence");
	super.new(name);
endfunction

task uart_tx_regression_sequence::body();
   repeat(1) begin
		`uvm_do(seq3)
		`uvm_do(seq4)
		`uvm_do(seq1)
		`uvm_do(seq2)
	  `uvm_do(seq5)
		`uvm_do(seq6) 
   end
endtask


