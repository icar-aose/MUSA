/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package musa.goalspec;

import musa.goalspec.model.AbstractGoalEntity;
import musa.goalspec.model.ActorEntity;
import musa.goalspec.model.Entity;
import musa.goalspec.model.ManyActorsEntity;
import musa.goalspec.model.ManyGoalsEntity;
import musa.goalspec.model.SocialGoalEntity;
import musa.goalspec.model.Specification;
import musa.goalspec.model.SystemGoalEntity;
import musa.goalspec.model.condition.ANDCondition;
import musa.goalspec.model.condition.Condition;
import musa.goalspec.model.condition.NOTCondition;
import musa.goalspec.model.condition.ORCondition;
import musa.goalspec.model.condition.event.DelayEvent;
import musa.goalspec.model.condition.event.WhenStateEvent;
import musa.goalspec.model.state.ANDState;
import musa.goalspec.model.state.MessageIncomeState;
import musa.goalspec.model.state.MessageOutcomeState;
import musa.goalspec.model.state.NOTState;
import musa.goalspec.model.state.ORState;
import musa.goalspec.model.state.State;
import musa.goalspec.model.state.term.AtomTerm;
import musa.goalspec.model.state.term.ListTerm;
import musa.goalspec.model.state.term.NumericTerm;
import musa.goalspec.model.state.term.StringTerm;
import musa.goalspec.model.state.term.StructureTerm;
import musa.goalspec.model.state.term.TermPredicate;
import musa.goalspec.model.state.term.VariableTerm;

/**
 *
 * @author luca
 */
public class myVisitor extends GOALspecBaseVisitor<Entity> {
    
    @Override
    public Entity visitSpecification(GOALspecParser.SpecificationContext ctx) {
        Specification specification = new Specification();

        specification.setGoals( (ManyGoalsEntity) visit(ctx.goal_list()));
        
        return specification;
    }

    @Override
    public Entity visitMany_goal_list(GOALspecParser.Many_goal_listContext ctx) {
        ManyGoalsEntity entity = new ManyGoalsEntity();
        entity.getGoals().add( (AbstractGoalEntity) visit( ctx.goal_type() ));
        
        ManyGoalsEntity list = (ManyGoalsEntity) visit( ctx.goal_list() );
        entity.getGoals().addAll(list.getGoals());
        return entity;
    }

    @Override
    public Entity visitSingle_goal_list(GOALspecParser.Single_goal_listContext ctx) {
        ManyGoalsEntity entity = new ManyGoalsEntity();
        entity.getGoals().add( (AbstractGoalEntity) visit( ctx.goal_type() ));
        return entity;
    }
    
    
    
    @Override
    public Entity visitSocial_goal(GOALspecParser.Social_goalContext ctx) {
        SocialGoalEntity social_goal = new SocialGoalEntity();
        
        social_goal.setName( ctx.goal_name().getText() );
        social_goal.setActors( (ManyActorsEntity) visit( ctx.social_goal_content().actors_list() ));
        
        Condition TC = (Condition) visit( ctx.social_goal_content().trigger_condition() );
        social_goal.setTriggeringCondition(TC);
        
        State FS = (State) visit( ctx.social_goal_content().final_state() );
        social_goal.setFinalState(FS);
        return social_goal;
    }

    @Override
    public Entity visitSystem_goal(GOALspecParser.System_goalContext ctx) {
        SystemGoalEntity system_goal = new SystemGoalEntity();
        system_goal.setName( ctx.goal_name().getText() );
        
        system_goal.setActor( (ActorEntity) visit(ctx.system_goal_content().actor()));
        
        Condition TC = (Condition) visit( ctx.system_goal_content().trigger_condition() );
        system_goal.setTriggeringCondition(TC);
        
        State FS = (State) visit( ctx.system_goal_content().final_state() );
        system_goal.setFinalState(FS);
        return system_goal;
    }
    
    
    
