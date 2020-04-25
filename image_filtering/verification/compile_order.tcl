if {![file isdirectory build]} {file mkdir build}
onerror { quit -f -code 1 }
vlib build/ov7670
vmap ov7670 build/ov7670
vcom -2008 +cover=bcst -mixedsvvh -work ov7670 ../rtl/ov7670/ov7670_regs.vhd
vcom -2008 +cover=bcst -mixedsvvh -work ov7670 ../rtl/ov7670/sccb_sender.vhd
vcom -2008 +cover=bcst -mixedsvvh -work ov7670 ../rtl/ov7670/ov7670_control.vhd
vcom -2008 +cover=bcst -mixedsvvh -work ov7670 ../rtl/ov7670/ov7670_capture.vhd
vcom -2008 +cover=bcst -mixedsvvh -work ov7670 ../rtl/ov7670/image_refresh.vhd
vlib build/image_filtering
vmap ip_standardfifo build/image_filtering
vcom -2008 +cover=bcst -mixedsvvh -work image_filtering ../rtl/image_filtering/constants.vhd
vcom -2008 +cover=bcst -mixedsvvh -work image_filtering ../rtl/image_filtering/vga.vhd
vcom -2008 +cover=bcst -mixedsvvh -work image_filtering ../rtl/image_filtering/capture_memory.vhd
vcom -2008 +cover=bcst -mixedsvvh -work image_filtering ../rtl/image_filtering/image_filtering.vhd
vcom -2008 +cover=bcst -mixedsvvh -work image_filtering ../rtl/image_filtering/top_filtering_system.vhd
vlib build/uvm
vmap uvm build/uvm
vlog +cover=bcst  -work uvm ${loc_uvc_axis}pkg_axis.sv  \
	+incdir+$loc_uvc_axis \
	+incdir+${loc_uvc_axis}sequences/ \
	+incdir+${loc_uvc_axis}coverage/
vlog +cover=bcst  -work uvm ptr_ctrl_agent/pkg_ptr_ctrl.sv \
	+incdir+ptr_ctrl_agent/ \
	+incdir+ptr_ctrl_agent/sequences/ 
vlog +cover=bcst  -work uvm pkg_test.sv  \
	+incdir+$loc_pdtest \
	+incdir+sequences/ \
	+incdir+$loc_uvc_axis \
	+incdir+${loc_uvc_axis}sequences/ \
	+incdir+${loc_uvc_axis}coverage/ \
	+incdir+ptr_ctrl_agent/ \
	+incdir+ptr_ctrl_agent/sequences/ 	
vlog +cover=bcst  -work uvm top.sv \
	-L ip_standardfifo \
	+incdir+$loc_uvc_axis \
	+incdir+ptr_ctrl_agent/