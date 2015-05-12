/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package ids.goalspec.model.state.term;

/**
 *
 * @author luca
 */
public class VariableTerm extends AtomTerm {

    public String getVariable() {
        return getAtom();
    }

    public void setVariable(String term) {
        setAtom(term);
    }

    @Override
    public String toString() {
        return getVariable().toLowerCase();
    }

    @Override
    public boolean isGround() {
        return true;
    }
}
