// Agent goalfusion in project normeEWF

/* Initial beliefs and rules */

/* Initial goals */
/****** GoalBase */

//{include( "goalBaseProva.asl" ) }

/*agent_goal( condition(received_emergency_notification(location, worker_operator)), 
			condition(done(move(worker_operator, location))), [firefighter]) // in realtà potrebbe esserci ad esempio worker_operator che è un parametro.
				[goal(process0_g0),pack(p1),parlist([ par(location,"boh"), par(worker_operator,"firefighter") ])].
agent_goal( condition(miacond), 
			condition(done(move(worker_operator, location))), [firefighter]) // in realtà potrebbe esserci ad esempio worker_operator che è un parametro.
				[goal(process0_g9),pack(p1), parlist([ par(location,"boh"), par(worker_operator,"firefighter") ])].
agent_goal( condition(nuovamiacond), 
			condition(done(move(worker_operator, location))), [firefighter]) // in realtà potrebbe esserci ad esempio worker_operator che è un parametro.
				[goal(process0_g10),pack(p1), parlist([ par(location,"boh"), par(worker_operator,"firefighter") ])].
agent_goal( condition(done(move(worker_operator, location))), 
				condition( done(assess_explosion_hazard) ), [firefighter])
				[pack(p1),goal(process0_g2), parlist([ par(location,"boh"), par(worker_operator,"firefighter") ])].
agent_goal( condition(done(move2(worker_operator, location))), 
				condition( done(assess_explosion_hazard) ), [firefighter])
				[pack(p1),goal(process0_g11), parlist([ par(location,"boh"), par(worker_operator,"firefighter") ])].
agent_goal( condition(done(delimit_dangerous_area)), 
				condition( done(prepare_medical_area) ), [firefighter])
				[goal(process0_g6),pack(p1)].
	*/
	

/*NormBase */
//{ include( "normBase.asl" ) }

	

//NormSpec: IS_PROHIBITED ACTIVITY delimit_dangerous_area ;
//formato IdGoal=process0.g0
/*norm(category(ActivityRuleWithoutCond), type(prohibition), role(_), activity(assess_explosion_hazard), condition(false))[goal(process0_g11)].
norm(category(ActivityRuleWithoutCond), type(prohibition), role(_), activity(prepare_medical_area), condition(bello(io)))[goal(process0_g6)].
norm(category(ActivityRuleWithoutCond), type(permission), role(_), activity(move(worker_operator, location)), condition(tempo(mite)))[goal(process0_g9)].
norm(category(ActivityRuleWithoutCond), type(permission), role(_), activity(move2(worker_operator, location)), condition(tempo(mite)))[goal(process0_g11)].
*/

{ include( "goalFusion/evaluateGoalFulfillment.asl" ) }
//Credenze di supporto ai piani
/**goaltobefusedWith(Goal,List): 
 * Goal è il goal che sto confrontando 
 * List è la lista di goal (se esistono) che sono stati identificati come goal da assemblare come unico goal
 **/
goaltobefusedWith(null,[]).	

/**precondTobefusedfor(Goal,List):
 *  Goal è il goal che sto confrontando 
 *  List è la lista delle precondition dei goal che sono stati identificati come goal da assemblare come unico goal
 **/
precondTobefusedfor(null,[]).

/**listActorTobefusedfor(Goal,List):
 * Goal è il goal che sto confrontando 
 * List è la lista degli attori dei goal che sono stati identificati come goal da assemblare come unico goal
 **/
listActorTobefusedfor(null,[]).

/** idGoaltobefusedWith(Goal, List):
 * Goal è  è il goal che sto confrontando 
 * List è la lista degli identificativi dei goal che sono stati fusi in un nuovo goal
 */
idGoaltobefusedWith(null,[]).

/**listNormstobemerged(List): 
 * List è la lista di tutte le norme dei goal 
 * che sono stati identificati come goal da assemblare in unico goal
 **/
listNormstobemerged([]).

/**normcondTobefusedfor(List) 
 * List è la lista di tutte le norme del goal corrente da rielaborare in un unica condizione
 **/
normcondTobefusedfor([]).

/** mergedGoal(Goal) 
 *  Goal è il goal risultato dall'unione 
 **/
mergedGoal(null).

/**initialListOfGoal(List):
 * List contiene la liste iniziale dei goal 
 **/
