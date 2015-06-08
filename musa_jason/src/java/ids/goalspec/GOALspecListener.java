// Generated from GOALspec.g4 by ANTLR 4.0
package ids.goalspec;
import org.antlr.v4.runtime.tree.*;
import org.antlr.v4.runtime.Token;

public interface GOALspecListener extends ParseTreeListener {
	void enterSystem_actor(GOALspecParser.System_actorContext ctx);
	void exitSystem_actor(GOALspecParser.System_actorContext ctx);

	void enterRole_actor(GOALspecParser.Role_actorContext ctx);
	void exitRole_actor(GOALspecParser.Role_actorContext ctx);

	void enterAtom(GOALspecParser.AtomContext ctx);
	void exitAtom(GOALspecParser.AtomContext ctx);

	void enterNumeral(GOALspecParser.NumeralContext ctx);
	void exitNumeral(GOALspecParser.NumeralContext ctx);

	void enterNeg_state(GOALspecParser.Neg_stateContext ctx);
	void exitNeg_state(GOALspecParser.Neg_stateContext ctx);

	void enterMany_goal_list(GOALspecParser.Many_goal_listContext ctx);
	void exitMany_goal_list(GOALspecParser.Many_goal_listContext ctx);

	void enterPredicate(GOALspecParser.PredicateContext ctx);
	void exitPredicate(GOALspecParser.PredicateContext ctx);

	void enterSingle_goal_list(GOALspecParser.Single_goal_listContext ctx);
	void exitSingle_goal_list(GOALspecParser.Single_goal_listContext ctx);

	void enterAfter(GOALspecParser.AfterContext ctx);
	void exitAfter(GOALspecParser.AfterContext ctx);

	void enterGoal_type(GOALspecParser.Goal_typeContext ctx);
	void exitGoal_type(GOALspecParser.Goal_typeContext ctx);

	void enterActor_and_list(GOALspecParser.Actor_and_listContext ctx);
	void exitActor_and_list(GOALspecParser.Actor_and_listContext ctx);

	void enterMsgActor(GOALspecParser.MsgActorContext ctx);
	void exitMsgActor(GOALspecParser.MsgActorContext ctx);

	void enterState_definition(GOALspecParser.State_definitionContext ctx);
	void exitState_definition(GOALspecParser.State_definitionContext ctx);

	void enterSystem_goal(GOALspecParser.System_goalContext ctx);
	void exitSystem_goal(GOALspecParser.System_goalContext ctx);

	void enterItem_descriptions(GOALspecParser.Item_descriptionsContext ctx);
	void exitItem_descriptions(GOALspecParser.Item_descriptionsContext ctx);

	void enterDigits(GOALspecParser.DigitsContext ctx);
	void exitDigits(GOALspecParser.DigitsContext ctx);

	void enterSub_state(GOALspecParser.Sub_stateContext ctx);
	void exitSub_state(GOALspecParser.Sub_stateContext ctx);

	void enterStructure(GOALspecParser.StructureContext ctx);
	void exitStructure(GOALspecParser.StructureContext ctx);

	void enterItem_description(GOALspecParser.Item_descriptionContext ctx);
	void exitItem_description(GOALspecParser.Item_descriptionContext ctx);

	void enterSingle_actor(GOALspecParser.Single_actorContext ctx);
	void exitSingle_actor(GOALspecParser.Single_actorContext ctx);

	void enterAnd_condition(GOALspecParser.And_conditionContext ctx);
	void exitAnd_condition(GOALspecParser.And_conditionContext ctx);

	void enterCharacters(GOALspecParser.CharactersContext ctx);
	void exitCharacters(GOALspecParser.CharactersContext ctx);

	void enterNeg_condition(GOALspecParser.Neg_conditionContext ctx);
	void exitNeg_condition(GOALspecParser.Neg_conditionContext ctx);

	void enterAnd_state(GOALspecParser.And_stateContext ctx);
	void exitAnd_state(GOALspecParser.And_stateContext ctx);

