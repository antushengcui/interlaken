#***************************************************************************
#
# Author:      $Author:$
# File:        $File:$
# Revision:    $Revision:$
# Date:        $Date:$
#
#****************************************************************************/
## Variables and scripts

#UVM_HOME = /usr/synopsys/uvm-1.1d
#VCS_HOME = /usr/synopsys/G-2012.09

verb =	UVM_MEDIUM
test = interlaken_example_test

DEFINE_PARA := MY_NULL_DEFINE DUMP_VCD DUMP_DEBUSSY SIM GLBL $(define)
define_para_local := $(foreach para,$(DEFINE_PARA),+define+$(para))

UVM_PARA = +define+UVM_OBJECT_MUST_HAVE_CONSTRUCTOR +incdir+$(UVM_HOME)/src $(UVM_HOME)/src/uvm.sv \
	$(UVM_HOME)/src/dpi/uvm_dpi.cc

VCS =	vcs -sverilog -timescale=1ns/1ns -debug_all -debug_pp \
	+acc +vpi +libext+.sv+.v+.vh+.vmd+.vo+.bv+.lmcds +v2k -ntb_opts dtm \
	-CFLAGS -DVCS +vcs+vcdpluson $(define_para_local) $(UVM_PARA) \
	+incdir+../sv +incdir+../../ut_utils/sv +incdir+../../ut_packets/sv \
	+incdir+../../common  \
	../../common/common_pkg.sv  \
	 ../../ut_utils/sv/ut_utils_pkg.sv  ../../ut_packets/sv/ut_packets_pkg.sv ../sv/interlaken_pkg.sv  -l vcs_$(test).log

SIMV = 	./simv +UVM_VERBOSITY=$(verb) -l sim_$(test).log +UVM_TESTNAME=$(test) \
		+vpdfile+vpd_$(test).vpd +UVM_SET_CONFIG_STRING=*,logs_dir,log_$(test) +UVM_TR_RECORD +UVM_LOG_RECORD

URG  = urg -format both -dir simv.vdb

TARGET=interlaken_demo_tb_top.sv

all: clean comp run

comp:
	$(VCS) +incdir+. $(TARGET)

run:
	mkdir log_$(test)
	$(SIMV)

dve:
	$(VCS_HOME)/bin/dve&

cover:
	$(URG)

clean:
	rm -rf *~ core csrc simv* vc_hdrs.h ucli.key urg* DVEfiles verdiLog log_$(test)

clean_all:
	rm -rf *~ core csrc simv* vc_hdrs.h ucli.key urg* *.log *.vpd DVEfiles verdi* novas* *.vf *.fsdb ral_* log_*

