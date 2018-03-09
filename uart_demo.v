/*
 * Copyright 2015 Forest Crossman
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *    http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 *
 */

`include "cores/osdvu/uart.v"

module top(
	input iCE_CLK,
	input RS232_Rx_TTL,
	output RS232_Tx_TTL,
	output LED0,
	output LED1,
	output LED2,
	output LED3,
	output LED4
	);

	wire reset = 0;
	reg transmit;
	reg [7:0] tx_byte;
	wire received;
	wire [12:0] rx_byte;
  wire [12:0] rx_byte_reversed;
	wire is_receiving;
	wire is_transmitting;
	wire recv_error;

  SB_PLL40_CORE #(
      .FEEDBACK_PATH("SIMPLE"),
      .PLLOUT_SELECT("GENCLK"),
      .DIVR(4'b0000),
      .DIVF(7'b1010100),
      .DIVQ(3'b011),
      .FILTER_RANGE(3'b001)
  ) uut (
      .LOCK(lock),
      .RESETB(1'b1),
      .BYPASS(1'b0),
      .REFERENCECLK(iCE_CLK),
      .PLLOUTCORE(clk)
  );


	assign LED4 = is_receiving;
	assign {LED3, LED2, LED1, LED0} = rx_byte[7:4];

	uart #(
		.baud_rate(8000000),                 // The baud rate in kilobits/s
		.sys_clk_freq(128000000)           // The master clock frequency
	)
	uart0(
		.clk(clk),                    // The master clock for this module
		.rst(reset),                      // Synchronous reset
		.rx(RS232_Rx_TTL),                // Incoming serial line
		.tx(RS232_Tx_TTL),                // Outgoing serial line
		.transmit(transmit),              // Signal to transmit
		.tx_byte(tx_byte),                // Byte to transmit
		.received(received),              // Indicated that a byte has been received
		.rx_byte(rx_byte),                // Byte received
		.is_receiving(is_receiving),      // Low when receive line is idle
		.is_transmitting(is_transmitting),// Low when transmit line is idle
		.recv_error(recv_error)           // Indicates error in receiving packet.
	);

	always @(posedge clk) begin
		if (received) begin
      rx_byte_reversed[12] = rx_byte[0];
      rx_byte_reversed[11] = rx_byte[1];
      rx_byte_reversed[10] = rx_byte[2];
      rx_byte_reversed[9] = rx_byte[3];
      rx_byte_reversed[8] = rx_byte[4];
      rx_byte_reversed[7] = rx_byte[5];
      rx_byte_reversed[6] = rx_byte[6];
      rx_byte_reversed[5] = rx_byte[7];
      rx_byte_reversed[4] = rx_byte[8];
      rx_byte_reversed[3] = rx_byte[9];
      rx_byte_reversed[2] = rx_byte[10];
      rx_byte_reversed[1] = rx_byte[11];
      rx_byte_reversed[0] = rx_byte[12];

			tx_byte <= rx_byte_reversed[11:4];
			transmit <= 1;
		end else begin
			transmit <= 0;
		end
	end
endmodule