    @Override
    public Entity visitAnd_condition(GOALspecParser.And_conditionContext ctx) {
        ANDCondition condition = new ANDCondition();
        Condition left = (Condition) visit( ctx.trigger_condition(0) );
        Condition right = (Condition) visit( ctx.trigger_condition(1) );
        condition.setLeft(left);
        condition.setRight(right);
        
        return condition;
    }
    
    @Override
    public Entity visitOr_condition(GOALspecParser.Or_conditionContext ctx) {
        ORCondition condition = new ORCondition();
        Condition left = (Condition) visit( ctx.trigger_condition(0) );
        Condition right = (Condition) visit( ctx.trigger_condition(1) );
        condition.setLeft(left);
        condition.setRight(right);
        
        return condition;
    }
    
    @Override
    public Entity visitNeg_condition(GOALspecParser.Neg_conditionContext ctx) {
        NOTCondition condition = new NOTCondition();
        Condition tc = (Condition) visit( ctx.trigger_condition() );
        condition.setNegative(tc);
        
        return condition;
    }
    
    @Override
    public Entity visitSub_condition(GOALspecParser.Sub_conditionContext ctx) {
        return visit( ctx.trigger_condition() );     
    }
       
    @Override
    public Entity visitEvent_definition(GOALspecParser.Event_definitionContext ctx) {
        return visit( ctx.event() );
    }

    
    @Override
    public Entity visitAfter(GOALspecParser.AfterContext ctx) { 
        DelayEvent event = new DelayEvent();
        event.setDelay( new Integer( ctx.variable().getText() ) );
        event.setPre_condition( (Condition) visit( ctx.trigger_condition() ));
        return event; 
    }
    
    @Override
    public Entity visitStateEvent(GOALspecParser.StateEventContext ctx) { 
        WhenStateEvent event = new WhenStateEvent();
        event.setState( (State) visit( ctx.state() ));
        return event; 
    }

    @Override
    public Entity visitNeg_state(GOALspecParser.Neg_stateContext ctx) {
        NOTState state = new NOTState();
        State fs = (State) visit( ctx.state() );
        state.setNegative(fs);
        
        return state;
    }

    @Override
    public Entity visitAnd_state(GOALspecParser.And_stateContext ctx) {
        ANDState state = new ANDState();
        State left = (State) visit( ctx.final_state(0) );
        State right = (State) visit( ctx.final_state(1) );
        state.setLeft(left);
        state.setRight(right);
        
        return state;
    }

    @Override
    public Entity visitState_definition(GOALspecParser.State_definitionContext ctx) {
        return visit( ctx.state() );
    }

    @Override
    public Entity visitSub_state(GOALspecParser.Sub_stateContext ctx) {
        return visit( ctx.final_state() );
    }

    @Override
    public Entity visitOr_state(GOALspecParser.Or_stateContext ctx) {
        ORState state = new ORState();
        State left = (State) visit( ctx.final_state(0) );
        State right = (State) visit( ctx.final_state(1) );
        state.setLeft(left);
        state.setRight(right);
        
        return state;
    }
    

    
    @Override
    public Entity visitPredicateState(GOALspecParser.PredicateStateContext ctx) { 
        return visit(ctx.predicate()); 
    }
    
    @Override
    public Entity visitMessageInState(GOALspecParser.MessageInStateContext ctx) { 
        return visit(ctx.message_received_state()); 
    }
    
    @Override
    public Entity visitMessageOutState(GOALspecParser.MessageOutStateContext ctx) { 
        return visit(ctx.message_sent_state()); 
    }
    
    @Override
    public Entity visitMessage_sent_state(GOALspecParser.Message_sent_stateContext ctx) { 
        MessageOutcomeState state = new MessageOutcomeState();
        state.setContent((State) visit( ctx.predicate() ));
        state.setReceiver( (ActorEntity) visit(ctx.actor()));
        return state; 
    }
    
