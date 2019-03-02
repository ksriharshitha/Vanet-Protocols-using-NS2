BEGIN{
		recv_size = o
		sTime = 1e6
		spTime = 0
		NumofRecd = 0
}

{
	event = $1
	time = $3
	node_id = $5
	packet = $19
	pkt_id = $41
	flow_id = $39
	packet_size = $37
	flow_type = $45

	if (packet == "AGT" && sendTime[pkt_id] == 0 && (event == "+" || event == "s")){
		if (time < sTime){
			sTime = time;
		}
		sendTime[pkt_id] = time
		this_flow = flow_type
	}

	if (packet = "AGT" && event = "r"){
		if (time > spTime){
			spTime = time;
		}
		recv_size = recv_size + packet_size 
		recvTime[pkt_id] = time
		NumofRecd = NumofRecd + 1
	}
}

END{
	if (NumofRecd == 0){
		printf("no packets recieved")
	}
	printf("start time %d\n",sTime)
	printf("stop time %d\n",spTime)
	printf("recieved packet time %d\n",NumofRecd)
	printf("throughput in kbps %f\n", (NumofRecd/(spTime-sTime)*(8/1000))) 
}  