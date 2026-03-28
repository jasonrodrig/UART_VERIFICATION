class uart_tx_monitor extends uvm_monitor;

	`uvm_component_utils(uart_tx_monitor)
	virtual uart_tx_interface.MONITOR vif;
	uvm_analysis_port#(uart_tx_sequence_item) mon_port;
	uart_tx_sequence_item seq;
	int target_count , monitor_id = 0 , reset_found , temp;

	extern function new (string name = "uart_tx_monitor", uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	extern task run_phase(uvm_phase phase);
	extern task uart_tx_monitor_code();
	extern task interf();

endclass

function uart_tx_monitor:: new (string name = "uart_tx_monitor", uvm_component parent);
	super.new(name, parent);
	mon_port = new("mon_port",this);
endfunction 

function void uart_tx_monitor::build_phase(uvm_phase phase);
	super.build_phase(phase);
	if(!uvm_config_db#(virtual uart_tx_interface)::get(this,"","vif", vif))
		`uvm_fatal("NO_VIF",{"virtual interface must be set for: UART_TX_DRIVER ",get_full_name(),".vif"});
endfunction

task uart_tx_monitor::run_phase(uvm_phase phase);
	forever begin  
		seq = uart_tx_sequence_item::type_id::create("uart_tx_seq");
		uart_tx_monitor_code();   
	end
endtask

task uart_tx_monitor::interf();
	seq.reset_n = vif.uart_tx_monitor_cb.reset_n;
	seq.send = vif.uart_tx_monitor_cb.send;
	seq.parity_type = vif.uart_tx_monitor_cb.parity_type;
	seq.baud_rate = vif.uart_tx_monitor_cb.baud_rate;
	seq.data_in = vif.uart_tx_monitor_cb.data_in;
	seq.data_tx = vif.uart_tx_monitor_cb.data_tx;
	seq.active_flag = vif.uart_tx_monitor_cb.active_flag;
	seq.done_flag = vif.uart_tx_monitor_cb.done_flag;
endtask

task uart_tx_monitor::uart_tx_monitor_code();

	// setting target_count such that it produce 1 baud_clk cycle

	case(vif.uart_tx_monitor_cb.baud_rate)
		0: target_count = `SET_CLK / 2400   ;  // 'd 20_834;
		1: target_count = `SET_CLK / 4800   ;  // 'd 10_416;
		2: target_count = `SET_CLK / 9600   ;  // 'd 5_208;
		3: target_count = `SET_CLK / 19200  ;  // 'd 2_604;
		default: target_count = 0;
	endcase		

	if( !vif.uart_tx_monitor_cb.reset_n ) 
	begin
		repeat(1) @(vif.uart_tx_monitor_cb);  
		interf();
		reset_found = 1;
		if ( reset_found && !temp ) begin
			mon_port.write(seq);
			temp = 1;
			reset_found = 0;
			//$display("monitor_id = %0d",monitor_id);
			monitor_id++;
			// `uvm_info( get_type_name() , $sformatf(" RESET = %0B | SEND = %0B | PARITY_TYPE = %0D | BAUD_RATE = %0D | DATA_IN = %0D | DATA_TX = %0B | ACTIVE_FLAG = %0B | DONE_FLAG = %0B |" , vif.uart_tx_monitor_cb.reset_n , vif.uart_tx_monitor_cb.send , vif.uart_tx_monitor_cb.parity_type , vif.uart_tx_monitor_cb.baud_rate , vif.uart_tx_monitor_cb.data_in , vif.uart_tx_monitor_cb.data_tx , vif.uart_tx_monitor_cb.active_flag , vif.uart_tx_monitor_cb.done_flag ) , UVM_NONE )
		end
	end

	else if( vif.uart_tx_monitor_cb.reset_n && !vif.uart_tx_monitor_cb.send)
	begin
		//$display("send 0 condition at monitor");
		repeat( target_count ) @(vif.uart_tx_monitor_cb); // generation of 1 baud clk_cycle delay 
		//$display("send 0 condition at monitor");
		interf();	
		//$display("monitor_id = %0d",monitor_id);
		monitor_id++;
		seq.send = 0;
		if( monitor_id == 14 ) monitor_id = 0;
		// `uvm_info( get_type_name() , $sformatf(" RESET = %0B | SEND = %0B | PARITY_TYPE = %0D | BAUD_RATE = %0D | DATA_IN = %0D | DATA_TX = %0B | ACTIVE_FLAG = %0B | DONE_FLAG = %0B | " , vif.uart_tx_monitor_cb.reset_n , !vif.uart_tx_monitor_cb.send , vif.uart_tx_monitor_cb.parity_type , vif.uart_tx_monitor_cb.baud_rate , vif.uart_tx_monitor_cb.data_in , vif.uart_tx_monitor_cb.data_tx , vif.uart_tx_monitor_cb.active_flag , vif.uart_tx_monitor_cb.done_flag ) , UVM_NONE )
		mon_port.write(seq);
	end

	else begin

		repeat( target_count  ) @(vif.uart_tx_monitor_cb); // generation of 1 baud clk_cycle delay 
		interf();	
		//  $display("monitor_id = %0d",monitor_id);
		monitor_id++;
		seq.send = 1;
		if( monitor_id == 14 ) monitor_id = 0;
		//	`uvm_info( get_type_name() , $sformatf(" RESET = %0B | SEND = %0B | PARITY_TYPE = %0D | BAUD_RATE = %0D | DATA_IN = %0D | DATA_TX = %0B | ACTIVE_FLAG = %0B | DONE_FLAG = %0B | " , vif.uart_tx_monitor_cb.reset_n , seq.send , vif.uart_tx_monitor_cb.parity_type , vif.uart_tx_monitor_cb.baud_rate , vif.uart_tx_monitor_cb.data_in , vif.uart_tx_monitor_cb.data_tx , vif.uart_tx_monitor_cb.active_flag , vif.uart_tx_monitor_cb.done_flag )  , UVM_NONE )
		mon_port.write(seq);
	end

endtask
