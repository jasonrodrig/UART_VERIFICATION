`include "uart_tx_defines.sv"
`include "design/uart_tx_design.v"
`include "testbench/uart_tx_interface.sv"
`include "testbench/uart_tx_packages.sv"
`include "testbench/uart_tx_assertions.sv"

import uvm_pkg::*;
import uart_tx_pkg::*;

`timescale 1ns/1ps

module top;

	// Clock frequency in Hz
	parameter real CLK_FREQUENCY = `SET_CLK;

  // Half clock period in ns
  parameter real HALF_PERIOD = 1e9 / ( 2.0 * CLK_FREQUENCY );

	bit clock = 0;

	always #(HALF_PERIOD) clock = ~clock;
  
	uart_tx_interface vif(clock);

	TxUnit DUT(
		.clock(vif.clock),
		.reset_n(vif.reset_n),
		.send(vif.send),
		.parity_type(vif.parity_type),
		.baud_rate(vif.baud_rate),
		.data_in(vif.data_in),
		.data_tx(vif.data_tx),
		.active_flag(vif.active_flag),
    .done_flag(vif.done_flag)
	);

	 bind vif uart_tx_assertions ASSERT(
		.clock(vif.clock),
		.reset_n(vif.reset_n),
		.send(vif.send),
		.parity_type(vif.parity_type),
		.baud_rate(vif.baud_rate),
		.data_in(vif.data_in),
		.data_tx(vif.data_tx),
		.active_flag(vif.active_flag),
    .done_flag(vif.done_flag)
	);

	initial begin 
		uvm_config_db#(virtual uart_tx_interface)::set(null,"*","vif",vif);
		$dumpfile("wave.vcd");
		$dumpvars;
	end

	initial begin 
		//run_test("uart_tx_base_test");
		//run_test("uart_tx_baud_rate_2400_test");    
		//run_test("uart_tx_baud_rate_4800_test");     
		//run_test("uart_tx_baud_rate_9600_test");       
		//run_test("uart_tx_baud_rate_19200_test");   
		//run_test("uart_tx_send0_first_test");        
		//run_test("uart_tx_mid_transfer_send0_test");  
		run_test("uart_tx_regression_test");
		#1000000000 ; $finish;
	end

endmodule
