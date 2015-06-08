/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package ids.goalspec.model.state.term;

import ids.goalspec.model.state.Predicate;

import java.util.Iterator;
import java.util.LinkedList;
import java.util.List;

/**
 *
 * @author luca
 */
public class StructureTerm extends TermPredicate {
    private AtomTerm atom;
    private List<TermPredicate> params;

    public StructureTerm() {
        params = new LinkedList<TermPredicate>();
    }

    public AtomTerm getAtom() {
        return atom;
    }

    public void setAtom(AtomTerm term) {
        this.atom = term;
    }

    public List<TermPredicate> getParams() {
        return params;
    }

    public void setParams(List<TermPredicate> params) {
        this.params = params;
    }
    
    public boolean isGround() {
        boolean result = false;
        Iterator it = params.iterator();
        while (it.hasNext() && result==false) {
            TermPredicate term = (TermPredicate) it.next();
            result = term.isGround();
        }
        return result;
    }

    @Override
    public void addBelief(LinkedList belief_base, String name, String namespace) {
        String cond_id= getId(name);
        boolean ground = isGround();
        
        if (ground==false) {
            belief_base.add("state_true_when("+cond_id+","+this.toString()+")[pack("+namespace+")]");
        } else {
            belief_base.add("state_is_property("+cond_id+","+this.atom.toString()+","+this.param_as_list()+")[pack("+namespace+")]");
        }
    }

    @Override
    public String toString() {
        int count = 0;
        String param_list = "";
        Iterator it = params.iterator();
        while (it.hasNext()) {
            TermPredicate term = (TermPredicate) it.next();
            if (count>0) {
                param_list += ",";
            }
            param_list += term.toString();
        }
        return atom.toString() + "(" + param_list + ')';
    }

    public String param_as_list() {
        int count = 0;
        String param_list = "";
        Iterator it = params.iterator();
        while (it.hasNext()) {
            TermPredicate term = (TermPredicate) it.next();
            if (count>0) {
                param_list += ",";
            }
            param_list += term.toString();
        }
        return "[" + param_list + ']';
    }

	@Override
	public String getPredicate() {
		// TODO Auto-generated method stub
		return toString();
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
