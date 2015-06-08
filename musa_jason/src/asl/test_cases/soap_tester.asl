// Agent soap_tester in project adaptive_workflow

/* Initial beliefs and rules */

/* Initial goals */

!start.

/* Plans */

+!start : true 
	<- 
		st.invokeSearchFlight("16","02","2014","Palermo","Trento",List); 
		.println(List);
		
		st.invokeFlightDetails("3",Flight); 
		.println(Flight);
		
		st.invokeBookFlight("3",Return); 
		.println(Return);
	.
