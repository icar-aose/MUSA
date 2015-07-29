/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package musa.goalspec.model.condition;

import java.util.LinkedList;

/**
 *
 * @author luca
 */
public class ANDCondition extends Condition {
    private Condition left;
    private Condition right;

    public Condition getLeft() {
        return left;
    }

    public void setLeft(Condition left) {
        this.left = left;
    }

    public Condition getRight() {
        return right;
    }

    public void setRight(Condition right) {
        this.right = right;
    }

    @Override
    public void addBelief(LinkedList belief_base, String name, String namespace) {
        String cond_id= getId(name);
        String left_id = left.getId(name);
        String right_id = right.getId(name);
        
        belief_base.add("event_definition("+cond_id+", and( ["+left_id+","+right_id+"] ) )[pack("+namespace+")]");
        left.addBelief(belief_base, name, namespace);
        right.addBelief(belief_base, name, namespace);
    }

	@Override
	public String getPredicate() {
		return "and (["+left.getPredicateWithinAND()+","+right.getPredicateWithinAND()+"])";
	}

	@Override
	public String getPredicateWithinAND() {
		return left.getPredicate()+","+right.getPredicate();
	}

	@Override
	public String getPredicateWithinOR() {
		return getPredicate();
	}
    
    
}