    @Override
    public Entity visitMessage_received_state(GOALspecParser.Message_received_stateContext ctx) { 
        MessageIncomeState state = new MessageIncomeState();
        state.setContent((State) visit( ctx.predicate() ));
        state.setSender( (ActorEntity) visit(ctx.actor()));
        return state; 
    }
    
    @Override
    public Entity visitAtom(GOALspecParser.AtomContext ctx) { 
        AtomTerm predicate = new AtomTerm();
        predicate.setAtom( ctx.getText() );
        return predicate; 
    }
    
    @Override
    public Entity visitStructure(GOALspecParser.StructureContext ctx) { 
        StructureTerm predicate = new StructureTerm();
        predicate.setAtom( (AtomTerm) visit(ctx.atom()));
        
        for (int i=0; i<ctx.term_list().getChildCount(); i++) {
            TermPredicate term = (TermPredicate) visit(ctx.term_list().getChild(i)) ;
            predicate.getParams().add(term);
        }
        return predicate; 
    }
    
    @Override
    public Entity visitList(GOALspecParser.ListContext ctx) { 
        ListTerm predicate = new ListTerm();
        
        for (int i=0; i<ctx.term_list().getChildCount(); i++) {
            TermPredicate term = (TermPredicate) visit(ctx.term_list().getChild(i)) ;
            predicate.getParams().add(term);
        }
        
        return predicate; 
    }

    @Override
    public Entity visitNumeral(GOALspecParser.NumeralContext ctx) {
        NumericTerm predicate = new NumericTerm();
        predicate.setValue( new Integer( ctx.digits().getText() ) );
        return predicate;
    }

    @Override
    public Entity visitString(GOALspecParser.StringContext ctx) {
        StringTerm predicate = new StringTerm();
        predicate.setString( ctx.characters().getText() );
        return predicate;
    }

    @Override
    public Entity visitVariable(GOALspecParser.VariableContext ctx) {
        VariableTerm predicate = new VariableTerm();
        predicate.setVariable( ctx.getText() ); // ctx.UPPERCASE_LETTER().getText().concat(ctx.characters().getText()) );
        return predicate;
    }

    @Override
    public Entity visitActor_and_list(GOALspecParser.Actor_and_listContext ctx) {
        ManyActorsEntity actor_list = new ManyActorsEntity();
        actor_list.getActorList().add( (ActorEntity) visit(ctx.actor()));
        
        ManyActorsEntity right = (ManyActorsEntity) visit( ctx.actors_list() );
        actor_list.getActorList().addAll( right.getActorList() );
        
        return actor_list;
    }

    @Override
    public Entity visitSingle_actor(GOALspecParser.Single_actorContext ctx) {
        ManyActorsEntity actor_list = new ManyActorsEntity();
        actor_list.getActorList().add( (ActorEntity) visit(ctx.actor()));
        
        return actor_list;
    }

    @Override
    public Entity visitActor_comma_list(GOALspecParser.Actor_comma_listContext ctx) {
        ManyActorsEntity actor_list = new ManyActorsEntity();
        actor_list.getActorList().add( (ActorEntity) visit(ctx.actor()));
        
        ManyActorsEntity right = (ManyActorsEntity) visit( ctx.actors_list() );
        actor_list.getActorList().addAll( right.getActorList() );
        
        return actor_list;
    }

    
    
    @Override
    public Entity visitRole_actor(GOALspecParser.Role_actorContext ctx) {
        ActorEntity actor = new ActorEntity();
        //System.out.println(ctx.characters().getText());
        actor.setActor( ctx.characters().getText() );
        
        return actor;
    }

    @Override
    public Entity visitSystem_actor(GOALspecParser.System_actorContext ctx) {
        ActorEntity actor = new ActorEntity();
        
        actor.setActor("the_system");
        
        return actor;
    }
    
    
    
}
