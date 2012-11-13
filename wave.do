onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /dp_testbench/clk
add wave -noupdate /dp_testbench/n_rst
add wave -noupdate -radix hexadecimal /dp_testbench/top/ir1
add wave -noupdate -radix hexadecimal /dp_testbench/top/ir2
add wave -noupdate -radix hexadecimal /dp_testbench/top/ir3
add wave -noupdate -radix hexadecimal /dp_testbench/top/ir4
add wave -noupdate -radix hexadecimal -expand -subitemconfig {{/dp_testbench/top/r_reg[0]} {-height 16 -radix hexadecimal} {/dp_testbench/top/r_reg[1]} {-height 16 -radix hexadecimal} {/dp_testbench/top/r_reg[2]} {-height 16 -radix hexadecimal} {/dp_testbench/top/r_reg[3]} {-height 16 -radix hexadecimal} {/dp_testbench/top/r_reg[4]} {-height 16 -radix hexadecimal} {/dp_testbench/top/r_reg[5]} {-height 16 -radix hexadecimal} {/dp_testbench/top/r_reg[6]} {-height 16 -radix hexadecimal} {/dp_testbench/top/r_reg[7]} {-height 16 -radix hexadecimal}} /dp_testbench/top/r_reg
add wave -noupdate -radix binary /dp_testbench/top/ra1
add wave -noupdate -radix hexadecimal /dp_testbench/top/rd1
add wave -noupdate -radix binary /dp_testbench/top/ra2
add wave -noupdate -radix hexadecimal /dp_testbench/top/rd2
add wave -noupdate -radix binary /dp_testbench/top/wa
add wave -noupdate -radix hexadecimal /dp_testbench/top/wd
add wave -noupdate /dp_testbench/top/we
add wave -noupdate -radix hexadecimal /dp_testbench/top/dr1
add wave -noupdate -radix hexadecimal /dp_testbench/top/dr2
add wave -noupdate -radix hexadecimal /dp_testbench/top/tr
add wave -noupdate -radix hexadecimal /dp_testbench/top/sr1
add wave -noupdate -radix hexadecimal /dp_testbench/top/sr2
add wave -noupdate -group mem -radix hexadecimal /dp_testbench/top/mem_a1
add wave -noupdate -group mem -radix hexadecimal /dp_testbench/top/mem_a2
add wave -noupdate -group mem -radix hexadecimal /dp_testbench/top/mem_rd1
add wave -noupdate -group mem -radix hexadecimal /dp_testbench/top/mem_rd2
add wave -noupdate -group mem -radix hexadecimal /dp_testbench/top/mem_wd1
add wave -noupdate -group mem -radix hexadecimal /dp_testbench/top/mem_wd2
add wave -noupdate -group mem -radix hexadecimal /dp_testbench/top/mem_we1
add wave -noupdate -group mem -radix hexadecimal /dp_testbench/top/mem_we2
add wave -noupdate /dp_testbench/top/alu/st_refresh
add wave -noupdate -radix hexadecimal /dp_testbench/top/cf
add wave -noupdate -radix hexadecimal /dp_testbench/top/pf
add wave -noupdate -radix hexadecimal /dp_testbench/top/sf
add wave -noupdate -radix hexadecimal /dp_testbench/top/vf
add wave -noupdate -radix hexadecimal /dp_testbench/top/zf
add wave -noupdate -radix hexadecimal /dp_testbench/top/phase
add wave -noupdate -radix hexadecimal /dp_testbench/top/pc
add wave -noupdate -radix hexadecimal /dp_testbench/top/teststate
add wave -noupdate /dp_testbench/top/ct_taken
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {336086 ps} 0}
configure wave -namecolwidth 226
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
WaveRestoreZoom {16914 ps} {569802 ps}
