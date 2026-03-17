class uart_tx_driver extends uvm_driver #(uart_tx_sequence_item);

	`uvm_component_utils(uart_tx_driver)
	virtual uart_tx_interface.DRIVER vif;
	int target_count, driver_id = 0 ;

	extern function new (string name = "uart_tx_driver", uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	extern task run_phase(uvm_phase phase);
	extern task uart_tx_driver_code();

endclass

function uart_tx_driver:: new (string name = "uart_tx_driver", uvm_component parent);
	super.new(name, parent);
endfunction 

function void uart_tx_driver::build_phase(uvm_phase phase);
	super.build_phase(phase);
	if(!uvm_config_db#(virtual uart_tx_interface)::get(this,"","vif", vif))
		`uvm_fatal("NO_VIF",{"virtual interface must be set for: UART_TX_DRIVER ",get_full_name(),".vif"});
endfunction

task uart_tx_driver::run_phase(uvm_phase phase);
	forever begin  
		seq_item_port.get_next_item(req);
		uart_tx_driver_code();   
		seq_item_port.item_done();
	end
endtask

task uart_tx_driver::uart_tx_driver_code();

	// setting target_count such that it produce 1 baud_clk cycle

	case(req.baud_rate)
		0: target_count = `SET_CLK / 2400 ;  // 'd 20_834;
		1: target_count = `SET_CLK / 4800 ;  // 'd 10_416;
		2: target_count = `SET_CLK / 9600 ;  // 'd 5_208;
		3: target_count = `SET_CLK / 19200;  // 'd 2_604;
		default: target_count = 0;
	endcase		
/*
	if( !req.reset_n ) begin
		vif.uart_tx_driver_cb.reset_n <= req.reset_n;
		vif.uart_tx_driver_cb.send <= req.send;
		vif.uart_tx_driver_cb.parity_type <= req.parity_type;
		vif.uart_tx_driver_cb.baud_rate <= req.baud_rate;
		vif.uart_tx_driver_cb.data_in <= req.data_in;
		`uvm_info( get_type_name() , $sformatf(" RESET = %0B | SEND = %0B | PARITY_TYPE = %0D | BAUD_RATE = %0D | DATA_IN = %0D " ,
			req.reset_n , req.send , req.parity_type , req.baud_rate , req.data_in ) , UVM_NONE )	
	 
		//$display("reset is driven waiting to get completed at %0t",$time);
		//repeat( target_count ) @(vif.uart_tx_driver_cb);
    //$display("driver reset waiting is completed at %0t",$time);
		
		@(vif.uart_tx_driver_cb);
		vif.uart_tx_driver_cb.reset_n <= 1'b1;	

	end
*/
	// driving it 13 times since at start it takes the reset signal to drive initially then followed by 11 bits to send one packet frame and final one extra drive to complete the transmission

	//	else begin
		repeat(14) begin 

			//vif.uart_tx_driver_cb.reset_n <= req.reset_n;
			vif.uart_tx_driver_cb.send <=  req.send;
			vif.uart_tx_driver_cb.parity_type <= req.parity_type;
			vif.uart_tx_driver_cb.baud_rate <= req.baud_rate;
			vif.uart_tx_driver_cb.data_in <= req.data_in;

			repeat(target_count) @(vif.uart_tx_driver_cb); // generation of 1 baud_clk cycle delay

		//	`uvm_info( get_type_name() , $sformatf(" RESET = %0B | SEND = %0B | PARITY_TYPE = %0D | BAUD_RATE = %0D | DATA_IN = %0D " ,
		//		req.reset_n , req.send , req.parity_type , req.baud_rate , req.data_in ) , UVM_NONE )
		
			`uvm_info( get_type_name() , $sformatf(" SEND = %0B | PARITY_TYPE = %0D | BAUD_RATE = %0D | DATA_IN = %0D " ,
			    req.send , req.parity_type , req.baud_rate , req.data_in ) , UVM_NONE )
			
			$display("driver_id = %0d",driver_id);
			driver_id++;

		end

		driver_id = 0;

	//end

endtask


