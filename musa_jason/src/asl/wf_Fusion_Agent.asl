{ include( "normBaseprova.asl" ) }
{include( "goalFusion/goalfusion.asl") }
{include( "configuration.asl") }

/* WFType=1 se solo incendio
 * WFType=2 se solo sisma
 * WFType=3 sisma+incendio
*/
!enact(1).

+!enact(WFType):true
	<-
		?enable_fusion_agent(State);
		
		if(State = true)
		{
			!do_goal_base_fusion(WFType);
		}
		else
		{
			action.loadGoalBase("src/asl/goalBaseSigma.asl",GoalList);
			.send(boss,achieve,awake);
		}
	.
	
+!do_goal_base_fusion(WFType)
	<-
		action.clearGoalBase("src/asl/goalBaseSigma.asl");
		
		if(WFType==1)
		{
			action.loadGoalBase("src/asl/goalBaseSigmaIncendio.asl",GoalList);
			.length(GoalList,Len);
			for (.range(I,0,Len-1))
			{
				.nth(I,GoalList,T);
			  	.print(T);	
				+T;	
			}
		
		}
			
		if(WFType==2)
		{
			action.loadGoalBase("src/asl/goalBaseSigmaTerremoto.asl",GoalList);
			.length(GoalList,Len);
			for (.range(I,0,Len-1))
			{
			 	.nth(I,GoalList,T);
			  	.print(T);	
				+T;	
			}
		
		}
		
		if(WFType==3)
		{
			action.loadGoalBase("src/asl/goalBaseSigmaIncendio.asl",GoalList1);
			.length(GoalList1,Len1);
			for (.range(I1,0,Len1-1))
			{
			 	.nth(I1,GoalList1,T1);
			  	.print(T1);	
				+T1;	
			}
			
			action.loadGoalBase("src/asl/goalBaseSigmaTerremoto.asl",GoalList2);
			.length(GoalList2,Len2);
			for (.range(I2,0,Len2-1))
			{
			 	.nth(I2,GoalList2,T2);
			  	.print(T2);	
				+T2;	
			}
		}
		
		/* Effettua la fusione dei goal e norme(if any) */
		!planFusion;
		.send(boss,achieve,awake);/* avvia la pianificazione per il tipo di emergenza */
	.
