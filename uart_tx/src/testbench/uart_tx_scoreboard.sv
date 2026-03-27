class uart_tx_scoreboard extends uvm_scoreboard;

	`uvm_component_utils(uart_tx_scoreboard)
	uvm_analysis_imp#(uart_tx_sequence_item, uart_tx_scoreboard) scb_port;
	uart_tx_sequence_item packet_q[$] , seq ;

	static int pass_count;
	static int fail_count;
	static int index = 0;
	bit done_reset , parity;
	bit done_flag_triggered , send_triggered;
	bit [ 10 : 0 ] ref_packet , temp;

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
		begin
			wait(packet_q.size()>0);
			seq = packet_q.pop_front();
			compare();
		end
	end
endtask

task uart_tx_scoreboard::compare();

	`uvm_info( get_type_name() , $sformatf("RESET_N = %0B | SEND = %0B | PARITY_TYPE = %0D | BAUD_RATE = %0D | DATA_IN = %0D | DATA_TX = %0B | ACTIVE_FLAG = %0B | DONE_FLAG = %0B | " , 
		seq.reset_n, seq.send , seq.parity_type , seq.baud_rate , seq.data_in , seq.data_tx , seq.active_flag , seq.done_flag ) , UVM_NONE )

	if     ( seq.parity_type == 1 )  parity = ~(^seq.data_in); //odd
	else if( seq.parity_type == 2 )  parity =  (^seq.data_in); //even
	else                             parity = 1 ;              // defaut case

	if( !seq.reset_n && !done_reset )
	begin
		
		done_reset = 1;
		`uvm_info(get_type_name(),"reset applied at start",UVM_NONE)
		
		if( seq.data_tx == 1 && seq.done_flag && !seq.active_flag )
		begin
			`uvm_info(get_type_name(),"reset passed",UVM_NONE)
			pass_count++;
		end
		
		else begin
			`uvm_error(get_type_name(),"reset failed")
			`uvm_error(get_type_name(),$sformatf("expected : data_out = %0b | active_flag = %0b | done_flag = %0b , got : data_out = %0b | active_flag = %0b | done_flag = %0b" ,
				1 , 0 , 1 , seq.data_tx,seq.active_flag , seq.done_flag ) )
			fail_count++;
		end
	
	end

	else if(seq.reset_n && done_reset)
	begin
		
		`uvm_info(get_type_name(),"reset applied for one baud cycle",UVM_NONE)	
		ref_packet = { 1'b1 , parity , seq.data_in , 1'b0 } ;
		
		if( seq.data_tx == 1 && seq.done_flag && !seq.active_flag )
		begin
			`uvm_info(get_type_name(),"reset passed",UVM_NONE)
			pass_count++;
		end

		else begin
			`uvm_error(get_type_name(),"reset failed")
			`uvm_error(get_type_name(),$sformatf("expected : data_out = %0b | active_flag = %0b | done_flag = %0b , got : data_out = %0b | active_flag = %0b | done_flag = %0b" , 
				1 , 0 , 1 , seq.data_tx,seq.active_flag , seq.done_flag ) )
			fail_count++;
		end

		done_reset = 0;  

		if(!seq.send) send_triggered = 1;
		else          send_triggered = 0;

	end

	else
	begin

		if( seq.send )
		begin

			if( index < 11 && !send_triggered )
			begin

				if( ref_packet[index] == seq.data_tx && seq.active_flag && !seq.done_flag )
				begin
					`uvm_info(get_type_name(), $sformatf("single bit data_tx passed at bit : %0d", index ),UVM_NONE)
					pass_count++;
				end

				else begin
					`uvm_error(get_type_name(),$sformatf("single bit data_tx failed at bit : %0d" , index ) )
					`uvm_error(get_type_name(),$sformatf("expected : data_out = %0b | active_flag = %0b | done_flag = %0b , got : data_out = %0b | active_flag = %0b | done_flag = %0b" , 
						ref_packet[index] , 1 , 0 , seq.data_tx , seq.active_flag , seq.done_flag ) )
					fail_count++;
				end

				temp[index] = seq.data_tx;
				index = index + 1;

				if( index == 11 ) done_flag_triggered = 1;
			
			end 

			else if( done_flag_triggered )
			begin

				if( temp === ref_packet && seq.done_flag && !seq.active_flag )
				begin
					`uvm_info(get_type_name(),"done_flag passed" , UVM_NONE)
					pass_count++;
				end
				
				else begin
					`uvm_error(get_type_name(),"done_flag failed")
					`uvm_error(get_type_name(),$sformatf("expected : reference_packet = %0b | done_flag = %0b | active_flag = %0b , got: actual_packet = %0b | done_flag = %0b | active_flag = %b " , 
						ref_packet , 1 , 0 , temp , seq.done_flag , seq.active_flag ) )
					fail_count++;
				end

				index = 0;
				ref_packet = 0;
				temp = 0;
				done_flag_triggered = 0;

			end

			else if(send_triggered)
			begin

				if( seq.data_tx && seq.done_flag && !seq.active_flag )
				begin
					`uvm_info( get_type_name(),"send 0 conditiion passed" , UVM_NONE)
					pass_count++;
				end

				else begin
					`uvm_error(get_type_name(),"send 0 condition failed")
					`uvm_error(get_type_name(),$sformatf("expected : data_tx = %0b | done_flag = %0b | active_flag = %0b , got: data_tx = %0b | done_flag = %0b | active_flag = %b " , 
						1 , 1 , 0 , seq.data_tx , seq.done_flag , seq.active_flag ) )
					fail_count++;
				end
			
				send_triggered = 0;
			
			end
		
		end

		else if(!seq.send)
		begin

			if( seq.data_tx == ref_packet[index] && !seq.done_flag && !seq.active_flag )
			begin
				`uvm_info( get_type_name(), "mid send 0 condition passed" , UVM_NONE)
				pass_count++;
			end

			else begin
				`uvm_error(get_type_name(),"mid send 0 condition failed")
				`uvm_error(get_type_name(),$sformatf("expected : data_tx = %0b | done_flag = %0b | active_flag = %0b , got: data_tx = %0b | done_flag = %0b | active_flag = %b " , 
					ref_packet[index] , 0 , 0 , seq.data_tx , seq.done_flag , seq.active_flag ) )
				fail_count++;
			end

		end

	end

endtask


