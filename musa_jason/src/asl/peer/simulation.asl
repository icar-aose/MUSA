/******************************************************************************
 * @Author: Davide Guastella
 * Description: plans necessary for simulating workflow without social behavior
 * ----------------------------------------------------------------------------
 * Last Modifies:  
 * 
 * TODOs:
 * - implementare remove_data_value
 *
 * Reported Bugs:  
 * 
 *
 ******************************************************************************/

{ include( "peer/common_context.asl" ) }
{ include( "search/goals_addressing_in_evolution.asl") }
{ include( "role/project_manager_activity.asl") }

!awakeSim.

/* Plans */

+!awakeSim 
	<-
		//
		true
	.

/**
 * Return a variable from the context. 
 */
+!get_data_value_simulated(Variable,Value,Context) 
	:
		Context = project_context(Department , Project)
	<-
		.my_name(Name);
		getProjectID(Project, ProjectID);
		getParameterByType(Variable, Name, ProjectID, VarString);
		.term2string(Var,VarString);
		//.print("ho preso ",Var);
		Var=par(_,Value);
	.

/**
 * Register a variable into the context
 */
+!register_data_value_simulated(Variable,Value,Context)
	:
		Context = project_context(Department , Project)
	<-
		.abolish( data_value(Department, Project, Variable, Value) );
		.my_name(Me);
		!persist_data_value_and_calculate_timestamp(Variable,Value,Project,Me,VerifyValue,TimeStamp);
		+data_value(Department, Project, Variable, VerifyValue)[TimeStamp];
	.

/* 
 * Registers a statement into the database of ask for the manager to do that
 */
+!register_statement_simulated(Term, Context)
	:
		Context = project_context(Department , Project)
	<-
		.abolish( statement(Department, Project, Term) );
		
		.my_name(Me);
		!persist_statement_and_calculate_timestamp(Term,Project,Me,TimeStamp);
		+statement(Department, Project, Term)[TimeStamp];
		
		.print("statement registrato");
	.
	
/*
 * Create a project
 */
//+!create_project_simulated(DepartmentName, ProjectName, Pack)
+!create_project_simulated(DepartmentName, ProjectName)
	<-
		Context = project_context(DepartmentName,ProjectName);
		.delete("_dept",DepartmentName,SocialGoalName);
		.term2string(SocialGoal,SocialGoalName);

		.println("organizing for event ",ProjectName," with ",Members);
		
		.print("SocialGoal: ",SocialGoal);
		!build_goal_pack(SocialGoal,Pack);

		
		.print("Context: ",Context);
		!organize_solution(Context, Pack);
		
	.
	
/*
 * Create or use the database artifact. Id is unified with the ID of the database artifact.
 */
+!create_database_artifact_simulated(Id)
	<-
		.print("creating DB artifact");
		makeArtifact("workflow_database", "ids.artifact.Database", [], Id);
	.
	
/**
 */
+!remove_data_value(Variable, Context)
	<-
		true
	.