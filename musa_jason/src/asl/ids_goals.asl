agent_metric(duplicate_workers)[pack(p1)].


/**
 * [Goal base OCCP] - prima
 *
social_goal( condition(and([received_order(order,user),true])), condition(done(complete_transaction)), system )[goal(process0),pack(p4),parlist([par(order,12345),par(user,185)])].
agent_goal( condition(received_order(order,user)), condition(order_placed(order,user)), system )[goal(g0),pack(p4),parlist([par(order,12345),par(user,185)])].
agent_goal( condition(order_placed(order,user)), condition(set_user_data(user,email)), system )[goal(g1),pack(p4),parlist([par(user,185),par(email,"davide.guastella90_AT_gmail.com")])].
agent_goal( condition(set_user_data(user,email)), condition(order_checked(order)), system )[goal(g2),pack(p4),parlist([par(order,12345),par(user,185),par(email,"davide.guastella90_AT_gmail.com")])].
agent_goal( condition(and([order_checked(order), order_status(accepted)])), condition(billing_delivered(billing,recipient_id,order,email)), system )[goal(g3),pack(p4),parlist([par(billing,"FATTURA_PDF"),par(order,12345),par(recipient_id,185),par(email,"davide.guastella90_AT_gmail.com")  ])].
agent_goal( condition(billing_delivered(billing,recipient_id,order,email)), condition(billing_uploaded(user)), system )[goal(g4),pack(p4),parlist([par(user,185)])].
agent_goal( condition(billing_uploaded(user)), condition(fulfill_order(order,user)), system )[goal(g5),pack(p4),parlist([par(order,12345),par(user,185)])].
agent_goal( condition(and([order_checked(order), order_status(refused)])), condition(notify_order_unfeasibility(message)), system )[goal(g6),pack(p4),parlist([par(message,"ORDER_REFUSED")])].
agent_goal( condition(notify_order_unfeasibility(message)), condition(order_deleted(order)), system )[goal(g7),pack(p4),parlist([par(order,12345)])].
agent_goal( condition(or([order_deleted(order),fulfill_order(order,user)])), condition(done(complete_transaction)), system )[goal(g8),pack(p4),parlist([])].
* 
* --------
* 
* social_goal( condition(and([received_order(order,user),true])), condition(done(complete_transaction)), system )[goal(process0),pack(p4),parlist([par(order,order_param),par(user,user_param)])].
agent_goal( condition(received_order(order,user)), condition(order_placed(order,user)), system )[goal(g0),pack(p4),parlist([par(order,order_param),par(user,user_param)])].
agent_goal( condition(order_placed(order,user)), condition(set_user_data(user,email)), system )[goal(g1),pack(p4),parlist([par(user,user_param),par(email,email_param)])].
agent_goal( condition(set_user_data(user,email)), condition(order_checked(order)), system )[goal(g2),pack(p4),parlist([par(order,order_param),par(user,user_param),par(email,email_param)])].
agent_goal( condition(and([order_checked(order), order_status(accepted)])), condition(billing_delivered(billing,recipient_id,order,email)), system )[goal(g3),pack(p4),parlist([par(billing,"FATTURA_PDF"),par(order,order_param),par(recipient_id,user_param),par(email,email_param)  ])].
agent_goal( condition(billing_delivered(billing,recipient_id,order,email)), condition(billing_uploaded(user)), system )[goal(g4),pack(p4),parlist([par(user,user_param)])].
agent_goal( condition(billing_uploaded(user)), condition(fulfill_order(order,user)), system )[goal(g5),pack(p4),parlist([par(order,order_param),par(user,user_param)])].
agent_goal( condition(and([order_checked(order), order_status(refused)])), condition(notify_order_unfeasibility(message)), system )[goal(g6),pack(p4),parlist([par(message,order_refused_message_param)])].
agent_goal( condition(notify_order_unfeasibility(message)), condition(order_deleted(order)), system )[goal(g7),pack(p4),parlist([par(order,order_param)])].
agent_goal( condition(or([order_deleted(order),fulfill_order(order,user)])), condition(done(complete_transaction)), system )[goal(g8),pack(p4),parlist([])].
* 
*/


