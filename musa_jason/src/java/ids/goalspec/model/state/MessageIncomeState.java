/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package ids.goalspec.model.state;

import ids.goalspec.model.ActorEntity;

import java.util.LinkedList;


/**
 *
 * @author luca
 */
public class MessageIncomeState extends State {
    private State content;
    private ActorEntity sender;

    public State getContent() {
        return content;
    }

    public void setContent(State content) {
        this.content = content;
    }

    public ActorEntity getSender() {
        return sender;
    }

    public void setSender(ActorEntity sender) {
        this.sender = sender;
    }

    @Override
    public void addBelief(LinkedList belief_base, String name, String namespace) {
        String cond_id= getId(name);
        String msg_id= getId(name+"_msg");
        belief_base.add("state_true_when_income_msg("+cond_id+", "+msg_id+", "+sender.getActor()+" )[pack("+namespace+")]");
        belief_base.add("message("+msg_id+")[pack("+cond_id+")]");
        belief_base.add("content("+msg_id+", "+content.toString()+" )[pack("+namespace+")]");
    }
    
	@Override
	public String getPredicate() {
		return "message_in("+content.getPredicate()+","+sender.getActor()+")";
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
