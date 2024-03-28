onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tb_epp_basic/DUT/epp_ckv
add wave -noupdate /tb_epp_basic/DUT/epp_data
add wave -noupdate /tb_epp_basic/DUT/epp_mode
add wave -noupdate /tb_epp_basic/DUT/epp_stv
add wave -noupdate /tb_epp_basic/DUT/epp_xcl
add wave -noupdate /tb_epp_basic/DUT/epp_xle
add wave -noupdate /tb_epp_basic/DUT/epp_xoe
add wave -noupdate /tb_epp_basic/DUT/epp_xstl
add wave -noupdate /tb_epp_basic/DUT/cnt_a
add wave -noupdate /tb_epp_basic/DUT/cnt_b
add wave -noupdate /tb_epp_basic/DUT/sys_clk_n
add wave -noupdate /tb_epp_basic/DUT/sys_clk_p
add wave -noupdate /tb_epp_basic/DUT/sys_nrst
add wave -noupdate /tb_epp_basic/DUT/btn_black_r
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ps} 0}
quietly wave cursor active 0
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 1
configure wave -timelineunits ns
update
WaveRestoreZoom {977002 ps} {1001211 ps}
