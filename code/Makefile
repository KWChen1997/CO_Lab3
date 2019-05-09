SOURCE = Adder.v ALU.v Decoder.v MUX_2to1.v Reg_File.v Sign_Extend.v testbench.v ALU_Ctrl.v Data_Memory.v Instr_Memory.v ProgramCounter.v Shift_Left_Two_32.v Simple_Single_CPU.v Branch_Ctrl.v MUX_4to1.v
VVP = lab3.vvp
VCD = tb_wave.vcd
OUTPUT = output.txt

$(VCD): $(VVP)
	vvp $(VVP) > $(OUTPUT)

$(VVP): $(SOURCE)
	iverilog -o $(VVP) $(SOURCE)

show:
	gtkwave $(VCD)
clean:
	rm -f $(VVP) $(VCD)