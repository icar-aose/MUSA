
{ include( "role/department_employee_activity.asl" ) }
{ include( "configuration.asl" ) }
{ include( "peer/common.asl" ) }

agent_capability(secureInjured)[type(simple)].
capability_parameters(secureInjured, []).
capability_precondition(secureInjured, condition(true) ).
capability_postcondition(secureInjured, condition(done(secure_injured)) ).
capability_cost(secureInjured,0).
capability_evolution(secureInjured,[add( done(secure_injured) )]).

agent_capability(delimitDangerousArea)[type(simple)].
capability_parameters(delimitDangerousArea, []).
capability_precondition(delimitDangerousArea, condition(true)).
capability_postcondition(delimitDangerousArea, condition(done(delimit_dangerous_area)) ).
capability_cost(delimitDangerousArea,0).
capability_evolution(delimitDangerousArea,[add( done(delimit_dangerous_area) )]).

agent_capability(prepareMedicalArea)[type(simple)].
capability_parameters(prepareMedicalArea, []).
capability_precondition(prepareMedicalArea, condition(true)).
capability_postcondition(prepareMedicalArea, condition(done(prepare_medical_area)) ).
capability_cost(prepareMedicalArea,0).
capability_evolution(prepareMedicalArea,[add( done(prepare_medical_area) )]).

agent_capability(estinguish_fire)[capability_types([type(simple), type(a), type(b)])].
capability_parameters(estinguish_fire, []).
capability_precondition(estinguish_fire, condition(true)).
capability_postcondition(estinguish_fire, condition(done(fire_extinguished)) ).
capability_cost(estinguish_fire,0).
capability_evolution(estinguish_fire,[add( done(fire_extinguished) )]).

agent_capability(secure_artworks)[type(simple)].
capability_parameters(secure_artworks, []).
capability_precondition(secure_artworks, condition(true)).
capability_postcondition(secure_artworks, condition(done(secure_artworks)) ).
capability_cost(secure_artworks,0).
capability_evolution(secure_artworks,[add( done(secure_artworks) )]).

!awake.

/* Plans */

+!awake
	<-
		.my_name(Me);
		.print("hello (i'm ",Me,").");
		!awake_as_employee;
	.

 +!prepare(secureInjured,Context) <- .print("Preparing capability ",secureInjured).
 +!action(secureInjured,Context) 
 	<- 
 		.print("--->ACTION FOR CAPABILITY ",secureInjured);
 		!register_statement(done(secure_injured),Context);
 	.
 +!terminate(secureInjured,Context) <- true.
	

 +!prepare(delimitDangerousArea,Context) <- .print("Preparing capability ",delimitDangerousArea).
 +!action(delimitDangerousArea,Context) 
 	<- 
 		.print("--->ACTION FOR CAPABILITY ",delimitDangerousArea);
 		!register_statement(done(delimit_dangerous_area),Context);
	.
 +!terminate(delimitDangerousArea,Context) <- true.
 
 +!prepare(prepareMedicalArea,Context) <- .print("Preparing capability ",prepareMedicalArea).
 +!action(prepareMedicalArea,Context) 
 	<- 
 		.print("--->ACTION FOR CAPABILITY ",prepareMedicalArea);
 		!register_statement(done(prepare_medical_area),Context);
	.
 +!terminate(prepareMedicalArea,Context) <- true.
 
 +!prepare(estinguish_fire,Context) <- .print("Preparing capability ",estinguish_fire).
 +!action(estinguish_fire,Context) 
 	<- 
 		.print("--->ACTION FOR CAPABILITY ",estinguish_fire);
 		!register_statement(done(fire_extinguished),Context);
	.
 +!terminate(estinguish_fire,Context) <- true.
 
 +!prepare(secure_artworks,Context) <- .print("Preparing capability ",secure_artworks).
 +!action(secure_artworks,Context) 
 	<- 
 		.print("--->ACTION FOR CAPABILITY ",secure_artworks);
 		!register_statement(done(secure_artworks),Context);
	.
 +!terminate(secure_artworks,Context) <- true.