initialListOfGoal([]).

/**finalListOfGoal(List):
 * List contiene la liste finale dei goal 
 * OSS: finalList<=initialList dipende dal numero di goal che sono stati unificati
 **/
finalListOfGoal([]).


/* Plans */

+!planFusion : 
	true 
<- 
	!algGoalFusion;
	.print("ddddddddddddddddd");
	!algNormFusion;
	!algGoalFulfillmentevaluation;
	!registerGoalBase;
.


/** Piano per il merging di goal */

+!algGoalFusion: true
<-
for(agent_goal(PrecCurrentGoal1,PostCurrentGoal1,ListActorCurrentGoal1)[goal(IdGoalCurrentGoal1),pack(P1),parlist(ParList1)]){
		CurrentGoal1=agent_goal(PrecCurrentGoal1,PostCurrentGoal1,ListActorCurrentGoal1)[goal(IdGoalCurrentGoal1),pack(P1),parlist(ParList1)];
		?initialListOfGoal(PreviousList);
		H=PreviousList;
		T=CurrentGoal1;
		-+initialListOfGoal([T|H]);
		-+finalListOfGoal([T|H]);
	}
	//ciclo a partire dalla lista iniziale e confronto con la lista finale
	?initialListOfGoal(InitialList);
	.length(InitialList,Len);		
	for(.range(J,0,Len-1)){
			.nth(J,InitialList,CurrentGoal);
			CurrentGoal=agent_goal(PrecCurrentGoal,PostCurrentGoal,ListActorCurrentGoal)[goal(IdGoalCurrentGoal),pack(P),parlist(ParList)];
			!serchGoalwithSamePostCondition(CurrentGoal,PostCurrentGoal);
			
			 ?goaltobefusedWith(CurrentGoal,GoalList);	
			.length(GoalList,X2);
			//Se ho tovato goal con la stessa postcond del current goal allora li fondo
			if(X2\==0){
			!createNewGoalFromFusion(CurrentGoal);
			}
			!updateMatchingGoalList(CurrentGoal,GoalList);
			!cleanBeliefForGoalFusion(CurrentGoal);
			//aggiorna la lista di confronto
		
		}
	
	.

/** Piano per il merging di norme e goal */
+!algNormFusion:true
<-
/** per i goal che derivano da una precedente fusione cerco le norme associate ai goal da cui è stato ottenuto il goal fuso */
for(agent_goal(PrecCurrentGoal,PostCurrentGoal,ListActorCurrentGoal)[goalfused(ListID),pack(P),parlist(ParList)]){
	.print("OK");
	CurrentGoal=agent_goal(PrecCurrentGoal,PostCurrentGoal,ListActorCurrentGoal)[goalfused(ListID),pack(P),parlist(ParList)];
	.print(ListID);
		.length(ListID,X2);
		for(.range(I,0,X2-1)){
			.nth(I,ListID,T);
		T=goal(IdGoal);
		!searchNormOfGoal(IdGoal);
		}
		!createNewGoalFromNormOfGoal(CurrentGoal);
		!cleanBeliefForNormFusion(CurrentGoal);
}
/**  questo ciclo for invece permette di cercare le norme associate a un singolo goal */
for(agent_goal(PrecCurrentGoal,PostCurrentGoal,ListActorCurrentGoal)[goal(Idgoal),pack(P2),parlist(ParList2)]){
	CurrentGoal2=agent_goal(PrecCurrentGoal,PostCurrentGoal,ListActorCurrentGoal)[goal(Idgoal),pack(P2),parlist(ParList2)];			
		!searchNormOfGoal(Idgoal);
		!createNewGoalFromNormOfGoal(CurrentGoal2);
		!cleanBeliefForNormFusion(CurrentGoal2);
}
.

/*****Ricerca Goal che producono lo stesso stato del mondo del GoalUnderAnalisys*/
+!serchGoalwithSamePostCondition(GoalUnderAnalisys,PostCond) : true
<-
.print("qqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqq");
//imposto le credenze per il goal in analisi
-+goaltobefusedWith(GoalUnderAnalisys,[]);
-+precondTobefusedfor(GoalUnderAnalisys,[]);
-+listActorTobefusedfor(GoalUnderAnalisys,[]);
-+idGoaltobefusedWith(GoalUnderAnalisys,[]);

