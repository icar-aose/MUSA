// Generated from GOALspec.g4 by ANTLR 4.0
package musa.goalspec;
import org.antlr.v4.runtime.tree.*;
import org.antlr.v4.runtime.Token;

public interface GOALspecVisitor<T> extends ParseTreeVisitor<T> {
	T visitSystem_actor(GOALspecParser.System_actorContext ctx);

	T visitRole_actor(GOALspecParser.Role_actorContext ctx);

	T visitAtom(GOALspecParser.AtomContext ctx);

	T visitNumeral(GOALspecParser.NumeralContext ctx);

	T visitNeg_state(GOALspecParser.Neg_stateContext ctx);

	T visitMany_goal_list(GOALspecParser.Many_goal_listContext ctx);

	T visitPredicate(GOALspecParser.PredicateContext ctx);

	T visitSingle_goal_list(GOALspecParser.Single_goal_listContext ctx);

	T visitAfter(GOALspecParser.AfterContext ctx);

	T visitGoal_type(GOALspecParser.Goal_typeContext ctx);

	T visitActor_and_list(GOALspecParser.Actor_and_listContext ctx);

	T visitMsgActor(GOALspecParser.MsgActorContext ctx);

	T visitState_definition(GOALspecParser.State_definitionContext ctx);

	T visitSystem_goal(GOALspecParser.System_goalContext ctx);

	T visitItem_descriptions(GOALspecParser.Item_descriptionsContext ctx);

	T visitDigits(GOALspecParser.DigitsContext ctx);

	T visitSub_state(GOALspecParser.Sub_stateContext ctx);

	T visitStructure(GOALspecParser.StructureContext ctx);

	T visitItem_description(GOALspecParser.Item_descriptionContext ctx);

	T visitSingle_actor(GOALspecParser.Single_actorContext ctx);

	T visitAnd_condition(GOALspecParser.And_conditionContext ctx);

	T visitCharacters(GOALspecParser.CharactersContext ctx);

	T visitNeg_condition(GOALspecParser.Neg_conditionContext ctx);

	T visitAnd_state(GOALspecParser.And_stateContext ctx);

	T visitData(GOALspecParser.DataContext ctx);

	T visitSocial_goal_content(GOALspecParser.Social_goal_contentContext ctx);

	T visitMessageOutState(GOALspecParser.MessageOutStateContext ctx);

	T visitCharacter(GOALspecParser.CharacterContext ctx);

	T visitMessageInState(GOALspecParser.MessageInStateContext ctx);

	T visitSub_condition(GOALspecParser.Sub_conditionContext ctx);

	T visitOr_condition(GOALspecParser.Or_conditionContext ctx);

	T visitMessage_received_state(GOALspecParser.Message_received_stateContext ctx);

	T visitSystem_goal_content(GOALspecParser.System_goal_contentContext ctx);

	T visitOr_state(GOALspecParser.Or_stateContext ctx);

	T visitWhere_clause(GOALspecParser.Where_clauseContext ctx);

	T visitPredicateState(GOALspecParser.PredicateStateContext ctx);

	T visitList(GOALspecParser.ListContext ctx);

	T visitEvent_definition(GOALspecParser.Event_definitionContext ctx);

	T visitData_item(GOALspecParser.Data_itemContext ctx);

	T visitSocial_goal(GOALspecParser.Social_goalContext ctx);

	T visitGoal_name(GOALspecParser.Goal_nameContext ctx);

	T visitTerm(GOALspecParser.TermContext ctx);

	T visitTerm_list(GOALspecParser.Term_listContext ctx);

	T visitString(GOALspecParser.StringContext ctx);

	T visitSpecification(GOALspecParser.SpecificationContext ctx);

	T visitStateEvent(GOALspecParser.StateEventContext ctx);

	T visitSpecial(GOALspecParser.SpecialContext ctx);

	T visitActor_comma_list(GOALspecParser.Actor_comma_listContext ctx);

	T visitMessage_sent_state(GOALspecParser.Message_sent_stateContext ctx);

	T visitVariable(GOALspecParser.VariableContext ctx);
}