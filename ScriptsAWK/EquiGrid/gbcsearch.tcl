# base values

set val(chan)       Channel/WirelessChannel
set val(prop)       Propagation/TwoRayGround
set val(netif)      Phy/WirelessPhy       
set val(mac)        Mac/802_11
set val(ifq)        Queue/DropTail/PriQueue
set val(ll)         LL
set val(ant)        Antenna/OmniAntenna
set val(ifqlen)         20                     ;# max packet in ifq
set val(seed)           0.0

LL set mindelay_                50us
LL set delay_                   25us

Queue/DropTail/PriQueue set Prefer_Routing_Protocols    1

# unity gain, omni-directional antennas
# set up the antennas to be centered in the node and 1.5 meters above it
Antenna/OmniAntenna set X_ 0
Antenna/OmniAntenna set Y_ 0
Antenna/OmniAntenna set Z_ 1.5
Antenna/OmniAntenna set Gt_ 1.0
Antenna/OmniAntenna set Gr_ 1.0
                                                                                
# Initialize the SharedMedia interface with parameters to make
# it work like the 914MHz Lucent WaveLAN DSSS radio interface
Phy/WirelessPhy set CPThresh_ 10.0
Phy/WirelessPhy set CSThresh_ 1.559e-11

puts "TXPower: [Phy/WirelessPhy set Pt_]"
Phy/WirelessPhy set Rb_ 2*1e6
Phy/WirelessPhy set Pt_ 0.2818
Phy/WirelessPhy set freq_ 914e+6
Phy/WirelessPhy set L_ 1.0

Phy/WirelessPhy set RXThresh_ 3.65213e-10
#Phy/WirelessPhy set RXThresh_ 5.8434e-09


#Phy/WirelessPhy set RXThresh_ 1.42661e-08
#  ./a.out -m TwoRayGround -Pt 0.2818 -fr 914e+6 -Gt 1.0 -Gr 1.0 -L 1.0 -ht 1.5 -hr 1.5 250
# distance = 250
# propagation model: TwoRayGround

# Selected parameters:
# transmit power: 0.2818
# frequency: 9.14e+08
# transmit antenna gain: 1
# receive antenna gain: 1
# system loss: 1
# transmit antenna height: 1.5
# receive antenna height: 1.5

# Receiving threshold RXThresh_ is: 3.65213e-10

# Other values:
# 50m: 7.69009e-08
# 75m: 3.41782e-08
# 100m: 1.42661e-08
# 125m: 5.8434e-09
# 150m: 2.818e-09
# 175m: 1.52109e-09
# 200m: 8.91633e-10
# 225m: 5.56642e-10
# 250m: 3.65213e-10

Mac/802_11 set dataRate_ 11Mb
Mac/802_11 set basicRate_ 11Mb


set val(x) 		 2800
set val(y) 		 2800

set val(adhocRouting)   NOAH
set val(nn) 		 169
set val(stop) 		 2110

set val(out) 		 "/dev/shm/ramfs/rmlsearch"
set val(usenam) 	0
set val(verbose)        true

set val(range)		12


#rml
#set val(optdelay)	0
set val(port)		1234
set val(initiator)	0
set val(mesg_size)	1000
set val(delay)		0.01
set val(jitter)		0.007
#set val(resource)	[expr int(rand()*$val(nn))]
#while {$val(initiator)==$val(resource)} {
#	set val(resource)       [expr int(rand()*$val(nn))]
#}

# default value !!! NÃO SEI PARA QUE SERVE ?
set mode 1

# load command-line options

for {set i 0} {$i < $argc} {incr i} {
    set arg [lindex $argv $i]
    if {[string range $arg 0 0] != "-"} continue

    set name [string range $arg 1 end]
    set val($name) [lindex $argv [expr $i+1]]
}

#if { [string equal -length 3 $val(proto) "gbc"] } {
#    set mode 1
#} else {
    #set mode 0
#}


#rml
#set val(optpampa) policy-delpwr

