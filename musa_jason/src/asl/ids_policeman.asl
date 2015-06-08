{ include( "role/department_employee_activity.asl" ) }
{ include( "role/department_manager_activity.asl") }
{ include( "role/project_manager_activity.asl" ) }
{ include( "peer/capability_lifecycle.asl" ) }
{ include( "peer/common_context.asl" ) }
{ include( "peer/simulation.asl" ) }

{ include( "core/accumulation.asl" ) }


agent_capability(call_115)[type(simple)].
capability_parameters(call_115, []).
capability_precondition(call_115, condition(true) ).
capability_postcondition(call_115, condition(done(call_115))).
capability_cost(call_115,0).
capability_evolution(call_115,[add( done(call_115) )]).

agent_capability(call_118)[type(simple)].
capability_parameters(call_118, []).
capability_precondition(call_118, condition(true) ).
capability_postcondition(call_118, condition(done(call_118))).
capability_cost(call_118,0).
capability_evolution(call_118,[add( done(call_118) )]).

agent_capability(evaluate_situation)[type(simple)].
capability_parameters(evaluate_situation, []).
capability_precondition(evaluate_situation, condition(true) ).
capability_postcondition(evaluate_situation, condition(done(evaluate_situation)) ).
capability_cost(evaluate_situation,0).
capability_evolution(evaluate_situation,[add(done(evaluate_situation))]).

agent_capability(evaluate_injured)[type(simple)].
capability_parameters(evaluate_injured, []).
capability_precondition(evaluate_injured, condition(true) ).
capability_postcondition(evaluate_injured, condition(done(evaluate_injured)) ).
capability_cost(evaluate_injured,0).
capability_evolution(evaluate_injured,[add(done(evaluate_injured))]).

agent_capability(close_gas)[type(simple)].
capability_parameters(close_gas, []).
capability_precondition(close_gas, condition(true) ).
capability_postcondition(close_gas, condition(done(close_gas)) ).
capability_cost(close_gas,0).
capability_evolution(close_gas,[add(done(close_gas))]).

agent_capability(close_gas)[type(simple)].
capability_parameters(close_gas, []).
capability_precondition(close_gas, condition(true) ).
capability_postcondition(close_gas, condition(done(close_gas)) ).
capability_cost(close_gas,0).
capability_evolution(close_gas,[add(done(close_gas))]).

agent_capability(assess_building_usability)[type(simple)].
capability_parameters(assess_building_usability, []).
capability_precondition(assess_building_usability, condition(true) ).
capability_postcondition(assess_building_usability, condition(done(assess_building_usability)) ).
capability_cost(assess_building_usability,0).
capability_evolution(assess_building_usability,[add(done(assess_building_usability))]).






agent_capability(move)[type(parametric)].
capability_parameters(move, [emergency_location]).
capability_precondition(move, condition(true) ).
capability_postcondition(move, par_condition( [emergency_location], property(move, [policeman,emergency_location]) ) ).
capability_cost(move,0).
capability_evolution(move,[add( move(policeman, emergency_location) )]).




!awake.

+!awake
	<-
		.print("Hello!");
		!awake_as_employee;
	.


//CAPABILITY call_115

 +!prepare(call_115,Context)
<-
	//.print("preparing capability ",call_115);
	true
.
 +!action(call_115,Context)
<-
	.print("...............................................executing capability ",call_115);
	true
.
 +!terminate(call_115,Context)
<-
	//.print("terminating capability ",call_115);
	true
.
//END OF CAPABILITY call_115
//---------------------------------------------

//CAPABILITY call_118

 +!prepare(call_118,Context)
<-
	//.print("preparing capability ",call_118);
	true
.
 +!action(call_118,Context)
<-
	.print("...............................................executing capability ",call_118);
	true
.
 +!terminate(call_118,Context)
<-
	//.print("terminating capability ",call_118);
	true
.
//END OF CAPABILITY call_118
//---------------------------------------------

//CAPABILITY evaluate_situation

 +!prepare(evaluate_situation,Context)
<-
	//.print("preparing capability ",evaluate_situation);
	true
.
 +!action(evaluate_situation,Context)
<-
	.print("...............................................executing capability ",evaluate_situation);
	true
.
 +!terminate(evaluate_situation,Context)
<-
	//.print("terminating capability ",evaluate_situation);
	true
.
//END OF CAPABILITY evaluate_situation
//---------------------------------------------

//CAPABILITY evaluate_injured

 +!prepare(evaluate_injured,Context)
<-
	//.print("preparing capability ",evaluate_injured);
	true
.
 +!action(evaluate_injured,Context)
<-
	.print("...............................................executing capability ",evaluate_injured);
	true
.
 +!terminate(evaluate_injured,Context)
<-
	//.print("terminating capability ",evaluate_injured);
	true
.
//END OF CAPABILITY evaluate_injured
//---------------------------------------------

//CAPABILITY close_gas

 +!prepare(close_gas,Context)
<-
	//.print("preparing capability ",close_gas);
	true
.
 +!action(close_gas,Context)
<-
	.print("...............................................executing capability ",close_gas);
	true
.
 +!terminate(close_gas,Context)
<-
	//.print("terminating capability ",close_gas);
	true
.
//END OF CAPABILITY close_gas
//---------------------------------------------

//CAPABILITY assess_building_usability

 +!prepare(assess_building_usability,Context)
<-
	//.print("preparing capability ",assess_building_usability);
	true
.
 +!action(assess_building_usability,Context)
<-
	.print("...............................................executing capability ",assess_building_usability);
	true
.
 +!terminate(assess_building_usability,Context)
<-
	//.print("terminating capability ",assess_building_usability);
	true
.
//END OF CAPABILITY assess_building_usability
//---------------------------------------------

