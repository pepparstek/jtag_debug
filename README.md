# JTAG DEBUG

## Prerequisites including versions used
- Vivado (2024.1)
- openocd (0.12.0)
- gdb (14.2)

## Steps
1) Create the Vivado project with the .tcl file
2) Open Vivado and build the .bit file with Generate Bitstream.
3) Locate the .bit file
4) In the openocd.cfg script in the scripts folder, edit the path "pld load 0 /path/to/bitfile". (TODO: Fix default path to the generated bitfile)
5) Run openocd.cfg with chosen flags.  When running it the first time it will fail. This is because it tries to run the script before loading the bitstream. When running it a second time it will work. (TODO: Fix load before script starts)
6) Open a second terminal and start GDB

## Creating project from tcl
Navigate to the jtag_debug git repository and run 
```
vivado -mode tcl -source hippo_uart.tcl
```
This will create the project you need to generate the bitfile.

## Starting Openocd
In a terminal, navigate to the scripts folder. Execute
```
openocd -f openocd.cfg
```
If you want verbose mode, run
```
opoenocd -d3 -f openocd.cfg
```

## Starting GDB
In a terminal and run 
```
gdb
```
then run 
```
target extended-remote localhost:3333
```
