// Agent sample_agent in project normeEWF
//{include("goalFusion/evaluateConditions.asl")}
{include("core/conditions.asl")}
{include("search/utilities.asl")}
/* Initial beliefs and rules */
/* Belief di supporto ai piani */
listOfStatement([]).
range(0).
stateOfWorld([]).
isAdmissible(null).

/* procedura per valutare se una condizione logica è una contraddizione */

+!testAdmissibility(Condition): true
<-

!extractStatementFromcondition(Condition);
 ?listOfStatement(List);

!generateStateOfWorld(List);
!evaluateConditionOnWorldList(Condition);

-+range(0);
-+listOfStatement([]);
-+stateOfWorld([]);
.

/*  */
+!extractStatementFromcondition(Condition):
	Condition = condition(LogicFormula) & utility.estractOperandsFromLogicFormula(LogicFormula,Operands)
<-	
if(Operands==[]){
		!save_Statement(LogicFormula);	
		}
		else{
	!extractStatementFromLogicformula(Operands);
	
	}
	?listOfStatement(List);

	utility.deleteEqualElementOfList(List,NewList);
	.print(NewList);
.

+!extractStatementFromLogicformula(Operands)
	:
		Operands=[ Head | Tail ] 
	<-
		utility.estractOperandsFromLogicFormula(Head,Op);	
		
		!extractStatementFromLogicformula(Op);
		if(Op==[]){
		!save_Statement(Head);	
		}
		!extractStatementFromLogicformula(Tail);	
	.
	
+!extractStatementFromLogicformula(Operands)
	:
		Operands=[]
	<-
		true;
	.


+!save_Statement(LogicFormula)
	:
		true
	<-
	
	LogicFormula = Statement;
	?listOfStatement(List);
	T=Statement;
	H=List;
	-+listOfStatement([T|H]);
	.

+!generateStateOfWorld(List): true

<-

.length(List,L);
if(L\==1){
utility.generatePossibleStateofWorld(List,StateOfWorld);
-+stateOfWorld(StateOfWorld);

}
else{
	.print("SONO QUA", List);
-+stateOfWorld(listofWorld([List]));	
}

.

+!evaluateConditionOnWorldList(Condition):true
<- .print("Condizione valutata",Condition);
	?stateOfWorld(List);
	List=listofWorld(ListStateOfWorld);
	.length(ListStateOfWorld,Len);
	while(range(J) & J< Len){
		.nth(J,ListStateOfWorld,CurrentWorld);
		World=world(CurrentWorld);
		.print("MONDO CORRENTE:",CurrentWorld);
	!test_condition(Condition,World,Bool);
	if(Bool==true){
		 
		.println("Condition : ", Condition," is :",Bool," in State of World :" ,World);		 
		 -+range(Len); 
		 -+isAdmissible(true);
		
	}
	
	else{
		.println("Condition : ", Condition," is :",Bool," in State of World :" ,World);
		
		-+range(J+1);
		if(J+1==Len){
		.println("Condition : ", Condition," is always false in each state of world"); 
		-+isAdmissible(false);
	}
	}
	
}

.
