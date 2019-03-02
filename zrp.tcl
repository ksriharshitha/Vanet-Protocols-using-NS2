set val(chan) Channel/WirelessChannel;#Channel Type

set val(prop) Propagation/TwoRayGround;# radio-propagationmodel

set val(netif) Phy/WirelessPhy;# network interface type

set val(mac) Mac/802_11;# MAC type

set val(ifq) Queue/DropTail/PriQueue;# interface queue type

set val(ll) LL;# link layer type

set val(ant) Antenna/OmniAntenna;# antenna model

set val(ifqlen) 500;# max packet in ifq

set val(nn) 20;# number of mobilenodes

set val(rp) ZRP;# Routing protocol

set val(x) 1100

set val(y) 1100

Agent/ZRP set radius_ 2;

# Initialize Global Variables

set ns [new Simulator]

set tracefile [open scatternet10.tr w]

$ns trace-all $tracefile


set namtrace [open scatternet10.nam w]

$ns namtrace-all-wireless $namtrace $val(x) $val(y)


#$ns use-newtrace


# set up topography object

set topo [new Topography]


$topo load_flatgrid $val(x) $val(y)


# Create God

create-god $val(nn)

# New API to config node:

# 1. Create channel (or multiple-channels);

# 2. Specify channel in node-config (instead of channelType);

# 3. Create nodes for simulations.


# Create channel #1 and #2

set chan_1_ [new $val(chan)]

set chan_2_ [new $val(chan)]


# configure node, please note the change below.

$ns node-config -adhocRouting $val(rp) \
-llType $val(ll) \
-macType $val(mac) \
-ifqType $val(ifq) \
-ifqLen $val(ifqlen) \
-antType $val(ant) \
-propType $val(prop) \
-phyType $val(netif) \
-topoInstance $topo \
-energyModel "EnergyModel" \
-initialEnergy 100.0 \
-txPower 0.9 \
-rxPower 0.5 \
-idlePower 0.45 \
-sleepPower 0.05 \
-agentTrace ON \
-routerTrace ON \
-macTrace ON \
-movementTrace ON \
-channel $chan_1_


for {set i 0} {$i < $val(nn)} {incr i} {

set node_($i) [$ns node]

$node_($i) random-motion 0

$ns initial_node_pos $node_($i) 120

}

puts $tracefile "Nodes Defined"


$node_(0) set X_ 300.0

$node_(0) set Y_ 400.0

$node_(0) set Z_ 0.0

$ns initial_node_pos $node_(0) 200


$node_(1) set X_ 700.0

$node_(1) set Y_ 500.0

$node_(1) set Z_ 0.0

$ns initial_node_pos $node_(1) 200


$node_(2) set X_ 550.0

$node_(2) set Y_ 550.0

$node_(2) set Z_ 0.0

$ns initial_node_pos $node_(2) 150


$node_(3) set X_ 820.0

$node_(3) set Y_ 820.0

$node_(3) set Z_ 0.0

$ns initial_node_pos $node_(3) 250


$node_(4) set X_ 780.0

$node_(4) set Y_ 780.0

$node_(4) set Z_ 0.0

$ns initial_node_pos $node_(4) 70


$node_(10) set X_ 300.0

$node_(10) set Y_ 200.0

$node_(10) set Z_ 0.0

$ns initial_node_pos $node_(10) 100


$node_(11) set X_ 100.0

$node_(11) set Y_ 350.0

$node_(11) set Z_ 0.0

$ns initial_node_pos $node_(11) 100


$node_(7) set X_ 100.0

$node_(7) set Y_ 600.0

$node_(7) set Z_ 0.0

$ns initial_node_pos $node_(7) 100


$node_(15) set X_ 500.0

$node_(15) set Y_ 450.0

$node_(15) set Z_ 0.0

$ns initial_node_pos $node_(15) 140


$node_(5) set X_ 800.0

$node_(5) set Y_ 300.0

$node_(5) set Z_ 0.0

$ns initial_node_pos $node_(5) 100


$node_(6) set X_ 1000.0

$node_(6) set Y_ 500.0

$node_(6) set Z_ 0.0

$ns initial_node_pos $node_(6) 100


$node_(8) set X_ 600.0

$node_(8) set Y_ 900.0

$node_(8) set Z_ 0.0

$ns initial_node_pos $node_(8) 100


$node_(9) set X_ 1000.0

$node_(9) set Y_ 700.0

$node_(9) set Z_ 0.0

$ns initial_node_pos $node_(9) 100

$node_(12) set X_ 10.0

