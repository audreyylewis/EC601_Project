## 100 MHz System Clock
set_property -dict { PACKAGE_PIN E3    IOSTANDARD LVCMOS33 } [get_ports { sys_clk }];
create_clock -add -name sys_clk_pin -period 10.00 -waveform {0 5} [get_ports { sys_clk }];

## Active-Low Reset (Red CPU_RESET button)
set_property -dict { PACKAGE_PIN C12   IOSTANDARD LVCMOS33 } [get_ports { rst_n }];

## 4-Bit Binary Input Switches (SW0 - SW3)
set_property -dict { PACKAGE_PIN J15   IOSTANDARD LVCMOS33 } [get_ports { sw_in[0] }];
set_property -dict { PACKAGE_PIN L16   IOSTANDARD LVCMOS33 } [get_ports { sw_in[1] }];
set_property -dict { PACKAGE_PIN M13   IOSTANDARD LVCMOS33 } [get_ports { sw_in[2] }];
set_property -dict { PACKAGE_PIN R15   IOSTANDARD LVCMOS33 } [get_ports { sw_in[3] }];

## Clock-Simulating Toggle Switch (SW15)
set_property -dict { PACKAGE_PIN V10   IOSTANDARD LVCMOS33 } [get_ports { clk_sw }];

## 4-Bit Binary Output LEDs (LD0 - LD3)
set_property -dict { PACKAGE_PIN H17   IOSTANDARD LVCMOS33 } [get_ports { result_out[0] }];
set_property -dict { PACKAGE_PIN K15   IOSTANDARD LVCMOS33 } [get_ports { result_out[1] }];
set_property -dict { PACKAGE_PIN J13   IOSTANDARD LVCMOS33 } [get_ports { result_out[2] }];
set_property -dict { PACKAGE_PIN N14   IOSTANDARD LVCMOS33 } [get_ports { result_out[3] }];

## External Breadboard GPIO Power Monitor (Pmod JA Pin 1)
set_property -dict { PACKAGE_PIN C17   IOSTANDARD LVCMOS33 } [get_ports { gpio_pwr_ok }];
set_property CLOCK_DEDICATED_ROUTE FALSE [get_nets gpio_pwr_ok_IBUF];

## Configuration Voltage Settings
set_property CFGBVS VCCO [current_design]
set_property CONFIG_VOLTAGE 3.3 [current_design]
