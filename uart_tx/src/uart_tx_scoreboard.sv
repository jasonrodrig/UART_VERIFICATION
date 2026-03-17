class uart_tx_scoreboard extends uvm_scoreboard;

	`uvm_component_utils(uart_tx_scoreboard)
	uvm_analysis_imp#(uart_tx_sequence_item, uart_tx_scoreboard) scb_port;
	uart_tx_sequence_item packet_q[$] , seq ;
  //virtual uart_tx_interface vif;
	static int pass_count;
	static int fail_count;

	extern function new(string name = "uart_tx_scoreboard", uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	extern function void write(uart_tx_sequence_item pkt);
	extern function void extract_phase(uvm_phase phase);
	extern task run_phase(uvm_phase phase);
	extern task compare( );

endclass

function uart_tx_scoreboard::new(string name = "uart_tx_scoreboard", uvm_component parent);
	super.new(name,parent);
endfunction

function void uart_tx_scoreboard::build_phase(uvm_phase phase);
	super.build_phase(phase);
	scb_port = new("scb_port",this);
//	if(!uvm_config_db#(virtual uart_tx_interface)::get(this,"","vif", vif))
//		`uvm_fatal("NO_VIF",{"virtual interface must be set for: UART_TX_SCB ",get_full_name(),".vif"});
endfunction

function void uart_tx_scoreboard::write(uart_tx_sequence_item pkt);
	packet_q.push_back(pkt);
endfunction

function void uart_tx_scoreboard::extract_phase(uvm_phase phase);
	super.extract_phase(phase);
	`uvm_info("SCOREBOARD", $sformatf("TOTAL PASS : %0d", pass_count), UVM_NONE)
	`uvm_info("SCOREBOARD", $sformatf("TOTAL FAIL : %0d", fail_count), UVM_NONE)
	`uvm_info("SCOREBOARD", $sformatf("TOTAL CASES : %0d", fail_count + pass_count), UVM_NONE)
endfunction

task uart_tx_scoreboard::run_phase(uvm_phase phase);

	forever begin
		fork
			begin
				wait(packet_q.size()>0);
				seq = packet_q.pop_front();
			end
		join
		compare();
	end

endtask

task uart_tx_scoreboard::compare();
	reg [10:0] ref_packet; 

//`uvm_info( get_type_name() , $sformatf(" SEND = %0B | PARITY_TYPE = %0D | BAUD_RATE = %0D | DATA_IN = %0D | DATA_TX = %0B | ACTIVE_FLAG = %0B | DONE_FLAG = %0B | BAUD_CLK_SIG = %0B " , seq.send , seq.parity_type , seq.baud_rate , seq.data_in , seq.data_tx , seq.active_flag , seq.done_flag , seq.baud_clk_sig ) , UVM_NONE )
  
    ref_packet = { 1'b1 , seq.parity_type , seq.data_in , 1'b0 };
	//	$display("packet = %b", ref_packet);
	
	
 


	/* if( seq.reset_n && !seq.active_flag && seq.done_flag && seq.data_tx )
		`uvm_info(get_type_name(),"reset passed",UVM_NONE)
	else
    `uvm_error(get_type_name(),"reset failed")

	`uvm_info(get_type_name() , $sformatf(" RESET = %B , ACTIVE_FLAG = %B , DONE_FLAG = %B , DATA_TX = %B " , seq.reset_n , seq.active_flag , seq.done_flag , seq.data_tx ), UVM_NONE )
	*/



endtask