?finalListOfGoal(Final);
.length(Final,Len);	
.print("la nuova lista e:",Final);
PostCond=condition(PostCondUnderAnalysis);
for(.range(J,0,Len-1)){
	
	.nth(J,Final,CurrentGoal);	
	CurrentGoal=agent_goal(PrecCurrentGoal,condition(PostCondCurrentGoal),ListActorCurrentGoal)[goal(IdGoalCurrentGoal),pack(P),parlist(ParList)];
	if(PostCondCurrentGoal==PostCondUnderAnalysis & CurrentGoal\==GoalUnderAnalisys){
		.print("GOAL DA FUSIONE");
		//goal selezionato per la fusione
		T=CurrentGoal;
		?goaltobefusedWith(GoalUnderAnalisys,List);
		H=List;
		//appendo in testa alla lista il goal trovato
		-+goaltobefusedWith(GoalUnderAnalisys,[T|H]);	
		
		//metto in una lista separata le precondition del Goal che poi devono essere assemblati
		PrecCurrentGoal=condition(Something);
		T1=Something;
		?precondTobefusedfor(GoalUnderAnalisys,PrecondList);
		H1=PrecondList;
		//appendo in testa alla lista la precondition associata al goal trovato
		-+precondTobefusedfor(GoalUnderAnalisys,[T1|H1]);
		//metto in una lista separata gli attori del Goal che poi devono essere assemblati poichè queste sono liste faccio l'unione
		?listActorTobefusedfor(GoalUnderAnalisys,ListActor);
		.union(ListActor,ListActorCurrentGoal,NewListActor);
		-+listActorTobefusedfor(GoalUnderAnalisys,NewListActor);
		
		//idgoal selezionato per la fusione
		T2=goal(IdGoalCurrentGoal);
		?idGoaltobefusedWith(GoalUnderAnalisys,ListID);
		H2=ListID;
		//appendo in testa alla lista il goal trovato
		-+idGoaltobefusedWith(GoalUnderAnalisys,[T2|H2]);	
		
	}
}
// se ho trovato goal con la stessa post condition metto nella lista anche il goal di partenza
?goaltobefusedWith(GoalUnderAnalisys,ListGoals);

.length(ListGoals,Len1);
if(Len1>0){
	//appendo in testa alla lista il goal trovato
	GoalUnderAnalisys=agent_goal(PrecGoalUnderAnalisys,PostCGoalUnderAnalisys,ListActorGoalUnderAnalisys)[goal(IdGoalGoalUnderAnalisys),pack(PUA),parlist(ParListUA)];
	T3=GoalUnderAnalisys;
	H3=ListGoals;
	-+goaltobefusedWith(GoalUnderAnalisys,[T3|H3]);	
	//appendo in testa alla lista la precondition associata al goal trovato
	PrecGoalUnderAnalisys=condition(Something2);
	T4=Something2;
	?precondTobefusedfor(GoalUnderAnalisys,PrecondList2);
	H4=PrecondList2;
	-+precondTobefusedfor(GoalUnderAnalisys,[T4|H4]);
	//appendo in testa alla lista gli attori associati al goal trovato
	?listActorTobefusedfor(GoalUnderAnalisys,ListActor2);
	.union(ListActor2,ListActorGoalUnderAnalisys,NewListActor2);
	-+listActorTobefusedfor(GoalUnderAnalisys,NewListActor2);
	
	//appendo in testa alla lista l'id del goal trovato
	T5=goal(IdGoalGoalUnderAnalisys);
	?idGoaltobefusedWith(GoalUnderAnalisys,ListID2);
	H5=ListID2;
	-+idGoaltobefusedWith(GoalUnderAnalisys,[T5|H5]);	
		
}
.




+!createNewGoalFromFusion(Goal):true
<-
Goal=agent_goal(PrecGoal,PostGoal,ListActorGoal)[goal(IdGoal),pack(P),parlist(ParList)];
?precondTobefusedfor(Goal,List);
utility.orConditionFromList(List,Cond);
MergedCondition=condition(Cond);
?listActorTobefusedfor(Goal,ListActor);
?idGoaltobefusedWith(Goal,ListIDGoalFused);
+agent_goal(MergedCondition,PostGoal,ListActor)[goalfused(ListIDGoalFused),pack(P),parlist(ParList)];
+mergedGoal(agent_goal(MergedCondition,PostGoal,ListActor)[ListIDGoalFused],pack(P),parlist(ParList));
.


