all: sim

vsim ?=vsim
console_mode = -c
sim_opts += $(console_mode)

.PHONY: clean
clean:
	rm -rf verification/build
	rm -f verification/transcript
	rm -f verification/*.wlf
	rm -f verification/modelsim.ini
	rm -f verification/mycov.ucdb
	rm -f verification/vsim_stacktrace.vstf
	rm -f verification/certe_dump.xml
	rm -f transcript

.PHONY: sim
sim:
	cd verification; $(vsim) $(sim_opts) -do "do sim.tcl;c;s"

.PHONY: gui
gui: 
	$(MAKE) sim console_mode=
