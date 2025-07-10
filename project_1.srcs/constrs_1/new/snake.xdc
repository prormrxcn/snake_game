# =============================================
# Clock Constraints (100MHz onboard clock)
# =============================================

set_property -dict { PACKAGE_PIN W5   IOSTANDARD LVCMOS33 } [get_ports clk];
# =============================================
# Reset Button (Active-High, Center button)
# =============================================
set_property -dict { PACKAGE_PIN U18   IOSTANDARD LVCMOS33 } [get_ports reset];
# =============================================
# Game Control Buttons (4-directional)
# =============================================
# right (BTNU)
set_property -dict { PACKAGE_PIN T17   IOSTANDARD LVCMOS33 } [get_ports {ctrl[0]}];

# left (BTND)
set_property -dict { PACKAGE_PIN W19   IOSTANDARD LVCMOS33 } [get_ports {ctrl[1]}];
# down (BTNL)
set_property -dict { PACKAGE_PIN U17   IOSTANDARD LVCMOS33 } [get_ports {ctrl[2]}];
# up (BTNR)
set_property -dict { PACKAGE_PIN T18   IOSTANDARD LVCMOS33 } [get_ports {ctrl[3]}];


# =============================================
# VGA Output Pins (4-bit color)
# =============================================
# vga_red (4-bit)
set_property -dict { PACKAGE_PIN G19   IOSTANDARD LVCMOS33 } [get_ports {vga_red[0]}];
set_property -dict { PACKAGE_PIN H19   IOSTANDARD LVCMOS33 } [get_ports {vga_red[1]}];
set_property -dict { PACKAGE_PIN J19   IOSTANDARD LVCMOS33 } [get_ports {vga_red[2]}];
set_property -dict { PACKAGE_PIN N19   IOSTANDARD LVCMOS33 } [get_ports {vga_red[3]}];

# vga_green (4-bit)
set_property -dict { PACKAGE_PIN J17   IOSTANDARD LVCMOS33 } [get_ports {vga_green[0]}];
set_property -dict { PACKAGE_PIN H17   IOSTANDARD LVCMOS33 } [get_ports {vga_green[1]}];
set_property -dict { PACKAGE_PIN G17   IOSTANDARD LVCMOS33 } [get_ports {vga_green[2]}];
set_property -dict { PACKAGE_PIN D17   IOSTANDARD LVCMOS33 } [get_ports {vga_green[3]}];

# vga_blue (4-bit)
set_property -dict { PACKAGE_PIN N18   IOSTANDARD LVCMOS33 } [get_ports {vga_blue[0]}];
set_property -dict { PACKAGE_PIN L18   IOSTANDARD LVCMOS33 } [get_ports {vga_blue[1]}];
set_property -dict { PACKAGE_PIN K18   IOSTANDARD LVCMOS33 } [get_ports {vga_blue[2]}];
set_property -dict { PACKAGE_PIN J18   IOSTANDARD LVCMOS33 } [get_ports {vga_blue[3]}];

# Sync Signals
set_property -dict { PACKAGE_PIN P19   IOSTANDARD LVCMOS33 } [get_ports vga_hsync];
set_property -dict { PACKAGE_PIN R19   IOSTANDARD LVCMOS33 } [get_ports vga_vsync];