@echo off
set xv_path=C:\\Xilinx\\Vivado\\2016.4\\bin
call %xv_path%/xelab  -wto ace9bde789fe406c8664e56ba6d5100c -m64 --debug typical --relax --mt 2 -L xil_defaultlib -L secureip --snapshot main_fpga_behav xil_defaultlib.main_fpga -log elaborate.log
if "%errorlevel%"=="0" goto SUCCESS
if "%errorlevel%"=="1" goto END
:END
exit 1
:SUCCESS
exit 0
