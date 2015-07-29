/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package musa.goalspec.model.state.term;

import java.util.Iterator;
import java.util.LinkedList;
import java.util.List;

/**
 *
 * @author luca
 */
public class ListTerm extends TermPredicate {
    private List<TermPredicate> params;

    public ListTerm() {
        params = new LinkedList<TermPredicate>();
    }

    public List<TermPredicate> getParams() {
        return params;
    }

    public void setParams(List<TermPredicate> params) {
        this.params = params;
    }

    @Override
    public void addBelief(LinkedList belief_base, String name, String namespace) {

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
        return "[" + param_list + ']';
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
	public String getPredicate() {
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
