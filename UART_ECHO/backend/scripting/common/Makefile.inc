
SETUP_DIR    = setup
COMPILE_DIR  = compile
BIT_DIR      = bitgen
IP_DIR       = generated_ip

MAKE_DIRS = $(SETUP_DIR) $(COMPILE_DIR) $(BIT_DIR) $(IP_DIR)

all: COMPILE

DIRS:
	@echo "\n\e[32mMaking Directories\e[0m"
	mkdir -p $(MAKE_DIRS)

.PHONY:IP
IP: DIRS
	@echo "\n\e[32mMaking IP\e[0m"
	vivado -mode batch -source create_ip.tcl > $(SETUP_DIR)/$(BOARD)_ip_setup.log

SETUP : DIRS IP
	@echo "\n\e[32mSetup\e[0m"
	vivado -mode batch -source setup.tcl > $(SETUP_DIR)/$(BOARD)_setup.log

COMPILE: SETUP
	@echo "\n\e[32mCompile\e[0m"
	vivado -mode batch -source compile.tcl > $(COMPILE_DIR)/$(BOARD)_compile.log

PROGRAM:
	@echo "\n\e[34mProgramming FPGA\e[0m"
	vivado -mode batch -source program.tcl > $(BIT_DIR)/$(BOARD)_program.log

.PHONY: clean
clean:
	@echo "\n\e[31mCleaning up....\e[0m"
	@rm -rf *jou *log *.os *.dcp *~ .Xil *.pb *.rpt *html *xml
	@rm -rf $(MAKE_DIRS) $(BOARD).cache $(BOARD).hw $(BOARD).xpr $(BOARD).ip_user_files
	@rm -rf ip/clk_wiz_0/doc/ ip/clk_wiz_0/mmcm_pll_drp_func_* ip/clk_wiz_0/*.v ip/clk_wiz_0/*vhdl ip/clk_wiz_0/*xdc ip/clk_wiz_0/*veo ip/clk_wiz_0/*dcp ip/clk_wiz_0/*xml
	@rm -rf .cache/
	@rm -rf clockInfo.txt
	@rm -rf generated_ip/
	@rm -rf IP/clk_wiz_0/
	@rm -rf uart_echo.cache  uart_echo.hw  uart_echo.ip_user_files  uart_echo.xpr
	@rm -rf .gen/ .ip_user_files/ .srcs/
	@find . -name "*~" | xargs rm -rf
