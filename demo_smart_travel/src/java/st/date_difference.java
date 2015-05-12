// Internal action code for project adaptive_workflow

package st;

import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.LinkedList;
import java.util.List;

import org.joda.time.DateTime;
import org.joda.time.Days;
import org.joda.time.Hours;

import jason.*;
import jason.asSemantics.*;
import jason.asSyntax.*;

public class date_difference extends DefaultInternalAction {
    @Override
    public Object execute(TransitionSystem ts, Unifier un, Term[] args) throws Exception {
        // execute the internal action
    	Structure date1 = (Structure) args[0];
    	Structure date2 = (Structure) args[1];

//    	System.out.println(date1.toString());
//    	System.out.println(date2.toString());
    	
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

//    	System.out.println("Y"+year1+" M"+month1+" D"+day1+" H"+hour1+" m"+minute1+" S"+second1);

    	
    	int year2 = term_to_int(date2.getTerm(0));
    	int month2 = term_to_int(date2.getTerm(1));
    	int day2 = term_to_int(date2.getTerm(2));
    	int hour2 = term_to_int(date2.getTerm(3));
    	int minute2 = term_to_int(date2.getTerm(4));
    	int second2 = term_to_int(date2.getTerm(5));
    	
//    	System.out.println("Y"+year2+" M"+month2+" D"+day2+" H"+hour2+" m"+minute2+" S"+second2);
    	
    	SimpleDateFormat format = new SimpleDateFormat("MM/dd/yyyy HH:mm:ss");
    	Date d1 = null;
    	Date d2 = null;

    	d1 = format.parse(month1+"/"+day1+"/"+year1+" "+hour1+":"+minute1+":"+second1);
		d2 = format.parse(month2+"/"+day2+"/"+year2+" "+hour2+":"+minute2+":"+second2);
		
//    	Calendar calend1 = Calendar.getInstance();
//    	calend1.set(year1, month1, day1, hour1, minute1, second1);
//    	
//    	Calendar calend2 = Calendar.getInstance();
//    	calend1.set(year2, month2, day2, hour2, minute2, second2);

		DateTime jodadt1 = new DateTime(d1);
		DateTime jodadt2 = new DateTime(d2);

		//System.out.println(jodadt1);
    	//System.out.println(jodadt2);

		//int diff = Days.daysBetween(jodadt2, jodadt1).getDays();
		double hour_diff = (double) Hours.hoursBetween(jodadt2, jodadt1).getHours();
    	//System.out.println(hour_diff);

    	double day_diff = hour_diff;// / 24;
    	//System.out.println(day_diff);
    	
//		System.out.println(d1.toString());
//    	System.out.println(d2.toString());
//
//    	System.out.println(calend1.getTimeInMillis() );
//    	System.out.println(calend2.getTimeInMillis() );
//   	
//    	System.out.println(calend1.getTime().getTime());
//    	System.out.println(calend2.getTime().getTime());
//
//    	double diff = calend1.getTime().getTime() - calend2.getTime().getTime();
//    	System.out.println(diff);
//    	double diffDays = diff / 86400000;
//    	System.out.println(diffDays);
    	
    	NumberTerm num_term = new NumberTermImpl(day_diff);
    	
    	return un.unifies(num_term,args[2]);
    }
    
    private int term_to_int(Term term) {
    	NumberTerm num_term = (NumberTerm) term;
    	double number = num_term.solve();
    	return (int) Math.round(number);
    }

}
