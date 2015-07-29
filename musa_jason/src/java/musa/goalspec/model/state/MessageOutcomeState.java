/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package musa.goalspec.model.state;

import musa.goalspec.model.ActorEntity;

import java.util.LinkedList;


/**
 *
 * @author luca
 */
public class MessageOutcomeState extends State {
    private State content;
    private ActorEntity receiver;

    public State getContent() {
        return content;
    }

    public void setContent(State content) {
        this.content = content;
    }

    public ActorEntity getReceiver() {
        return receiver;
    }

    public void setReceiver(ActorEntity receiver) {
        this.receiver = receiver;
    }
    
    @Override
    public void addBelief(LinkedList belief_base, String name, String namespace) {
        String cond_id= getId(name);
        String msg_id= getId(name+"_msg");
        belief_base.add("state_true_when_outcome_msg("+cond_id+", "+msg_id+", "+receiver.getActor()+" )[pack("+namespace+")]");
        belief_base.add("message("+msg_id+")[pack("+namespace+")]");
        belief_base.add("content("+msg_id+", "+content.toString()+" )[pack("+namespace+")]");
    }
    
	@Override
	public String getPredicate() {
		return "message_out("+content.getPredicate()+","+receiver.getActor()+")";
	}

	@Override
	public String getPredicateWithinAND() {
		return getPredicate();
	}

	@Override
	public String getPredicateWithinOR() {
		return getPredicate();
	}
}
