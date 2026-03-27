class uart_tx_subscriber extends uvm_subscriber #(uart_tx_sequence_item);

	`uvm_component_utils(uart_tx_subscriber)
	uart_tx_sequence_item cov;
	real cov_results;

	covergroup uart_tx_coverage;
		option.per_instance = 1;

		RESET_N: coverpoint cov.reset_n{ 
			bins reset_n_cp[] = {0,1};
		}

		SEND: coverpoint cov.send{ 
			bins send_cp[] = {0,1};
		}

		PARITY_TYPE: coverpoint cov.parity_type{ 
			bins odd_parity_cp = {1};
			bins even_parity_cp = {2};
			ignore_bins invalid_parity_cp[] = {0,3};
		}

		BAUD_RATE: coverpoint cov.baud_rate{ 
			bins baud_rate_2400_cp  = {0};
			bins baud_rate_4800_cp  = {1};
			bins baud_rate_9600_cp  = {2};
			bins baud_rate_19200_cp = {3};
		}

		DATA_IN: coverpoint cov.data_in{ 
			bins low_data_in_cp    = { [ 0 : 85 ] };
			bins medium_data_in_cp = { [ 86 : 170 ] };
			bins high_data_in_cp   = { [ 171 : 255 ] };
		}

		DATA_TX: coverpoint cov.data_tx{ 
			bins data_tx_cp[] = {0,1};
		}

		ACTIVE_FLAG: coverpoint cov.active_flag{ 
			bins active_flag_cp[] = {0,1};
		}

		DONE_FLAG: coverpoint cov.done_flag{ 
			bins done_flag_cp[] = {0,1};
		}
    
		cross SEND , RESET_N ;
    cross BAUD_RATE, SEND;
		cross SEND , PARITY_TYPE;

		
	endgroup

	extern function new(string name = "uart_tx_subscriber", uvm_component parent );
	extern function void write(uart_tx_sequence_item t);
	extern virtual function void report_phase(uvm_phase phase);

endclass

function uart_tx_subscriber::new(string name = "uart_tx_subscriber", uvm_component parent );
	super.new(name, parent);
	uart_tx_coverage = new();
endfunction 

function void uart_tx_subscriber::write(uart_tx_sequence_item t);
	cov = t;
	uart_tx_coverage.sample();
endfunction 

function void uart_tx_subscriber::report_phase(uvm_phase phase);
	super.report_phase(phase);
	cov_results = uart_tx_coverage.get_coverage();
	`uvm_info(get_type_name(), $sformatf("UART - TX Total Coverage = %0.2f %%", cov_results ), UVM_NONE);
endfunction
