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
proc s {{param1 10} {openInViewer 1}} {
	quit -sim
	# try to close already open datasets
	catch {dataset close vsim}
	catch {dataset close mycoverage}	
	set test "test_base"
	#vsim	
	puts "\n NEW TEST STARTING... param1=$param1"
	vsim -dpicpppath /usr/bin/gcc verification.test_top \
		-voptargs=+acc -coverage -classdebug -onfinish final -uvmcontrol=all -msgmode both \
		-L ov7670 \
		-L image_filtering \
		+UVM_TESTNAME=$test \
		-G param1=$param1

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
	#s <param1>
	s 11
	quit -f
}
#print help
proc h {} {
	puts "press:"
	puts "      'c' to compile"
	puts "      's' to simulate base test"
	puts "      'h' for this help"
	puts "In mode 's' a desired value for widths can be applied"
}

#init Questa
puts "reload files automatically when they are modified"
set PrefSource(AutoReloadModifiedFiles) 1
#print help
h
