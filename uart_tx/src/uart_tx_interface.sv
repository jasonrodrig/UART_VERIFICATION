interface uart_tx_interface(input bit clock , reset_n);

	bit send;
	bit [  1 : 0 ] parity_type , baud_rate ; 
	bit [  8 - 1 : 0 ] data_in ;
	bit data_tx , active_flag , done_flag , baud_clk_sig;

	clocking uart_tx_driver_cb@(posedge clock);
		default input #0 output #0;
		output send;
		output parity_type;
		output baud_rate;
		output data_in;
		input  data_tx;
		input  active_flag;
	  input  done_flag;
		input  baud_clk_sig;
	endclocking

	clocking uart_tx_monitor_cb@(posedge clock);
		default input #0 output #0;
		input send;
		input parity_type;
		input baud_rate;
		input data_in;
		input data_tx;
		input active_flag;
	  input done_flag;	
		input baud_clk_sig;
	endclocking

	modport DRIVER(clocking uart_tx_driver_cb);
	modport MONITOR(clocking uart_tx_monitor_cb);

endinterface
