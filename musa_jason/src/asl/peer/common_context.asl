/******************************************************************************
 * @Author: Luca Sabatucci
 * Description: store/read data in Context
 * ----------------------------------------------------------------------------
 * Last Modifies:  
 * - [davide] Commented .term2string(ValueTerm,VerifyValue); in plan +!persist_data_value_and_calculate_timestamp
 *
 * TODOs:
 *
 * Reported Bugs:  
 * 
 *
 ******************************************************************************/

//manager_of(dptname).
//statement(dptname,projectname,done(x))[time_stamp].
//data_value(dptname,projectname,doc,23)[time_stamp].

/*
 * [davide]
 * 
 * Check if a parameter exists within the context (that is, within the table 'adw_value')
 */
+!check_data_value(Type, Context, Result)
	:
		Context = project_context(Department , Project)
	<-
		.my_name(Name);										//Get the agent name	
		getProjectID(Project, ProjectID);					//Get the project ID
		existsParameter(Type, Name, ProjectID, Result);		//Check if parameter 'Type' exists
	.

+!get_data_value(Variable,Value,Context) 
	:
		/*not manager_of(Department,Project,Members)
	&*/	Context = project_context(Department , Project)
	<-
		getDptManager(Department,ManagerString);
		.term2string(Manager,ManagerString);
		.send(Manager,askOne,data_value(Department,Project,Variable,Value),Reply);
		if (Reply\==null)	{Reply = data_value(Department,Project,Variable,Value)[source(Manager)];} 
		else 				{Value = null;}
	.

/* 
 * It forces to read all the statement and variable-value from the data_valuebase
 * Only for the Manager
 */
+!update_context_from_db(Context)
	:
		manager_of(Department,Project,Members)
	&	Context = project_context(Department , Project)
	<-
		.abolish( statement(Department,Project,_) );
		.abolish( data_value(Department,Project,_,_) );
		
		readAllStates(Project,Department,AllStatesString);
		.term2string(StateList,AllStatesString);
		
		for (.member(ContextState,StateList)) 
		{
			ContextState = context_state(Assertion,Context,TimeStamp);
			+statement(Department,Project,Assertion)[TimeStamp];
		}

		readAllValues(Project,Department,AllValuesString);
		.term2string(ValueList,AllValuesString);
		
		for (.member(ContextValue,ValueList)) 
		{
			ContextValue = context_data(Variable,Value,Context,TimeStamp);
			+data_value(Department,Project,Variable,Value)[TimeStamp];
		}

	.	
+!update_context_from_db(Context,WI) <- true.

/*
 * It ask for the manager to update the current state of the world
 */
+!request_manager_send_context(Context)
	:
		not manager_of(Department,Project,Members)
	&	Context = project_context(Department , Project)
	<-
		getDptManager(Department,Manager);
		.send(Manager,tell,request_for_context(Department,Project));
	.
+!request_manager_send_context(Context)
	<-
		true
	.
+request_for_context(Department,Project)[source(Agent)]
	:
		manager_of(Department,Project,Members)		
	<-
		.findall(statement(Term,TS), statement(Department, Project, Term)[TS], Statements);
		.findall(data_value(Variable,Value,TS), data_value(Department, Project, Variable, Value)[TS], DataValues);
		.send(Agent,tell,context_is(Department,Project,Statements,DataValues));

		.abolish( request_for_context(Department,Project)[source(Agent)] );		
	.
+context_is(Department,Project,Statements,DataValues)
	<-
		.abolish( statement(Department,Project,_) );
		.abolish( data_value(Department,Project,_,_) );
		
		for (.member(S,Statements)) 
		{
			S=statement(Term,TS);
			+statement(Department,Project,Term)[TS];
		}

		for (.member(D,DataValues)) 
		{
			D=data_value(Variable,Value,TS);
			+data_value(Department,Project,Variable,Value)[TS];
		}

		.abolish(context_is(Department,Project,Statements,DataValues));
	.

/* 
 * It build the state of the world format ( world([ statement list]) ) 
 * by using all the statement in memory
 */
+!build_current_state_of_world(Context,WI)
	:
		Context = project_context(Department , Project)
	<-
		.findall(Term, statement(Department, Project, Term), Terms);
		WI=world(Terms);
	.

+!retrieve_assignment_from_context(Context,AssignmentList)
	:
		Context = project_context(Department , Project)
	<-
		.findall(assignment(Variable,Value), data_value(Department,Project,Variable,Value), AssignmentList);
	.
+!retrieve_assignment_from_context(Context,AssignmentList)
	<-
		AssignmentList = [];
	.

/* 
 * It build the state of the world format ( world([ statement list]) ) 
 * by using all the statement in database
 * Only for the manager
 */
+!retrieve_current_state_of_world(Context,WI)
	:
	//	manager_of(Department,Project,Members)
	//&	Context = project_context(Department , Project)
	Context = project_context(Department , Project)
	<-
		!update_context_from_db(Context);
		!build_current_state_of_world(Context,WI);
	.

