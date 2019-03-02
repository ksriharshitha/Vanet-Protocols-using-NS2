BEGIN{
	s = 0
	r = 0
	forwardPkt = 0
}

{
	if(($1 == "s" && $4 == "AGT") || ($1 == "s" && $4 == "RTR")){
		s++;
	}
	if(($1 == "r" && $4 == "AGT") || ($1 == "r" && $4 == "RTR")){
		r++;
	}
}

END{
	printf("sent packets %d\n",s);
	printf("received packets %d\n",r);
	printf("recv to send ratio %f \n",r/s);
	printf("dropped packects %d\n",(s-r));
}