$node_(12) set Y_ 10.0

$node_(12) set Z_ 0.0

$ns initial_node_pos $node_(12) 350

$node_(13) set X_ 175.0

$node_(13) set Y_ 100.0

$node_(13) set Z_ 0.0

$ns initial_node_pos $node_(13) 145

$node_(14) set X_ 200.0

$node_(14) set Y_ 200.0

$node_(14) set Z_ 0.0

$ns initial_node_pos $node_(14) 90


$node_(16) set X_ 300.0

$node_(16) set Y_ 300.0

$node_(16) set Z_ 0.0

$ns initial_node_pos $node_(16) 135


$node_(17) set X_ 250.0

$node_(17) set Y_ 250.0

$node_(17) set Z_ 0.0

$ns initial_node_pos $node_(17) 168


$node_(18) set X_ 317.0

$node_(18) set Y_ 222.0

$node_(18) set Z_ 0.0

$ns initial_node_pos $node_(18) 190

#$node_(19) set X_ 300.0

#$node_(19) set Y_ 300.0

#$node_(19) set Z_ 0.0

#$ns initial_node_pos $node_(19) 290



puts $tracefile "Nodes' coordinates are Defined"


$ns at 1.0 "$node_(0) setdest 301.0 401.0 0.0"

$ns at 1.0 "$node_(1) setdest 700.0 500.0 0.0"

$ns at 1.0 "$node_(10) setdest 200.0 300.0 0.0"

$ns at 1.0 "$node_(11) setdest 100.0 400.0 0.0"

$ns at 1.0 "$node_(15) setdest 500.0 400.0 0.0"

$ns at 1.0 "$node_(5) setdest 800.0 300.0 0.0"

$ns at 1.0 "$node_(6) setdest 900.0 500.0 0.0"

$ns at 1.0 "$node_(7) setdest 200.0 600.0 0.0"

$ns at 1.0 "$node_(8) setdest 600.0 700.0 0.0"

$ns at 1.0 "$node_(9) setdest 1000.0 700.0 0.0"


#$ns at 1.0 "$node_(2) setdest 0.0 0.0 0.0"

#$ns at 1.0 "$node_(3) setdest 0.0 0.0 0.0"

#$ns at 1.0 "$node_(4) setdest 0.0 0.0 0.0"

#$ns at 1.0 "$node_(12) setdest 0.0 0.0 0.0"

#$ns at 1.0 "$node_(13) setdest 0.0 0.0 0.0"

#$ns at 1.0 "$node_(14) setdest 0.0 0.0 0.0"

#$ns at 1.0 "$node_(16) setdest 0.0 0.0 0.0"

#$ns at 1.0 "$node_(17) setdest 0.0 0.0 0.0"

#$ns at 1.0 "$node_(18) setdest 0.0 0.0 0.0"

#$ns at 1.0 "$node_(19) setdest 0.0 0.0 0.0"


#Creating TCP agents


set tcp0 [new Agent/TCP]

$ns attach-agent $node_(0) $tcp0

set tcp1 [new Agent/TCP]

$ns attach-agent $node_(1) $tcp1

set tcp2 [new Agent/TCP]

$ns attach-agent $node_(10) $tcp2

set tcp3 [new Agent/TCP]

$ns attach-agent $node_(11) $tcp3

set tcp4 [new Agent/TCP]

$ns attach-agent $node_(15) $tcp4

set tcp5 [new Agent/TCP]

$ns attach-agent $node_(5) $tcp5

set tcp6 [new Agent/TCP]

$ns attach-agent $node_(6) $tcp6

set tcp7 [new Agent/TCP]

$ns attach-agent $node_(7) $tcp7

set tcp8 [new Agent/TCP]

$ns attach-agent $node_(8) $tcp8

set tcp9 [new Agent/TCP]

$ns attach-agent $node_(9) $tcp9


#Creating NULL agents


set sink0 [new Agent/Null]

$ns attach-agent $node_(0) $sink0

$ns connect $tcp0 $sink0


set sink1 [new Agent/Null]

$ns attach-agent $node_(1) $sink1

$ns connect $tcp1 $sink1


set sink2 [new Agent/Null]

$ns attach-agent $node_(10) $sink2

$ns connect $tcp2 $sink2


set sink3 [new Agent/Null]

$ns attach-agent $node_(11) $sink3

$ns connect $tcp3 $sink3


set sink4 [new Agent/Null]

$ns attach-agent $node_(15) $sink4

$ns connect $tcp4 $sink4


set sink5 [new Agent/Null]

