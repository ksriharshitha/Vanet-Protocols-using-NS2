BEGIN{
		recv = o
		currentTime = previousTime = 0
		timetic = 0.1
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

	if (previousTime){
		previousTime = times
	}

	if (packet = "AGT" && event = "r"){
		recv = recv + packet_size 
		currentTime = currentTime + (time - previousTime)
		if (currentTime >= timetic){
			printf("%f %f \n",time,(recv/currentTime)*(8/1000))
			recv = 0
			currentTime = 0
		}
		previousTime = time 
	}
}

END{
	printf("\n")
}