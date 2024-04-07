## This file is for the ARTY
## To use it in a project:
## - uncomment the lines corresponding to used pins
## - rename the used ports (in each line, after get_ports) according to the top level signal names in the project

## Clock signal 100 MHz

set_property -dict {PACKAGE_PIN E3 IOSTANDARD LVCMOS33} [get_ports sysclk]

# do not time async inputs
set_false_path -from [get_ports {sw[0]}]
set_false_path -from [get_ports {sw[1]}]
set_false_path -from [get_ports {btn[0]}]
set_false_path -from [get_ports {btn[1]}]
set_false_path -from [get_ports {btn[2]}]
set_false_path -from [get_ports {btn[3]}]

set_false_path -to [get_ports {led[0]}]
set_false_path -to [get_ports {led[1]}]
set_false_path -to [get_ports {led[2]}]
set_false_path -to [get_ports {led[3]}]

set_false_path -to [get_ports rx]
set_false_path -from [get_ports tx]

set_false_path -to [get_ports {led_r[0]}]
set_false_path -to [get_ports {led_r[1]}]
set_false_path -to [get_ports {led_r[2]}]
set_false_path -to [get_ports {led_r[3]}]
set_false_path -to [get_ports {led_g[0]}]
set_false_path -to [get_ports {led_g[1]}]
set_false_path -to [get_ports {led_g[2]}]
set_false_path -to [get_ports {led_g[3]}]
set_false_path -to [get_ports {led_b[0]}]
set_false_path -to [get_ports {led_b[1]}]
set_false_path -to [get_ports {led_b[2]}]
set_false_path -to [get_ports {led_b[3]}]

## Switches
set_property -dict {PACKAGE_PIN A8 IOSTANDARD LVCMOS33} [get_ports {sw[0]}]
set_property -dict {PACKAGE_PIN C11 IOSTANDARD LVCMOS33} [get_ports {sw[1]}]

## Buttons
set_property -dict {PACKAGE_PIN D9 IOSTANDARD LVCMOS33} [get_ports {btn[0]}]
set_property -dict {PACKAGE_PIN C9 IOSTANDARD LVCMOS33} [get_ports {btn[1]}]
set_property -dict {PACKAGE_PIN B9 IOSTANDARD LVCMOS33} [get_ports {btn[2]}]
set_property -dict {PACKAGE_PIN B8 IOSTANDARD LVCMOS33} [get_ports {btn[3]}]

## Rx/Tx
set_property -dict {PACKAGE_PIN D10 IOSTANDARD LVCMOS33} [get_ports rx]
set_property -dict {PACKAGE_PIN A9 IOSTANDARD LVCMOS33} [get_ports tx]

## LEDs
set_property -dict {PACKAGE_PIN G6 IOSTANDARD LVCMOS33} [get_ports {led_r[0]}]
set_property -dict {PACKAGE_PIN G3 IOSTANDARD LVCMOS33} [get_ports {led_r[1]}]
set_property -dict {PACKAGE_PIN J3 IOSTANDARD LVCMOS33} [get_ports {led_r[2]}]
set_property -dict {PACKAGE_PIN K1 IOSTANDARD LVCMOS33} [get_ports {led_r[3]}]
set_property -dict {PACKAGE_PIN F6 IOSTANDARD LVCMOS33} [get_ports {led_g[0]}]
set_property -dict {PACKAGE_PIN J4 IOSTANDARD LVCMOS33} [get_ports {led_g[1]}]
set_property -dict {PACKAGE_PIN J2 IOSTANDARD LVCMOS33} [get_ports {led_g[2]}]
set_property -dict {PACKAGE_PIN H6 IOSTANDARD LVCMOS33} [get_ports {led_g[3]}]
set_property -dict {PACKAGE_PIN E1 IOSTANDARD LVCMOS33} [get_ports {led_b[0]}]
set_property -dict {PACKAGE_PIN G4 IOSTANDARD LVCMOS33} [get_ports {led_b[1]}]
set_property -dict {PACKAGE_PIN H4 IOSTANDARD LVCMOS33} [get_ports {led_b[2]}]
set_property -dict {PACKAGE_PIN K2 IOSTANDARD LVCMOS33} [get_ports {led_b[3]}]

set_property -dict {PACKAGE_PIN H5 IOSTANDARD LVCMOS33} [get_ports {led[0]}]
set_property -dict {PACKAGE_PIN J5 IOSTANDARD LVCMOS33} [get_ports {led[1]}]
set_property -dict {PACKAGE_PIN T9 IOSTANDARD LVCMOS33} [get_ports {led[2]}]
set_property -dict {PACKAGE_PIN T10 IOSTANDARD LVCMOS33} [get_ports {led[3]}]



