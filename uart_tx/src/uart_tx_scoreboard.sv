class uart_tx_scoreboard extends uvm_scoreboard;

	`uvm_component_utils(uart_tx_scoreboard)
	uvm_analysis_imp#(uart_tx_sequence_item, uart_tx_scoreboard) scb_port;
	uart_tx_sequence_item packet_q[$];
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
	uart_tx_sequence_item seq;

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

task uart_tx_scoreboard::compare( );

endtask


