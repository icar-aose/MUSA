{ include( "normBase.asl" ) }
{include( "goalFusion/goalfusion.asl") }
{include( "configuration.asl") }

!enact.

+!enact
	<-
		?goal_fusion_enabled(GoalFusionEnabled);
		
		if(GoalFusionEnabled)
		{
			!do_goal_base_fusion(WFType);
		}
		else
		{
			action.loadGoalBase("src/asl/goalBase.asl",GoalList);
			.send(boss, achieve, awake);
		}
	.
	
+!do_goal_base_fusion(WFType)
	<-
		action.clearGoalBase("src/asl/goalBase.asl");

		?goal_fusion_goalbase_first(GoalList1Path);
		?goal_fusion_goalbase_last(GoalList2Path);

		action.loadGoalBase(GoalList1Path,GoalList1);
		.length(GoalList1,Len1);
		for (.range(I1,0,Len1-1))
		{
		 	.nth(I1,GoalList1,T1);
		  	.print(T1);	
			+T1;	
		}		
		action.loadGoalBase(GoalList2Path,GoalList2);
		.length(GoalList2,Len2);
		for (.range(I2,0,Len2-1))
		{
		 	.nth(I2,GoalList2,T2);
		  	.print(T2);	
			+T2;	
		}

		/* Effettua la fusione dei goal e norme(if any) */
		!planFusion;
		
		/* avvia la pianificazione per il tipo di emergenza */
		.send(boss, achieve, awake);
	.