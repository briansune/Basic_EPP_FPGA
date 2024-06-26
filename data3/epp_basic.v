/* =====================================================================
    ____         _                 ____                      
   | __ )  _ __ (_)  __ _  _ __   / ___|  _   _  _ __    ___ 
   |  _ \ | '__|| | / _` || '_ \  \___ \ | | | || '_ \  / _ \
   | |_) || |   | || (_| || | | |  ___) || |_| || | | ||  __/
   |____/ |_|   |_| \__,_||_| |_| |____/  \__,_||_| |_| \___|
   
   =====================================================================
   Date: 2024-03
   Author: Brian Sune
   Contact: briansune@gmail.com
   Revision: 1.0.0
   FPGA: XC7A100FTG
   =====================================================================
*/

`timescale 1ns/1ps

module epp_basic(
	
	input wire					sys_clk_p,
	input wire					sys_clk_n,
	input wire					sys_nrst,
	
	input wire					btn_black,
	
	// clock gate driver
	output wire					epp_ckv,
	// gate start pulse
	output wire					epp_stv,
	// source output enable
	output wire					epp_xoe,
	// source start pulse
	output wire					epp_xstl,
	// source latch enable
	output wire					epp_xle,
	
	// clock source driver
	// SDCK = XCL - 33MHz
	output wire					epp_xcl,
	
	output wire					epp_mode,
	output wire		[7:0]		epp_data
	
	// output wire					i2c_sclk,
	// inout						i2c_sdat
);
	
	// wire		pll_nrst;
	
	wire		epp_xcl_w;
	
	wire		glb_clk;
	wire		glb_nrst;
	
	clk_wiz_0 clk_inst0(
		.clk_out1	(glb_clk),
		.clk_out2	(epp_xcl_w),
		.locked		(glb_nrst),
		
		.resetn		(sys_nrst),
		.clk_in1_p	(sys_clk_p),
		.clk_in1_n	(sys_clk_n)
	);
	
	// reg_config iic_config0(
		// .clk_25M		(glb_clk),
		// .camera_rstn	(pll_nrst),
		// .reg_conf_done	(glb_nrst),
		// .i2c_sclk		(i2c_sclk),
		// .i2c_sdat		(i2c_sdat)
	// );
	
	localparam lsl = 10;
	localparam lbl = 7;
	// 960 / [8 / 2bits]
	localparam ldl = 240;
	localparam lel = 105;
	localparam gdck_sta = 2;
	localparam gdck_hi = ldl * 2;
	localparam ltot = lsl + lbl + ldl + lel;
	
	localparam fsl = 1;
	localparam fbl = 4;
	localparam fdl = 540;
	localparam fel = 15;
	localparam ftot = fsl + fbl + fdl + fel;
	
	reg		[8 : 0]		cnt_a;
	reg		[10 : 0]	cnt_b;
	
	reg		[7 : 0]		epp_data_r;
	
	reg					sdle_r;
	reg					sdce_l_r;
	reg					gdck_r;
	
	reg					line_en;
	
	reg					gdsp_r;
	reg					sdoe_r;
	reg					gdoe_r;
	
	reg					btn_black_r;
	
	assign epp_xcl		= epp_xcl_w;
	
	assign epp_xle		= sdle_r;
	
	assign epp_xoe		= sdoe_r;
	assign epp_mode		= gdoe_r;
	
	assign epp_ckv		= gdck_r;
	assign epp_xstl		= sdce_l_r;
	
	assign epp_stv		= gdsp_r;
	assign epp_data		= epp_data_r;
	
	localparam integer lut_bw = 20;
	
	reg		[lut_bw*2-1 : 0]	gray_lut	[0 : 15];
	
	reg		[4 : 0]			gray_cnt;
	reg		[3 : 0]			clean_cnt;
	
	// ===============================================================
	// 				=	0 0	........................	VSS		+ 0V
	// DRAW BLACK	=	0 1	........................	VPOS	+15V
	// DRAW WHITE	=	1 0	........................	VNEG	-15V
	// 				=	1 1	........................	No Input
	// ===============================================================
	
initial begin
// gray_lut[ 0] <= 24'b01_01_01_01_01_01_01_10_10_01_01_01;
// gray_lut[ 1] <= 24'b00_01_01_01_01_01_01_01_10_10_01_01;

// gray_lut[ 2] <= 24'b00_00_00_00_00_00_00_00_00_01_01_01;
// gray_lut[ 3] <= 24'b00_00_00_00_00_00_00_00_00_00_01_01;
// gray_lut[ 4] <= 24'b00_00_00_00_00_00_00_00_00_00_00_01;
// gray_lut[ 5] <= 24'b00_00_00_10_10_10_10_10_01_01_01_01;
// gray_lut[ 6] <= 24'b00_00_00_00_10_10_10_10_10_01_01_01;
// gray_lut[ 7] <= 24'b00_00_00_00_00_10_10_10_10_10_01_01;

// gray_lut[ 8] <= 24'b00_00_00_00_00_00_10_10_10_10_10_01;
// gray_lut[ 9] <= 24'b00_00_00_00_01_01_01_01_01_01_01_10;

// gray_lut[10] <= 24'b00_00_00_00_00_00_00_00_00_01_01_10;

// gray_lut[11] <= 24'b00_00_00_00_01_01_01_01_01_01_10_10;

// gray_lut[12] <= 24'b00_00_01_01_01_01_01_01_01_10_10_10;
// gray_lut[13] <= 24'b00_01_01_01_01_01_01_01_10_10_10_10;
// gray_lut[14] <= 24'b01_01_01_01_01_01_01_10_10_10_10_10;

// gray_lut[15] <= 24'b00_00_00_00_00_00_00_10_10_10_10_10;

gray_lut[ 0] <= 40'b01_01_01_01_01_01_01_01_01_01_01_01_01_01_01_01_01_01_01_01;
gray_lut[ 1] <= 40'b01_01_01_01_01_01_01_01_01_01_01_01_01_01_01_01_01_01_01_00;
gray_lut[ 2] <= 40'b01_01_01_01_01_01_01_01_01_01_01_01_01_01_10_01_01_01_01_00;
gray_lut[ 3] <= 40'b01_01_01_01_01_01_01_01_01_01_01_01_01_10_01_01_00_00_00_00;
gray_lut[ 4] <= 40'b01_01_01_01_01_01_01_01_01_01_01_01_01_10_00_00_00_00_00_00;
gray_lut[ 5] <= 40'b01_01_01_01_01_01_01_01_01_01_01_10_00_00_00_00_00_00_00_00;
gray_lut[ 6] <= 40'b01_01_01_01_01_01_01_01_01_10_00_00_00_00_00_00_00_00_00_00;
gray_lut[ 7] <= 40'b01_01_01_01_01_01_01_01_10_00_00_00_00_00_00_00_00_00_00_00;
gray_lut[ 8] <= 40'b01_01_01_01_01_01_01_10_00_00_00_00_00_00_00_00_00_00_00_00;
gray_lut[ 9] <= 40'b01_01_01_01_01_01_10_00_00_00_00_00_00_00_00_00_00_00_00_00;
gray_lut[10] <= 40'b01_01_01_01_01_10_00_00_00_00_00_00_00_00_00_00_00_00_00_00;
gray_lut[11] <= 40'b01_01_01_01_10_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00;
gray_lut[12] <= 40'b01_01_01_10_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00;
gray_lut[13] <= 40'b01_01_10_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00;
gray_lut[14] <= 40'b01_10_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00;
gray_lut[15] <= 40'b10_10_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00;
end

	always@(posedge glb_clk)begin
		
		if(!glb_nrst)begin
			cnt_a <= 9'd0;
			btn_black_r <= 1'b0;
		end else begin
			
			btn_black_r <= btn_black;
			
			if(cnt_a >= (ltot - 1) )begin
				cnt_a <= 9'd0;
			end else begin
				cnt_a <= cnt_a + 1'b1;
			end
		end
	end
	
	always@(posedge glb_clk)begin
		
		if(!glb_nrst)begin
			sdle_r <= 1'b0;
		end else if(
			(cnt_b >= (fsl + fbl)) &&
			(cnt_b < (fsl + fbl + fdl))
		)begin
			if(cnt_a <= (lsl - 1) )begin
				sdle_r <= 1'b1;
			end else begin
				sdle_r <= 1'b0;
			end
		end else begin
			sdle_r <= 1'b0;
		end
	end
	
	always@(posedge glb_clk)begin
		
		if(!glb_nrst)begin
			sdce_l_r <= 1'b1;
		end else if(
			(cnt_b >= (fsl + fbl - 1)) &&
			(cnt_b < (fsl + fbl + fdl - 1))
		)begin
			if(
				(cnt_a >= (lsl + lbl - 1)) && 
				(cnt_a < (lsl + lbl + ldl - 1))
			)begin
				sdce_l_r <= 1'b0;
			end else begin
				sdce_l_r <= 1'b1;
			end
		end else begin
			sdce_l_r <= 1'b1;
		end
	end
	
	
	// =======================================================
	// Data
	// =======================================================
	wire	[lut_bw*2-1 : 0]	gray_w		[0 : 15];
	
	genvar i;
	
	generate
		for(i=0;i<16;i=i+1)begin : wire_ass
			assign gray_w[i] = gray_lut[i] << {gray_cnt, 1'b0};
		end
	endgenerate
	
	always@(posedge glb_clk)begin
		
		if(!glb_nrst)begin
			
			epp_data_r <= 8'b00_00_00_00;
		end else if(
			(cnt_b >= (fsl + fbl - 1)) &&
			(cnt_b < (fsl + fbl + fdl - 1))
		)begin
			if(clean_cnt > 4'd0)begin
				if(clean_cnt >= 4'd8)begin
					epp_data_r <= 8'b0101_0101;
				end else begin
					epp_data_r <= 8'b1010_1010;
				end
			end else if( (cnt_a >= (lsl + lbl + 0 - 1)) && (cnt_a < (lsl + lbl + 15 - 1)) )begin
				epp_data_r <= {4{gray_w[0][lut_bw*2-1 : lut_bw*2-2]}};
			end else if( (cnt_a >= (lsl + lbl + 15 - 1)) && (cnt_a < (lsl + lbl + 30 - 1)) )begin
				epp_data_r <= {4{gray_w[1][lut_bw*2-1 : lut_bw*2-2]}};
			end else if( (cnt_a >= (lsl + lbl + 30 - 1)) && (cnt_a < (lsl + lbl + 45 - 1)) )begin
				epp_data_r <= {4{gray_w[2][lut_bw*2-1 : lut_bw*2-2]}};
			end else if( (cnt_a >= (lsl + lbl + 45 - 1)) && (cnt_a < (lsl + lbl + 60 - 1)) )begin
				epp_data_r <= {4{gray_w[3][lut_bw*2-1 : lut_bw*2-2]}};
			end else if( (cnt_a >= (lsl + lbl + 60 - 1)) && (cnt_a < (lsl + lbl + 75 - 1)) )begin
				epp_data_r <= {4{gray_w[4][lut_bw*2-1 : lut_bw*2-2]}};
			end else if( (cnt_a >= (lsl + lbl + 75 - 1)) && (cnt_a < (lsl + lbl + 90 - 1)) )begin
				epp_data_r <= {4{gray_w[5][lut_bw*2-1 : lut_bw*2-2]}};
			end else if( (cnt_a >= (lsl + lbl + 90 - 1)) && (cnt_a < (lsl + lbl + 105 - 1)) )begin
				epp_data_r <= {4{gray_w[6][lut_bw*2-1 : lut_bw*2-2]}};
			end else if( (cnt_a >= (lsl + lbl + 105 - 1)) && (cnt_a < (lsl + lbl + 120 - 1)) )begin
				epp_data_r <= {4{gray_w[7][lut_bw*2-1 : lut_bw*2-2]}};
			end else if( (cnt_a >= (lsl + lbl + 120 - 1)) && (cnt_a < (lsl + lbl + 135 - 1)) )begin
				epp_data_r <= {4{gray_w[8][lut_bw*2-1 : lut_bw*2-2]}};
			end else if( (cnt_a >= (lsl + lbl + 135 - 1)) && (cnt_a < (lsl + lbl + 150 - 1)) )begin
				epp_data_r <= {4{gray_w[9][lut_bw*2-1 : lut_bw*2-2]}};
			end else if( (cnt_a >= (lsl + lbl + 150 - 1)) && (cnt_a < (lsl + lbl + 165 - 1)) )begin
				epp_data_r <= {4{gray_w[10][lut_bw*2-1 : lut_bw*2-2]}};
			end else if( (cnt_a >= (lsl + lbl + 165 - 1)) && (cnt_a < (lsl + lbl + 180 - 1)) )begin
				epp_data_r <= {4{gray_w[11][lut_bw*2-1 : lut_bw*2-2]}};
			end else if( (cnt_a >= (lsl + lbl + 180 - 1)) && (cnt_a < (lsl + lbl + 195 - 1)) )begin
				epp_data_r <= {4{gray_w[12][lut_bw*2-1 : lut_bw*2-2]}};
			end else if( (cnt_a >= (lsl + lbl + 195 - 1)) && (cnt_a < (lsl + lbl + 210 - 1)) )begin
				epp_data_r <= {4{gray_w[13][lut_bw*2-1 : lut_bw*2-2]}};
			end else if( (cnt_a >= (lsl + lbl + 210 - 1)) && (cnt_a < (lsl + lbl + 225 - 1)) )begin
				epp_data_r <= {4{gray_w[14][lut_bw*2-1 : lut_bw*2-2]}};
			end else if( (cnt_a >= (lsl + lbl + 225 - 1)) && (cnt_a < (lsl + lbl + 240 - 1)) )begin
				epp_data_r <= {4{gray_w[15][lut_bw*2-1 : lut_bw*2-2]}};
			end else begin
				epp_data_r <= 8'b00_00_00_00;
			end
		end
	end
	
	always@(posedge glb_clk)begin
		
		if(!glb_nrst)begin
			gdck_r <= 1'b0;
		end else begin
			if(
				(cnt_a >= (lsl + gdck_sta - 1)) && 
				(cnt_a < (lsl + gdck_sta + gdck_hi - 1))
			)begin
				gdck_r <= 1'b1;
			end else begin
				gdck_r <= 1'b0;
			end
		end
	end
	
	always@(posedge glb_clk)begin
		
		if(!glb_nrst)begin
			cnt_b <= 11'd0;
			gray_cnt <= 0;
			clean_cnt <= 4'd15;
		end else begin
			if(cnt_a >= (ltot - 1) )begin
				if(cnt_b >= (ftot - 1) )begin
					
					if(clean_cnt == 4'd0)begin
						if(gray_cnt >= (lut_bw-1) )begin
						
						end else begin
							cnt_b <= 11'd0;
							gray_cnt <= gray_cnt + 1'b1;
						end
					end else begin
						cnt_b <= 11'd0;
						clean_cnt <= clean_cnt - 1'b1;
					end
					
				end else begin
					cnt_b <= cnt_b + 1'b1;
				end
			end
		end
	end
	
	always@(posedge glb_clk)begin
		
		if(!glb_nrst)begin
			gdsp_r <= 1'b0;
		end else if(cnt_a >= (ltot - 1))begin
			if( cnt_b <= (fsl - 1) )begin
				gdsp_r <= 1'b0;
			end else begin
				gdsp_r <= 1'b1;
			end
		end
	end
	
	always@(posedge glb_clk)begin
		
		if(!glb_nrst)begin
			sdoe_r <= 1'b0;
		end else if(cnt_a >= (ltot - 1))begin
			if(
				(cnt_b >= (fsl + fbl - 1)) &&
				(cnt_b < (fsl + fbl + fdl - 1))
			)begin
				sdoe_r <= 1'b1;
			end else begin
				sdoe_r <= 1'b0;
			end
		end
	end
	
	always@(posedge glb_clk)begin
		
		if(!glb_nrst)begin
			gdoe_r <= 1'b0;
		end else if(cnt_a >= (ltot - 1))begin
			if(
				(cnt_b >= (fsl - 1)) &&
				(cnt_b < (fsl + fbl + fdl - 1))
			)begin
				gdoe_r <= 1'b1;
			end else begin
				gdoe_r <= 1'b0;
			end
		end
	end
	
endmodule