$ns attach-agent $node_(5) $sink5

$ns connect $tcp5 $sink5


set sink6 [new Agent/Null]

$ns attach-agent $node_(6) $sink6

$ns connect $tcp6 $sink6


set sink7 [new Agent/Null]

$ns attach-agent $node_(7) $sink7

$ns connect $tcp7 $sink7


set sink8 [new Agent/Null]

$ns attach-agent $node_(8) $sink8

$ns connect $tcp8 $sink8


set sink9 [new Agent/Null]

$ns attach-agent $node_(9) $sink9

$ns connect $tcp9 $sink9

# Creating CBR Agents


set cbr0 [new Agent/CBR]

$ns attach-agent $node_(0) $cbr0

$cbr0 set packetSize_ 100

$cbr0 set interval_ 0.05

$ns connect $cbr0 $sink0


set cbr1 [new Agent/CBR]

$ns attach-agent $node_(1) $cbr1

$cbr1 set packetSize_ 100

$cbr1 set interval_ 0.05

$cbr1 set rate_ 1mb

$ns connect $cbr1 $sink1


set cbr2 [new Agent/CBR]

$ns attach-agent $node_(10) $cbr2

$cbr2 set packetSize_ 100

$cbr2 set interval_ 0.05

$cbr2 set rate_ 1mb

$ns connect $cbr2 $sink2


set cbr3 [new Agent/CBR]

$ns attach-agent $node_(11) $cbr3

$cbr3 set packetSize_ 100

$cbr3 set interval_ 0.05

$cbr3 set rate_ 1mb

$ns connect $cbr3 $sink3


set cbr4 [new Agent/CBR]

$ns attach-agent $node_(15) $cbr4

$cbr4 set packetSize_ 100

$cbr4 set interval_ 0.05

$cbr4 set rate_ 1mb

$ns connect $cbr4 $sink4


set cbr5 [new Agent/CBR]

$ns attach-agent $node_(5) $cbr5

$cbr5 set packetSize_ 100

$cbr5 set interval_ 0.05

$cbr5 set rate_ 1mb

$ns connect $cbr5 $sink5


set cbr6 [new Agent/CBR]

$ns attach-agent $node_(6) $cbr6

$cbr6 set packetSize_ 100

$cbr6 set interval_ 0.05

$cbr6 set rate_ 1mb

$ns connect $cbr6 $sink6


set cbr7 [new Agent/CBR]

$ns attach-agent $node_(7) $cbr7

$cbr7 set packetSize_ 100

$cbr7 set interval_ 0.05

$cbr7 set rate_ 1mb

$ns connect $cbr7 $sink7


set cbr8 [new Agent/CBR]

$ns attach-agent $node_(8) $cbr8

$cbr8 set packetSize_ 100

$cbr8 set interval_ 0.05

$cbr8 set rate_ 1mb

$ns connect $cbr8 $sink8


set cbr9 [new Agent/CBR]

$ns attach-agent $node_(9) $cbr9

$cbr9 set packetSize_ 100

$cbr9 set interval_ 0.05

$cbr9 set rate_ 1mb

$ns connect $cbr9 $sink9


puts $tracefile "All Agents Created"


$ns at 1.1 "$cbr0 start"

$ns at 1.1 "$cbr1 start"

$ns at 1.1 "$cbr2 start"

$ns at 1.1 "$cbr3 start"

$ns at 1.1 "$cbr4 start"

$ns at 1.1 "$cbr5 start"

$ns at 1.1 "$cbr6 start"

$ns at 1.1 "$cbr7 start"

$ns at 1.1 "$cbr8 start"

$ns at 1.1 "$cbr9 start"

$ns at 5.0 "$cbr0 stop"

$ns at 5.0 "$cbr1 stop"

$ns at 5.0 "$cbr2 stop"

$ns at 5.0 "$cbr3 stop"

$ns at 5.0 "$cbr4 stop"

$ns at 5.0 "$cbr5 stop"

$ns at 5.0 "$cbr6 stop"

$ns at 5.0 "$cbr7 stop"

$ns at 5.0 "$cbr8 stop"

$ns at 5.0 "$cbr9 stop"


for {set i 0} {$i < $val(nn) } {incr i} {

$ns at 5.1 "$node_($i) reset";

}


$ns at 5.2 "stop"

$ns at 5.3 "puts \"NS EXITING...\" ; $ns halt"


proc stop {} {

global ns tracefile

$ns flush-trace

close $tracefile

}

puts "Starting Simulation..."

$ns run