	void enterData(GOALspecParser.DataContext ctx);
	void exitData(GOALspecParser.DataContext ctx);

	void enterSocial_goal_content(GOALspecParser.Social_goal_contentContext ctx);
	void exitSocial_goal_content(GOALspecParser.Social_goal_contentContext ctx);

	void enterMessageOutState(GOALspecParser.MessageOutStateContext ctx);
	void exitMessageOutState(GOALspecParser.MessageOutStateContext ctx);

	void enterCharacter(GOALspecParser.CharacterContext ctx);
	void exitCharacter(GOALspecParser.CharacterContext ctx);

	void enterMessageInState(GOALspecParser.MessageInStateContext ctx);
	void exitMessageInState(GOALspecParser.MessageInStateContext ctx);

	void enterSub_condition(GOALspecParser.Sub_conditionContext ctx);
	void exitSub_condition(GOALspecParser.Sub_conditionContext ctx);

	void enterOr_condition(GOALspecParser.Or_conditionContext ctx);
	void exitOr_condition(GOALspecParser.Or_conditionContext ctx);

	void enterMessage_received_state(GOALspecParser.Message_received_stateContext ctx);
	void exitMessage_received_state(GOALspecParser.Message_received_stateContext ctx);

	void enterSystem_goal_content(GOALspecParser.System_goal_contentContext ctx);
	void exitSystem_goal_content(GOALspecParser.System_goal_contentContext ctx);

	void enterOr_state(GOALspecParser.Or_stateContext ctx);
	void exitOr_state(GOALspecParser.Or_stateContext ctx);

	void enterWhere_clause(GOALspecParser.Where_clauseContext ctx);
	void exitWhere_clause(GOALspecParser.Where_clauseContext ctx);

	void enterPredicateState(GOALspecParser.PredicateStateContext ctx);
	void exitPredicateState(GOALspecParser.PredicateStateContext ctx);

	void enterList(GOALspecParser.ListContext ctx);
	void exitList(GOALspecParser.ListContext ctx);

	void enterEvent_definition(GOALspecParser.Event_definitionContext ctx);
	void exitEvent_definition(GOALspecParser.Event_definitionContext ctx);

	void enterData_item(GOALspecParser.Data_itemContext ctx);
	void exitData_item(GOALspecParser.Data_itemContext ctx);

	void enterSocial_goal(GOALspecParser.Social_goalContext ctx);
	void exitSocial_goal(GOALspecParser.Social_goalContext ctx);

	void enterGoal_name(GOALspecParser.Goal_nameContext ctx);
	void exitGoal_name(GOALspecParser.Goal_nameContext ctx);

	void enterTerm(GOALspecParser.TermContext ctx);
	void exitTerm(GOALspecParser.TermContext ctx);

	void enterTerm_list(GOALspecParser.Term_listContext ctx);
	void exitTerm_list(GOALspecParser.Term_listContext ctx);

	void enterString(GOALspecParser.StringContext ctx);
	void exitString(GOALspecParser.StringContext ctx);

	void enterSpecification(GOALspecParser.SpecificationContext ctx);
	void exitSpecification(GOALspecParser.SpecificationContext ctx);

	void enterStateEvent(GOALspecParser.StateEventContext ctx);
	void exitStateEvent(GOALspecParser.StateEventContext ctx);

	void enterSpecial(GOALspecParser.SpecialContext ctx);
	void exitSpecial(GOALspecParser.SpecialContext ctx);

	void enterActor_comma_list(GOALspecParser.Actor_comma_listContext ctx);
	void exitActor_comma_list(GOALspecParser.Actor_comma_listContext ctx);

	void enterMessage_sent_state(GOALspecParser.Message_sent_stateContext ctx);
	void exitMessage_sent_state(GOALspecParser.Message_sent_stateContext ctx);

	void enterVariable(GOALspecParser.VariableContext ctx);
	void exitVariable(GOALspecParser.VariableContext ctx);
}