/*** Piano che aggiorna la lista con cui faccio i confronti a partire dalla lista iniziale di goal, 
 * è una lista da cui di volta in volta elimino gli elementi confrontati
 */
+!updateMatchingGoalList(Goal,ListOfGoalTobeMerged):true
<-
?finalListOfGoal(List);
.difference(List,ListOfGoalTobeMerged,NewFinalList);
-+finalListOfGoal(NewFinalList);
.

+!searchNormOfGoal(IdGoal):true
<-
//imposto le credenze per il goal in analisi

for(norm(Category,type(Type), Role, Activity, Condition)[goal(IdGoal)]){
	
	if(Type==obligation | Type==permission){
		?listNormstobemerged(List2);
		Condition=condition(Something);
		T2=Something;
		H2=List2;
		-+listNormstobemerged([T2|H2]);
	}
	else{
		?listNormstobemerged(List2);
		Condition=condition(Something);
		if(Something==false){T2=Something;}
		else{
		T2=neg(Something);
		}
		H2=List2;
		-+listNormstobemerged([T2|H2]);	
	}
	?listNormstobemerged(List3);
	.print("OK2",IdGoal,List3);	
}

.

/*
 * Piano che permette di generare un nuovo goal considerando anche le norme
 * 
 */
+!createNewGoalFromNormOfGoal(Goal): true
<-
?listNormstobemerged(NormCondList);
.print("OK3",NormCondList);
.length(NormCondList,LengthNormCondList);
if(LengthNormCondList>0){//se ci sono norme
	Goal=agent_goal(PrecG,PostG,ListActorG)[Any,Any2,Any3];
	PrecG=condition(PC);
	.union(NormCondList,[PC],CondList);
	 utility.andConditionFromList(CondList,Cond);
	NewCond=condition(Cond);
	-agent_goal(PrecG,PostG,ListActorG)[Any,Any2,Any3];
	+agent_goal(NewCond,PostG,ListActorG)[Any,Any2,Any3];
	}
.
/***
 * 
 * Pulisce tutte le belief necessarie per fare la goal fusion
 * 
 */

+!cleanBeliefForGoalFusion(Goal):true
<-
?goaltobefusedWith(Goal,GoalList);	
.length(GoalList,X2);

for (.range(I,0,X2-1)){
	 .nth(I,GoalList,T);
	  .print(T);	
	-T;
	
}
-goaltobefusedWith(_,_);
+goaltobefusedWith(null,[]);
-precondTobefusedfor(_,_);
+precondTobefusedfor(null,[]);
-listActorTobefusedfor(_,_);
+listActorTobefusedfor(null,[]);
-+idGoaltobefusedWith(null,[]);	
-+mergedGoal(null);
.

/***
 * 
 * Pulisce tutte le belief necessarie per fare la norm fusion
 * 
 */
+!cleanBeliefForNormFusion(Goal):true
<-

-normcondTobefusedfor(_);
+normcondTobefusedfor([]);
-listNormstobemerged(_);
+listNormstobemerged([]);
.


/*
 * Piano per valutare se esiste un possibile stato del mondo in cui i goal possono essere perseguibili
 * 
 */
+!algGoalFulfillmentevaluation:true
<-

