BEGIN{
	i = 0
	n = 0
	total_energy = 0.0
	energy_avail[s] = initenergy;
}

{
	if($1 == "N"){
		for(i = 0; i < 24; i++){
			if(i == $5){
				energy_avail[i] = energy_avail[i] - (energy_avail[i] - $7);
				printf("%d - %f\n",i,energy_avail[i]);
			}
		}
	}
}

END{
	for(i = 0; i < 24; i++){
		printf("residual energy of %d node is %f\n",i,energy_avail[i])
		total_energy = total_energy + energy_avail[i];
	}
	printf("total energy of nodes is %f\n",total_energy)
}