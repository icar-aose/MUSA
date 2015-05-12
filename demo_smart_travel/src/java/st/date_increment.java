// Internal action code for project adaptive_workflow

package st;

import java.util.Calendar;
import java.util.LinkedList;
import java.util.List;

import jason.*;
import jason.asSemantics.*;
import jason.asSyntax.*;

public class date_increment extends DefaultInternalAction {

    @Override
    public Object execute(TransitionSystem ts, Unifier un, Term[] args) throws Exception {
        // execute the internal action
    	Structure date1 = (Structure) args[0];
    	Structure date2 = (Structure) args[1];

    	String dt1 = date1.getFunctor();
    	String dt2 = date2.getFunctor();
    	
    	if (!dt1.equals("dt") || !dt2.equals("dt")) {
    		throw new JasonException("incorrect input");
    	}
    	
    	List<Term> terms1 = date1.getTerms();
    	List<Term> terms2 = date2.getTerms();
    	
    	if (terms1.size() != 6 | terms2.size() != 6) {
    		throw new JasonException("incorrect terms");
    	}
    	
    	int year1 = term_to_int(date1.getTerm(0));
    	int month1 = term_to_int(date1.getTerm(1));
    	int day1 = term_to_int(date1.getTerm(2));
    	int hour1 = term_to_int(date1.getTerm(3));
    	int minute1 = term_to_int(date1.getTerm(4));
    	int second1 = term_to_int(date1.getTerm(5));
    	
    	int year2 = term_to_int(date2.getTerm(0));
    	int month2 = term_to_int(date2.getTerm(1));
    	int day2 = term_to_int(date2.getTerm(2));
    	int hour2 = term_to_int(date2.getTerm(3));
    	int minute2 = term_to_int(date2.getTerm(4));
    	int second2 = term_to_int(date2.getTerm(5));
    	
    	Calendar calend1 = Calendar.getInstance();
    	calend1.set(year1, month1, day1, hour1, minute1, second1);
    	
    	calend1.add(Calendar.YEAR , year2);
    	calend1.add(Calendar.MONTH, month2);
    	calend1.add(Calendar.DAY_OF_MONTH, day2);
    	calend1.add(Calendar.HOUR_OF_DAY , hour2);
    	calend1.add(Calendar.MINUTE, minute2);
    	calend1.add(Calendar.SECOND, second2);
    	
    	List<Term> terms3 = new LinkedList<Term>();
    	terms3.add(int_to_term(calend1.get(Calendar.YEAR)));
    	terms3.add(int_to_term(calend1.get(Calendar.MONTH)));
    	terms3.add(int_to_term(calend1.get(Calendar.DAY_OF_MONTH)));
    	terms3.add(int_to_term(calend1.get(Calendar.HOUR_OF_DAY)));
    	terms3.add(int_to_term(calend1.get(Calendar.MINUTE)));
    	terms3.add(int_to_term(calend1.get(Calendar.SECOND)));
    	
    	Structure date3 = new Structure("dt");
    	date3.addTerms(terms3);
    	
    	return un.unifies(date3,args[2]);
    }
    
    private int term_to_int(Term term) {
    	NumberTerm num_term = (NumberTerm) term;
    	double number = num_term.solve();
    	return (int) Math.round(number);
    }
    
    private NumberTerm int_to_term(int integer) {
    	return new NumberTermImpl((double) integer); 
    }
    
}
