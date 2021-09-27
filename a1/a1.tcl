set val(chan)       Channel/WirelessChannel     ;# channel type
set val(prop)       Propagation/TwoRayGround    ;# radio-propagation model
set val(netif)      Phy/WirelessPhy             ;# network interface type
set val(mac)        Mac/802_11                  ;# MAC type
set val(ifq)        Queue/DropTail/PriQueue     ;# interface queue type
set val(ll)         LL                          ;# link layer type
set val(ant)        Antenna/OmniAntenna         ;# antenna model
set val(ifqlen)     50                          ;# max packet in ifq
set val(nn)         6                           ;# number of mobilenodes
set val(rp)         AODV                        ;# routing protocol
set val(x)          1000                         ;# X dimension of topography
set val(y)          1000                         ;# Y dimension of topography
set val(stop)       150                         ;# time of simulation end

set ns          [new Simulator]
set tracefd     [open trace.tr w]
set namtrace    [open out.nam w]

$ns trace-all $tracefd
$ns namtrace-all-wireless $namtrace $val(x) $val(y)

# set up topography object
set topo [new Topography]
$topo load_flatgrid $val(x) $val(y)
create-god $val(nn)

# Create nn mobilenodes [$val(nn)] and attach them to the channel.
set chan_1_ [new $val(chan)]

# configure the nodes
$ns node-config -adhocRouting $val(rp) \
-llType $val(ll) \
-macType $val(mac) \
-channel $chan_1_ \
-ifqType $val(ifq) \
-ifqLen $val(ifqlen) \
-antType $val(ant) \
-propType $val(prop) \
-phyType $val(netif) \
-topoInstance $topo \
-agentTrace ON \
-routerTrace ON \
-macTrace OFF \
-movementTrace ON

for {set i 0} {$i < $val(nn) } { incr i } {
    set node_($i) [$ns node]
}

# Road Endpoints:
# $node_(6) set X_ 0.0
# $node_(6) set Y_ 300.0
# $node_(6) set Z_ 0.0

# $node_(7) set X_ 150.0
# $node_(7) set Y_ 600.0
# $node_(7) set Z_ 0.0

# $node_(8) set X_ 150.0
# $node_(8) set Y_ 0.0
# $node_(8) set Z_ 0.0

# $node_(9) set X_ 300.0
# $node_(9) set Y_ 600.0
# $node_(9) set Z_ 0.0

# $node_(10) set X_ 300.0
# $node_(10) set Y_ 0.0
# $node_(10) set Z_ 0.0

# $node_(11) set X_ 450.0
# $node_(11) set Y_ 300.0
# $node_(11) set Z_ 0.0

# RSU:
$node_(0) set X_ 150.0
$node_(0) set Y_ 300.0
$node_(0) set Z_ 0.0
$node_(0) color red
$ns at 0.0 "$node_(0) color red"


$node_(1) set X_ 300.0
$node_(1) set Y_ 300.0
$node_(1) set Z_ 0.0
$node_(1) color red
$ns at 0.0 "$node_(1) color red"

# Vehicles:
$node_(2) set X_ 30.0
$node_(2) set Y_ 300.0
$node_(2) set Z_ 0.0

$node_(3) set X_ 210.0
$node_(3) set Y_ 300.0
$node_(3) set Z_ 0.0

$node_(4) set X_ 300.0
$node_(4) set Y_ 490.0
$node_(4) set Z_ 0.0

$node_(5) set X_ 390.0
$node_(5) set Y_ 300.0
$node_(5) set Z_ 0.0


# Generation of movements
$ns at 0.0 "$node_(2) setdest 450.0 300.0 49.0"
$ns at 0.0 "$node_(3) setdest 30.0 300.0 35.0"
$ns at 0.0 "$node_(4) setdest 300.0 30.0 57.0"
$ns at 0.0 "$node_(5) setdest 150.0 300.0 45.0"

# Set a TCP connection between node (2) and node (3)
set tcp [new Agent/TCP]
set sink [new Agent/TCPSink]
$ns attach-agent $node_(2) $tcp
$ns attach-agent $node_(3) $sink
$ns connect $tcp $sink
set ftp [new Application/FTP]
$ftp attach-agent $tcp
$ns at 0.0 "$ftp start"
$ns at 150.0 "$ftp stop"


# Set a TCP connection between node (5) and node (1)
set tcp [new Agent/TCP]
set sink [new Agent/TCPSink]
$ns attach-agent $node_(4) $tcp
$ns attach-agent $node_(1) $sink
$ns connect $tcp $sink
set ftp [new Application/FTP]
$ftp attach-agent $tcp
$ns at 0.0 "$ftp start"
$ns at 150.0 "$ftp stop"

# Set a TCP connection between node (4) and node (0)
set tcp [new Agent/TCP]
set sink [new Agent/TCPSink]
$ns attach-agent $node_(5) $tcp
$ns attach-agent $node_(0) $sink
$ns connect $tcp $sink
set ftp [new Application/FTP]
$ftp attach-agent $tcp
$ns at 0.0 "$ftp start"
$ns at 150.0 "$ftp stop"


# Define node initial position in nam
for {set i 0} {$i <$val(nn)} { incr i } {

# 30 defines the node size for nam
$ns initial_node_pos $node_($i) 30
}

# Telling nodes when the simulation ends
for {set i 0} {$i <$val(nn) } { incr i } {
$ns at $val(stop) "$node_($i) reset";
}

# ending nam and the simulation
$ns at $val(stop) "$ns nam-end-wireless $val(stop)"
$ns at $val(stop) "stop"
$ns at 150.01 "puts \"end simulation\" ; $ns halt"
proc stop {} {
    global ns tracefd namtrace
    $ns flush-trace
    close $tracefd
    close $namtrace
}

$ns run
