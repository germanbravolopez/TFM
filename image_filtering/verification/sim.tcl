#compile
proc c {} {
	do compile_order.tcl
	h
}
proc exit_with_code {} {
    set rc [coverage attribute -name TESTSTATUS -concise]
	puts "This is the return code :$rc"
    if {$rc > 1} {set rc 1} else {set rc 0}
    if {[batch_mode] && $rc} {
    	#check if questa runs from batch mode (vsim -c or vsim -batch option). 
    	#quit if this is the case (usefull when running automatic testbenches)
    	quit -f -code $rc
	#if the process is called from 'a' do not quit.
    } elseif {[batch_mode]} {return $rc}
}
proc addWaves {} {
	if {[batch_mode]} {
        #check if questa runs from batch mode (vsim -c or vsim -batch option).
        #in this case, do not add waves
		do wave.do
		# Added all signals, now trigger a wave window update
		wave refresh
    }
}
#simulate
proc s {{WAW 10} {WDW 8} {RDW 8} {CLK_M_P 10} {CLK_S_P 10} {COMMON_CLK 0} {it 5000} {openInViewer 1}} {
	quit -sim
	# try to close already open datasets
	catch {dataset close vsim}
	catch {dataset close mycoverage}	
	set test "test_base"
	#vsim	
	puts "\n NEW TEST STARTING...WAW=$WAW, WDW=$WDW, RDW=$RDW, iterations=$it, CLK_MASTER_PERIOD=$CLK_M_P, CLK_SLAVE_PERIOD=$CLK_S_P, COMMON_CLK=$COMMON_CLK"
	vsim -dpicpppath /usr/bin/gcc verification.test_top \
		-voptargs=+acc -coverage -classdebug -onfinish final -uvmcontrol=all -msgmode both \
		-L ip_standardfifo \
		-L uvc_axis \
		-L ptr_ctrl_agent \
		+UVM_TESTNAME=$test \
		-G WAW=$WAW -G WDW=$WDW -G RDW=$RDW -G iterations=$it \
		-G CLK_MASTER_PERIOD=$CLK_M_P -G CLK_SLAVE_PERIOD=$CLK_S_P \
		-G COMMON_CLK=$COMMON_CLK

	# log all signals in scope (so they can be added afterwards in the viewer) and run the simulation
	run 0
	log -r /*
	run -a
	if {[batch_mode]} {
        #check if questa runs from batch mode (vsim -c or vsim -batch option). 
        #quit if this is the case (usefull when running automatic testbenches)
        exit_with_code
    }
	
	#Add waves
	#addWaves
}
#simulate all tests
proc a {} {
	#to call the simulation use: 
	#s <Write_Address_Width> <Read_Data_Width> <Write_Data_Width> <CLK_MASTER_PERIOD> <CLK_SLAVE_PERIOD>.
	s 10  8  8 11 11 1
	s 10 16  8 33 11 0
	s 10  8 16 11 33 0
	s 10 32  8 11 11 1
	s 10 32 16 33 11 0
	s 10  8 32 11 33 0
	s  5 16 16 11 11 1
	s  7 17 34 33 11 0
	s  9 32  8 11 33 0
	s  8 12 24 10 10 0
	quit -f
}
#print help
proc h {} {
	puts "press:"
	puts "      'c' to compile"
	puts "      's' to simulate base test"
	puts "      'h' for this help"
	puts "      'a' simulate all test"
	puts "In mode 's' a desired value for widths can be applied as: s <WAW> <WDW> <RDW>"
}

#init Questa
puts "reload files automatically when they are modified"
set PrefSource(AutoReloadModifiedFiles) 1
#print help
h