if { $val(verbose) } {
    puts "DataRate: [Mac/802_11 set dataRate_]"
    puts "Range: $val(range) RXThresh: [Phy/WirelessPhy set RXThresh_]"
}

# =====================================================================
# Main Program
# ======================================================================

#
# Initialize Global Variables
#

# create simulator instance

set ns_		[new Simulator]

# setup topography object

set topo	[new Topography]

# create trace object for ns and nam

set tracefd	[open $val(out).tr w] 
$ns_ use-newtrace
$ns_ trace-all $tracefd


if {$val(usenam)==1} {
    set namtrace    [open $val(out).nam w]
    $ns_ namtrace-all-wireless $namtrace $val(x) $val(y)
}


# define topology
$topo load_flatgrid $val(x) $val(y)

#
# Create God
#
set god_ [create-god $val(nn)]

#
# define how node should be created
#

#global node setting

set chan [new $val(chan)]

$ns_ node-config \
    -adhocRouting $val(adhocRouting) \
    -llType $val(ll) \
    -macType $val(mac) \
    -ifqType $val(ifq) \
    -ifqLen $val(ifqlen) \
    -antType $val(ant) \
    -propType $val(prop) \
    -phyType $val(netif) \
    -channel $chan \
    -topoInstance $topo \
    -agentTrace OFF\
    -routerTrace OFF \
    -macTrace ON


#
#  Create the specified number of nodes [$val(nn)] and "attach" them
#  to the channel. 

#set val(optbcir) "policy-bers"
#set val(optargs) "10"
set val(res) "resources"

#debug 1

for {set i 0} {$i < $val(nn) } {incr i} {
    set node_($i) [$ns_ node]
    $node_($i) random-motion 0	;# disable random motion
    set gbc_($i) [new Agent/GBC]
    $node_($i) attach $gbc_($i) $val(port)
    $ns_ attach-agent $node_($i) $gbc_($i)

    #Set resources
    $gbc_($i) resource [expr $i + 1]
    
    
    $gbc_($i) delay $val(delay)
    $gbc_($i) jitter $val(jitter)
        
        
    # Set the destination for log info
    set T [new Trace/Generic]
    $T target [$ns_ set nullAgent_]
    $T attach $tracefd
    $T set src_ [$node_($i) id]
    $gbc_($i) log-target $T
}


#Set resources
#    if { [info exists resource]  } {
#	$gbc_($val(resource)) "resource"
#	puts "NS Resource =  $val(resource)"
#} else {
#	source ./res/$val(res)
#    	}




#
# Creates the Trace object to flush cache state messages. Several 
# can be created and each can be passed to a different instance of
# the dump-state command

#
#set finalstatsfd [open ./simul/$val(out)$val(proto).stats w]
#
#set finalstats [new Trace/Generic]
#$finalstats target [$ns_ set nullAgent_]
#$finalstats attach $finalstatsfd
#


#
# Load a movement file
#

source $val(mov)

#
# Placing the nodes at the correct position for nam
#

for {set i 0} {$i < $val(nn) } {incr i} {
    $ns_ initial_node_pos $node_($i) 30
}

#
# Some bcir commands
#

#$ns_ at 1.0 "$bcir_(0) bcast 1000"
#$ns_ at 0.0 "$bcir_($val(initiator)) bers $val(mesg_size) $val(resource)"

source ./$val(traf)

#
# Dump results
#
#for {set i 0} {$i < $val(nn) } {incr i} {
#    $ns_ at [expr $val(stop)+0.001] "$bcir_($i) dump-stats $finalstats";
#}

if { $val(verbose) } {
	$ns_ at $val(stop) "puts \"NS EXITING...\" ; $ns_ halt"
}

puts $tracefd "M 0.0 nn $val(nn) x $val(x) y $val(y) rp $val(adhocRouting)"
puts $tracefd "M 0.0 prop $val(prop) ant $val(ant)"

#puts $tracefd "[$pampa_(0) print-config]"

if { $val(verbose) } {
        puts "NS Starting... with $val(mov) and $val(traf)"
}

$ns_ run
