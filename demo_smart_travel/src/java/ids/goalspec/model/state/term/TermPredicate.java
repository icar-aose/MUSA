/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package ids.goalspec.model.state.term;

import ids.goalspec.model.state.Predicate;

/**
 *
 * @author luca
 */
public abstract class TermPredicate extends Predicate {
    public abstract boolean isGround();
}
