all: sim

vsim ?=vsim
console_mode = -c
sim_opts += $(console_mode)

.PHONY: clean
clean:
	rm -rf build
	rm -f transcript
	rm -f *.wlf
	rm -f modelsim.ini
	rm -f mycov.ucdb
	rm -f vsim_stacktrace.vstf
	rm -f certe_dump.xml

.PHONY: sim
sim:
	$(vsim) $(sim_opts) -do "do sim.tcl;c;a"

.PHONY: gui
gui: 
	$(MAKE) sim console_mode=
	
