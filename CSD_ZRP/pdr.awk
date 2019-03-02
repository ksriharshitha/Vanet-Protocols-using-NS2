BEGIN{
	s = 0
	r = 0
	d = 0
	forwardPkt = 0
}

{
	if($1 == "s" && $4 == "AGT"){
		s++;
	}
	if($1 == "r" && $4 == "AGT"){
		r++;
	}
	if ($1 == "D"){

            d++;            

  } 
}

END{
	printf("sent packets %d\n",s);
	printf("received packets %d\n",s-d);
	printf("recv to send ratio %f \n",(s-d)/s);
	printf("dropped packects %d\n",d);
}
