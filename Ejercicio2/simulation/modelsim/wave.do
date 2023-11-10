onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -divider PC
add wave -noupdate -radix unsigned /processor_tb/dut/dp/FETCH/PC/d
add wave -noupdate -radix unsigned /processor_tb/dut/dp/FETCH/PC/q
add wave -noupdate -radix unsigned /processor_tb/dut/dp/FETCH/PC/enable
add wave -noupdate -divider FORWARDING
add wave -noupdate -radix binary /processor_tb/dut/dp/EXECUTE/forwarding_unit/forwardA
add wave -noupdate -radix binary /processor_tb/dut/dp/EXECUTE/forwarding_unit/forwardB
add wave -noupdate -radix unsigned /processor_tb/dut/dp/EXECUTE/forwarding_unit/EX_MEM_regWrite
add wave -noupdate -radix unsigned /processor_tb/dut/dp/EXECUTE/forwarding_unit/MEM_WB_regWrite
add wave -noupdate -radix unsigned /processor_tb/dut/dp/EXECUTE/forwarding_unit/ID_EX_rn1
add wave -noupdate -radix unsigned /processor_tb/dut/dp/EXECUTE/forwarding_unit/ID_EX_rm2
add wave -noupdate -radix unsigned /processor_tb/dut/dp/EXECUTE/forwarding_unit/EX_MEM_rd
add wave -noupdate -radix unsigned /processor_tb/dut/dp/EXECUTE/forwarding_unit/MEM_WB_rd
add wave -noupdate -divider ALU
add wave -noupdate -radix unsigned /processor_tb/dut/dp/EXECUTE/AluSrc
add wave -noupdate -radix unsigned /processor_tb/dut/dp/EXECUTE/AluControl
add wave -noupdate -radix hexadecimal /processor_tb/dut/dp/EXECUTE/aluResult_E
add wave -noupdate -radix unsigned /processor_tb/dut/dp/EXECUTE/zero_E
add wave -noupdate -radix unsigned /processor_tb/dut/dp/EXECUTE/ALU_a
add wave -noupdate -radix hexadecimal /processor_tb/dut/dp/EXECUTE/ALU_b
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {50 ps} 0}
quietly wave cursor active 1
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
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {0 ps} {173 ps}
