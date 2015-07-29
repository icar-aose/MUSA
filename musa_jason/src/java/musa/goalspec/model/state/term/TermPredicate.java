/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package musa.goalspec.model.state.term;

import musa.goalspec.model.state.Predicate;

/**
 *
 * @author luca
 */
public abstract class TermPredicate extends Predicate {
    public abstract boolean isGround();
}