for(agent_goal(PrecCurrentGoal1,PostCurrentGoal1,ListActorCurrentGoal1)){
		CurrentGoal1=agent_goal(PrecCurrentGoal1,PostCurrentGoal1,ListActorCurrentGoal1);
	.print("ggggggggggggg",CurrentGoal1);
	!testAdmissibility(PrecCurrentGoal1);
	?isAdmissible(Value);
	?agent_goal(PrecCurrentGoal1,PostCurrentGoal1,ListActorCurrentGoal1)[Any,pack(Any2),parlist(Any3)];
	
	if(Value==false){
		//.println("WARNING:  Goal :",CurrentGoal1,"can not be fulfilled");
		.concat("WARNING:  Goal :",Any,S1);
		.concat(S1," can not be fulfilled \n",S2);
		-+text(S2);
		if(Any=goal(IDGoal)){
		//.println("Possible Causes: ");
		//.println("Preconditions of Goal",IDGoal,"can be contraddictory");
		//.println("Norms of Goal",IDGoal,"can be contraddictory");
		
		.concat(S2,"Possible Causes:\n Preconditions of Goal",S3);
		.concat(S3,PrecCurrentGoal1,S4);
		.concat(S4," can be contraddictory \n",S5);
		.concat(S5,IDGoal,S6);
		.concat(S6," may have contraddictory Norm",S7);
		?text(T);
		.concat(T,S7,NT);
		-+text(NT);
		
		for(norm(Category,type(Type), Role, Activity, Condition)[goal(IDGoal)]){
		.println("Norm :",norm(Category,type(Type), Role, Activity, Condition)[goal(IDGoal)]);
		?text(Text);
		.concat(Text,norm(Category,type(Type), Role, Activity, Condition)[goal(IDGoal)],NewText);
		-+text(NewText);
		}
		}
		if(Any=goalfused(ListOfGoal)){
			//.println("Possible Causes: ");
			//.println("Preconditions or Norms of Goal Components can be contraddictory");
			//.println("Goal :",CurrentGoal1,"is a merging of: ");
			.concat(S2,"Possible Causes - Preconditions or Norms of Goal Components can be contraddictory \n\n Goal : ",S3);
			.concat(S3, Any ,S5);
			.concat(S5," is a merging of: \n---------------------------------------- ",S6);
			-+text(S6);
	
			.length(ListOfGoal,Len);
			for(.range(I,0,Len-1)){ 
				.nth(I,ListOfGoal,X);
				?initialListOfGoal(InitialList);
				.member(agent_goal(PrecCurrentGoal,PostCurrentGoal,ListActorCurrentGoal)[X,_,_],InitialList);				
				//.println("Component Goal: ",agent_goal(PrecCurrentGoal,PostCurrentGoal,ListActorCurrentGoal)[X,_,_]);
				?text(TT);
				.concat(TT,"\n",TT1);
				.concat(TT1,I+1,TT2);
				.concat(TT2," - Component Goal: ",TT3);
				
				.concat(TT3,agent_goal(PrecCurrentGoal,PostCurrentGoal,ListActorCurrentGoal)[X,_,_],TT4);
				
				-+text(TT4);
				for(norm(Category,type(Type), Role, Activity, Condition)[X]){
				//.println("Has Norm :",norm(Category,type(Type), Role, Activity, Condition)[X]);
				?text(Text);
				.concat(Text,"\n with Norm : ",Text2);
				.concat(Text2,norm(Category,type(Type), Role, Activity, Condition)[X],NewText);
			
				-+text(NewText);		
				}
				?text(TEX);
				.concat(TEX,"\n----------------------------------------",TEX2);
				-+text(TEX2);
				
		}
		
		}
		?text(Text);
			utility.warningDialog(Text);
			.wait(5000);
		-+text("");
	}
	
	}	
.

+!registerGoalBase: true
<-
for(agent_goal(PrecCurrentGoal,PostCurrentGoal,ListActorCurrentGoal)[goal(Idgoal),pack(Any2),parlist(Any3)]){
		CurrentGoal=agent_goal(PrecCurrentGoal,PostCurrentGoal,ListActorCurrentGoal)[goal(Idgoal),pack(Any2),parlist(Any3)];
		utility.saveGoalBase(CurrentGoal);
	}
for(agent_goal(PrecCurrentGoal,PostCurrentGoal,ListActorCurrentGoal)[goalfused(Lisgoal),pack(Any2),parlist(Any3)]){
		CurrentGoal=agent_goal(PrecCurrentGoal,PostCurrentGoal,ListActorCurrentGoal)[goalfused(Lisgoal),pack(Any2),parlist(Any3)];
		utility.saveGoalBase(CurrentGoal);
	}
for(social_goal(PrecCurrentGoal,PostCurrentGoal,ListActorCurrentGoal)[goal(Idgoal),pack(Any2),parlist(Any3)]){
		CurrentGoal=social_goal(PrecCurrentGoal,PostCurrentGoal,ListActorCurrentGoal)[goal(Idgoal),pack(Any2),parlist(Any3)];
		utility.saveGoalBase(CurrentGoal);
	}
	.print("--------------------------->DONE GOAL FUSION");
	.wait(10000);
.
