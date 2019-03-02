# set number of nodes
#set opt(nn) 33

# set activity file
#set opt(af) $opt(config-path)
#append opt(af) /activity.tcl

# set mobility file
#set opt(mf) $opt(config-path)
#append opt(mf) /mobility.tcl

# set start/stop time
#set opt(start) 0.0
#set opt(stop) 100.0

# set floor size
#set opt(min-x) 810.66
#set opt(min-y) 945.51

# Copyright (c) 1997 Regents of the University of California.
# All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions
# are met:
# 1. Redistributions of source code must retain the above copyright
#    notice, this list of conditions and the following disclaimer.
# 2. Redistributions in binary form must reproduce the above copyright
#    notice, this list of conditions and the following disclaimer in the
#    documentation and/or other materials provided with the distribution.
# 3. All advertising materials mentioning features or use of this software
#    must display the following acknowledgement:
#      This product includes software developed by the Computer Systems
#      Engineering Group at Lawrence Berkeley Laboratory.
# 4. Neither the name of the University nor of the Laboratory may be used
#    to endorse or promote products derived from this software without
#    specific prior written permission.
#
# THIS SOFTWARE IS PROVIDED BY THE REGENTS AND CONTRIBUTORS ``AS IS'' AND
# ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
# IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
# ARE DISCLAIMED.  IN NO EVENT SHALL THE REGENTS OR CONTRIBUTORS BE LIABLE
# FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
# DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
# OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
# HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
# LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
# OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
# SUCH DAMAGE.
#
# simple-wireless.tcl
# A simple example for wireless simulation

# ======================================================================
# Define options
# ======================================================================
set val(chan)           Channel/WirelessChannel    ;# channel type
set val(prop)           Propagation/TwoRayGround   ;# radio-propagation model
set val(netif)          Phy/WirelessPhy            ;# network interface type
set val(mac)            Mac/802_11                 ;# MAC type
set val(ifq)            Queue/DropTail/PriQueue    ;# interface queue type
set val(ll)             LL                         ;# link layer type
set val(ant)            Antenna/OmniAntenna        ;# antenna model
set val(ifqlen)         50                         ;# max packet in ifq
set val(nn)             33                          ;# number of mobilenodes
set val(rp)             ZRP                       ;# routing protocol

# ======================================================================
# Main Program
# ======================================================================
set opt(x) 2874
set opt(y) 2022

Agent/ZRP set radius_ 2;
#
# Initialize Global Variables
#
set ns_		[new Simulator]
set tracefd     [open jubilee.tr w]
$ns_ trace-all $tracefd

set namf [open jubilee.nam w]
$ns_ namtrace-all-wireless $namf $opt(x) $opt(y)
# set up topography object
set topo       [new Topography]

$topo load_flatgrid $opt(x) $opt(y)

#
# Create God
#
create-god $val(nn)


set chan_1_ [new $val(chan)]

set chan_2_ [new $val(chan)]
#
#  Create the specified number of mobilenodes [$val(nn)] and "attach" them
#  to the channel. 
#  Here two nodes are created : node(0) and node(1)

# configure node

        $ns_ node-config -adhocRouting $val(rp) \
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
			 -movementTrace ON	\
			 -channel $chan_1_ \
			 -channel $chan_2_		
			 
	for {set i 0} {$i < $val(nn) } {incr i} {
		set node_($i) [$ns_ node]	
		$node_($i) random-motion 0		;# disable random motion
		$ns_ initial_node_pos $node_($i) 20
	}

#
# Provide initial (X,Y, for now Z=0) co-ordinates for mobilenodes
#
#$node_(0) set X_ 5.0
#$node_(0) set Y_ 2.0
#$node_(0) set Z_ 0.0

#$node_(1) set X_ 390.0
#$node_(1) set Y_ 385.0
#$node_(1) set Z_ 0.0

#
# Now produce some simple node movements
# Node_(1) starts to move towards node_(0)
#
#$ns_ at 50.0 "$node_(1) setdest 25.0 20.0 15.0"
#$ns_ at 10.0 "$node_(0) setdest 20.0 18.0 1.0"

# Node_(1) then starts to move away from node_(0)
#$ns_ at 100.0 "$node_(1) setdest 490.0 480.0 15.0" 

# Setup traffic flow between nodes
# TCP connections between node_(0) and node_(1)
source mobility.tcl



for {set i 0} {$i < $val(nn)} {incr i} {
# Defining a transport agent for sending
	set tcp [new Agent/TCP]

	# Attaching transport agent to sender node
	$ns_ attach-agent $node_($i) $tcp

	# Defining a transport agent for receiving
	set sink [new Agent/Null]

	# Attaching transport agent to receiver node
	$ns_ attach-agent $node_($i) $sink

	#Connecting sending and receiving transport agents
	$ns_ connect $tcp $sink

	#Defining Application instance
	set cbr [new Agent/CBR]

	$ns_ attach-agent $node_($i) $cbr

	# Attaching transport agent to application agent
	#$cbr attach-agent $udp

	#Packet size in bytes and interval in seconds definition
	$cbr set packetSize_ 100
	$cbr set interval_ 0.05
	$cbr set rate_ 1mb

	$ns_ connect $cbr $sink
	# data packet generation starting time
	$ns_ at 1.0 "$cbr start"

	# data packet generation ending time
	#$ns at 6.0 "$cbr stop"
	$ns_ at 100.0 "$cbr stop"

}
#
# Tell nodes when the simulation ends
#
for {set i 0} {$i < $val(nn) } {incr i} {
    $ns_ at 100.0 "$node_($i) reset";
}
$ns_ at 100.0 "stop"
$ns_ at 100.01 "puts \"NS EXITING...\" ; $ns_ halt"
proc stop {} {
    global ns_ tracefd
    $ns_ flush-trace
    close $tracefd
}

puts "Starting Simulation..."
$ns_ run