create_debug_core u_ila_0 ila
set_property ALL_PROBE_SAME_MU true [get_debug_cores u_ila_0]
set_property ALL_PROBE_SAME_MU_CNT 4 [get_debug_cores u_ila_0]
set_property C_ADV_TRIGGER true [get_debug_cores u_ila_0]
set_property C_DATA_DEPTH 1024 [get_debug_cores u_ila_0]
set_property C_EN_STRG_QUAL true [get_debug_cores u_ila_0]
set_property C_INPUT_PIPE_STAGES 0 [get_debug_cores u_ila_0]
set_property C_TRIGIN_EN false [get_debug_cores u_ila_0]
set_property C_TRIGOUT_EN false [get_debug_cores u_ila_0]
set_property port_width 1 [get_debug_ports u_ila_0/clk]
connect_debug_port u_ila_0/clk [get_nets [list clk_gen/inst/clk_in1_clk_wiz_0]]
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe0]
set_property port_width 32 [get_debug_ports u_ila_0/probe0]
connect_debug_port u_ila_0/probe0 [get_nets [list {dmi_test_arr[1][0]} {dmi_test_arr[1][1]} {dmi_test_arr[1][2]} {dmi_test_arr[1][3]} {dmi_test_arr[1][4]} {dmi_test_arr[1][5]} {dmi_test_arr[1][6]} {dmi_test_arr[1][7]} {dmi_test_arr[1][8]} {dmi_test_arr[1][9]} {dmi_test_arr[1][10]} {dmi_test_arr[1][11]} {dmi_test_arr[1][12]} {dmi_test_arr[1][13]} {dmi_test_arr[1][14]} {dmi_test_arr[1][15]} {dmi_test_arr[1][16]} {dmi_test_arr[1][17]} {dmi_test_arr[1][18]} {dmi_test_arr[1][19]} {dmi_test_arr[1][20]} {dmi_test_arr[1][21]} {dmi_test_arr[1][22]} {dmi_test_arr[1][23]} {dmi_test_arr[1][24]} {dmi_test_arr[1][25]} {dmi_test_arr[1][26]} {dmi_test_arr[1][27]} {dmi_test_arr[1][28]} {dmi_test_arr[1][29]} {dmi_test_arr[1][30]} {dmi_test_arr[1][31]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe1]
set_property port_width 32 [get_debug_ports u_ila_0/probe1]
connect_debug_port u_ila_0/probe1 [get_nets [list {dmi_test_arr[2][0]} {dmi_test_arr[2][1]} {dmi_test_arr[2][2]} {dmi_test_arr[2][3]} {dmi_test_arr[2][4]} {dmi_test_arr[2][5]} {dmi_test_arr[2][6]} {dmi_test_arr[2][7]} {dmi_test_arr[2][8]} {dmi_test_arr[2][9]} {dmi_test_arr[2][10]} {dmi_test_arr[2][11]} {dmi_test_arr[2][12]} {dmi_test_arr[2][13]} {dmi_test_arr[2][14]} {dmi_test_arr[2][15]} {dmi_test_arr[2][16]} {dmi_test_arr[2][17]} {dmi_test_arr[2][18]} {dmi_test_arr[2][19]} {dmi_test_arr[2][20]} {dmi_test_arr[2][21]} {dmi_test_arr[2][22]} {dmi_test_arr[2][23]} {dmi_test_arr[2][24]} {dmi_test_arr[2][25]} {dmi_test_arr[2][26]} {dmi_test_arr[2][27]} {dmi_test_arr[2][28]} {dmi_test_arr[2][29]} {dmi_test_arr[2][30]} {dmi_test_arr[2][31]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe2]
set_property port_width 32 [get_debug_ports u_ila_0/probe2]
connect_debug_port u_ila_0/probe2 [get_nets [list {dmi_read_data[0]} {dmi_read_data[1]} {dmi_read_data[2]} {dmi_read_data[3]} {dmi_read_data[4]} {dmi_read_data[5]} {dmi_read_data[6]} {dmi_read_data[7]} {dmi_read_data[8]} {dmi_read_data[9]} {dmi_read_data[10]} {dmi_read_data[11]} {dmi_read_data[12]} {dmi_read_data[13]} {dmi_read_data[14]} {dmi_read_data[15]} {dmi_read_data[16]} {dmi_read_data[17]} {dmi_read_data[18]} {dmi_read_data[19]} {dmi_read_data[20]} {dmi_read_data[21]} {dmi_read_data[22]} {dmi_read_data[23]} {dmi_read_data[24]} {dmi_read_data[25]} {dmi_read_data[26]} {dmi_read_data[27]} {dmi_read_data[28]} {dmi_read_data[29]} {dmi_read_data[30]} {dmi_read_data[31]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe3]
set_property port_width 40 [get_debug_ports u_ila_0/probe3]
connect_debug_port u_ila_0/probe3 [get_nets [list {dmi_inc_data[0]} {dmi_inc_data[1]} {dmi_inc_data[2]} {dmi_inc_data[3]} {dmi_inc_data[4]} {dmi_inc_data[5]} {dmi_inc_data[6]} {dmi_inc_data[7]} {dmi_inc_data[8]} {dmi_inc_data[9]} {dmi_inc_data[10]} {dmi_inc_data[11]} {dmi_inc_data[12]} {dmi_inc_data[13]} {dmi_inc_data[14]} {dmi_inc_data[15]} {dmi_inc_data[16]} {dmi_inc_data[17]} {dmi_inc_data[18]} {dmi_inc_data[19]} {dmi_inc_data[20]} {dmi_inc_data[21]} {dmi_inc_data[22]} {dmi_inc_data[23]} {dmi_inc_data[24]} {dmi_inc_data[25]} {dmi_inc_data[26]} {dmi_inc_data[27]} {dmi_inc_data[28]} {dmi_inc_data[29]} {dmi_inc_data[30]} {dmi_inc_data[31]} {dmi_inc_data[32]} {dmi_inc_data[33]} {dmi_inc_data[34]} {dmi_inc_data[35]} {dmi_inc_data[36]} {dmi_inc_data[37]} {dmi_inc_data[38]} {dmi_inc_data[39]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe4]
set_property port_width 2 [get_debug_ports u_ila_0/probe4]
connect_debug_port u_ila_0/probe4 [get_nets [list {dmi_read_op[0]} {dmi_read_op[1]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe5]
set_property port_width 32 [get_debug_ports u_ila_0/probe5]
connect_debug_port u_ila_0/probe5 [get_nets [list {dmi_test_arr[3][0]} {dmi_test_arr[3][1]} {dmi_test_arr[3][2]} {dmi_test_arr[3][3]} {dmi_test_arr[3][4]} {dmi_test_arr[3][5]} {dmi_test_arr[3][6]} {dmi_test_arr[3][7]} {dmi_test_arr[3][8]} {dmi_test_arr[3][9]} {dmi_test_arr[3][10]} {dmi_test_arr[3][11]} {dmi_test_arr[3][12]} {dmi_test_arr[3][13]} {dmi_test_arr[3][14]} {dmi_test_arr[3][15]} {dmi_test_arr[3][16]} {dmi_test_arr[3][17]} {dmi_test_arr[3][18]} {dmi_test_arr[3][19]} {dmi_test_arr[3][20]} {dmi_test_arr[3][21]} {dmi_test_arr[3][22]} {dmi_test_arr[3][23]} {dmi_test_arr[3][24]} {dmi_test_arr[3][25]} {dmi_test_arr[3][26]} {dmi_test_arr[3][27]} {dmi_test_arr[3][28]} {dmi_test_arr[3][29]} {dmi_test_arr[3][30]} {dmi_test_arr[3][31]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe6]
set_property port_width 6 [get_debug_ports u_ila_0/probe6]
connect_debug_port u_ila_0/probe6 [get_nets [list {dmi_read_addr[0]} {dmi_read_addr[1]} {dmi_read_addr[2]} {dmi_read_addr[3]} {dmi_read_addr[4]} {dmi_read_addr[5]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe7]
set_property port_width 32 [get_debug_ports u_ila_0/probe7]
connect_debug_port u_ila_0/probe7 [get_nets [list {dmi_test_arr[0][0]} {dmi_test_arr[0][1]} {dmi_test_arr[0][2]} {dmi_test_arr[0][3]} {dmi_test_arr[0][4]} {dmi_test_arr[0][5]} {dmi_test_arr[0][6]} {dmi_test_arr[0][7]} {dmi_test_arr[0][8]} {dmi_test_arr[0][9]} {dmi_test_arr[0][10]} {dmi_test_arr[0][11]} {dmi_test_arr[0][12]} {dmi_test_arr[0][13]} {dmi_test_arr[0][14]} {dmi_test_arr[0][15]} {dmi_test_arr[0][16]} {dmi_test_arr[0][17]} {dmi_test_arr[0][18]} {dmi_test_arr[0][19]} {dmi_test_arr[0][20]} {dmi_test_arr[0][21]} {dmi_test_arr[0][22]} {dmi_test_arr[0][23]} {dmi_test_arr[0][24]} {dmi_test_arr[0][25]} {dmi_test_arr[0][26]} {dmi_test_arr[0][27]} {dmi_test_arr[0][28]} {dmi_test_arr[0][29]} {dmi_test_arr[0][30]} {dmi_test_arr[0][31]}]]
set_property C_CLK_INPUT_FREQ_HZ 300000000 [get_debug_cores dbg_hub]
set_property C_ENABLE_CLK_DIVIDER false [get_debug_cores dbg_hub]
set_property C_USER_SCAN_CHAIN 1 [get_debug_cores dbg_hub]
connect_debug_port dbg_hub/clk [get_nets u_ila_0_clk_in1_clk_wiz_0]
