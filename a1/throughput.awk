BEGIN {
	recv_size=0
	sTime=1e6
	spTime=0
	NumOfRecd=0
}
{
event =$1
time=$2
packet=$4
pkt_id=$9
packet_size=$8

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
	NumOfRecd++;
}
}

END {
	printf("Received Packets %d\n", NumOfRecd)
	printf("The throughput in kbps is %f \n", (NumOfRecd/(spTime-sTime)*(8/1000)))		
}