/* It registers a statement into the database of ask for the manager to do that */
@manager_register_a_statement[atomic]
+!register_statement(Term,Context)
	:
		manager_of(Department,Project,Members)
	&	Context = project_context(Department , Project)
	<-
		.abolish( statement(Department, Project, Term) );
		
		.my_name(Me);
		!persist_statement_and_calculate_timestamp(Term,Project,Me,TimeStamp);
		+statement(Department, Project, Term)[TimeStamp];
		
		if(not .empty(Members))
		{
			.send(Members,tell,add_statement(Department, Project, Term, TimeStamp ));
		}
	.

@staff_register_a_statement[atomic]
+!register_statement(Term,Context)[source(Agent)]
	<-
		Context = project_context(Department , Project);
		
		+statement(Department, Project, Term);
		
		getDptManager(Department,Manager);
		
		//Tell the applicant agent to wait until the term is registered in context
		.send(Agent, tell, wait_for_manager_to_register_statement(Term, Agent));
		
		.send(Manager,tell,add_statement(Department, Project, Term));		
	.

@manager_receive_a_statement[atomic]
+add_statement(Department, Project, Term)[source(Agent)]
	:
		manager_of(Department,Project,Members)		
	<-
		.abolish( statement(Department, Project, Term) );
		.abolish(add_statement(Department, Project, Term));
		!persist_statement_and_calculate_timestamp(Term,Project,Agent,TimeStamp);
		+statement(Department, Project, Term)[TimeStamp];
		.send(Members,tell,add_statement(Department, Project, Term, TimeStamp));
	.
@staff_receive_a_statement[atomic]
+add_statement(Department, Project, Term, TimeStamp)[source(Manager)]
	<-
		!build_current_state_of_world(Context, World);
		
		.abolish( statement(Department, Project, Term) );
		.abolish(add_statement(Department, Project, Term, TimeStamp));
		+statement(Department, Project, Term)[TimeStamp];
	.

	
+!register_statement(Term,Context) <- .println("error in registering a statement"); .

/* private plan */
+!persist_statement_and_calculate_timestamp(Term,Project,Agent,TimeStampTerm)
	<-
		registerState(Term,Project,Agent);
		isStateTrue(Term,VerifyTruth,Project,TimeStamp);
		.println("persist: ",Term," is ",VerifyTruth," @ ",TimeStamp);
		
		.term2string(TimeStampTerm,TimeStamp);
	.		

-!persist_statement_and_calculate_timestamp(Term,Project,Agent,TimeStampTerm)
	<-
		.wait(10);
		!persist_statement_and_calculate_timestamp(Term,Project,Agent,TimeStampTerm);
	.


+!register_data_value(Variable,Value,Context)
	:
		manager_of(Department,Project,Members)
	&	Context = project_context(Department , Project)
	<-
		.abolish( data_value(Department, Project, Variable, Value) );
	
		.my_name(Me);	
		!persist_data_value_and_calculate_timestamp(Variable,Value,Project,Me,VerifyValue,TimeStamp);
		+data_value(Department, Project, Variable, VerifyValue)[TimeStamp];
		.send(Members,tell,add_data_value(Department, Project, Variable, VerifyValue, TimeStamp));	
	.
	
//questo piano viene eseguito quando è un utente non manager a voler registrare un valore nel contesto
+!register_data_value(Variable,Value,Context)
	<-
		Context = project_context(Department , Project);
		getDptManager(Department,Manager);
		
		.send(Manager,tell,add_data_value(Department, Project, Variable, Value));
	.
+!register_data_value(Variable,Value,Context) 
	<- 
		.print("[WARNING] ",Variabile," not registered.");
	.

+add_data_value(Department, Project, Variable, Value)[source(Agent)]
	:
		manager_of(Department,Project,Members)		
	<-
		.abolish( data_value(Department, Project, Variable, Value) );
		
		.abolish(add_data_value(Department, Project, Variable, Value));
		!persist_data_value_and_calculate_timestamp(Variable,Value,Project,Agent,VerifyValue,TimeStamp);
		+data_value(Department, Project, Variable, VerifyValue)[TimeStamp];
		.send(Members,tell,add_data_value(Department, Project, Value, VerifyValue, TimeStamp));
	.
+add_data_value(Department, Project, Variable, Value, TimeStamp)[source(Manager)]
	<-
		.abolish( data_value(Department, Project, Variable, Value) );

		.abolish(add_data_value(Department, Project, Variable, Value, TimeStamp));
		+data_value(Department, Project, Variable, Value)[TimeStamp];
	.

+!persist_data_value_and_calculate_timestamp(Variable,Value,Project,Agent,ValueTerm,TimeStampTerm)
	<-
		registerValue(Variable,Value,Project,Agent);
		readValue(Variable,VerifyValue,Project,TimeStamp);
		
		VerifyValue=ValueTerm;
//		.term2string(ValueTerm,VerifyValue);
		.term2string(TimeStampTerm,TimeStamp);				
	.		