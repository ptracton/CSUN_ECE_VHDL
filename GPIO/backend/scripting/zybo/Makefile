
SYNTH_DIR = synthesis
IMPL_DIR  = implementation
BIT_DIR   = bitgen
BOARD     = zybo
PART      = xc7z010clg400-1

MAKE_DIRS = $(SYNTH_DIR) $(IMPL_DIR) $(BIT_DIR)

all: DIRS BIT_GEN

DIRS:
	@echo "Making Directories $(MAKE_DIRS)"
	@mkdir -p $(MAKE_DIRS)

SYNTHESIS: DIRS
	@echo "Synthesis"
	vivado -mode batch -source synthesis.tcl > $(SYNTH_DIR)/$(BOARD)_synthesis.log

IMPLEMENTATION: SYNTHESIS
	@echo "Implement Design"
	vivado -mode batch -source implementation.tcl > $(IMPL_DIR)/$(BOARD)_implementation.log

BIT_GEN:IMPLEMENTATION
	@echo "Generating Bit File"
	vivado -mode batch -source bitgen.tcl > $(BIT_DIR)/$(BOARD)_bitgen.log

PROGRAM:
	@echo "Programming FPGA"
	vivado -mode batch -source program.tcl > $(BIT_DIR)/$(BOARD)_program.log

clean:
	rm -rf *jou *log *.os *.dcp *~ .Xil *.pb *.rpt *html *xml
	rm -rf $(MAKE_DIRS) $(BOARD).cache $(BOARD).hw $(BOARD).xpr $(BOARD).ip_user_files
	rm -rf ip/clk_wiz_0/doc/ ip/clk_wiz_0/mmcm_pll_drp_func_* ip/clk_wiz_0/*.v ip/clk_wiz_0/*vhdl ip/clk_wiz_0/*xdc ip/clk_wiz_0/*veo ip/clk_wiz_0/*dcp ip/clk_wiz_0/*xml
	rm -rf .cache/
	find . -name "*~" | xargs rm -rf
