
set_property IOSTANDARD LVCMOS33 [get_ports {epp_data[7]}]
set_property IOSTANDARD LVCMOS33 [get_ports {epp_data[6]}]
set_property IOSTANDARD LVCMOS33 [get_ports {epp_data[5]}]
set_property IOSTANDARD LVCMOS33 [get_ports {epp_data[4]}]
set_property IOSTANDARD LVCMOS33 [get_ports {epp_data[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {epp_data[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {epp_data[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {epp_data[0]}]

set_property IOSTANDARD LVCMOS33 [get_ports epp_ckv]
set_property IOSTANDARD LVCMOS33 [get_ports epp_mode]
set_property IOSTANDARD LVCMOS33 [get_ports epp_stv]
set_property IOSTANDARD LVCMOS33 [get_ports epp_xcl]
set_property IOSTANDARD LVCMOS33 [get_ports epp_xle]
set_property IOSTANDARD LVCMOS33 [get_ports epp_xstl]
set_property IOSTANDARD LVCMOS33 [get_ports epp_xoe]

set_property PACKAGE_PIN P16 [get_ports epp_stv]
set_property PACKAGE_PIN R17 [get_ports epp_xstl]
set_property PACKAGE_PIN R16 [get_ports epp_xoe]
set_property PACKAGE_PIN P15 [get_ports epp_xle]
set_property PACKAGE_PIN Y12 [get_ports epp_ckv]
set_property PACKAGE_PIN V18 [get_ports epp_xcl]
set_property PACKAGE_PIN V19 [get_ports epp_mode]

set_property PACKAGE_PIN U17 [get_ports {epp_data[7]}]
set_property PACKAGE_PIN U18 [get_ports {epp_data[5]}]
set_property PACKAGE_PIN P19 [get_ports {epp_data[3]}]
set_property PACKAGE_PIN R19 [get_ports {epp_data[1]}]

set_property PACKAGE_PIN AA10 [get_ports {epp_data[6]}]
set_property PACKAGE_PIN AA11 [get_ports {epp_data[4]}]
set_property PACKAGE_PIN W10 [get_ports {epp_data[2]}]
set_property PACKAGE_PIN V10 [get_ports {epp_data[0]}]



set_property PACKAGE_PIN R4 [get_ports sys_clk_p]
set_property IOSTANDARD DIFF_SSTL15 [get_ports sys_clk_p]
set_property IOSTANDARD DIFF_SSTL15 [get_ports sys_clk_n]

set_property PACKAGE_PIN J21 [get_ports sys_nrst]
set_property IOSTANDARD LVCMOS33 [get_ports sys_nrst]

set_property BITSTREAM.GENERAL.COMPRESS TRUE [current_design]

set_property IOSTANDARD LVCMOS33 [get_ports btn_black]
set_property PACKAGE_PIN E13 [get_ports btn_black]
