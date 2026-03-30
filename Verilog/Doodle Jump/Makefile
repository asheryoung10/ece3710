IVERILOG ?= iverilog
VVP ?= vvp
IVERILOG_FLAGS := -g2005 -Wall -I rtl/common

.PHONY: test test-cpu test-mmio test-soc clean

test: test-cpu test-mmio test-soc

test-cpu:
	mkdir -p build
	$(IVERILOG) $(IVERILOG_FLAGS) -o build/tb_cpu_smoke.out -f filelists/cpu_smoke.f
	$(VVP) build/tb_cpu_smoke.out

test-mmio:
	mkdir -p build
	$(IVERILOG) $(IVERILOG_FLAGS) -o build/tb_mmio_decode.out -f filelists/mmio.f
	$(VVP) build/tb_mmio_decode.out

test-soc:
	mkdir -p build
	$(IVERILOG) $(IVERILOG_FLAGS) -o build/tb_doodle_soc.out -f filelists/doodle_soc.f
	$(VVP) build/tb_doodle_soc.out

clean:
	rm -rf build
