/* =====================================================================
    ____         _                 ____                      
   | __ )  _ __ (_)  __ _  _ __   / ___|  _   _  _ __    ___ 
   |  _ \ | '__|| | / _` || '_ \  \___ \ | | | || '_ \  / _ \
   | |_) || |   | || (_| || | | |  ___) || |_| || | | ||  __/
   |____/ |_|   |_| \__,_||_| |_| |____/  \__,_||_| |_| \___|
   
   =====================================================================
   Date: 2024-01
   Author: Brian Sune
   Contact: briansune@gmail.com
   Revision: 1.0.0
   FPGA: XC7A100
   Tab Size: 4 spaces
   =====================================================================
*/

module reg_config(
	input clk_25M,
	input camera_rstn,
	output reg_conf_done,
	output i2c_sclk,
	inout i2c_sdat
);

    reg clock_20k;
	reg [8:0]reg_index;
     
     reg [15:0]clock_20k_cnt;
     reg [1:0]config_step;
	  
     reg [23:0]i2c_data;
     reg [15:0]reg_data;
     reg start;
	  reg reg_conf_done_reg;
	  
     i2c_com u1(.clock_i2c(clock_20k),
               .camera_rstn(camera_rstn),
               .ack(ack),
               .i2c_data(i2c_data),
               .start(start),
               .tr_end(tr_end),
               .i2c_sclk(i2c_sclk),
               .i2c_sdat(i2c_sdat));

assign reg_conf_done=reg_conf_done_reg;
//����i2c����ʱ��-20khz    
always@(posedge clk_25M or negedge camera_rstn)   
begin
   if(!camera_rstn) begin
        clock_20k<=0;
        clock_20k_cnt<=0;
   end
   else if(clock_20k_cnt<1249)
      clock_20k_cnt<=clock_20k_cnt+1'b1;
   else begin
         clock_20k<=!clock_20k;
         clock_20k_cnt<=0;
   end
end


////iic�Ĵ������ù��̿���    
always@(posedge clock_20k or negedge camera_rstn)    
begin
   if(!camera_rstn) begin
       config_step<=0;
       start<=0;
       reg_index<=0;
		 reg_conf_done_reg<=0;
   end
   else begin
      if(reg_conf_done_reg==1'b0) begin          //���camera��ʼ��δ���
			  if(reg_index<1) begin               //����ǰ302���Ĵ���
					 case(config_step)
					 0:begin
						i2c_data<={8'h90,reg_data};       //OV5640 IIC Device address is 0x78   
						start<=1;                         //i2cд��ʼ
						config_step<=1;                  
					 end
					 1:begin
						if(tr_end) begin                  //i2cд����               					
							 start<=0;
							 config_step<=2;
						end
					 end
					 2:begin
						  reg_index<=reg_index+1'b1;       //������һ���Ĵ���
						  config_step<=0;
					 end
					 endcase
				end
			 else 
				reg_conf_done_reg<=1'b1;                //OV5640�Ĵ�����ʼ�����
      end
   end
 end

////iic��Ҫ���õļĴ���ֵ
always@(*)   
 begin
    case(reg_index)
		0:  reg_data <= 16'h08_B1;
		default:reg_data <= 16'hffff;
    endcase      
end	 



endmodule