/*
 * [Goal base IDS]
social_goal( condition(message_in(doc,customer)), condition( or([rejected(doc), notified(doc,customer)])), [customer,system] )[goal(process0),pack(p1),parlist([])].
agent_goal( condition(message_in(doc,customer)), condition( and([available(doc),unclassified(doc)]) ), system)[goal(g0),pack(p1),parlist([])].
agent_goal( condition(unclassified(doc)), condition( classified(doc) ), system)[goal(g1),pack(p1),parlist([])].
agent_goal( condition(classified(doc)), condition( and([refined(doc),available(doc,attachment)] )), system)[goal(g2),pack(p1),parlist([])].
agent_goal( condition(refined(doc)), condition( or([approved(doc),rejected(doc),incomplete(doc)] )), system )[goal(g3),pack(p1),parlist([])].
agent_goal( condition(approved(doc)), condition( notified(doc,customer) ), system)[goal(g4),pack(p1), parlist([par(msg,"approved"), par(msg_code,1)])  ].
agent_goal( condition(rejected(doc)), condition( fixed(doc) ), system)[goal(g5),pack(p1),parlist([])].
 */

/* goal base funzionante [SIGMA]*
social_goal( condition(  received_emergency_notification(location, worker_operator) ), condition( done(secure_artworks) ), [firefighter,system] )[goalfused(process0),pack(p1), parlist([ par(location,"palermo"), par(worker_operator,"firefighter") ])].
agent_goal( condition( received_emergency_notification(location, worker_operator) ), condition( move(worker_operator, location) ), [firefighter]) [goal(g0),pack(p1), parlist([ par(location,"palermo"), par(worker_operator,"firefighter") ])].
agent_goal( condition( and([done(secure_injured), done(assess_explosion_hazard), done(assess_fire_hazard)])), condition( done(evacuation) ), [firefighter])[goal(g4),pack(p1),parlist([])].
agent_goal( condition( and([move(worker_operator, location), injured(person)]) ), condition( done(secure_injured) ), [firefighter])[goal(g1),pack(p1), parlist([ par(location,"palermo"), par(worker_operator,"firefighter") ])].
agent_goal( condition( move(worker_operator, location)), condition( done(assess_explosion_hazard) ), [firefighter])[goal(g2),pack(p1),parlist([ par(location,"palermo"), par(worker_operator,"firefighter") ])].
agent_goal( condition( move(worker_operator, location)), condition( done(assess_fire_hazard) ), [firefighter])[goalfused(g3),pack(p1), parlist([ par(location,"palermo"), par(worker_operator,"firefighter") ])].
agent_goal( condition( done(evacuation)), condition( done(delimit_dangerous_area) ), [firefighter])[goal(g5),pack(p1),parlist([])].
agent_goal( condition( done(delimit_dangerous_area)), condition( done(prepare_medical_area) ), [firefighter])[goal(g6),pack(p1),parlist([])].
agent_goal( condition( done(prepare_medical_area)), condition( done(fire_extinguished) ), [firefighter])[goal(g7),pack(p1),parlist([])].
agent_goal( condition( done(fire_extinguished)), condition( done(secure_artworks)), [firefighter])[goal(g8),pack(p1),parlist([])].
*/

//social_goal( condition( received_emergency_notification(location, worker_operator) ), condition( done(secure_artworks) ), [firefighter,system] )[goal(process0),pack(p1), parlist([ par(location,"palermo"), par(worker_operator,"firefighter") ])].
//agent_goal( condition( received_emergency_notification(location, worker_operator) ), condition( move(worker_operator, location) ), [firefighter]) [goal(g0),pack(p1), parlist([ par(location,"palermo"), par(worker_operator,"firefighter") ])].
//agent_goal( condition( received_emergency_notification(location, worker_operator) ), condition( move(firefighter, location) ), [firefighter]) [goal(g0),pack(p1), parlist([ par(location,"palermo"), par(worker_operator,"firefighter") ])].

