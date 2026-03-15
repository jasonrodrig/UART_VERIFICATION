`include "uart_tx_design.v"
`include "uart_tx_interface.sv"
`include "uart_tx_packages.sv"

import uvm_pkg::*;
import uart_tx_pkg::*;

`timescale 1ns/1ps

module top;

	// Clock frequency in Hz
	parameter real CLK_FREQUENCY = 50_000_000.0;

  // Half clock period in ns
  parameter real HALF_PERIOD = 1e9 / ( 2.0 * CLK_FREQUENCY );

	bit clock = 0;
	bit reset_n = 1;

	always #(HALF_PERIOD) clock = ~clock;
  
	uart_tx_interface vif(clock,reset_n);

	TxUnit DUT(
		.clock(vif.clock),
		.reset_n(vif.reset_n),
		.send(vif.send),
		.parity_type(vif.parity_type),
		.baud_rate(vif.baud_rate),
		.data_in(vif.data_in),
		.data_tx(vif.data_tx),
		.active_flag(vif.active_flag),
    .done_flag(vif.done_flag),
    .baud_clk_sig(vif.baud_clk_sig)
	);

	initial begin 
		uvm_config_db#(virtual uart_tx_interface)::set(null,"*","vif",vif);
		$dumpfile("wave.vcd");
		$dumpvars;
	end
 
	initial begin
   reset_n = 0;
	 @(posedge clock);
   reset_n = 1;
	end

	initial begin 
  //  run_test("uart_tx_reset_test");
	//  run_test("uart_tx_transfer_test");
 	  run_test("uart_tx_base_test");
		#1000000 $finish;
	end

endmodule
