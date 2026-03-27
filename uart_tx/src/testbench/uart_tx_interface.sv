interface uart_tx_interface( input bit clock );

	bit send , reset_n ;
	bit [  1 : 0 ] parity_type , baud_rate ; 
	bit [  7 : 0 ] data_in ;
	bit data_tx , active_flag , done_flag ;

	clocking uart_tx_driver_cb@(posedge clock);
		default input #0 output #0;
	  output reset_n;
		output send;
		output parity_type;
		output baud_rate;
		output data_in;
		input  data_tx;
		input  active_flag;
	  input  done_flag;
	endclocking

	clocking uart_tx_monitor_cb@(posedge clock);
		default input #0 output #0;
	  input reset_n;
		input send;
		input parity_type;
		input baud_rate;
		input data_in;
		input data_tx;
		input active_flag;
	  input done_flag;	
	endclocking

	modport DRIVER(clocking uart_tx_driver_cb);
	modport MONITOR(clocking uart_tx_monitor_cb);

endinterface