/*
agent_goal( condition( and([done(secure_injured), done(assess_explosion_hazard), done(assess_fire_hazard)])), condition( done(evacuation) ), [firefighter])[goal(g4),pack(p1),parlist([])].
agent_goal( condition( and([move(worker_operator, location), injured(person)]) ), condition( done(secure_injured) ), [firefighter])[goal(g1),pack(p1), parlist([ par(location,"palermo"), par(worker_operator,"firefighter") ])].
//agent_goal( condition( move(worker_operator, location)), condition( done(assess_explosion_hazard) ), [firefighter])[goal(g2),pack(p1),parlist([ par(location,"palermo"), par(worker_operator,"firefighter") ])].
//agent_goal( condition( move(worker_operator, location)), condition( done(assess_fire_hazard) ), [firefighter])[goal(g3),pack(p1), parlist([ par(location,"palermo"), par(worker_operator,"firefighter") ])].		
agent_goal( condition( done(evacuation)), condition( done(delimit_dangerous_area) ), [firefighter])[goal(g5),pack(p1),parlist([])].
agent_goal( condition( done(delimit_dangerous_area)), condition( done(prepare_medical_area) ), [firefighter])[goal(g6),pack(p1),parlist([])].
agent_goal( condition( done(prepare_medical_area)), condition( done(fire_extinguished) ), [firefighter])[goal(g7),pack(p1),parlist([])].
agent_goal( condition( done(fire_extinguished)), condition( done(secure_artworks)), [firefighter])[goal(g8),pack(p1),parlist([])].
agent_goal( condition( and([done(secure_injured), done(activityFittizia)])), condition( done(evacuation) ), [firefighter])[goal(g10),pack(p1),parlist([])].
 */

//{ include("goalBaseSigma.asl") }





/**
 * Utilizzata per calcolare lo score di una soluzione
 */
+!metric(duplicate_workers,CS,Accumulation,Score)
	<-
		!unroll_CS_to_exctract_agent_set(CS,AgentSet);
		
		!unroll_AgentSet_to_count_workers(AgentSet,WorkerNumber);
		if (WorkerNumber>1) {Score = 0;} 
		else 				{Score = 1;}
	.

+!unroll_CS_to_exctract_agent_set(CS,AgentSet)
	:	CS		 = []
	<-	AgentSet = [];
	.
+!unroll_CS_to_exctract_agent_set(CS,AgentSet)
	:
		CS		= [ Head | Tail ] &
		Head 	= commitment (Agent, Capability, Percent)
	<-
		!unroll_CS_to_exctract_agent_set(Tail,TailAgentSet);
		.union([Agent],TailAgentSet,AgentSet);
	.

+!unroll_CS_to_exctract_agent_set(CS,AgentSet)
	:
		CS=[ Head | Tail ] &
		Head = task(TC,FS,Evo,cs(TaskCS),AssignmentSet,Norms)
	<-
		!unroll_CS_to_exctract_agent_set(TaskCS,TaskAgentSet);
		!unroll_CS_to_exctract_agent_set(Tail,TailAgentSet);
		.union(TaskAgentSet,TailAgentSet,AgentSet);
	.

+!unroll_AgentSet_to_count_workers(AgentSet,WorkerNumber)
	:	AgentSet		= []
	<-	WorkerNumber	= 0;
	.
+!unroll_AgentSet_to_count_workers(AgentSet,WorkerNumber)
	:
		AgentSet=[ Head | Tail ]
	<-
		!get_agent_role(Head,Role);
		!unroll_AgentSet_to_count_workers(Tail,TailWorkerNumber);
		
		if (Role=worker) 	{ WorkerNumber = TailWorkerNumber + 1; 	} 
		else 				{ WorkerNumber = TailWorkerNumber;		}
	.

	
+!get_agent_role(emilio,worker).
+!get_agent_role(filippo,worker).
+!get_agent_role(luigi,worker).
+!get_agent_role(luca,supervisor).
+!get_agent_role(ids_customer,customer).
+!get_agent_role(_,system).

		