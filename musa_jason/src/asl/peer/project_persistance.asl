/******************************************************************************
 * @Author: Luca Sabatucci
 * Description: recover a project from the database
 * ----------------------------------------------------------------------------
 * Last Modifies:  
 * 	- [davide, (2015-3-4)]: cambio il formato della soluzione in !recover_project
 *
 * TODOs:
 * 
 *
 * Reported Bugs:  
 * 
 *
 ******************************************************************************/

+!recover_projects_from_database(Pack, DptContext)
	<-
		DptContext = department_context(DptNameString);
		
		getProjects(DptNameString,String);
		.term2string(List,String);
		
		!recover_project_list(Pack, DptContext,List);
.


-!recover_projects_from_database(Pack, DptContext)
	<-
		.println("Unable to recover project from database. May be a (NULL) project is contained in database?");
		occp.logger.action.error("Unable to recover project from database. May be a (NULL) project is contained in database?");
	.

+!recover_project_list(Pack, DptContext, ProjectList)
	:
		ProjectList=[ T | H ]
	&	T = project(ProjectName,Coordinator,CS)
	<-
		DptContext = department_context(DptName);
		PrjContext = project_context(DptName,ProjectName);
		
		!recover_project(Pack, PrjContext, T);
		!recover_project_list(Pack, DptContext, H);
	.
/**
 * Questo piano viene attivato quando non vi sono progetti nel database relativi al pack/contesto di dpt specificati.
 */
+!recover_project_list(Pack, DptContext, ProjectList)
	:
		ProjectList=[]
	<-
		.print("Empty project list");
	.
+!recover_project(Pack, PrjContext, Project)
	:
		Project = project(ProjectName,Coordinator,CS)
	<-
		!build_current_state_of_world(PrjContext,WI);
		!retrieve_assignment_from_context(PrjContext,AssignmentList);
		
		//TODO modifica (2015-3-4)
		//Solution=item(cs(CS),evo([dummy_accumulation]),0);
		Solution = item(cs(CS), accumulation( world(WI), par_world([],[]), assignment_list(AssignmentList) ), ag([]), 0);
		
		.print("~~~Recovering existing project from persistance~~~");
		!activate_social_commitment(PrjContext, Pack, Solution);
		!activate_project_monitoring(PrjContext,Pack,Solution);		
	.
	
