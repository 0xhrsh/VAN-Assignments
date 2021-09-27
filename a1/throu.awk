#average throughput
BEGIN {
	recv_size=0
	sTime=1e6
	spTime=0
	NumOfRecd=0
}
#This awk file works only for new trace format, old trace does not have support
{
event =$1
time=$2
node_id=$5
packet=$4
pkt_id=$41
packet_size=$37

if(packet=="AGT" && sendTime[pkt_id] == 0 && (event == "+" || event == "s")) {
	if (time < sTime) {
		sTime=time
	}
	sendTime[pkt_id] = time
}

if(packet=="AGT" && event == "r") {
	if(time >spTime) {
		spTime=time
	}
	recv_size = recv_size + packet_size
	recvTime[pkt_id] = time
	NumOfRecd = NumOfRecd + 1
}
}

END {
	if (NumOfRecd ==0) {
		printf("No packets, the simulation might be very small \n")
	}
	printf("Start Time %d\n", sTime)
	printf("Stop Time %d\n", spTime)
	printf("Received Packets %d\n", NumOfRecd)
	printf("The throughput in kbps is %f \n", (NumOfRecd/(spTime-sTime)*(8/1000)))		
}