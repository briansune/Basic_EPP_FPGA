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

module i2c_com(clock_i2c,          //i2c控制接口传输所需时钟，0-400khz，此处为20khz
               camera_rstn,     
               ack,              //应答信号
               i2c_data,          //sdin接口传输的32位数据
               start,             //开始传输标志
               tr_end,           //传输结束标志
               i2c_sclk,          //FPGA与camera iic时钟接口
               i2c_sdat);         //FPGA与camera iic数据接口
    input [23:0]i2c_data;
    input camera_rstn;
    input clock_i2c;
    output ack;
    input start;
    output tr_end;
    output i2c_sclk;
    inout i2c_sdat;
    reg [5:0] cyc_count;
    reg reg_sdat;
    reg sclk;
    reg ack1,ack2,ack3;
    reg tr_end;
 
   
    wire i2c_sclk;
    wire i2c_sdat;
    wire ack;
   
    assign ack=ack1|ack2|ack3;
    assign i2c_sclk=sclk|(((cyc_count>=4)&(cyc_count<=30))?~clock_i2c:0);
    assign i2c_sdat=reg_sdat?1'bz:0; 
   
    always@(posedge clock_i2c or  negedge camera_rstn)
    begin
       if(!camera_rstn)
         cyc_count<=6'b111111;
       else 
		   begin
           if(start==0)
             cyc_count<=0;
           else if(cyc_count<6'b111111)
             cyc_count<=cyc_count+1;
         end
    end
	 
	 
    always@(posedge clock_i2c or negedge camera_rstn)
    begin
       if(!camera_rstn)
       begin
          tr_end<=0;
          ack1<=1;
          ack2<=1;
          ack3<=1;
          sclk<=1;
          reg_sdat<=1;
       end
       else
          case(cyc_count)
          0:begin ack1<=1;ack2<=1;ack3<=1;tr_end<=0;sclk<=1;reg_sdat<=1;end
          1:reg_sdat<=0;                 //开始传输
          2:sclk<=0;
          3:reg_sdat<=i2c_data[23];
          4:reg_sdat<=i2c_data[22];
          5:reg_sdat<=i2c_data[21];
          6:reg_sdat<=i2c_data[20];
          7:reg_sdat<=i2c_data[19];
          8:reg_sdat<=i2c_data[18];
          9:reg_sdat<=i2c_data[17];
          10:reg_sdat<=i2c_data[16];
          11:reg_sdat<=1;                //应答信号
          12:begin reg_sdat<=i2c_data[15];ack1<=i2c_sdat;end
          13:reg_sdat<=i2c_data[14];
          14:reg_sdat<=i2c_data[13];
          15:reg_sdat<=i2c_data[12];
          16:reg_sdat<=i2c_data[11];
          17:reg_sdat<=i2c_data[10];
          18:reg_sdat<=i2c_data[9];
          19:reg_sdat<=i2c_data[8];
          20:reg_sdat<=1;                //应答信号       
          21:begin reg_sdat<=i2c_data[7];ack1<=i2c_sdat;end
          22:reg_sdat<=i2c_data[6];
          23:reg_sdat<=i2c_data[5];
          24:reg_sdat<=i2c_data[4];
          25:reg_sdat<=i2c_data[3];
          26:reg_sdat<=i2c_data[2];
          27:reg_sdat<=i2c_data[1];
          28:reg_sdat<=i2c_data[0];
          29:reg_sdat<=1;                //应答信号
          30:begin ack3<=i2c_sdat;sclk<=0;reg_sdat<=0;end
          31:sclk<=1;
          32:begin reg_sdat<=1;tr_end<=1;end
          endcase
       
end
endmodule

