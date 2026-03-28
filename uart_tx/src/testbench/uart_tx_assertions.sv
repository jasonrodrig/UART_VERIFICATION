interface uart_tx_assertions(
	input clock,
	input reset_n,
	input send,
	input [ 1 : 0 ] parity_type,
	input [ 1 : 0 ] baud_rate,
	input [ 7 : 0 ] data_in,
	input data_tx,
	input active_flag,
	input done_flag	
);

	reg [ 13 : 0 ] final_value;
	reg [ 13 : 0 ] count;
	reg [ 10 : 0 ] ref_frame;
	reg parity , baud_clk ;

	always@(*)
	begin
		case (baud_rate)
			0 : final_value = 14'd10417;  //2400 baud_rate
			1 : final_value = 14'd5208;   //4800 baud_rate
			2 : final_value = 14'd2604;   //9600 baud_rate
			3 : final_value = 14'd1302;   //19200 baud_rate
			default: final_value = 14'd0;     
		endcase

		if     ( parity_type == 1 )  parity = ~(^data_in); //odd
		else if( parity_type == 2 )  parity =  (^data_in); //even
		else                         parity = 1 ;  //defualt

		ref_frame = { 1'b1 , parity , data_in , 1'b0 };	       
	end

	always@(posedge clock)
	begin
		if(!reset_n) begin 
			count           <= 0;
			baud_clk        <= 0;
		end
		else
		begin
			if (count == final_value)
			begin
				count     <= 0; 
				baud_clk  <= ~baud_clk;
			end 
			else
			begin
				count     <= count + 1'd1;
				baud_clk  <= baud_clk;
			end
		end
	end

  // reset check
	property rst_n;
		@( posedge clock )
		( !reset_n ) |-> ( data_tx && !active_flag && done_flag );
	endproperty

	assert property( rst_n )
	else $error( "RESET CHECK FAILED! -> data_tx = %0b | active_flag = %0b | done_flag = %0b", data_tx , active_flag , done_flag );

	// transmission check 
	sequence uart_frame_seq;
		@( posedge baud_clk )
		    (data_tx == ref_frame[0]  && active_flag && !done_flag )
		##1 (data_tx == ref_frame[1]  && active_flag && !done_flag )
		##1 (data_tx == ref_frame[2]  && active_flag && !done_flag )
		##1 (data_tx == ref_frame[3]  && active_flag && !done_flag )
		##1 (data_tx == ref_frame[4]  && active_flag && !done_flag )
		##1 (data_tx == ref_frame[5]  && active_flag && !done_flag )
		##1 (data_tx == ref_frame[6]  && active_flag && !done_flag )
		##1 (data_tx == ref_frame[7]  && active_flag && !done_flag )
		##1 (data_tx == ref_frame[8]  && active_flag && !done_flag )
		##1 (data_tx == ref_frame[9]  && active_flag && !done_flag )
		##1 (data_tx == ref_frame[10] && active_flag && !done_flag ); 
	endsequence

	property transmission_check;
		@( posedge baud_clk ) disable iff(!reset_n)
		send |-> uart_frame_seq.ended |-> ##1 done_flag && !active_flag;
	endproperty

	assert property( transmission_check ) 
	else $error( " TRANSMISSION CHECK FAILED! "); 

endinterface
