/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package ids.goalspec.model.state;

import java.util.LinkedList;

/**
 *
 * @author luca
 */
public class ANDState extends State {
    private State left;
    private State right;

    public State getLeft() {
        return left;
    }

    public void setLeft(State left) {
        this.left = left;
    }

    public State getRight() {
        return right;
    }

    public void setRight(State right) {
        this.right = right;
    }
    
    @Override
    public void addBelief(LinkedList belief_base, String name, String namespace) {
        String cond_id= getId(name);
        String left_id = left.getId(name);
        String right_id = right.getId(name);
        
        belief_base.add("state_definition("+cond_id+", and( ["+left_id+","+right_id+"] ) )[pack("+namespace+")]");
        left.addBelief(belief_base, name, namespace);
        right.addBelief(belief_base, name, namespace);
    }
    
	@Override
	public String getPredicate() {
		return "and( ["+left.getPredicateWithinAND()+","+right.getPredicateWithinAND()+"] )";
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
