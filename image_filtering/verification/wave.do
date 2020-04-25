onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /test_top/dut/aresetn
add wave -noupdate /test_top/dut/s_axis_aclk
add wave -noupdate /test_top/dut/s_axis_tready
add wave -noupdate /test_top/dut/s_axis_tvalid
add wave -noupdate /test_top/dut/s_axis_tdata
add wave -noupdate /test_top/dut/m_axis_aclk
add wave -noupdate /test_top/dut/m_axis_tready
add wave -noupdate /test_top/dut/m_axis_tvalid
add wave -noupdate /test_top/dut/m_axis_tdata
add wave -noupdate /test_top/dut/StorePtr
add wave -noupdate /test_top/dut/RestorePtr
add wave -noupdate /test_top/dut/ClearPtr
add wave -noupdate /test_top/dut/EmptyCount
add wave -noupdate /test_top/dut/FillCount
add wave -noupdate /test_top/dut/RdPtr
add wave -noupdate /test_top/dut/WrPtr
add wave -noupdate /test_top/dut/WrEnOut
add wave -noupdate /test_top/dut/Full
add wave -noupdate /test_top/dut/Empty
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {180 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 207
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ps
update
WaveRestoreZoom {0 ps} {174009929 ps}
