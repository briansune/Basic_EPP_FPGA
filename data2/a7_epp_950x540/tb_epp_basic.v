/* =====================================================================
    ____         _                 ____                      
   | __ )  _ __ (_)  __ _  _ __   / ___|  _   _  _ __    ___ 
   |  _ \ | '__|| | / _` || '_ \  \___ \ | | | || '_ \  / _ \
   | |_) || |   | || (_| || | | |  ___) || |_| || | | ||  __/
   |____/ |_|   |_| \__,_||_| |_| |____/  \__,_||_| |_| \___|
   
   =====================================================================
   Date: 2023-05
   Author: Brian Sune
   Contact: briansune@gmail.com
   Revision: 1.0.0
   FPGA: XC7Z0x0-CLG400
   =====================================================================
*/

`timescale 1ns/1ps


module tb_epp_basic;

	reg					clk_p;
	reg					clk_n;
	reg					nrst;
	
	epp_basic DUT(
		
		.btn_black		(1'b0),
		.sys_nrst		(nrst),
		
		.sys_clk_p		(clk_p),
		.sys_clk_n		(clk_n)
	);
	
	always begin
		#2.500 clk_p = ~clk_p;
	end
	always begin
		#2.500 clk_n = ~clk_n;
	end
	
	
	initial begin
		fork begin
			
			#0 clk_p = 1'b1;
			clk_n = 1'b0;
			
			nrst = 1'b0;
			
			#10000 nrst = 1'b1;
			
			
		end join
	end
	
endmodule
