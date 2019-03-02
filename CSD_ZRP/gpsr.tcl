# author: Thomas Ogilvie
# sample tcl script showing the use of GPSR and HLS (hierarchical location service)


## GPSR Options
Agent/GPSR set bdesync_                0.5 ;# beacon desync random component
Agent/GPSR set bexp_                   [expr 3*([Agent/GPSR set bint_]+[Agent/GPSR set bdesync_]*[Agent/GPSR set bint_])] ;# beacon timeout interval
Agent/GPSR set pint_                   1.5 ;# peri probe interval
Agent/GPSR set pdesync_                0.5 ;# peri probe desync random component
Agent/GPSR set lpexp_                  8.0 ;# peris unused timeout interval
Agent/GPSR set drop_debug_             1   ;#
Agent/GPSR set peri_proact_            1 	 ;# proactively generate peri probes
Agent/GPSR set use_implicit_beacon_    1   ;# all packets act as beacons; promisc.
Agent/GPSR set use_timed_plnrz_        0   ;# replanarize periodically
Agent/GPSR set use_congestion_control_ 0
Agent/GPSR set use_reactive_beacon_    0   ;# only use reactive beaconing

set opt(bint)           1.0 ;# beacon interval
set opt(use_mac)        1    ;# use link breakage feedback from MAC
set opt(use_peri)       1    ;# probe and use perimeters
set opt(use_planar)     1    ;# planarize graph
set opt(verbose)        1    ;#
set opt(use_beacon)     1    ;# use beacons at all
set opt(use_reactive)   0    ;# use reactive beaconing
set opt(locs)           0    ;# default to OmniLS
set opt(use_loop)       0    ;# look for unexpected loops in peris

set opt(agg_mac)          1 ;# Aggregate MAC Traces
set opt(agg_rtr)          0 ;# Aggregate RTR Traces
set opt(agg_trc)          0 ;# Shorten Trace File


set opt(chan)		Channel/WirelessChannel
set opt(prop)		Propagation/TwoRayGround
set opt(netif)		Phy/WirelessPhy
set opt(mac)		Mac/802_11
set opt(ifq)		Queue/DropTail/PriQueue
set opt(ll)		LL
set opt(ant)		Antenna/OmniAntenna
set opt(x)		1020      ;# X dimension of the topography
set opt(y)		1020      ;# Y dimension of the topography
set opt(ifqlen)		512       ;# max packet in ifq
set opt(seed)		1.0
set opt(adhocRouting)	GPSR      ;# AdHoc Routing Protocol
set opt(nn)		60       ;# how many nodes are simulated
set opt(stop)		300.0     ;# simulation time
set opt(use_gk)		0	  ;# > 0: use GridKeeper with this radius
set opt(zip)		0         ;# should trace files be zipped

set opt(agttrc)         ON ;# Trace Agent
set opt(rtrtrc)         ON ;# Trace Routing Agent
set opt(mactrc)         OFF ;# Trace MAC Layer
set opt(movtrc)         OFF;# Trace Movement


set opt(lt)		""
set opt(cp)		"./cbr/n60/n60_ms15_rate025_size64_seed2"
set opt(sc)		"./scenario/n60/d500_n60_x1020_y1020_h10_l0_p0"

set opt(out)            "result_gpsr.tr"

Agent/GPSR set locservice_type_ 2

Agent/GPSR set bint_                  $opt(bint)
# Recalculating bexp_ here
Agent/GPSR set bexp_                 [expr 3*([Agent/GPSR set bint_]+[Agent/GPSR set bdesync_]*[Agent/GPSR set bint_])] ;# beacon timeout interval
Agent/GPSR set use_peri_              $opt(use_peri)
Agent/GPSR set use_planar_            $opt(use_planar)
Agent/GPSR set use_mac_               $opt(use_mac)
Agent/GPSR set use_beacon_            $opt(use_beacon)
Agent/GPSR set verbose_               $opt(verbose)
Agent/GPSR set use_reactive_beacon_   $opt(use_reactive)
Agent/GPSR set use_loop_detect_       $opt(use_loop)

CMUTrace set aggregate_mac_           $opt(agg_mac)
CMUTrace set aggregate_rtr_           $opt(agg_rtr)

# seeding RNG
ns-random $opt(seed)

# create simulator instance
set ns_		[new Simulator]

set loadTrace  $opt(lt)

set topo	[new Topography]
$topo load_flatgrid $opt(x) $opt(y)

set tracefd	[open $opt(out) w]

$ns_ trace-all $tracefd

set chanl [new $opt(chan)]

# Create God
set god_ [create-god $opt(nn)]

# Attach Trace to God
set T [new Trace/Generic]
$T attach $tracefd
$T set src_ -5
$god_ tracetarget $T

#
# Define Nodes
#
puts "AdHoc Routing Protocol ($opt(adhocRouting))"
puts "Configuring Nodes ($opt(nn))"
puts "Time Simulation ($opt(stop))"
$ns_ node-config -adhocRouting $opt(adhocRouting) \
                 -llType $opt(ll) \
                 -macType $opt(mac) \
                 -ifqType $opt(ifq) \
                 -ifqLen $opt(ifqlen) \
                 -antType $opt(ant) \
                 -propType $opt(prop) \
                 -phyType $opt(netif) \
                 -channel $chanl \
		 -topoInstance $topo \
                 -wiredRouting OFF \
		 -mobileIP OFF \
		 -agentTrace $opt(agttrc) \
                 -routerTrace $opt(rtrtrc) \
                 -macTrace $opt(mactrc) \
                 -movementTrace $opt(movtrc)

#
#  Create the specified number of nodes [$val(nn)] and "attach" them
#  to the channel. 
for {set i 0} {$i < $opt(nn) } {incr i} {
    set node_($i) [$ns_ node]
    $node_($i) random-motion 0		;# disable random motion
	set ragent [$node_($i) set ragent_]
	$ragent install-tap [$node_($i) set mac_(0)]

    if { $opt(mac) == "Mac/802_11" } {      
	# bind MAC load trace file
	[$node_($i) set mac_(0)] load-trace $loadTrace
    }

    # Bring Nodes to God's Attention
    $god_ new_node $node_($i)
}

source $opt(sc)

source $opt(cp)

#
# Tell nodes when the simulation ends
#
for {set i 0} {$i < $opt(nn) } {incr i} {
    $ns_ at $opt(stop).0 "$node_($i) reset";
}

$ns_ at  $opt(stop).0002 "puts \"NS EXITING... $opt(out)\" ; $ns_ halt"

puts "Starting Simulation..."
$ns_ run